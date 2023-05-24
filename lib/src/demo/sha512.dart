import 'package:flutter/material.dart';
import 'package:hashlib/hashlib.dart'
    show sha512, sha512t224, sha512t256, HashDigest;
import 'package:hashlib_demo/src/components/digest_view.dart';
import 'package:hashlib_demo/src/form/input_form.dart';
import 'package:hashlib_demo/src/utils/converter.dart';

class SHA512Demo extends StatefulWidget {
  const SHA512Demo({super.key});

  @override
  State<StatefulWidget> createState() => _SHA512DemoState();
}

class _SHA512DemoState extends State<SHA512Demo> {
  HashDigest? digest;
  final variation = SelectionFormField(
    label: 'Variation',
    value: '512 bits',
    options: [
      '512 bits',
      '256 bits',
      '224 bits',
    ],
  );
  final format = SelectionFormField(
    label: 'Input format',
    value: TextInputFormat.utf8,
    options: TextInputFormat.values,
  );
  final input = TextInputFormField(
    label: 'Input text',
    value: 'Hashlib',
  );

  makeDigest() {
    var bytes = format.value?.apply(input.value) ?? [];
    switch (variation.value) {
      case '512 bits':
        digest = sha512.convert(bytes);
        break;
      case '256 bits':
        digest = sha512t256.convert(bytes);
        break;
      case '224 bits':
        digest = sha512t224.convert(bytes);
        break;
    }
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
          itemGap: 10,
          onChange: (_) => setState(makeDigest),
          inputs: [
            variation,
            format,
            input,
          ],
        ),
        const Divider(height: 30),
        HashDigestView(digest),
      ],
    );
  }
}
