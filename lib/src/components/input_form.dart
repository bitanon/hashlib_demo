import 'dart:math' show ln10, ln2, max, min;

import 'package:flutter/material.dart';

class TextInputConfig {
  final int minLines;
  final int maxLines;
  final int maxLength;

  const TextInputConfig({
    this.minLines = 2,
    this.maxLines = 8,
    this.maxLength = 1000,
  });
}

abstract class InputFormBase<T extends Object> {
  VoidCallback? onSubmit;
  TextStyle style;
  String? label;
  String? hint;
  bool enabled;

  InputFormBase({
    this.hint,
    this.label,
    this.onSubmit,
    this.enabled = true,
    this.style = const TextStyle(fontSize: 16),
  });

  Widget build(BuildContext context);
}

class SubmitButtonFormField extends InputFormBase {
  SubmitButtonFormField({
    super.onSubmit,
    super.label,
    super.enabled = true,
    super.style = const TextStyle(fontSize: 16),
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onSubmit,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label ?? 'Submit',
            style: style,
          ),
        ],
      ),
    );
  }
}

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

class InputForm extends StatelessWidget {
  final Iterable<InputFormBase> inputs;
  final double? itemGap;
  final void Function()? onSubmit;
  final void Function(InputFormField config)? onChange;

  const InputForm({
    super.key,
    this.onChange,
    this.onSubmit,
    this.itemGap,
    required this.inputs,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Builder(
        builder: buildFieldArray,
      ),
    );
  }

  Widget buildFieldArray(BuildContext context) {
    var children = <Widget>[];
    for (final config in inputs) {
      config.onSubmit = () {
        if (!Form.of(context).validate()) return;
        FocusScope.of(context).unfocus();
        onSubmit?.call();
      };
      if (config is InputFormField) {
        config.onChange = (value) {
          config.value = value;
          onChange?.call(config);
        };
      }
      if (children.isNotEmpty) {
        children.add(SizedBox(height: itemGap ?? 10));
      }
      children.add(Builder(builder: config.build));
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}
