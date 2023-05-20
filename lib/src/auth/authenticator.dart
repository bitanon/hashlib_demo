import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:hashlib/hashlib.dart' show TOTP;
import 'package:hashlib_demo/src/components/input_text.dart';
import 'package:hashlib_demo/src/pages/auth.dart';
import 'package:hashlib_demo/src/utils/hive_box.dart';
import 'package:hashlib_demo/src/utils/totp.dart';
import 'package:hashlib_demo/src/utils/utils.dart';

class OTPAuthViewer extends StatelessWidget {
  final void Function()? onClosed;
  final Iterable<TOTP> instances;
  final ValueChanged<Iterable<TOTP>> onChanged;

  const OTPAuthViewer({
    super.key,
    this.onClosed,
    required this.instances,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Builder(builder: buildScanner),
        const SizedBox(height: 10),
        Builder(builder: buildImportExport),
        const SizedBox(height: 10),
        const Divider(height: 1),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(10),
            children: [
              ...instances.map(buildItem),
            ],
          ),
        ),
        const Divider(height: 1),
        InkWell(
          onTap: onClosed,
          child: Container(
            padding: const EdgeInsets.all(10),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout),
                SizedBox(width: 10),
                Text('Close Authenticator'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildScanner(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 15),
        ...(Platform.isMacOS || Platform.isAndroid || Platform.isIOS
            ? [
                Expanded(
                  child: Card(
                    elevation: 2,
                    margin: const EdgeInsets.all(0),
                    child: ListTile(
                      onTap: () => scanQR(context),
                      title: const Text(
                        'Scan QR',
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                      ),
                      leading: const Icon(Icons.qr_code),
                      trailing: const Icon(Icons.chevron_right),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ]
            : []),
        Expanded(
          child: Card(
            elevation: 2,
            margin: const EdgeInsets.all(0),
            child: ListTile(
              onTap: () => parseText(context),
              title: const Text(
                'Add URL',
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
              leading: const Icon(Icons.input),
              trailing: const Icon(Icons.chevron_right),
            ),
          ),
        ),
        const SizedBox(width: 15),
      ],
    );
  }

  Widget buildImportExport(BuildContext context) {
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
              onTap: () => exportOTPBox(context, authBox!),
              title: const Text('Export'),
              leading: const Icon(Icons.share_outlined),
            ),
          ),
        ),
        const SizedBox(width: 15),
      ],
    );
  }

  Widget buildItem(TOTP totp) {
    return StreamBuilder(
      stream: totp.stream,
      initialData: totp.value(),
      builder: (context, snapshot) {
        var code = snapshot.data?.toString();
        var formattedCode = '000 000';
        if (code != null) {
          var otp = code.padLeft(totp.digits, '0');
          var left = otp.substring(0, totp.digits ~/ 2);
          var right = otp.substring(totp.digits ~/ 2);
          formattedCode = '$left $right';
        }
        void copyCode() {
          if (code == null) return;
          copyToClipboard(
            text: code,
            context: context,
            successText: 'Copied to clipboard: $code',
          );
        }

        return Card(
          child: ListTile(
            title: Text(totp.label ?? ''),
            subtitle: Text(formattedCode),
            titleTextStyle: const TextStyle(
              fontSize: 12,
              color: Colors.lightBlueAccent,
            ),
            subtitleTextStyle: const TextStyle(
              fontSize: 32,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
            trailing: const Icon(Icons.copy),
            minVerticalPadding: 5,
            onTap: copyCode,
            onLongPress: () => deleteItem(context, totp),
          ),
        );
      },
    );
  }

  bool checkTextForUrl(String? text) {
    if (text == null || text.isEmpty) return false;
    final newItems = parseTOTP(text).toList();
    if (newItems.isEmpty) return false;
    onChanged([...instances, ...newItems]);
    return true;
  }

  void scanQR(BuildContext context) async {
    var messenger = ScaffoldMessenger.of(context);
    try {
      var text = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        "Cancel",
        false,
        ScanMode.QR,
      );
      if (!checkTextForUrl(text)) {
        showSnackBar(messenger, 'Invalid OTP Auth URL');
      }
    } catch (err) {
      showSnackBar(messenger, 'Failed to read QR code');
    }
  }

  void parseText(BuildContext context) async {
    var messenger = ScaffoldMessenger.of(context);
    final text = await showDialog<String>(
      context: context,
      builder: (context) {
        final input = TextEditingController();
        return AlertDialog(
          title: const Text('Enter OTP Auth URL'),
          insetPadding: const EdgeInsets.all(20),
          titlePadding: const EdgeInsets.all(20).copyWith(bottom: 0),
          contentPadding: const EdgeInsets.all(20).copyWith(bottom: 0),
          actionsPadding: const EdgeInsets.all(15).copyWith(top: 0),
          content: SizedBox(
            width: 400,
            child: InputTextField(
              label: 'OTP Auth URL',
              controller: input,
              maxLines: 10,
              maxLength: 10000,
              onSubmit: Navigator.of(context).pop,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
              ),
              child: const Text('Submit'),
              onPressed: () => Navigator.of(context).pop(input.text),
            ),
          ],
        );
      },
    );
    if (!checkTextForUrl(text)) {
      showSnackBar(messenger, 'Invalid OTP Auth URL');
    }
  }

  void deleteItem(BuildContext context, TOTP totp) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text(
          'Deleting is permanent.\n'
          'Are you sure to delete "${totp.label}"?',
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).primaryColor,
            ),
            child: const Text('Yes'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      onChanged(
        instances.where(
          (item) => toOTPAuthURL(totp) != toOTPAuthURL(item),
        ),
      );
    }
  }
}
