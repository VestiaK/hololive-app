import 'package:first/data/constants.dart';
import 'package:flutter/material.dart';

class ProfileheaderWidget extends StatelessWidget {
  final String name;
  final String headerBg;
  final String highlightIamge;
  final List<String> avatar;

  const ProfileheaderWidget({
    super.key,
    required this.name,
    required this.headerBg,
    required this.highlightIamge,
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
          child: Image.asset(headerBg),
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
              child: Image.network(
                'https://hololive.hololivepro.com/wp-content/uploads/2020/07/Kobo-Kanaeru_pr-img_01.webp',
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
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage(
                        imagePath,
                      ), 
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
