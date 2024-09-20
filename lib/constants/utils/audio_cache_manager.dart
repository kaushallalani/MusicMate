import 'dart:async';
import 'dart:developer';

class AudioCacheManager {
  static final AudioCacheManager _instance = AudioCacheManager._internal();
  factory AudioCacheManager() => _instance;

  final Map<String, _CacheEntry> _cache = {};
  final List<Map<String, dynamic>> _playedList = [];
  Timer? _cleanupTimer;

  AudioCacheManager._internal() {
    // Start periodic cleanup timer
    _cleanupTimer = Timer.periodic(const Duration(days: 20), (timer) {
      _cleanupExpiredEntries();
    });
  }

  // Getter for audio URL
  String? getAudioUrl(String key) => _cache[key]?.url;

  // Setter for audio URL with expiration time
  void setAudioUrl(String key, String url, Duration ttl) {
    _cache[key] = _CacheEntry(url, DateTime.now().add(ttl));
  }

  // Method to get a played item
  Map<String, dynamic>? getPlayedItem(String key) {
    return _playedList.firstWhere((item) => item['key'] == key,
        orElse: () => {});
  }

  // Method to add to played list
  void addToPlayedList(String key, Map<String, dynamic> data) {
    _playedList.add({'key': key, ...data});
    log('data added =>$_playedList');
  }

  // Method to update a played item
  void updatePlayedItem(String key, Map<String, dynamic> data) {
    final index = _playedList.indexWhere((item) => item['key'] == key);
    if (index != -1) {
      _playedList[index].addAll(data);
    } else {
      addToPlayedList(key, data);
    }
  }

  // Method to remove all played items
  void removePlayedPlaylist() {
    _playedList.clear();
  }

  // Method to clean up expired entries
  void _cleanupExpiredEntries() {
    _cache.removeWhere((key, entry) => entry.isExpired);
  }

  // Check if a specific key is expired in the audio cache
  bool isAudioExpired(String key) {
    return _cache[key]?.isExpired ?? true;
  }

  String? findVideoId(String songName, List<String> artistNames) {
    final playedItem = _playedList.firstWhere(
      (item) =>
          item['songName'] == songName &&
          (item['artistName'] as List<String>)
              .any((artist) => artistNames.contains(artist)),
      orElse: () => {},
    );

    return playedItem['videoId'];
  }

  // Dispose method to cancel the timer if needed
  void dispose() {
    _cleanupTimer?.cancel();
  }
}

class _CacheEntry {
  final String url;
  final DateTime expirationDate;

  _CacheEntry(this.url, this.expirationDate);

  bool get isExpired => DateTime.now().isAfter(expirationDate);
}
