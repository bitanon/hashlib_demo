import 'package:flutter/material.dart';

class InputTextField extends StatelessWidget {
  final String label;
  final bool enabled;
  final int maxLength;
  final int minLines;
  final int maxLines;
  final bool multiline;
  final String? initialValue;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onSubmit;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;

  const InputTextField({
    super.key,
    this.onChanged,
    this.controller,
    this.initialValue,
    this.keyboardType,
    this.validator,
    this.onSubmit,
    this.minLines = 2,
    this.maxLines = 8,
    this.enabled = true,
    this.multiline = true,
    this.maxLength = 1000,
    this.label = 'Input text',
    this.textInputAction = TextInputAction.done,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      autofocus: false,
      autocorrect: false,
      maxLength: maxLength,
      validator: validator,
      onChanged: onChanged,
      controller: controller,
      keyboardType: keyboardType,
      initialValue: initialValue,
      onFieldSubmitted: onSubmit,
      textInputAction: textInputAction,
      minLines: multiline ? minLines : null,
      maxLines: multiline ? maxLines : null,
      textAlignVertical: TextAlignVertical.top,
      autovalidateMode: AutovalidateMode.always,
      style: const TextStyle(
        color: Colors.cyanAccent,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
