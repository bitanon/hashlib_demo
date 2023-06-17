import 'package:flutter/material.dart';
import 'package:hashlib/hashlib.dart' show blake2s256;
import 'package:hashlib_demo/src/components/benchmark_generic.dart';

class Blake2sBenchmark extends StatelessWidget {
  const Blake2sBenchmark({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericBenchmarkPage(blake2s256.name);
  }
}
