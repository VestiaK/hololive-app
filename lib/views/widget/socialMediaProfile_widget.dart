import 'package:first/data/notifiers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';


class SocialMediaProfile extends StatelessWidget {
  final String label;
  final FaIconData icon;
  final Color iconColor;
  final String url;

  const SocialMediaProfile({
    super.key,
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.url,
  });

  Future<void> _launchURL() async {
    final Uri parsedUrl = Uri.parse(url);
    if (!await launchUrl(parsedUrl)) {
      throw Exception('Gagal membuka link $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: darkmode,
      builder: (context, dark, child) {
        return ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: dark ? Colors.white : const Color(0xFF1F2431),
          ),
          onPressed: _launchURL,
          icon: FaIcon(icon, color: iconColor),
          label: Text(label, style: TextStyle(color: dark ?  Colors.black87 : Colors.white)),
        );
      }
    );
  }
}