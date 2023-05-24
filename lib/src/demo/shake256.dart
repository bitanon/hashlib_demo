import 'package:flutter/material.dart';
import 'package:hashlib/hashlib.dart' show Shake256, HashDigest;
import 'package:hashlib_demo/src/components/digest_view.dart';
import 'package:hashlib_demo/src/form/input_form.dart';
import 'package:hashlib_demo/src/form/slider_input_field.dart';
import 'package:hashlib_demo/src/utils/converter.dart';

class SHAKE256Demo extends StatefulWidget {
  const SHAKE256Demo({super.key});

  @override
  State<StatefulWidget> createState() => _SHAKE256DemoState();
}

class _SHAKE256DemoState extends State<SHAKE256Demo> {
  HashDigest? digest;
  final outputLength = SliderInputFormField(
    label: 'Output length',
    prefix: 'Bits',
    min: 8,
    max: 1024,
    step: 8,
    value: 256,
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

  void makeDigest() {
    var bytes = format.value?.apply(input.value) ?? [];
    digest = Shake256(outputLength.value! >>> 3).convert(bytes);
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
          onSubmit: () => setState(makeDigest),
          inputs: [
            outputLength,
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
