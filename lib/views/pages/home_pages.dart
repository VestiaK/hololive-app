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


  final ScrollController _scrollController = ScrollController();
  int _currentOffset = 0;
  bool _isFetchingMore = false; 
  bool _hasMore = true; 

  @override
  void initState() {
    super.initState();
    _fetchData(); 
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    _scrollController.dispose(); 
    super.dispose();
  }


  void _onScroll() {

    if (_scrollController.position.maxScrollExtent > 0) {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        if (!_isLoading && !_isFetchingMore && _hasMore) {
          _fetchMoreData();
        }
      }
    }
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _currentOffset = 0; 
      _hasMore = true;
      _allLiveVideos = []; 
    });

    try {
      List<VideoFull> videos;
      if (_selectedStatus == 'Live') {
        videos = await _holodexService.fetchLiveVideos(
          org: _selectedOrg,
          offset: _currentOffset,
        );
      } else {
        videos = await _holodexService.fetchUploadedVideos(
          org: _selectedOrg,
          offset: _currentOffset,
        );
      }

      setState(() {
        _allLiveVideos = videos
            .toList(); 

        _isLoading = false;
        if (videos.length < 10) _hasMore = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }


  Future<void> _fetchMoreData() async {
    setState(() {
      _isFetchingMore = true;
      _currentOffset += 10; 
    });

    try {
      List<VideoFull> videos;
      if (_selectedStatus == 'Live') {
        videos = await _holodexService.fetchLiveVideos(
          org: _selectedOrg,
          offset: _currentOffset,
        );
      } else {
        videos = await _holodexService.fetchUploadedVideos(
          org: _selectedOrg,
          offset: _currentOffset,
        );
      }

      setState(() {
  
        final newVideos = videos.where((v) => !_allLiveVideos.any((existing) => existing.id == v.id)).toList();
        
        _allLiveVideos.addAll(newVideos); 
        _isFetchingMore = false;
      
        if (videos.length < 10 || newVideos.isEmpty) {
          _hasMore = false; 
        }
      });
    } catch (e) {
      setState(() {
        _isFetchingMore = false;
        _hasMore = false; 
      });
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchQuery = query.toLowerCase();
      });
    });
  }

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

                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);

                        bool requiresApiCall =
                            (_selectedOrg != tempOrg) ||
                            (_selectedStatus != tempStatus);

                        setState(() {
                          _selectedLang = tempLang;
                          _selectedOrg = tempOrg;
                          _selectedStatus = tempStatus;
                        });

                        if (requiresApiCall) {
                          _fetchData();
                        }
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
        title: Text(_selectedStatus == 'Live' ? 'Live Now' : 'Uploaded Videos'),
        actions: [
          IconButton(icon: const Icon(Icons.tune), onPressed: _showFilterModal),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Cari nama VTuber atau judul...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).cardColor,
              ),
            ),
          ),

          Expanded(child: _buildBody()),
        ],
      ),
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
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            'Tidak ada video yang cocok dengan pencarian atau filtermu.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.builder(

      controller: _scrollController,

      itemCount: displayList.length + (_isFetchingMore ? 1 : 0),
      itemBuilder: (context, index) {

        if (index == displayList.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Center(
              child: CircularProgressIndicator(color: Colors.redAccent),
            ),
          );
        }
        return CardWidget(video: displayList[index]);
      },
    );
  }
}
