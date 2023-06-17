import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(25),
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(100),
              child: CircleAvatar(
                maxRadius: 96,
                child: Image.asset('images/logo.png'),
              ),
              onTap: () {
                launchUrlString(
                  'https://play.google.com/store/apps/details?id=io.bitanon.hashlib_demo',
                  mode: LaunchMode.externalApplication,
                );
              },
            ),
            const SizedBox(height: 10),
            buildAppName(),
            const SizedBox(height: 10),
            Linkify(
              text: "A demo app for https://pub.dev/packages/hashlib",
              options: const LinkifyOptions(humanize: false),
              linkStyle: const TextStyle(
                color: Colors.cyanAccent,
                decoration: TextDecoration.none,
              ),
              onOpen: (link) {
                launchUrlString(
                  link.url,
                  mode: LaunchMode.externalApplication,
                );
              },
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  Widget buildAppName() {
    return FutureBuilder(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Container();
        }
        final info = snapshot.data!;
        return Text(
          'Hashlib Demo v${info.version}',
          style: Theme.of(context).textTheme.headlineSmall,
        );
      },
    );
  }
}
