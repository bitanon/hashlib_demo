import 'package:flutter/material.dart';
import 'package:hashlib_demo/src/app.dart';
import 'package:hashlib_demo/src/utils/utils.dart';
import 'package:hive/hive.dart';

void main() async {
  Hive.init(await getAppHomeDirectory());
  runApp(const App());
}
