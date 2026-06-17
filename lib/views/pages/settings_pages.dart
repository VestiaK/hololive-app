import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
// Sesuaikan import ini dengan struktur folder kamu
import 'package:first/data/notifiers.dart'; 

class Settings extends StatelessWidget {
  const Settings({super.key});

  // Fungsi untuk membuka browser sistem ketika teks API diklik
  Future<void> _launchURL() async {
    final Uri url = Uri.parse('https://holodex.net');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Tidak dapat membuka $url');
    }
  }

  // Fungsi untuk memunculkan Popup (Dialog) Informasi
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blueAccent),
              SizedBox(width: 10),
              Text('Informasi & Kredit'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hololive Stream App',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 5),
              // Versi ini diambil dari pubspec.yaml kamu (1.0.0+1)
              const Text('Versi 1.0.0'), 
              const Divider(height: 20, thickness: 1),
              const Text(
                'Aplikasi ini dibuat sebagai proyek portofolio pengembangan antarmuka seluler. Seluruh aset gambar dan video adalah milik agensi VTuber terkait.',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 15),
              const Text(
                'Data Provider:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 5),
              // Teks yang bisa diklik untuk membuka URL
              InkWell(
                onTap: _launchURL,
                child: const Text(
                  'Powered by Holodex API',
                  style: TextStyle(
                    color: Colors.blueAccent,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Tutup',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // --- Kategori: Tampilan ---
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: Text(
              'Tampilan',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          // Menggunakan ValueListenableBuilder untuk update real-time Dark Mode
          ValueListenableBuilder(
            valueListenable: darkmode,
            builder: (context, isDark, child) {
              return ListTile(
                leading: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
                title: const Text('Mode Gelap'),
                trailing: Switch(
                  value: isDark,
                  onChanged: (value) {
                    darkmode.value = value;
                  },
                ),
              );
            },
          ),
          const Divider(),

          // --- Kategori: Tentang Aplikasi ---
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: Text(
              'Tentang',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.code),
            title: const Text('Informasi API & Kredit'),
            subtitle: const Text('Versi, Atribusi Data, & Keterangan Proyek'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showAboutDialog(context), // Memanggil Dialog saat diklik
          ),
        ],
      ),
    );
  }
}