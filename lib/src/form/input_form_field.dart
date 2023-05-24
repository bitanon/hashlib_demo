import 'package:flutter/material.dart';

import 'input_form_base.dart';

abstract class InputFormField<T extends Object> extends InputFormBase<T> {
  T? value;
  bool dense;
  bool readOnly;
  bool autofocus;
  bool autocorrect;
  ValueChanged<T?>? onChange;
  final T? Function(String?)? transform;
  final FormFieldValidator<T?>? validator;

  InputFormField({
    super.hint,
    super.label,
    super.style,
    super.enabled,
    super.onSubmit,
    required this.value,
    this.onChange,
    this.transform,
    this.validator,
    this.dense = false,
    this.readOnly = false,
    this.autofocus = false,
    this.autocorrect = false,
  });
}
