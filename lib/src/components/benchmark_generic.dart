import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hashlib_demo/src/components/input_form.dart';
import 'package:hashlib_demo/src/utils/benchmark.dart';
import 'package:hive/hive.dart';

class GenericBenchmarkPage extends StatefulWidget {
  final String algorithmName;

  const GenericBenchmarkPage(this.algorithmName, {super.key});

  @override
  State<StatefulWidget> createState() => _GenericBenchmarkPageState();
}

class _GenericBenchmarkPageState extends State<GenericBenchmarkPage> {
  Box? config;
  Isolate? isolate;
  String outputLogs = 'No benchmark has been run yet.';
  final ScrollController scroller = ScrollController();
  final inputSize = NumberInputFormField(
    label: 'Input array size',
    value: 100000,
    bitLength: 30,
  );

  notify() {
    if (mounted) setState(() {});
  }

  openConfig() async {
    config = await Hive.openBox('app-config');
    if (isolate != null) return;
    inputSize.value = config!.get(
      'benchmark input size',
      defaultValue: inputSize.value!,
    );
    outputLogs = config!.get(
      'benchmark logs ${widget.algorithmName}',
      defaultValue: outputLogs,
    );
    notify();
  }

  saveConfig() async {
    await config?.put(
      'benchmark input size',
      inputSize.value!,
    );
    if (outputLogs.isNotEmpty) {
      await config?.put(
        'benchmark logs ${widget.algorithmName}',
        outputLogs,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    openConfig();
  }

  @override
  void dispose() {
    isolate?.kill(priority: Isolate.immediate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    inputSize.enabled = isolate == null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        InputForm(
          inputs: [
            inputSize,
            SubmitButtonFormField(
              label: isolate == null ? 'Run Benchmark' : 'Stop Benchmark',
              style: TextStyle(color: isolate == null ? null : Colors.red),
            )
          ],
          onSubmit: isolate == null ? doBenchmark : stopBenchmark,
        ),
        const SizedBox(height: 10),
        const Divider(height: 30),
        SelectableText(
          outputLogs,
          style: const TextStyle(
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }

  void stopBenchmark() {
    if (isolate == null) return;
    isolate!.kill(priority: Isolate.immediate);
    setState(() => isolate = null);
  }

  Future<void> doBenchmark() async {
    outputLogs = '';
    notify();

    var size = inputSize.value;
    if (size == null || size == 0) {
      outputLogs = 'Input size is not valid';
      notify();
      return;
    }

    await BenchmarkRunner.spawnIsolate(
      size: size,
      name: widget.algorithmName,
      onIsolate: (value) {
        isolate = value;
        notify();
      },
      onMessage: (value) {
        outputLogs = '$value\n$outputLogs';
        notify();
      },
    );

    isolate = null;
    saveConfig();
    notify();
  }
}
