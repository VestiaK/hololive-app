import 'package:first/data/constants.dart';
import 'package:first/data/notifiers.dart';
import 'package:flutter/material.dart';

class ProfileheaderWidget extends StatelessWidget {
  final String name;
  final String headerBg;
  final String highlightImage;
  final List<String> avatar;

  const ProfileheaderWidget({
    super.key,
    required this.name,
    required this.headerBg,
    required this.highlightImage,
    required this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
          child: ValueListenableBuilder(
            valueListenable: darkmode,
            builder: (context, dark, child) {
              return Image.asset(headerBg, color: dark ? null :Colors.black.withValues(alpha: 0.6),colorBlendMode: BlendMode.darken);
            }
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, top: 10),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios, size: 40),
          ),
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Center(
                child: Card(child: Text(name, style: DetailText.title)),
              ),
            ),
            Center(
              child: Image.network(highlightImage,
                height: 400,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: avatar.map(
                (imagePath) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5.0,
                    ), 
                    child: ValueListenableBuilder(
                      valueListenable: darkmode,
                      builder: (context, dark, child) {
                        return CircleAvatar(
                          radius: 40,
                          backgroundColor: dark ? Colors.white : const Color(0xFF1F2431),
                          backgroundImage: AssetImage(
                            imagePath,
                          ), 
                        );
                      }
                    ),
                  );
                },
              ).toList(), 
            ),
          ],
        ),
      ],
    );
  }
}
