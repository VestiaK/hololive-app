import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  static const String _key = 'favorites_video';

  static Future<void> toggleFavorite(Map<String, dynamic> videoData) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_key) ?? [];

    final index = favorites.indexWhere((item) {
      final decoded = jsonDecode(item);
      return decoded['id'] == videoData['id'];
    });

    if (index >= 0) {
      favorites.removeAt(index); 
    } else {
      favorites.add(jsonEncode(videoData)); 
    }


    await prefs.setStringList(_key, favorites);
  }

  static Future<List<Map<String, dynamic>>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_key) ?? [];
    

    return favorites.map((item) => jsonDecode(item) as Map<String, dynamic>).toList();
  }


  static Future<bool> isFavorite(String videoId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_key) ?? [];
    
    for (String item in favorites) {
      final decoded = jsonDecode(item);
      if (decoded['id'] == videoId) return true;
    }
    return false;
  }
}