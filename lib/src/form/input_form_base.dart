import 'package:flutter/material.dart';

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
