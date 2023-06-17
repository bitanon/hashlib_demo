import 'package:flutter/material.dart';
import 'package:hashlib/hashlib.dart' show Blake2b, HashDigest;
import 'package:hashlib_demo/src/components/digest_view.dart';
import 'package:hashlib_demo/src/form/input_form.dart';
import 'package:hashlib_demo/src/utils/converter.dart';

class Blake2bDemo extends StatefulWidget {
  const Blake2bDemo({super.key});

  @override
  State<StatefulWidget> createState() => _Blake2bDemoState();
}

class _Blake2bDemoState extends State<Blake2bDemo> {
  HashDigest? digest;
  final variation = SelectionFormField(
    label: 'Variation',
    value: '256 bits',
    options: [
      '512 bits',
      '384 bits',
      '256 bits',
      '224 bits',
      '160 bits',
      '128 bits',
      '64 bits',
      '32 bits',
    ],
  );
  final inputFormat = SelectionFormField(
    label: 'Input format',
    value: TextInputFormat.utf8,
    options: TextInputFormat.values,
  );
  final inputText = TextInputFormField(
    label: 'Input text',
    value: 'Hashlib',
  );
  final keyFormat = SelectionFormField(
    label: 'Key format',
    value: TextInputFormat.utf8,
    options: TextInputFormat.values,
  );
  late final keyText = TextInputFormField(
    label: 'Key for MAC generation (Optional)',
    minLines: 1,
    validator: (value) {
      if (value == null || value.isEmpty) return null;
      var key = keyFormat.value?.apply(value) ?? [];
      if (key.length <= 64) return null;
      return 'Key should not exceed 64 bytes';
    },
  );
  final saltFormat = SelectionFormField(
    label: 'Salt format',
    value: TextInputFormat.utf8,
    options: TextInputFormat.values,
  );
  late final saltText = TextInputFormField(
    label: '16-byte Salt (Optional)',
    minLines: 1,
    validator: (value) {
      if (value == null || value.isEmpty) return null;
      var salt = saltFormat.value?.apply(value) ?? [];
      if (salt.length == 16) return null;
      return 'Salt should be exactly 16 bytes';
    },
  );
  final extraFormat = SelectionFormField(
    label: 'Personalization format',
    value: TextInputFormat.utf8,
    options: TextInputFormat.values,
  );
  late final extraText = TextInputFormField(
    label: '16-byte Personalization (Optional)',
    minLines: 1,
    validator: (value) {
      if (value == null || value.isEmpty) return null;
      var salt = extraFormat.value?.apply(value) ?? [];
      if (salt.length == 16) return null;
      return 'Personalization should be exactly 16 bytes';
    },
  );

  makeDigest() {
    var input = inputFormat.value?.apply(inputText.value) ?? [];
    var key = keyFormat.value?.apply(keyText.value) ?? [];
    var salt = saltFormat.value?.apply(saltText.value) ?? [];
    var extra = extraFormat.value?.apply(extraText.value) ?? [];
    int digestSize = 32;
    switch (variation.value) {
      case '512 bits':
        digestSize = 512 >>> 3;
        break;
      case '384 bits':
        digestSize = 384 >>> 3;
        break;
      case '256 bits':
        digestSize = 256 >>> 3;
        break;
      case '224 bits':
        digestSize = 224 >>> 3;
        break;
      case '160 bits':
        digestSize = 160 >>> 3;
        break;
      case '128 bits':
        digestSize = 128 >>> 3;
        break;
      case '64 bits':
        digestSize = 64 >>> 3;
        break;
      case '32 bits':
        digestSize = 32 >>> 3;
        break;
    }
    digest = Blake2b(
      digestSize,
      key: key.length <= 64 ? key : null,
      salt: salt.length == 16 ? salt : null,
      personalization: extra.length == 16 ? extra : null,
    ).convert(input);
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
            inputFormat,
            inputText,
            keyFormat,
            keyText,
            saltFormat,
            saltText,
            extraFormat,
            extraText,
          ],
        ),
        const Divider(height: 30),
        HashDigestView(digest),
      ],
    );
  }
}
