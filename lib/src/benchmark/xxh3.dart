import 'package:flutter/material.dart';
import 'package:hashlib/hashlib.dart' show xxh3;
import 'package:hashlib_demo/src/components/benchmark_generic.dart';

class XXH3Benchmark extends StatelessWidget {
  const XXH3Benchmark({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericBenchmarkPage(xxh3.name);
  }
}
