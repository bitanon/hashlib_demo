import 'package:flutter/material.dart';
import 'package:hashlib/hashlib.dart' show xxh32;
import 'package:hashlib_demo/src/components/benchmark_generic.dart';

class XXH32Benchmark extends StatelessWidget {
  const XXH32Benchmark({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericBenchmarkPage(xxh32.name);
  }
}
