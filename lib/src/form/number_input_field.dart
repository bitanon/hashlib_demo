import 'dart:math' show ln10, ln2;

import 'package:flutter/material.dart';

import 'input_form_controller.dart';

class NumberInputFormField extends InputFormController<int> {
  final int bitLength;

  NumberInputFormField({
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
    this.bitLength = 64,
  });

  int get maxLength => (bitLength * ln2 / ln10).ceil();

  @override
  get transform =>
      super.transform ??
      (text) => (int.tryParse(text ?? '') ?? 0).toUnsigned(bitLength);

  @override
  Widget build(BuildContext context) {
    var submitted = onSubmit ?? () {};
    var changed = onChange ?? (_) {};
    return TextFormField(
      enabled: enabled,
      controller: controller,
      readOnly: readOnly,
      autofocus: autofocus,
      autocorrect: autocorrect,
      maxLength: maxLength,
      style: style,
      textAlignVertical: TextAlignVertical.top,
      onFieldSubmitted: (_) => submitted(),
      onChanged: (value) => changed(transform!(value)),
      autovalidateMode: AutovalidateMode.always,
      validator: (value) {
        var number = transform!(value ?? '');
        if (number.toString() != value) return 'Invalid number';
        return validator?.call(number);
      },
      decoration: InputDecoration(
        isDense: dense,
        hintText: hint,
        labelText: label,
        border: const OutlineInputBorder(),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
