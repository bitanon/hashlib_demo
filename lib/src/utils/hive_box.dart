import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hashlib/hashlib.dart';
import 'package:hashlib_demo/src/utils/utils.dart';
import 'package:hive/hive.dart';
import 'package:share_plus/share_plus.dart';

import './totp.dart';

(Uint8List, String) generateKeyPair(String password) {
  int number = int.tryParse(password) ?? 309235206;
  var radix = number.toRadixString(2 + (number & 31));
  var message = '$password/${password.length}/$number/$radix';
  var key = sha3_256.convert(message.codeUnits).bytes;
  var suffix = xxh3.convert(key).base64(urlSafe: true);
  return (key, suffix);
}

Future<Box<String>> openOTPBox(String password) async {
  var (key, suffix) = generateKeyPair(password);
  return Hive.openBox<String>(
    'OTPAuth.$suffix',
    encryptionCipher: HiveAesCipher(key),
  );
}

Iterable<TOTP> readOTPEntries(Box<String> box) {
  return box.values.expand(parseTOTP);
}

Future<void> saveOTPEntries(Box<String> box, Iterable<TOTP> entries) async {
  var visited = <int>{};
  var tba = <int, String>{};
  for (final totp in entries) {
    var url = toOTPAuthURL(totp);
    var key = xxh32code(url);
    if (visited.contains(key)) continue;
    visited.add(key);
    if (box.containsKey(key)) continue;
    tba[key] = url;
  }
  var tbd = box.keys.where((key) => !visited.contains(key)).toList();
  await box.putAll(tba);
  if (tbd.isNotEmpty) {
    await box.deleteAll(tbd);
  }
  await box.compact();
}

Future<void> exportOTPBox(BuildContext context, Box<String> box) async {
  var messenger = ScaffoldMessenger.of(context);
  try {
    if (box.path == null) {
      throw Exception('The box has path');
    }
    var file = File(box.path!);
    var parts = file.path.split('.');
    var unix = DateTime.now().millisecondsSinceEpoch;
    var sign = parts[parts.length - 2];
    var name = '$unix.$sign';
    var dst = '${file.parent.path}/$name';
    file.copySync(dst);
    var res = await Share.shareXFiles([XFile(dst)]).whenComplete(() {
      File(dst).deleteSync();
    });
    if (res.status == ShareResultStatus.success) {
      showSnackBar(messenger, 'Exported $name');
    } else if (res.status == ShareResultStatus.unavailable) {
      showSnackBar(messenger, 'Export is not available');
    }
  } catch (err) {
    showSnackBar(messenger, '$err');
  }
}

Future<void> importOTPBox(BuildContext context) async {
  var messenger = ScaffoldMessenger.of(context);
  try {
    var result = await FilePicker.platform.pickFiles(withData: true);
    if (result == null) return;

    var file = result.files.single;
    var data = file.bytes;
    if (data == null) {
      throw Exception('Could not read $file');
    }

    var parts = file.name.split('.');
    var sign = parts[parts.length - 1];
    if (fromBase64Url(sign).length != 8) {
      throw Exception('Invalid sign');
    }
    var version = int.tryParse(parts[parts.length - 2]);
    if (version == null) {
      throw Exception('Invalid timestamp');
    }
    var sep = Platform.pathSeparator;
    var path = await getAppHomeDirectory();

    var lockFile = File([path, 'otpauth.$sign.lock'].join(sep));
    lockFile.createSync();

    var hiveFile = File([path, 'otpauth.$sign.hive'].join(sep));
    if (hiveFile.existsSync()) {
      var current = hiveFile.lastModifiedSync().millisecondsSinceEpoch;
      if (current > version) {
        throw Exception('A newer version of this box exists');
      }
    }
    hiveFile.writeAsBytesSync(data, flush: true);
    showSnackBar(messenger, 'Imported ${file.name}');
  } catch (err) {
    showSnackBar(messenger, '$err');
  }
}
