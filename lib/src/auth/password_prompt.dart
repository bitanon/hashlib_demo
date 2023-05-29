import 'package:flutter/material.dart';

class PasswordPromptDialog extends StatefulWidget {
  final String titleText;
  final String acceptText;
  final String cancelText;
  final VoidCallback? onCancel;
  final ValueChanged<String> onSubmit;

  const PasswordPromptDialog({
    this.titleText = 'Open Authenticator',
    this.acceptText = 'Enter',
    required this.onSubmit,
    this.cancelText = 'Cancel',
    this.onCancel,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _PasswordPromptDialogState();
}

class _PasswordPromptDialogState extends State<PasswordPromptDialog> {
  final password = TextEditingController();
  bool showPassword = false;
  bool passwordValid = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text(widget.titleText),
      content: SizedBox(
        width: 300,
        child: TextFormField(
          controller: password,
          onChanged: checkPassword,
          onFieldSubmitted: widget.onSubmit,
          obscureText: !showPassword,
          autofocus: true,
          autocorrect: false,
          enableSuggestions: false,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            isDense: true,
            border: const OutlineInputBorder(),
            labelText: 'Password',
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: IconButton(
              onPressed: togglePasswordVisibility,
              icon: Icon(
                showPassword ? Icons.visibility_off : Icons.visibility,
              ),
            ),
          ),
          validator: (value) => value == null || value.length < 4
              ? 'At least 4 digits are required'
              : null,
        ),
      ),
      actions: [
        ...(widget.onCancel != null
            ? [
                ElevatedButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).primaryColor,
                  ),
                  onPressed: widget.onCancel,
                  child: Text(widget.cancelText),
                )
              ]
            : []),
        ElevatedButton.icon(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).primaryColor,
          ),
          onPressed: passwordValid ? handleSubmit : null,
          icon: const Icon(Icons.login),
          label: Text(widget.acceptText),
        ),
      ],
    );
  }

  void handleSubmit() {
    widget.onSubmit(password.text);
  }

  void togglePasswordVisibility() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  void checkPassword(String value) {
    setState(() {
      passwordValid = value.length >= 4;
    });
  }
}
