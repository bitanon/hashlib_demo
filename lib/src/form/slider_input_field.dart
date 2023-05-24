import 'package:flutter/material.dart';

import 'input_form_field.dart';

class SliderInputFormField extends InputFormField<int> {
  final int min;
  final int max;
  final int step;
  final String? prefix;

  SliderInputFormField({
    super.value = 0,
    super.hint,
    super.label,
    super.style,
    super.enabled,
    super.onSubmit,
    super.onChange,
    super.transform,
    super.validator,
    super.dense,
    super.readOnly,
    super.autofocus,
    super.autocorrect,
    this.prefix,
    this.min = 0,
    this.max = 1,
    this.step = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: 10,
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white60),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Builder(builder: buildContents),
        )
      ],
    );
  }

  Widget buildContents(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            label ?? '',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[400],
            ),
          ),
        ),
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            Positioned(
              left: 5,
              child: Text(
                prefix ?? '$value',
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 20),
              child: Builder(builder: buildSlider),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildSlider(BuildContext context) {
    var submitted = onSubmit ?? () {};
    var changed = onChange ?? (_) {};
    return Slider(
      label: '$value',
      value: value!.toDouble(),
      min: min.toDouble(),
      max: max.toDouble(),
      divisions: (max - min) ~/ step,
      onChanged: (value) {
        changed(value.toInt());
        submitted();
      },
    );
  }
}
