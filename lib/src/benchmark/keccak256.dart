import 'package:flutter/material.dart';
import 'package:hashlib/hashlib.dart' show keccak256;
import 'package:hashlib_demo/src/components/benchmark_generic.dart';

class Keccak256Benchmark extends StatelessWidget {
  const Keccak256Benchmark({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericBenchmarkPage(keccak256.name);
  }
}
