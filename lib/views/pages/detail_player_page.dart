import 'package:flutter/material.dart';
import 'package:dart_holodex_api/dart_holodex_api.dart';
import 'package:url_launcher/url_launcher.dart'; 

class DetailPlayerPage extends StatelessWidget {
  final VideoFull video;

  const DetailPlayerPage({Key? key, required this.video}) : super(key: key);

  // Fungsi untuk membuka link langsung ke aplikasi YouTube / Browser
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

  @override
  Widget build(BuildContext context) {
    final videoId = video.id;
    // Mengambil gambar thumbnail resolusi tinggi langsung dari server YouTube berdasarkan ID Video
    final thumbnailUrl = 'https://img.youtube.com/vi/$videoId/maxresdefault.jpg';

    return Scaffold(
      // Mencegah error perhitungan layar negatif saat resize browser Web
      resizeToAvoidBottomInset: false, 
      appBar: AppBar(
        title: Text(video.channel?.name ?? 'Detail Streaming'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- BAGIAN GAMBAR THUMBNAIL (PENGGANTI PLAYER) ---
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                thumbnailUrl,
                fit: BoxFit.cover,
                // Jika gambar resolusi maksimal (maxresdefault) tidak tersedia, 
                // otomatis pindah mengambil resolusi standar (hqdefault) agar tidak blank
                errorBuilder: (context, error, stackTrace) {
                  return Image.network(
                    'https://img.youtube.com/vi/$videoId/hqdefault.jpg',
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            
            // --- BAGIAN DETAIL INFORMASI & TOMBOL ---
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
                  const SizedBox(height: 8),
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
                  
                  // --- TOMBOL UTAMA UNTUK NONTON KE YT ---
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