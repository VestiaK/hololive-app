import 'package:flutter/material.dart';

class HeroWidget extends StatelessWidget {
  const HeroWidget({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Hero(
          tag: 'hero1',
          child: Center(
            child: Padding(
              padding: EdgeInsetsGeometry.all(20.0),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(20.0),
                    child: Image.network(
                      'https://png.pngtree.com/thumb_back/fh260/background/20250205/pngtree-soft-pastel-floral-design-light-blue-background-image_16896113.jpg',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        FittedBox(
          child: Text(
            title,
            style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, letterSpacing: 30.0, color: Colors.black54),
          ),
        ),
      ],
    );
  }
}
