import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dart_holodex_api/dart_holodex_api.dart';

class HolodexService {
  final HolodexClient client = HolodexClient(
    apiKey: dotenv.env['HOLODEX_API_KEY'] ?? '',
  );

  // Ubah Organization menjadi nullable (Organization?)
  Future<List<VideoFull>> fetchLiveVideos({Organization? org}) async {
    try {
      final response = await client.getLiveVideos(
        VideoFilter(
          organization: org, // Jika null, otomatis mengambil ALL Agency
          status: [VideoStatus.live], 
          type: VideoType.stream,
          includes: [Includes.liveInfo],
          limit: 50,
        ),
      );
      return response.items; 
    } catch (e) {
      throw Exception('Gagal mengambil data live: $e');
    }
  }
}