import 'package:flutter/material.dart';
import 'package:hashlib/hashlib.dart' show Shake128, shake128_256, HashDigest;
import 'package:hashlib_demo/src/components/digest_view.dart';
import 'package:hashlib_demo/src/components/input_text.dart';
import 'package:hashlib_demo/src/components/slider.dart';

const _initialText = 'Hashlib';

class SHAKE128Demo extends StatefulWidget {
  const SHAKE128Demo({super.key});

  @override
  State<StatefulWidget> createState() => _SHAKE128DemoState();
}

class _SHAKE128DemoState extends State<SHAKE128Demo> {
  int bitLength = 256;
  var input = TextEditingController(text: _initialText);
  HashDigest? digest = shake128_256.string(_initialText);

  void makeDigest() {
    digest = Shake128(bitLength >>> 3).string(input.text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SliderInput(
          label: 'Output length',
          prefix: 'Bits',
          value: bitLength,
          min: 8,
          max: 1024,
          step: 8,
          onChanged: (value) {
            if (value == bitLength) return;
            setState(() {
              bitLength = value;
              makeDigest();
            });
          },
        ),
        const SizedBox(height: 10),
        InputTextField(
          controller: input,
          onChanged: (_) => setState(makeDigest),
        ),
        const Divider(height: 30),
        HashDigestView(digest),
      ],
    );
  }
}
