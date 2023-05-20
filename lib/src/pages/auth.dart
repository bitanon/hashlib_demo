import 'package:flutter/material.dart';
import 'package:hashlib/hashlib.dart' show TOTP;
import 'package:hashlib_demo/src/auth/authenticator.dart';
import 'package:hashlib_demo/src/utils/hive_box.dart';
import 'package:hashlib_demo/src/utils/utils.dart';
import 'package:hive/hive.dart';

Box<String>? authBox;

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<StatefulWidget> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final password = TextEditingController();
  bool showPassword = false;
  bool passwordValid = false;
  bool loading = false;
  Iterable<TOTP> instances = [];

  @override
  void initState() {
    super.initState();
    readInstances();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (authBox != null) {
      return OTPAuthViewer(
        onClosed: closeBox,
        instances: instances,
        onChanged: saveInstances,
      );
    }
    return Center(
      child: Builder(builder: buildPasswordInputDialog),
    );
  }

  Widget buildPasswordInputDialog(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text('Open Authenticator'),
      content: SizedBox(
        width: 300,
        child: TextFormField(
          controller: password,
          onChanged: checkPassword,
          onFieldSubmitted: (_) => openBox(),
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
              icon:
                  Icon(showPassword ? Icons.visibility_off : Icons.visibility),
            ),
          ),
          validator: (value) => value == null || value.length < 4
              ? 'At least 4 digits are required'
              : null,
        ),
      ),
      actions: [
        ElevatedButton.icon(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).primaryColor,
          ),
          onPressed: passwordValid ? openBox : null,
          icon: const Icon(Icons.login),
          label: const Text('Enter'),
        ),
      ],
    );
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

  void openBox() async {
    if (!passwordValid) return;
    setState(() {
      loading = true;
      showPassword = false;
    });
    try {
      authBox = await openOTPBox(password.text);
      readInstances();
      setState(() {
        loading = false;
        password.clear();
        passwordValid = false;
      });
    } catch (err) {
      setState(() {
        loading = false;
      });
      openSnackBar(context, 'Failed to open the box.\n$err');
    }
  }

  void closeBox() async {
    await authBox?.close();
    setState(() {
      authBox = null;
      instances = [];
    });
  }

  void readInstances() {
    if (authBox == null) {
      instances = [];
    } else {
      instances = readOTPEntries(authBox!);
    }
  }

  void saveInstances(Iterable<TOTP> values) async {
    setState(() {
      loading = true;
    });
    try {
      await saveOTPEntries(authBox!, values);
      setState(() {
        loading = false;
        readInstances();
      });
    } catch (err) {
      setState(() {
        loading = false;
        readInstances();
      });
      openSnackBar(context, 'Failed to update.\n$err');
    }
  }
}
