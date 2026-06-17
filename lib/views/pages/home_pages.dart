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

  List<VideoFull> _allLiveVideos = [];
  bool _isLoading = true;
  String? _errorMessage;

  // State untuk filter
  String _selectedLang = 'All';
  Organization? _selectedOrg = Organization.Hololive;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // Fungsi fetch sekarang menggunakan _selectedOrg
  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final videos = await _holodexService.fetchLiveVideos(org: _selectedOrg);
      setState(() {
        _allLiveVideos = videos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  // Filter bahasa secara lokal
  List<VideoFull> get _filteredVideos {
    if (_selectedLang == 'All') return _allLiveVideos;

    return _allLiveVideos.where((video) {
      final channelName = video.channel?.name?.toUpperCase() ?? '';
      if (_selectedLang == 'ID') {
        return channelName.contains('ID') || channelName.contains('INDONESIA');
      } else if (_selectedLang == 'EN') {
        return channelName.contains('EN') || channelName.contains('ENGLISH');
      } else if (_selectedLang == 'JP') {
        return !channelName.contains('EN') && !channelName.contains('ID');
      }
      return true;
    }).toList();
  }

  // --- FUNGSI MEMUNCULKAN MENU FILTER ---
  void _showFilterModal() {
    // Simpan status sementara saat modal dibuka
    String tempLang = _selectedLang;
    Organization? tempOrg = _selectedOrg;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        // Gunakan StatefulBuilder agar modal bisa di-update secara terpisah
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filter Videos',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),

                  const Text(
                    'Language / Branch',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Wrap(
                    spacing: 8.0,
                    children: ['All', 'ID', 'EN', 'JP'].map((lang) {
                      return ChoiceChip(
                        label: Text(lang),
                        selected: tempLang == lang,
                        onSelected: (selected) {
                          if (selected) setModalState(() => tempLang = lang);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'Agency',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Wrap(
                    spacing: 8.0,
                    children: [
                      // Tambahkan chip ALL di paling depan
                      _buildOrgChip(
                        'All',
                        null,
                        tempOrg,
                        (org) => setModalState(() => tempOrg = org),
                      ),
                      _buildOrgChip(
                        'Hololive',
                        Organization.Hololive,
                        tempOrg,
                        (org) => setModalState(() => tempOrg = org),
                      ),
                      _buildOrgChip(
                        'Nijisanji',
                        Organization.Nijisanji,
                        tempOrg,
                        (org) => setModalState(() => tempOrg = org),
                      ),
                      _buildOrgChip(
                        'VShojo',
                        Organization.VShojo,
                        tempOrg,
                        (org) => setModalState(() => tempOrg = org),
                      ),
                      _buildOrgChip(
                        'Indie',
                        Organization.Independents,
                        tempOrg,
                        (org) => setModalState(() => tempOrg = org),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Tombol Terapkan Filter
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Tutup modal

                        // Jika agensi berubah, panggil ulang API
                        bool orgChanged = _selectedOrg != tempOrg;

                        setState(() {
                          _selectedLang = tempLang;
                        _selectedOrg = tempOrg;
                        });

                        if (orgChanged) {
                          _fetchData();
                        }
                      },
                      child: const Text('Apply Filter'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Helper widget untuk Bottom Sheet
  Widget _buildOrgChip(
    String label,
    Organization? org,
    Organization? currentSelected,
    Function(Organization?) onSelect,
  ) {
    return ChoiceChip(
      label: Text(label),
      selected: currentSelected == org,
      onSelected: (selected) {
        if (selected) onSelect(org);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Now'),
        actions: [
          // TOMBOL FILTER DI POJOK KANAN ATAS
          IconButton(icon: const Icon(Icons.tune), onPressed: _showFilterModal),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null) {
      return Center(child: Text('Error: $_errorMessage'));
    }

    final displayList = _filteredVideos;
    if (displayList.isEmpty) {
      return const Center(
        child: Text('Tidak ada VTuber di kategori ini yang sedang Live.'),
      );
    }

    return ListView.builder(
      itemCount: displayList.length,
      itemBuilder: (context, index) {
        return CardWidget(video: displayList[index]);
      },
    );
  }
}
