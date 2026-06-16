import 'package:first/data/constants.dart';
import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {

  final String title;
  final String description;
  final String image;
  final VoidCallback onTap;

  const CardWidget({super.key, required this.title, required this.description, required this.image, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(image, height: 100, ),
            SizedBox(height: 5,),
            Text(title, style: KtextStyle.titleCard),
            Text(description, style: KtextStyle.deCard),
          ],
        ),
      ),
    );
  }
}