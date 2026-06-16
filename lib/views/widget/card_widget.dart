import 'package:flutter/material.dart';
// 1. Pastikan import holodex ada di sini
import 'package:dart_holodex_api/dart_holodex_api.dart'; 

class CardWidget extends StatelessWidget {
  // 2. PASTIKAN tipe datanya adalah VideoFull, BUKAN Video
  final VideoFull video; 

  const CardWidget({Key? key, required this.video}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.network(
            'https://i.ytimg.com/vi/${video.id}/hqdefault.jpg',
            fit: BoxFit.cover,
          ),
          ListTile(
            title: Text(video.title ?? 'No Title'),
            subtitle: Text(video.channel?.name ?? 'Unknown Channel'),
          ),
        ],
      ),
    );
  }
}