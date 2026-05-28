import 'package:first/data/constants.dart';
import 'package:first/views/widget/socialMediaProfile_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileDetailWidget extends StatelessWidget {
  final String name;
  final String namejp;
  final String jiko;
  final String description;
  final String image;

  const ProfileDetailWidget({super.key, required this.name, required this.namejp, required this.jiko, required this.description, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF61AAD8),
      padding: EdgeInsets.all(20),
      child: Center(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            image: DecorationImage(
              image: AssetImage(image),
              fit: BoxFit.cover,
              opacity: 0.15,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(name, style: DetailText.title, textAlign: TextAlign.center),
              Text(
                namejp,
                style: DetailText.titlejp,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 25),
              Text(
                jiko,
                style: DetailText.jiko,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 25),
              Text(
                description,
                textAlign: TextAlign.justify,
                style: DetailText.description,
              ),
              SizedBox(height: 20),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  SocialMediaProfile(label: 'YouTube', icon: FontAwesomeIcons.youtube, iconColor: Colors.red, url: 'https://www.youtube.com/@KoboKanaeru'),
                  SocialMediaProfile(label: 'X', icon: FontAwesomeIcons.xTwitter, iconColor: Colors.black, url: 'https://x.com/kobokanaeru'),
                  SocialMediaProfile(label: 'Instagram', icon: FontAwesomeIcons.instagram, iconColor: Colors.purple, url: 'https://www.instagram.com/kobokanaeru/'),
                  SocialMediaProfile(label: 'TikTok', icon: FontAwesomeIcons.tiktok, iconColor: Colors.black, url: 'https://www.tiktok.com/@kobokanaeru'),
                  SocialMediaProfile(label: 'Facebook', icon: FontAwesomeIcons.facebook, iconColor: Colors.blue, url: 'https://www.facebook.com/KoboKanaeru'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
