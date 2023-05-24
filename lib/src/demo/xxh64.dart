import 'package:flutter/material.dart';
import 'package:hashlib/hashlib.dart' show XXHash64, HashDigest;
import 'package:hashlib_demo/src/components/digest_view.dart';
import 'package:hashlib_demo/src/form/input_form.dart';
import 'package:hashlib_demo/src/utils/converter.dart';

class XXH64Demo extends StatefulWidget {
  const XXH64Demo({super.key});

  @override
  State<StatefulWidget> createState() => _XXH64DemoState();
}

class _XXH64DemoState extends State<XXH64Demo> {
  HashDigest? digest;
  final seed = NumberInputFormField(
    label: 'Seed (64-bit integer)',
    value: 0,
    bitLength: 64,
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
    var bytes = inputFormat.value?.apply(input.value) ?? [];
    digest = XXHash64(s).convert(bytes);
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
