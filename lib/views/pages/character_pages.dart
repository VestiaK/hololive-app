import 'package:first/data/notifiers.dart';
import 'package:first/views/widget/profileDetail_widget.dart';
import 'package:first/views/widget/profileHeader_widget.dart';
import 'package:flutter/material.dart';

class CharacterPages extends StatelessWidget {
  final String name;
  final String namejp;
  final String jiko;
  final String description;
  final String image;
  final String headerBg;
  final String highlightImage;
  final List<String> avatar;

  const CharacterPages({
    super.key,
    required this.name,
    required this.namejp,
    required this.jiko,
    required this.image,
    required this.description,
    required this.headerBg,
    required this.highlightImage,
    required this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ValueListenableBuilder(
          valueListenable: darkmode,
          builder: (context, dark, child) {
            return Container(
              color: dark ? Color(0xFF61AAD8) :Color(0xFF121A2A),
              child: Column(
                children: [
                  ProfileheaderWidget(
                    name: name,
                    headerBg: headerBg,
                    highlightImage: highlightImage,
                    avatar: avatar,
                  ),
                  ProfileDetailWidget(
                    name: name,
                    namejp: namejp,
                    jiko: jiko,
                    description: description,
                    image: image,
                  ),
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}
