import 'package:first/views/pages/welcome_pages.dart';
import 'package:flutter/material.dart';

class MyProfile extends StatelessWidget {
  const MyProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Logout'),
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return WelcomePages();
            },
          ),
        );
      },
    );
  }
}
