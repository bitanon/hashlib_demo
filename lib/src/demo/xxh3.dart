import 'package:flutter/material.dart';
import 'package:hashlib/hashlib.dart' show XXH3, HashDigest;
import 'package:hashlib_demo/src/components/digest_view.dart';
import 'package:hashlib_demo/src/components/input_form.dart';
import 'package:hashlib_demo/src/utils/converter.dart';

class XXH3Demo extends StatefulWidget {
  const XXH3Demo({super.key});

  @override
  State<StatefulWidget> createState() => _XXH3DemoState();
}

class _XXH3DemoState extends State<XXH3Demo> {
  HashDigest? digest;
  final seed = NumberInputFormField(
    label: 'Seed (64-bit integer)',
    value: 0,
    bitLength: 64,
  );
  final secretFormat = SelectionFormField(
    label: 'Secret format',
    value: TextInputFormat.base16,
    options: TextInputFormat.values,
  );
  final secret = TextInputFormField(
    label: 'Secret text',
  );
  final inputFormat = SelectionFormField(
    label: 'Input format',
    value: TextInputFormat.utf8,
    options: TextInputFormat.values,
  );
  final input = TextInputFormField(
    label: 'Input text',
    value: 'Hashlib',
  );

  void makeDigest() {
    int s = seed.value ?? 0;
    var k = secretFormat.value?.apply(secret.value);
    var bytes = inputFormat.value?.apply(input.value) ?? [];

    if (s == 0) {
      secret.enabled = true;
      secretFormat.enabled = true;
      if (k != null && k.length >= 136) {
        seed.enabled = false;
      } else {
        k = null;
        seed.enabled = true;
      }
    } else {
      k = null;
      secret.enabled = false;
      secretFormat.enabled = false;
    }

    digest = XXH3(seed: s, secret: k).convert(bytes);
  }

  @override
  void initState() {
    makeDigest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        InputForm(
          inputs: [
            seed,
            secretFormat,
            secret,
            inputFormat,
            input,
          ],
          onChange: (_) => setState(makeDigest),
        ),
        const Divider(height: 30),
        HashDigestView(digest),
      ],
    );
  }
}
