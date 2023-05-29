import 'dart:typed_data';

import 'package:hashlib/hashlib.dart';
import 'package:hive/hive.dart';

import 'totp.dart';

(Uint8List, String) generateKeyPair(String password) {
  int number = int.tryParse(password) ?? 309235206;
  final radix = number.toRadixString(2 + (number & 31));
  final message = '$password/${password.length}/$number/$radix';
  final key = sha3_256.convert(message.codeUnits).bytes;
  final suffix = xxh32.convert(key).base32(upper: false, padding: false);
  return (key, suffix);
}

Future<Box<String>> openOTPBox(String password) async {
  final (key, suffix) = generateKeyPair(password);
  return Hive.openBox<String>(
    'OTPAuth.$suffix',
    encryptionCipher: HiveAesCipher(key),
  );
}

Future<Box<String>> openTempBox(String password, String name, String path) {
  final (key, _) = generateKeyPair(password);
  return Hive.openBox<String>(
    name,
    path: path,
    encryptionCipher: HiveAesCipher(key),
  );
}

Iterable<TOTP> readOTPEntries(Box<String> box) {
  final list = box.values.expand(parseTOTP).toList();
  list.sort((a, b) => a.label!.compareTo(b.label!));
  return list;
}

Future<void> saveOTPEntries(Box<String> box, Iterable<TOTP> entries) async {
  final visited = <int>{};
  final tba = <int, String>{};
  for (final totp in entries) {
    final url = toOTPAuthURL(totp);
    final key = xxh32code(url);
    if (visited.contains(key)) continue;
    visited.add(key);
    if (box.containsKey(key)) continue;
    tba[key] = url;
  }
  final tbd = box.keys.where((key) => !visited.contains(key)).toList();
  await box.putAll(tba);
  if (tbd.isNotEmpty) {
    await box.deleteAll(tbd);
  }
  await box.compact();
}
