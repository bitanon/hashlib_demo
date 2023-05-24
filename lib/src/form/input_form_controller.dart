import 'dart:math' show min;

import 'package:flutter/material.dart';

import 'input_form_field.dart';

abstract class InputFormController<T extends Object> extends InputFormField<T> {
  final TextEditingController controller;

  InputFormController({
    required super.value,
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
  }) : controller = TextEditingController(text: '$value');

  @override
  T? get value {
    return transform!(controller.text);
  }

  @override
  set value(T? changed) {
    if (controller.text == '$changed') return;
    controller.text = '$changed';
    int offset = min(
      controller.text.length,
      controller.selection.extentOffset,
    );
    controller.selection = controller.selection.copyWith(
      baseOffset: offset,
      extentOffset: offset,
    );
  }
}
