import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:hashlib_demo/src/utils/utils.dart';

class TOTPScannerButtons extends StatelessWidget {
  final bool Function(String?) onUrlReceive;

  const TOTPScannerButtons({
    super.key,
    required this.onUrlReceive,
  });

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      const SizedBox(width: 15),
    ];
    if (Platform.isAndroid || Platform.isIOS) {
      children.addAll([
        Expanded(
          child: QRScanButton(onUrlReceive: onUrlReceive),
        ),
        const SizedBox(width: 10),
      ]);
    }
    children.addAll([
      Expanded(
        child: UrlInputButton(onUrlReceive: onUrlReceive),
      ),
      const SizedBox(width: 15),
    ]);
    return Row(children: children);
  }
}

class QRScanButton extends StatelessWidget {
  final bool Function(String?) onUrlReceive;

  const QRScanButton({
    super.key,
    required this.onUrlReceive,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
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
      if (!onUrlReceive(text)) {
        showSnackBar(messenger, 'Invalid OTP Auth URL');
      }
    } catch (err) {
      showSnackBar(messenger, 'Failed to read QR code');
    }
  }
}

class UrlInputButton extends StatelessWidget {
  final bool Function(String?) onUrlReceive;

  const UrlInputButton({
    super.key,
    required this.onUrlReceive,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
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
            child: TextFormField(
              controller: input,
              maxLines: 10,
              maxLength: 10000,
              onFieldSubmitted: Navigator.of(context).pop,
              decoration: const InputDecoration(
                labelText: 'OTP Auth URL',
                hintText: 'otpauth://totp/...\n'
                    'otpauth-migration://offline?data=...',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
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
    if (!onUrlReceive(text)) {
      showSnackBar(messenger, 'Invalid OTP Auth URL');
    }
  }
}
