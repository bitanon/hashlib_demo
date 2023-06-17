import 'package:flutter/material.dart';
import 'package:hashlib_demo/src/auth/authenticator.dart';
import 'package:hashlib_demo/src/auth/password_prompt.dart';
import 'package:hashlib_demo/src/utils/hive_box.dart';
import 'package:hashlib_demo/src/utils/utils.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<StatefulWidget> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool loading = false;
  List<OTPBox> data = [];
  String? error;

  @override
  void initState() {
    super.initState();
    refreshList();
  }

  Future<void> refreshList() async {
    loading = true;
    if (mounted) setState(() {});
    try {
      data = await getBoxList();
    } catch (err) {
      error = '$err';
    } finally {
      loading = false;
      if (mounted) setState(() {});
    }
  }

  @override
  void didUpdateWidget(covariant AuthPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    refreshList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Expanded(
            child: Builder(builder: buildBoxList),
          ),
          const Divider(height: 20),
          buildCreateButton(),
        ],
      ),
    );
  }

  Widget buildCreateButton() {
    return ElevatedButton(
      onPressed: () => enterBox(),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text('New Authenticator'),
          ),
        ],
      ),
    );
  }

  Widget buildBoxList(BuildContext context) {
    return FutureBuilder<List<OTPBox>>(
      future: getBoxList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.data == null || snapshot.data!.isEmpty) {
          return Center(child: buildNoData());
        }
        final count = snapshot.data!.length;
        final children = <Widget>[
          Text(
            '$count authenticators are available',
            style: const TextStyle(fontSize: 18),
          ),
          const Divider(height: 25),
        ];
        for (final box in snapshot.data!) {
          children.add(buildBoxTile(box));
        }
        return ListView(children: children);
      },
    );
  }

  Widget buildNoData() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.science_rounded,
          size: 64,
          color: Theme.of(context).primaryColorLight,
        ),
        Text(
          'No authenticator available.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).primaryColorLight),
        ),
      ],
    );
  }

  Widget buildBoxTile(OTPBox box) {
    return Card(
      child: ListTile(
        onTap: () => enterBox(box),
        onLongPress: () => deleteBox(box),
        title: Text(
          box.name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          'Last modified: ${formatDateTime(box.updatedAt)}',
          style: TextStyle(
            color: Theme.of(context).primaryColorLight,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        leading: CircleAvatar(
          radius: 24,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Text(
              formatSize(box.size, gap: ''),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColorLight,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> enterBox([OTPBox? box]) async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final passwordPrompt = DialogRoute<String>(
      context: context,
      builder: (context) => PasswordPromptDialog(
        onCancel: () => Navigator.of(context).pop(),
        onSubmit: (password) => Navigator.of(context).pop(password),
        acceptText: box == null ? 'Submit' : 'Enter',
        titleText: box == null ? 'New Authenticator' : 'Open ${box.name}',
      ),
    );

    var password = await navigator.push(passwordPrompt);
    if (password == null || password.isEmpty) return;

    showSnackBar(messenger, 'Opening box...');
    try {
      var authBox = await openOTPBox(password, box);
      messenger.clearSnackBars();
      navigator.push(
        MaterialPageRoute(
          fullscreenDialog: true,
          maintainState: false,
          builder: (context) => AuthenticatorDialog(authBox),
        ),
      );
      refreshList();
    } catch (err) {
      showSnackBar(messenger, '$err');
    }
  }

  Future<void> deleteBox(OTPBox box) async {
    final messenger = ScaffoldMessenger.of(context);

    final confirmation = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete ${box.name}?'),
        content: const Text('Are you sure to delete this box? '
            'The contents will be lost forever!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Yes',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
    if (confirmation == null || !confirmation) return;
    try {
      await deleteOTPBox(box);
      refreshList();
    } catch (err) {
      showSnackBar(messenger, '$err');
    }
  }
}
