import 'package:flutter/material.dart';
import 'package:hashlib/hashlib.dart' show HashDigest;
import 'package:hashlib_demo/src/form/input_form.dart';
import 'package:hashlib_demo/src/utils/converter.dart';
import 'package:hashlib_demo/src/utils/utils.dart';
import 'package:hive/hive.dart';

class HashDigestView extends StatefulWidget {
  final HashDigest? digest;

  const HashDigestView(this.digest, {super.key});

  @override
  State<StatefulWidget> createState() => _HashDigestViewState();
}

class _HashDigestViewState extends State<HashDigestView> {
  Box? config;
  String content = '';
  final format = SelectionFormField(
    label: 'Output format',
    value: TextOutputFormat.base16,
    options: TextOutputFormat.values,
  );

  makeDigest() {
    content = format.value?.apply(widget.digest?.bytes) ?? '';
    saveConfig();
  }

  openConfig() async {
    config = await Hive.openBox('app-config');
    int saved = config!.get(
      'digest format',
      defaultValue: format.value,
    );
    format.value = TextOutputFormat.values[saved];
    if (mounted) setState(makeDigest);
  }

  saveConfig() async {
    if (config == null || format.value == null) return;
    await config!.put(
      'digest format',
      format.value!.index,
    );
  }

  @override
  void initState() {
    makeDigest();
    super.initState();
    openConfig();
  }

  @override
  void didUpdateWidget(covariant HashDigestView oldWidget) {
    super.didUpdateWidget(oldWidget);
    makeDigest();
    openConfig();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InputForm(
          inputs: [format],
          onChange: (value) => setState(makeDigest),
        ),
        const SizedBox(height: 10),
        Builder(builder: buildTextViewer),
      ],
    );
  }

  Widget buildTextViewer(BuildContext context) {
    return Stack(
      children: [
        TextFormField(
          minLines: 2,
          maxLines: 8,
          readOnly: true,
          maxLength: content.isEmpty ? null : content.length,
          textAlignVertical: TextAlignVertical.top,
          controller: TextEditingController(text: content),
          style: const TextStyle(
            color: Colors.amberAccent,
            fontSize: 16,
          ),
          decoration: const InputDecoration(
            label: Text('Hash Digest'),
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.only(
              top: 14,
              left: 12,
              right: 12,
              bottom: 32,
            ),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 24,
          child: Builder(builder: buildCopyButton),
        ),
      ],
    );
  }

  Widget buildCopyButton(BuildContext context) {
    if (content.isEmpty) {
      return Container();
    }
    return IconButton(
      icon: const Icon(
        Icons.copy,
        size: 18,
      ),
      style: const ButtonStyle(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: () => copyToClipboard(
        text: content,
        context: context,
      ),
    );
  }
}
