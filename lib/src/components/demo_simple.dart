import 'package:flutter/material.dart';
import 'package:hashlib/hashlib.dart' show HashBase, HashDigest;
import 'package:hashlib_demo/src/components/digest_view.dart';
import 'package:hashlib_demo/src/form/input_form.dart';
import 'package:hashlib_demo/src/utils/converter.dart';

class SimpleDemoPage extends StatefulWidget {
  final HashBase algorithm;

  const SimpleDemoPage(this.algorithm, {super.key});

  @override
  State<StatefulWidget> createState() => _SimpleDemoPageState();
}

class _SimpleDemoPageState extends State<SimpleDemoPage> {
  HashDigest? digest;
  final format = SelectionFormField(
    label: 'Input format',
    value: TextInputFormat.utf8,
    options: TextInputFormat.values,
  );
  late final input = TextInputFormField(
    label: 'Input text',
    value: 'Hashlib',
    validator: (value) {
      if (value == null || value.isEmpty || format.value == null) {
        return null;
      }
      var i = format.value?.apply(value);
      if (i != null && i.isNotEmpty) return null;
      return 'Invalid ${format.value} string';
    },
  );

  makeDigest() {
    var bytes = format.value?.apply(input.value) ?? [];
    digest = widget.algorithm.convert(bytes);
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
