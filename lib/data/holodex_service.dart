import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dart_holodex_api/dart_holodex_api.dart';

class HolodexService {
  final HolodexClient client = HolodexClient(
    apiKey: dotenv.env['HOLODEX_API_KEY'] ?? '',
  );


  Future<List<VideoFull>> fetchLiveVideos({Organization? org, int offset = 0}) async {
    try {
      final response = await client.getLiveVideos(
        VideoFilter(
          organization: org, 
          status: [VideoStatus.live], 
          type: VideoType.stream,
          includes: [Includes.liveInfo],
          limit: 20, 
          offset: offset, 
        ),
      );
      return response.items; 
    } catch (e) {
      throw Exception('Gagal mengambil data live: $e');
    }
  }


  Future<List<VideoFull>> fetchUploadedVideos({Organization? org, int offset = 0}) async {
    try {
      final response = await client.getVideos( 
        VideoFilter(
          organization: org, 
          status: [VideoStatus.past], 
          type: VideoType.stream,
          includes: [Includes.liveInfo],
          limit: 10,
          offset: offset, 
        ),
      );
      return response.items; 
    } catch (e) {
      throw Exception('Gagal mengambil data video: $e');
    }
  }

  Future<List<VideoFull>> fetchChannelVideos(String channelId) async {
    try {
      final response = await client.getVideos(
        VideoFilter(
          channelId: channelId,
          limit: 50, 
          includes: [Includes.liveInfo],
        ),
      );
      return response.items; 
    } catch (e) {
      throw Exception('Gagal mengambil data video channel: $e');
    }
  }
}