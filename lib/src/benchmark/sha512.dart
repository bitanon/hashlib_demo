import 'package:flutter/material.dart';
import 'package:hashlib/hashlib.dart' show sha512;
import 'package:hashlib_demo/src/components/benchmark_generic.dart';

class SHA512Benchmark extends StatelessWidget {
  const SHA512Benchmark({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericBenchmarkPage(sha512.name);
  }
}
