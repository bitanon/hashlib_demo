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
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height -
              kBottomNavigationBarHeight -
              kToolbarHeight,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildLogo(),
            const SizedBox(height: 10),
            buildAppName(),
            const SizedBox(height: 10),
            buildDescription(),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  Widget buildLogo() {
    return InkWell(
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

  Widget buildDescription() {
    return Linkify(
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
    );
  }
}
