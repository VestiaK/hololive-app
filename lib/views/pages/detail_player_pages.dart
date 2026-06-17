import 'package:first/views/pages/channel_detail_pages.dart';
import 'package:flutter/material.dart';
import 'package:dart_holodex_api/dart_holodex_api.dart';
import 'package:url_launcher/url_launcher.dart'; 

class DetailPlayerPage extends StatelessWidget {
  final VideoFull video;

  const DetailPlayerPage({Key? key, required this.video}) : super(key: key);

  Future<void> _launchYouTubeApp(BuildContext context) async {
    final videoId = video.id;
    final Uri url = Uri.parse('https://www.youtube.com/watch?v=$videoId');
    
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication); 
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak dapat membuka aplikasi YouTube')),
        );
      }
    }
  }

  void _goToChannel(BuildContext context) {
    if (video.channel != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChannelDetailPages(channel: video.channel!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final videoId = video.id;
    final thumbnailUrl = 'https://img.youtube.com/vi/$videoId/maxresdefault.jpg';

    return Scaffold(
      resizeToAvoidBottomInset: false, 
      appBar: AppBar(
        title: Text(video.channel?.name ?? 'Detail Streaming'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                thumbnailUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.network(
                    'https://img.youtube.com/vi/$videoId/hqdefault.jpg',
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: const TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // --- PROFIL CHANNEL BISA DIKLIK ---
                  InkWell(
                    onTap: () => _goToChannel(context),
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(video.channel?.photo ?? ''),
                            onBackgroundImageError: (_, __) => const Icon(Icons.person),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              video.channel?.name ?? 'Unknown Channel',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 24),

                  Row(
                    children: [
                      const Icon(Icons.radio_button_checked, color: Colors.red, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'STATUS: ${video.status?.name.toUpperCase() ?? "LIVE"}',
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () => _launchYouTubeApp(context),
                      icon: const Icon(Icons.open_in_new),
                      label: const Text(
                        'Tonton Siaran Langsung di YouTube',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}