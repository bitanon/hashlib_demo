import 'package:flutter/material.dart';
import 'package:hashlib_demo/src/components/algorithm_list.dart';
import 'package:hashlib_demo/src/utils/algorithms.dart';

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AlgorithmList(
      algorithms: algorithms.where((item) => item.demo != null),
      onSelect: (selected) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => buildSelected(ctx, selected),
          ),
        );
      },
    );
  }

  Widget buildSelected(BuildContext context, Algorithm selected) {
    return Scaffold(
      appBar: AppBar(
        title: Text(selected.name),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              selected.info,
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          const Divider(height: 5),
          Padding(
            padding: const EdgeInsets.all(15),
            child: selected.demo,
          ),
        ],
      ),
    );
  }
}
