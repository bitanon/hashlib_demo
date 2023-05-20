import 'package:flutter/material.dart';
import 'package:hashlib/hashlib.dart' show sha384;
import 'package:hashlib_demo/src/components/benchmark_generic.dart';

class SHA384Benchmark extends StatelessWidget {
  const SHA384Benchmark({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericBenchmarkPage(sha384.name);
  }
}
