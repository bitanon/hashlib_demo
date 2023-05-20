import 'package:flutter/material.dart';
import 'package:hashlib/hashlib.dart' show sha3_384;
import 'package:hashlib_demo/src/components/benchmark_generic.dart';

class SHA3of384Benchmark extends StatelessWidget {
  const SHA3of384Benchmark({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericBenchmarkPage(sha3_384.name);
  }
}
