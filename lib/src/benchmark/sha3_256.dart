import 'package:flutter/material.dart';
import 'package:hashlib/hashlib.dart' show sha3_256;
import 'package:hashlib_demo/src/components/benchmark_generic.dart';

class SHA3of256Benchmark extends StatelessWidget {
  const SHA3of256Benchmark({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericBenchmarkPage(sha3_256.name);
  }
}
