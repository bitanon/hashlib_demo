import 'package:flutter/material.dart';

import 'input_form_base.dart';
import 'input_form_field.dart';

export 'number_input_field.dart';
export 'selection_form_field.dart';
export 'submit_button_field.dart';
export 'text_input_field.dart';

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
