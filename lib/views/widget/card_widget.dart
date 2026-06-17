import 'package:first/views/pages/detail_player_pages.dart';
import 'package:first/views/pages/channel_detail_pages.dart';
import 'package:first/data/favorite_service.dart'; 
import 'package:flutter/material.dart';
import 'package:dart_holodex_api/dart_holodex_api.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CardWidget extends StatefulWidget {
  final VideoFull video;

  const CardWidget({Key? key, required this.video}) : super(key: key);

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  bool _isFav = false;

  @override
  void initState() {
    super.initState();
    _checkFavorite();
  }


  void _checkFavorite() async {
    final isFav = await FavoriteService.isFavorite(widget.video.id);
    if (mounted) {
      setState(() => _isFav = isFav);
    }
  }


  void _toggleFav() async {

    final videoData = {
      'id': widget.video.id,
      'title': widget.video.title,
      'channelName': widget.video.channel?.name ?? 'Unknown Channel',
      'photo': widget.video.channel?.photo ?? '',
    };

    await FavoriteService.toggleFavorite(videoData);
    _checkFavorite(); 

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isFav ? 'Dihapus dari Favorit' : 'Ditambahkan ke Favorit',
          ),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  void _goToChannel(BuildContext context) {
    if (widget.video.channel != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ChannelDetailPages(channel: widget.video.channel!),
        ),
      );
    }
  }

  void _goToPlayer(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPlayerPage(video: widget.video),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => _goToPlayer(context),
            child: CachedNetworkImage(
              imageUrl:
                  'https://i.ytimg.com/vi/${widget.video.id}/hqdefault.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
              placeholder: (context, url) =>
                  Container(color: Colors.grey[300]), 
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => _goToChannel(context),
                  child: CircleAvatar(
                    radius: 22,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: widget.video.channel?.photo ?? '',
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.person),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () => _goToPlayer(context),
                        child: Text(
                          widget.video.title ?? 'No Title',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      InkWell(
                        onTap: () => _goToChannel(context),
                        child: Text(
                          widget.video.channel?.name ?? 'Unknown Channel',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                IconButton(
                  icon: Icon(
                    _isFav ? Icons.favorite : Icons.favorite_border,
                    color: _isFav ? Colors.red : Colors.grey,
                  ),
                  onPressed: _toggleFav,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
