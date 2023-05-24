import 'package:flutter/material.dart';

import 'input_form_controller.dart';

class TextInputFormField extends InputFormController<String> {
  int minLines;
  int maxLines;
  int maxLength;

  TextInputFormField({
    super.value = '',
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
    this.minLines = 2,
    this.maxLines = 8,
    this.maxLength = 1000,
  });

  @override
  get transform => super.transform ?? (text) => text ?? '';

  @override
  Widget build(BuildContext context) {
    var submitted = onSubmit ?? () {};
    var changed = onChange ?? (_) {};
    return TextFormField(
      enabled: enabled,
      controller: controller,
      readOnly: readOnly,
      maxLength: maxLength,
      minLines: minLines,
      maxLines: maxLines,
      autofocus: autofocus,
      autocorrect: autocorrect,
      validator: validator,
      autovalidateMode: AutovalidateMode.always,
      style: style,
      textAlignVertical: TextAlignVertical.top,
      onFieldSubmitted: (_) => submitted(),
      onChanged: (value) => changed(transform!(value)),
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
