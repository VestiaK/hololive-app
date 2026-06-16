import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dart_holodex_api/dart_holodex_api.dart';

class HolodexService {
  final HolodexClient client = HolodexClient(
    apiKey: dotenv.env['HOLODEX_API_KEY'] ?? '',
  );

  // Tipe kembalian sudah diubah menjadi List<VideoFull>
  Future<List<VideoFull>> fetchLiveVideos() async {
    try {
      final response = await client.getLiveVideos();
      // Mengembalikan properti items yang sudah berupa List<VideoFull>
      return response.items; 
    } catch (e) {
      throw Exception('Gagal mengambil data live: $e');
    }
  }
}