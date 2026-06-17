import 'package:first/data/holodex_service.dart';
import 'package:first/views/widget/card_widget.dart';
import 'package:flutter/material.dart';
import 'package:dart_holodex_api/dart_holodex_api.dart';

class ChannelDetailPages extends StatefulWidget {
  final ChannelMin channel;

  const ChannelDetailPages({Key? key, required this.channel}) : super(key: key);

  @override
  State<ChannelDetailPages> createState() => _ChannelDetailPagesState();
}

class _ChannelDetailPagesState extends State<ChannelDetailPages> {
  final HolodexService _holodexService = HolodexService();
  
  List<VideoFull> _channelVideos = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchVideos();
  }

  Future<void> _fetchVideos() async {
    try {
      final videos = await _holodexService.fetchChannelVideos(widget.channel.id);
      setState(() {
        _channelVideos = videos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.channel.name ?? 'Channel Detail'),
      ),
      body: Column(
        children: [

          Container(
            padding: const EdgeInsets.all(20.0),
            color: Theme.of(context).cardColor,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(widget.channel.photo ?? ''),
                  onBackgroundImageError: (_, __) => const Icon(Icons.person, size: 40),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.channel.name ?? 'Unknown Channel',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.channel.englishName ?? 'VTuber Channel',
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),
          
          Expanded(
            child: _buildVideoList(),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null) {
      return Center(child: Text('Error: $_errorMessage'));
    }
    if (_channelVideos.isEmpty) {
      return const Center(child: Text('Belum ada video dari channel ini.'));
    }

    return ListView.builder(
      itemCount: _channelVideos.length,
      itemBuilder: (context, index) {
        return CardWidget(video: _channelVideos[index]);
      },
    );
  }
}