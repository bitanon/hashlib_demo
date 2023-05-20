import 'package:flutter/material.dart';
import 'package:hashlib/hashlib.dart' show keccak384;
import 'package:hashlib_demo/src/components/benchmark_generic.dart';

class Keccak384Benchmark extends StatelessWidget {
  const Keccak384Benchmark({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericBenchmarkPage(keccak384.name);
  }
}
