import 'package:flutter/material.dart';
import 'package:hashlib/hashlib.dart' show md5;
import 'package:hashlib_demo/src/components/benchmark_generic.dart';

class MD5Benchmark extends StatelessWidget {
  const MD5Benchmark({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericBenchmarkPage(md5.name);
  }
}
