import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:logger/logger.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _spotifyTracks = [];
  List<dynamic> _youtubeTracks = [];
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _duration = const Duration();
  Duration _position = const Duration();
  final yt = YoutubeExplode();
  final logger = Logger();
  final String _spotifyAuthToken =
      'BQAhR-bpj11xzE9y8Cd6UsPzjPRstciakFEhz4c0KJV9TUJ4pNHcPBOPKHFqqF-tYpD110TQl0IcUuue9FEZmvmjdMR7TA5bdqUUX107czzCAouQ_5U'; // Add your Spotify Auth Token here
  Timer? _debounce;
  int _offset = 0; // Track offset for pagination
  int _limit = 20; // Number of results per request
  bool _isLoadingMore = false;
  bool _allResultsLoaded = false; // Track if all results are loaded
  final ScrollController _scrollController = ScrollController();
  int _currentTrackIndex = -1; // Track the index of the currently playing track

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.positionStream.listen((event) {
      setState(() {
        _position = event;
      });
    });
    _audioPlayer.durationStream.listen((event) {
      setState(() {
        if (event != null) {
          _duration = event;
        }
      });
    });

    // Load Spotify new releases on app start
    _loadSpotifyNewReleases();

    // Add scroll listener to detect when user reaches end of list
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    yt.close();
    _debounce?.cancel(); // Cancel the debounce timer if it's active
    _scrollController.dispose(); // Dispose the scroll controller
    super.dispose();
  }

  /// Fetches new releases from Spotify API.
  void _loadSpotifyNewReleases() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.spotify.com/v1/browse/new-releases'),
        headers: {
          'Authorization': 'Bearer $_spotifyAuthToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Map<String, dynamic>> releaseTracks = [];

        for (var album in data['albums']['items']) {
          var trackName = album['name'];
          var imageUrl = album['images'][0]['url']; // Use the first image URL
          var previewUrl = album['preview_url']; // Track preview URL
          releaseTracks.add({
            'name': trackName,
            'image': imageUrl,
            'url': previewUrl,
          });
        }
        setState(() {
          _spotifyTracks = releaseTracks;
        });
      } else {
        throw Exception('Failed to load new releases: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching new releases: $e');
    }
  }

  /// Searches Spotify tracks based on query.
  void _searchSpotifyTracks(String query, {bool loadMore = false}) async {
    try {
      if (query.isEmpty) {
        _loadSpotifyNewReleases(); // Load new releases if query is empty
        return;
      }

      // Calculate offset for pagination
      int offset = loadMore ? _offset + _limit : 0;

      final response = await http.get(
        Uri.parse(
            'https://api.spotify.com/v1/search?q=$query&type=album&offset=$offset&limit=$_limit'),
        headers: {
          'Authorization': 'Bearer $_spotifyAuthToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Map<String, dynamic>> searchTracks = [];

        int totalItems = data['albums']['total']; // Total items available

        for (var album in data['albums']['items']) {
          var trackName = album['name'];
          var imageUrl = album['images'][0]['url']; // Use the first image URL
          var previewUrl = album['preview_url']; // Track preview URL
          searchTracks.add({
            'name': trackName,
            'image': imageUrl,
            'url': previewUrl,
          });
        }

        setState(() {
          if (loadMore) {
            _spotifyTracks.addAll(searchTracks);
            _offset += _limit; // Update offset for the next pagination
            _isLoadingMore = false; // Reset loading indicator
          } else {
            _spotifyTracks = searchTracks;
            _offset = _limit; // Reset offset for fresh search results
            _allResultsLoaded =
                _offset >= totalItems; // Check if all results are loaded
          }
        });
      } else {
        throw Exception('Failed to search Spotify: ${response.statusCode}');
      }
    } catch (e) {
      print('Error searching Spotify: $e');
    }
  }

  /// Debounces search to prevent frequent API calls.
  void _debounceSearch(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchSpotifyTracks(query);
    });
  }

  /// Searches for a track on YouTube and plays it.
  void _searchAndPlay(String songName) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://www.googleapis.com/youtube/v3/search?part=snippet&q=$songName&key=AIzaSyCizoXiBWYEfnglp5f2vfr1xkSXt77FuUM&type=video&maxResults=1',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _youtubeTracks = data['items'];
        });
        if (_youtubeTracks.isNotEmpty) {
          final videoId = _youtubeTracks[0]['id']['videoId'];
          await _playTrack(videoId);
        }
      } else {
        throw Exception('Failed to search on YouTube: ${response.statusCode}');
      }
    } catch (e) {
      print('Error searching on YouTube: $e');
    }
  }

  /// Plays a track from YouTube using its video ID.
  Future<void> _playTrack(String videoId) async {
    try {
      var manifest = await yt.videos.streamsClient.getManifest(videoId);
      var streamInfo = manifest.audioOnly.withHighestBitrate();
      var streamUrl = streamInfo.url.toString();

      await _audioPlayer.setUrl(streamUrl);
      _audioPlayer.play();
      setState(() {
        _isPlaying = true;
      });
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  /// Plays the next track in the playlist.
  void _playNext() {
    if (_currentTrackIndex < _spotifyTracks.length - 1) {
      _currentTrackIndex++;
      _playTrackByUrl(_spotifyTracks[_currentTrackIndex]['url']);
    }
  }

  /// Plays the previous track in the playlist.
  void _playPrevious() {
    if (_currentTrackIndex > 0) {
      _currentTrackIndex--;
      _playTrackByUrl(_spotifyTracks[_currentTrackIndex]['url']);
    }
  }

  /// Plays a track from a provided URL.
  Future<void> _playTrackByUrl(String url) async {
    try {
      await _audioPlayer.setUrl(url);
      _audioPlayer.play();
      setState(() {
        _isPlaying = true;
      });
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  /// Pauses the currently playing track.
  void _pauseTrack() {
    _audioPlayer.pause();
    setState(() {
      _isPlaying = false;
    });
  }

  /// Stops the currently playing track.
  void _stopTrack() {
    _audioPlayer.stop();
    setState(() {
      _isPlaying = false;
      _currentTrackIndex = -1; // Reset current track index
    });
  }

  /// Formats duration to display in UI.
  String _formatDuration(Duration duration) {
    return duration.toString().split('.').first.padLeft(8, '0');
  }

  /// Listens to scroll events to load more tracks when user reaches end of list.
  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // User has scrolled to the end, load more results
      if (!_isLoadingMore && !_allResultsLoaded) {
        setState(() {
          _isLoadingMore = true;
        });
        _searchSpotifyTracks(_controller.text, loadMore: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Player'),
      ),
      body: Column(
        children: [
// Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onChanged: (value) {
                      _debounceSearch(value);
                    },
                    decoration: InputDecoration(
                      labelText: 'Search for a track',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          _searchSpotifyTracks(_controller.text);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
// Track list
          Expanded(
            child: _spotifyTracks.isEmpty
                ? const Center(child: Text('No results found'))
                : GridView.builder(
                    controller: _scrollController,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: _spotifyTracks.length + (_isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < _spotifyTracks.length) {
// Display Spotify track
                        final track = _spotifyTracks[index];
                        return GestureDetector(
                          onTap: () {
// Search and play song on YouTube when tapping on a Spotify track
                            _searchAndPlay(track['name']);
                          },
                          child: Card(
                            elevation: 2.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
// Track image
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(8.0)),
                                    child: Image.network(
                                      track[
                                          'image'], // Replace with actual image URL from Spotify data
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
// Track name
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    track['name'],
                                    style:
                                        const TextStyle(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
// Show loading indicator at the end of the list while loading more tracks
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
          ),
// Playback controls
          Container(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous),
                  onPressed: _currentTrackIndex > 0 ? _playPrevious : null,
                ),
                IconButton(
                  icon: _isPlaying ? const Icon(Icons.pause) : const Icon(Icons.play_arrow),
                  onPressed: _isPlaying ? _pauseTrack : _playTrackFromCurrent,
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next),
                  onPressed: _currentTrackIndex < _spotifyTracks.length - 1
                      ? _playNext
                      : null,
                ),
              ],
            ),
          ),
// Track position slider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text(
                  _formatDuration(_position),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Slider(
                    value: _position.inMilliseconds.toDouble(),
                    min: 0.0,
                    max: _duration.inMilliseconds.toDouble(),
                    onChanged: (value) {
                      final Duration position =
                          Duration(milliseconds: value.toInt());
                      _audioPlayer.seek(position);
                    },
                  ),
                ),
                Text(
                  _formatDuration(_duration),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Plays the track from the current index in the playlist.
  void _playTrackFromCurrent() {
    if (_currentTrackIndex != -1 &&
        _currentTrackIndex < _spotifyTracks.length) {
      _playTrackByUrl(_spotifyTracks[_currentTrackIndex]['url']);
    } else if (_spotifyTracks.isNotEmpty) {
      _currentTrackIndex = 0;
      _playTrackByUrl(_spotifyTracks[_currentTrackIndex]['url']);
    }
  }
}


// ### Explanation:
// 1. **Next and Previous Functionality**: 
//    - Added `IconButton` widgets for skip previous (`Icons.skip_previous`) and skip next (`Icons.skip_next`) actions in the playback controls section.
//    - `_playNext()` and `_playPrevious()` methods handle the logic to play the next and previous tracks in `_spotifyTracks` list respectively.
//    - `_playTrackFromCurrent()` method is introduced to play the track from the current `_currentTrackIndex` if available or from the start of the list if `_currentTrackIndex` is `-1`.

// 2. **Track Playback Logic**:
//    - Updated `_playTrackByUrl()` method to handle playing tracks based on URL.

// 3. **User Interface**:
//    - Integrated the playback controls (`skip previous`, `play/pause`, `skip next`) into a `Row` container in the `Scaffold` widget.
//    - Displayed the track position slider with labels for current position and total duration.

// This implementation assumes that `_spotifyTracks` contains track details including `name`, `image`, and `url` for each track from the Spotify API response. Adjustments might be needed based on the actual structure of your Spotify API response and how you handle track playback URLs and other details.