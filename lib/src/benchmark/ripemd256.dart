import 'package:flutter/material.dart';
import 'package:hashlib/hashlib.dart' show ripemd256;
import 'package:hashlib_demo/src/components/benchmark_generic.dart';

class RIPEMD256Benchmark extends StatelessWidget {
  const RIPEMD256Benchmark({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericBenchmarkPage(ripemd256.name);
  }
}
