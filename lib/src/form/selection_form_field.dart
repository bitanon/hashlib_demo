import 'package:flutter/material.dart';

import 'input_form_field.dart';

class SelectionFormField<T extends Object> extends InputFormField<T> {
  Iterable<T> options;
  String Function(T)? optionLabel;
  DropdownMenuItem<T> Function(T)? optionBuilder;

  SelectionFormField({
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
    required super.value,
    required this.options,
    this.optionLabel,
    this.optionBuilder,
  });

  @override
  Widget build(BuildContext context) {
    var buildLabel = optionLabel ?? (v) => '$v';
    var buildOption = optionBuilder ??
        (option) => DropdownMenuItem(
              value: option,
              child: Text(buildLabel(option)),
            );

    return DropdownButtonFormField(
      value: value,
      style: TextStyle(
        color: enabled ? Colors.cyanAccent : null,
      ).merge(style),
      autofocus: autofocus,
      validator: validator,
      items: options.map(buildOption).toList(),
      onChanged: enabled ? _handleChange : null,
      decoration: InputDecoration(
        isDense: dense,
        hintText: hint,
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  void _handleChange(T? value) {
    onChange?.call(value);
    onSubmit?.call();
  }
}
