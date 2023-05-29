import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:hashlib_demo/src/utils/utils.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.code, size: 96),
          Text(
            'Hashlib Demo',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 10),
          Linkify(
            text: "A demo app for https://pub.dev/packages/hashlib",
            options: const LinkifyOptions(humanize: false),
            linkStyle: const TextStyle(
              color: Colors.cyanAccent,
              decoration: TextDecoration.none,
            ),
            onOpen: (link) async {
              final messenger = ScaffoldMessenger.of(context);
              final result = await launchUrlString(
                link.url,
                mode: LaunchMode.externalApplication,
              );
              if (!result) {
                showSnackBar(messenger, 'Could not launch ${link.url}');
              }
            },
          ),
        ],
      ),
    );
  }
}
