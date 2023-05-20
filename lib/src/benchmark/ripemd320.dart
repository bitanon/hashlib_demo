import 'package:flutter/material.dart';
import 'package:hashlib/hashlib.dart' show ripemd320;
import 'package:hashlib_demo/src/components/benchmark_generic.dart';

class RIPEMD320Benchmark extends StatelessWidget {
  const RIPEMD320Benchmark({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericBenchmarkPage(ripemd320.name);
  }
}
