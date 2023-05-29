import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hashlib/hashlib.dart' show TOTP;
import 'package:hashlib_demo/src/auth/totp_scanners.dart';
import 'package:hashlib_demo/src/utils/hive_box.dart';
import 'package:hashlib_demo/src/utils/totp.dart';
import 'package:hashlib_demo/src/utils/utils.dart';
import 'package:hive/hive.dart';

import 'import_export.dart';

class AuthenticatorDialog extends StatefulWidget {
  final Box<String> authBox;

  const AuthenticatorDialog(this.authBox, {super.key});

  @override
  State<StatefulWidget> createState() => _AuthenticatorDialogState();

  String get authSign {
    var parts = authBox.path!.split('.');
    return parts[parts.length - 2];
  }
}

class _AuthenticatorDialogState extends State<AuthenticatorDialog> {
  late Iterable<TOTP> instances;

  void readInstances() {
    instances = readOTPEntries(widget.authBox);
  }

  void saveInstances(Iterable<TOTP> values) async {
    try {
      await saveOTPEntries(widget.authBox, values);
    } catch (err) {
      openSnackBar(context, 'Failed to update.\n$err');
    } finally {
      if (mounted) setState(readInstances);
    }
  }

  bool onUrlReceive(String? text) {
    if (text == null || text.isEmpty) return false;
    final newItems = parseTOTP(text).toList();
    if (newItems.isEmpty) return false;
    saveInstances([...instances, ...newItems]);
    return true;
  }

  void importInstances(Iterable<TOTP> values) {
    saveInstances([...instances, ...values]);
  }

  @override
  void initState() {
    super.initState();
    setState(readInstances);
  }

  @override
  void dispose() {
    widget.authBox.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authenticator: ${widget.authSign}'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          ImportExportButtons(
            path: widget.authBox.path!,
            onImport: importInstances,
          ),
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
          const SizedBox(height: 10),
          TOTPScannerButtons(
            onUrlReceive: onUrlReceive,
          ),
          const SizedBox(height: 10),
        ],
      ),
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
      saveInstances(
        instances.where((item) => toOTPAuthURL(totp) != toOTPAuthURL(item)),
      );
    }
  }
}
