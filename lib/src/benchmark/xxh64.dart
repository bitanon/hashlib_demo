import 'package:flutter/material.dart';
import 'package:hashlib/hashlib.dart' show xxh64;
import 'package:hashlib_demo/src/components/benchmark_generic.dart';

class XXH64Benchmark extends StatelessWidget {
  const XXH64Benchmark({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericBenchmarkPage(xxh64.name);
  }
}
