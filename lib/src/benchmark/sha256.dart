import 'package:flutter/material.dart';
import 'package:hashlib/hashlib.dart' show sha256;
import 'package:hashlib_demo/src/components/benchmark_generic.dart';

class SHA256Benchmark extends StatelessWidget {
  const SHA256Benchmark({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericBenchmarkPage(sha256.name);
  }
}
