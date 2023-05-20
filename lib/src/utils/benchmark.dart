import 'dart:async';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:hashlib/hashlib.dart';
import 'package:hashlib_demo/src/utils/utils.dart';

class HashBenchmark {
  final int size;
  final HashBase algo;
  var input = Uint8List(0);

  HashBenchmark({
    required this.algo,
    required this.size,
  });

  void run() {
    for (int i = 0; i < 10; ++i) {
      algo.convert(input);
    }
  }

  void setup() {
    input = Uint8List(size);
    for (int i = 0; i < size; ++i) {
      input[i] = i & 0xFF;
    }
  }

  void teardown() {
    input = Uint8List(0);
  }

  double measure(int millis, {void Function(double)? notify}) {
    final watch = Stopwatch()..start();
    int t = 0;
    int elapsed = 0;
    int lastNotify = 0;
    int micros = millis * 1000;
    double hashRate = 0;
    while (elapsed < micros) {
      watch.reset();
      run();
      elapsed += watch.elapsedMicroseconds;
      t += 10;

      if (elapsed - lastNotify >= 1000000) {
        hashRate = t * (1e6 * size / elapsed);
        lastNotify = elapsed;
        notify?.call(hashRate);
      }
    }
    watch.stop();
    return hashRate;
  }
}

mixin HashRateListener {
  final listeners = <ValueChanged<double>>{};

  void addListener(ValueChanged<double> listener) {
    listeners.add(listener);
  }

  void removeListener(ValueChanged<double> listener) {
    listeners.remove(listener);
  }

  void notifyListeners(double value) {
    for (final listener in listeners) {
      listener(value);
    }
  }
}

class BenchmarkRunner {
  const BenchmarkRunner(this.log);

  final void Function(Object? message) log;

  void logTime(String content) {
    var time = DateTime.now().toIso8601String();
    time = time.substring(0, time.lastIndexOf('.') + 4);
    log('[$time]: $content');
  }

  void run(HashBenchmark instance) {
    logTime('Benchmark for ${instance.algo.name}');
    log('--------------------------------------');
    logTime('Setup');
    logTime('Input array size: ${instance.size}');
    instance.setup();
    logTime('Warming up');
    logTime('Measuring hash rate');
    var rate = instance.measure(10000, notify: (rate) {
      logTime('Hash Rate: ${formatSize(rate)}/s');
    });
    logTime('Teardown');
    instance.teardown();
    logTime('Benchmark finished');
    log('--------------------------------------');
    log('Measured hash rate: ${formatSize(rate)}/s');
  }

  Future<void> start() async {
    final receiver = ReceivePort();
    try {
      log(receiver.sendPort);
      final message = await receiver.first;
      if (message is List && message.length >= 2) {
        var algo = HashRegistry.lookup(message[0]);
        if (algo == null) return;
        var instance = HashBenchmark(
          algo: algo,
          size: message[1],
        );
        run(instance);
      }
    } finally {
      receiver.close();
      log(null);
      Isolate.exit();
    }
  }

  static Future<void> spawnIsolate({
    required String name,
    required int size,
    required void Function(Isolate) onIsolate,
    required void Function(String) onMessage,
  }) async {
    final receiver = ReceivePort();
    final isolate = await Isolate.spawn(_processJob, receiver.sendPort);
    onIsolate(isolate);
    try {
      await for (final message in receiver) {
        if (message is SendPort) {
          message.send([name, size]);
        } else if (message is String) {
          onMessage(message);
        } else {
          break;
        }
      }
    } finally {
      receiver.close();
    }
  }
}

@pragma("vm:entry-point")
Future<void> _processJob(SendPort sender) async {
  final runner = BenchmarkRunner(sender.send);
  await runner.start();
}
