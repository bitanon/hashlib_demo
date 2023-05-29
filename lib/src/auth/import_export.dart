import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hashlib/hashlib.dart';
import 'package:hashlib_demo/src/auth/password_prompt.dart';
import 'package:hashlib_demo/src/utils/hive_box.dart';
import 'package:hashlib_demo/src/utils/utils.dart';
import 'package:share_plus/share_plus.dart';

class ImportExportButtons extends StatelessWidget {
  final String path;
  final ValueChanged<Iterable<TOTP>> onImport;

  const ImportExportButtons({
    super.key,
    required this.path,
    required this.onImport,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 15),
        Expanded(
          child: Card(
            elevation: 2,
            margin: const EdgeInsets.all(0),
            child: ListTile(
              onTap: () => importOTPBox(context),
              title: const Text('Import'),
              leading: const Icon(Icons.file_download_outlined),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Card(
            elevation: 2,
            margin: const EdgeInsets.all(0),
            child: ListTile(
              onTap: () => exportOTPBox(context),
              title: const Text('Export'),
              leading: const Icon(Icons.file_upload_outlined),
            ),
          ),
        ),
        const SizedBox(width: 15),
      ],
    );
  }

  Future<void> exportOTPBox(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final parts = path.split('.');
      final sign = parts[parts.length - 2];
      final unix = DateTime.now().millisecondsSinceEpoch;
      final name = '$unix.$sign.bin';
      final file = File(path);
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        final result = await FilePicker.platform.saveFile(
          fileName: name,
          type: FileType.custom,
          allowedExtensions: ['bin'],
          dialogTitle: 'Save OTP box',
          lockParentWindow: true,
        );
        if (result != null) {
          file.copySync(result);
          showSnackBar(messenger, 'Exported $result');
        }
      } else {
        final dst = '${file.parent.path}/$name';
        file.copySync(dst);
        var res = await Share.shareXFiles([XFile(dst)]).whenComplete(() {
          File(dst).deleteSync();
        });
        if (res.status == ShareResultStatus.success) {
          showSnackBar(messenger, 'Exported $name');
        } else if (res.status == ShareResultStatus.unavailable) {
          showSnackBar(messenger, 'Export is not available');
        }
      }
    } catch (err) {
      showSnackBar(messenger, '$err');
    }
  }

  Future<void> importOTPBox(BuildContext context) async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final passwordPrompt = buildPasswordPrompt(context);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['bin'],
        dialogTitle: 'Open OTP box',
        lockParentWindow: true,
        withReadStream: true,
      );
      if (result == null) return;

      final file = result.files.single;
      final name = file.name;
      final stream = file.readStream;
      if (stream == null) {
        throw Exception('Could not read $file');
      }

      final sep = Platform.pathSeparator;
      final temp = [Directory(path).parent.path, 'temp'].join(sep);
      final hiveFile = File([temp, '$name.hive'].join(sep));
      hiveFile.createSync(recursive: true);
      final writer = hiveFile.openWrite();
      await writer.addStream(stream);
      writer.close();

      final password = await navigator.push(passwordPrompt);
      if (password == null) {
        return;
      }

      final box = await openTempBox(password, name, temp);
      final instances = readOTPEntries(box);
      onImport(instances);

      await box.close();
      hiveFile.deleteSync();

      showSnackBar(messenger, 'Imported $name');
    } catch (err) {
      showSnackBar(messenger, '$err');
    }
  }

  DialogRoute<String> buildPasswordPrompt(BuildContext context) {
    return DialogRoute<String>(
      context: context,
      builder: (context) => PasswordPromptDialog(
        acceptText: 'Submit',
        onCancel: () => Navigator.of(context).pop(),
        onSubmit: (password) => Navigator.of(context).pop(password),
      ),
    );
  }
}
