import 'dart:io';
import 'dart:typed_data';

import 'package:hashlib/hashlib.dart';
import 'package:hashlib_demo/src/utils/utils.dart';
import 'package:hive/hive.dart';

import 'totp.dart';

class OTPBox {
  final int size;
  final String name;
  final DateTime updatedAt;

  OTPBox({
    required this.size,
    required this.name,
    required this.updatedAt,
  });
}

(Uint8List, String) generateKeyPair(String password) {
  int number = int.tryParse(password) ?? 309235206;
  final radix = number.toRadixString(2 + (number & 31));
  final message = '$password/${password.length}/$number/$radix';
  final key = sha3_256.convert(message.codeUnits).bytes;
  final suffix = xxh32.convert(key).base32(upper: false, padding: false);
  return (key, suffix);
}

Future<List<OTPBox>> getBoxList() async {
  final boxes = <OTPBox>[];
  final path = await getAppHomeDirectory();
  for (final file in Directory(path).listSync()) {
    final stats = file.statSync();
    if (stats.type != FileSystemEntityType.file) continue;
    final name = file.path.toLowerCase().split(RegExp(r'[/\\]')).last;
    final parts = name.split('.');
    if (parts.length != 3 || parts[0] != 'otpauth' || parts[2] != 'hive') {
      continue;
    }
    final box = OTPBox(
      name: parts[1],
      size: stats.size,
      updatedAt: stats.changed,
    );
    boxes.add(box);
  }
  return boxes;
}

Future<Box<String>> openOTPBox(
  String password, [
  OTPBox? box,
]) async {
  final (key, suffix) = generateKeyPair(password);
  final name = 'OTPAuth.$suffix';
  if (box != null && box.name != suffix) {
    throw Exception('Invalid password for authenticator: ${box.name}');
  }
  if (box == null && await Hive.boxExists(name)) {
    throw Exception('Authenticator already exists: $suffix');
  }
  return Hive.openBox<String>(
    name,
    encryptionCipher: HiveAesCipher(key),
  );
}

Future<void> deleteOTPBox(OTPBox box) async {
  final name = 'OTPAuth.${box.name}';
  await Hive.deleteBoxFromDisk(name);
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
