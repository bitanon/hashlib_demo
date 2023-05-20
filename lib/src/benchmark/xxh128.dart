import 'package:flutter/material.dart';
import 'package:hashlib/hashlib.dart' show xxh128;
import 'package:hashlib_demo/src/components/benchmark_generic.dart';

class XXH128Benchmark extends StatelessWidget {
  const XXH128Benchmark({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericBenchmarkPage(xxh128.name);
  }
}
