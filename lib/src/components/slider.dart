import 'package:flutter/material.dart';

class SliderInput extends StatelessWidget {
  final int value;
  final int min;
  final int max;
  final int step;
  final String label;
  final String? prefix;
  final ValueChanged<int> onChanged;

  const SliderInput({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.prefix,
    this.min = 0,
    this.max = 1,
    this.step = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white60),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              Positioned(
                left: 0,
                child: Text(
                  prefix ?? '$value',
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 15),
                child: Slider(
                  label: '$value',
                  value: value.toDouble(),
                  min: min.toDouble(),
                  max: max.toDouble(),
                  divisions: (max - min) ~/ step,
                  onChanged: (value) => onChanged(value.toInt()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
