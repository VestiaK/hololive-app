import 'package:first/data/holodex_service.dart';
import 'package:first/views/widget/card_widget.dart';
import 'package:flutter/material.dart';
import 'package:dart_holodex_api/dart_holodex_api.dart';

class MyHome extends StatefulWidget {
  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  final HolodexService _holodexService = HolodexService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hololive Live Now')),
      body: FutureBuilder<List<VideoFull>>(
        future: _holodexService.fetchLiveVideos(),
        builder: (context, snapshot) {
          // 1. Jika masih loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Bisa diganti Shimmer nanti
          }
          
          // 2. Jika terjadi error
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          // 3. Jika data kosong
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada VTuber yang sedang Live.'));
          }

          // 4. Jika sukses, render ke CardWidget
          final liveVideos = snapshot.data!;
          return ListView.builder(
            itemCount: liveVideos.length,
            itemBuilder: (context, index) {
              return CardWidget(video: liveVideos[index]);
            },
          );
        },
      ),
    );
  }
}