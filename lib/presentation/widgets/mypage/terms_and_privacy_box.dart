import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wetravel/core/constants/app_shadow.dart';

class TermsAndPrivacyBox extends StatelessWidget {
  const TermsAndPrivacyBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final url =
            'https://weetravel.notion.site/188e73dd935881a8af01f4f12db0d7c9';
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url));
        } else {
          throw 'Could not launch $url';
        }
      },
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
        ))
    );
  }
}