import 'package:flutter/material.dart';

import 'input_form_base.dart';

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
