import 'package:flutter/material.dart';
import 'package:hashlib/hashlib.dart' show blake2b512;
import 'package:hashlib_demo/src/components/benchmark_generic.dart';

class Blake2bBenchmark extends StatelessWidget {
  const Blake2bBenchmark({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericBenchmarkPage(blake2b512.name);
  }
}
