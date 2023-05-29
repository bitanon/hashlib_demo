import 'package:flutter/material.dart';
import 'package:hashlib_demo/src/auth/authenticator.dart';
import 'package:hashlib_demo/src/auth/password_prompt.dart';
import 'package:hashlib_demo/src/utils/hive_box.dart';
import 'package:hashlib_demo/src/utils/utils.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PasswordPromptDialog(
        onSubmit: (password) => openBox(context, password),
      ),
    );
  }

  void openBox(BuildContext context, String password) async {
    var navigator = Navigator.of(context);
    var messenger = ScaffoldMessenger.of(context);
    showSnackBar(messenger, 'Opening box. Please wait...');
    try {
      var authBox = await openOTPBox(password);
      messenger.clearSnackBars();
      navigator.push(
        MaterialPageRoute(
          fullscreenDialog: true,
          maintainState: false,
          builder: (context) => AuthenticatorDialog(authBox),
        ),
      );
    } catch (err) {
      openSnackBar(context, '$err');
    }
  }
}
