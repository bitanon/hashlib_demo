import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

void showSnackBar(ScaffoldMessengerState? messenger, String text) {
  messenger?.clearSnackBars();
  messenger?.showSnackBar(SnackBar(content: Text(text)));
}

void openSnackBar(BuildContext context, String text) {
  showSnackBar(ScaffoldMessenger.of(context), text);
}

Future<void> copyToClipboard({
  required String text,
  BuildContext? context,
  String? successText,
  String? failureText,
}) async {
  ScaffoldMessengerState? messenger;
  if (context != null) {
    messenger = ScaffoldMessenger.of(context);
  }
  try {
    await Clipboard.setData(ClipboardData(text: text));
    showSnackBar(messenger, successText ?? 'Copied to clipboard');
  } catch (err) {
    showSnackBar(messenger, failureText ?? 'Could not copy text to clipboard');
  }
}

String formatSize(
  num size, {
  String gap = '',
  String leading = '',
  String trailing = '',
}) {
  const suffix = ['B', 'KB', 'MB', 'GB', 'TB', 'PB'];
  int i;
  for (i = 0; size >= 1000; i++) {
    size /= 1000;
  }
  size = (size * 100).round() / 100;
  return '$leading${size.toString()}$gap${suffix[i]}$trailing';
}

String formatDateTime(DateTime datetime) {
  final date = DateFormat.yMMMd().format(datetime);
  final time = DateFormat.jms().format(datetime);
  return '$date $time';
}

Future<String> getAppHomeDirectory() async {
  var sep = Platform.pathSeparator;
  var doc = await getApplicationDocumentsDirectory();
  var app = Directory([doc.path, 'Hashlib Demo'].join(sep));
  app.createSync(recursive: true);
  return app.path;
}
