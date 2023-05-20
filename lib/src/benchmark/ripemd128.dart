import 'package:flutter/material.dart';
import 'package:hashlib/hashlib.dart' show ripemd128;
import 'package:hashlib_demo/src/components/benchmark_generic.dart';

class RIPEMD128Benchmark extends StatelessWidget {
  const RIPEMD128Benchmark({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericBenchmarkPage(ripemd128.name);
  }
}
