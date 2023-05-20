import 'package:flutter/material.dart';
import 'package:hashlib/hashlib.dart' show keccak512;
import 'package:hashlib_demo/src/components/benchmark_generic.dart';

class Keccak512Benchmark extends StatelessWidget {
  const Keccak512Benchmark({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericBenchmarkPage(keccak512.name);
  }
}
