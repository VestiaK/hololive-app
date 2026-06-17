import 'dart:async';
import 'package:first/data/holodex_service.dart';
import 'package:first/views/widget/card_widget.dart';
import 'package:first/views/widget/shimmer_card_widget.dart';
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

  String _selectedLang = 'All';
  Organization? _selectedOrg = Organization.Hololive;
  String _selectedStatus = 'Live';

  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String _searchQuery = '';

  int _currentPage = 1;
  final int _itemsPerPage = 50; // HARUS 50, SESUAIKAN DENGAN LIMIT API 
  bool _hasMore = true;

  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _fetchData(); 
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _allLiveVideos = []; 
    });

    try {
      int offset = (_currentPage - 1) * _itemsPerPage;
      List<VideoFull> videos;

      if (_selectedStatus == 'Live') {
        videos = await _holodexService.fetchLiveVideos(
          org: _selectedOrg,
          offset: offset,
        );
      } else {
        videos = await _holodexService.fetchUploadedVideos(
          org: _selectedOrg,
          offset: offset,
        );
      }

      setState(() {
        _allLiveVideos = videos;
        _isLoading = false;
        _hasMore = videos.length == _itemsPerPage;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _nextPage() {
    if (_hasMore && !_isLoading) {
      setState(() {
        _currentPage++;
      });
      _fetchData();
    }
  }

  void _prevPage() {
    if (_currentPage > 1 && !_isLoading) {
      setState(() {
        _currentPage--;
      });
      _fetchData();
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchQuery = query.toLowerCase();
        _currentPage = 1; 
      });
      _fetchData();
    });
  }

  // Filter Lokal Dikembalikan: Menyaring 50 data yang diambil menggunakan teks channel
  List<VideoFull> get _filteredVideos {
    return _allLiveVideos.where((video) {
      final channelName = video.channel?.name?.toUpperCase() ?? '';
      bool matchLang = true;
      if (_selectedLang == 'ID') {
        matchLang =
            channelName.contains('ID') || channelName.contains('INDONESIA');
      } else if (_selectedLang == 'EN') {
        matchLang =
            channelName.contains('EN') || channelName.contains('ENGLISH');
      } else if (_selectedLang == 'JP') {
        matchLang = !channelName.contains('EN') && !channelName.contains('ID');
      }

      bool matchSearch = true;
      if (_searchQuery.isNotEmpty) {
        final title = video.title.toLowerCase();
        final cName = video.channel?.name?.toLowerCase() ?? '';
        matchSearch =
            title.contains(_searchQuery) || cName.contains(_searchQuery);
      }

      return matchLang && matchSearch;
    }).toList();
  }

  void _showFilterModal() {
    String tempLang = _selectedLang;
    Organization? tempOrg = _selectedOrg;
    String tempStatus = _selectedStatus;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
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
                    'Video Status',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Wrap(
                    spacing: 8.0,
                    children: ['Live', 'Video'].map((stat) {
                      return ChoiceChip(
                        label: Text(stat),
                        selected: tempStatus == stat,
                        selectedColor: Colors.redAccent.withOpacity(0.2),
                        onSelected: (selected) {
                          if (selected) setModalState(() => tempStatus = stat);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

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
                      _buildOrgChip('All', null, tempOrg, (org) => setModalState(() => tempOrg = org)),
                      _buildOrgChip('Hololive', Organization.Hololive, tempOrg, (org) => setModalState(() => tempOrg = org)),
                      _buildOrgChip('Nijisanji', Organization.Nijisanji, tempOrg, (org) => setModalState(() => tempOrg = org)),
                      _buildOrgChip('VShojo', Organization.VShojo, tempOrg, (org) => setModalState(() => tempOrg = org)),
                      _buildOrgChip('Indie', Organization.Independents, tempOrg, (org) => setModalState(() => tempOrg = org)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);

                        setState(() {
                          _selectedLang = tempLang;
                          _selectedOrg = tempOrg;
                          _selectedStatus = tempStatus;
                          _currentPage = 1; 
                        });

                        _fetchData();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                      ),
                      child: const Text(
                        'Apply Filter',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  Widget _buildOrgChip(String label, Organization? org, Organization? currentSelected, Function(Organization?) onSelect) {
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
        title: _isSearching
            ? TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                autofocus: true,
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(
                  hintText: 'Cari nama VTuber atau judul...',
                  border: InputBorder.none,
                ),
              )
            : Text(_selectedStatus == 'Live' ? 'Live Now' : 'Uploaded Videos'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _searchController.clear();
                  _onSearchChanged(''); 
                } else {
                  _isSearching = true;
                }
              });
            },
          ),
          IconButton(icon: const Icon(Icons.tune), onPressed: _showFilterModal),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) => const ShimmerCardWidget(),
      );
    }

    if (_errorMessage != null) {
      return Center(child: Text('Error: $_errorMessage'));
    }

    final displayList = _filteredVideos;
    
    if (displayList.isEmpty) {
      return ListView(
        children: [
          const SizedBox(height: 60),
          const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Tidak ada video ditemukan di halaman ini.',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildPaginationControls(), 
        ],
      );
    }

    return ListView.builder(
      itemCount: displayList.length + 1, 
      itemBuilder: (context, index) {
        if (index == displayList.length) {
          return _buildPaginationControls();
        }
        return CardWidget(video: displayList[index]);
      },
    );
  }

  Widget _buildPaginationControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: _currentPage > 1 ? _prevPage : null,
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(12),
            ),
            child: const Icon(Icons.arrow_back),
          ),
          const SizedBox(width: 16),
          Text(
            'Halaman $_currentPage',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: _hasMore ? _nextPage : null,
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(12),
            ),
            child: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
}