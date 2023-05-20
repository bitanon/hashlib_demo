import 'dart:math' show ln2, ln10;

import 'package:flutter/material.dart';

class InputNumberField extends StatelessWidget {
  final bool enabled;
  final int bitLength;
  final String label;
  final ValueChanged<String>? onSubmit;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  const InputNumberField({
    super.key,
    this.enabled = true,
    this.bitLength = 32,
    this.onSubmit,
    this.onChanged,
    this.controller,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      onChanged: onChanged,
      controller: controller,
      onFieldSubmitted: onSubmit,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      maxLength: (bitLength * ln2 / ln10).ceil(),
      validator: (value) {
        int v = (int.tryParse(value ?? '') ?? 0).toUnsigned(32);
        return v.toString() != value ? 'Invalid number' : null;
      },
    );
  }
}
