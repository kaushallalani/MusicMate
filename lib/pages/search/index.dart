import 'dart:async';
import 'dart:convert';
import 'dart:developer';
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
  String? _spotifyAuthToken; // Add your Spotify Auth Token here
  DateTime? _tokenExpiryTime;
  String? _currentTrackName;
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

    _initializeSpotify();

    // Add scroll listener to detect when user reaches end of list
    _scrollController.addListener(_onScroll);

    // Listen for track completion to reset playing state
    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        setState(() {
          _isPlaying = false;
          _currentTrackName = null;
          _currentTrackIndex = -1;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    yt.close();
    _debounce?.cancel(); // Cancel the debounce timer if it's active
    _scrollController.dispose(); // Dispose the scroll controller
    super.dispose();
  }

  /// Initializes Spotify token using client credentials.
  Future<void> _initializeSpotify() async {
    try {
      // Get the token (generate if expired)
      final token = await _getSpotifyAuthToken();

      // Now load the Spotify data (e.g., new releases)
      _loadSpotifyNewReleases(token);
    } catch (e) {
      print('Error initializing Spotify: $e');
    }
  }

  // Method to get Spotify Auth Token (either use the existing one or generate a new one)
  Future<String> _getSpotifyAuthToken() async {
    if (_spotifyAuthToken != null && !_isTokenExpired()) {
      return _spotifyAuthToken!;
    }

    // Replace with your Spotify client ID and client secret
    const clientId = '3222f0dac2e24c908781642f43c8506d';
    const clientSecret = '31e95b4c7dd04ee0a7a285d23c4f36be';

    final credentials = base64Encode(utf8.encode('$clientId:$clientSecret'));

    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {
        'Authorization': 'Basic $credentials',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'grant_type': 'client_credentials',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _spotifyAuthToken = data['access_token'];
      // Token expires in the given seconds from the response
      _tokenExpiryTime =
          DateTime.now().add(Duration(seconds: data['expires_in']));
      return _spotifyAuthToken!;
    } else {
      throw Exception('Failed to get Spotify Auth Token');
    }
  }

  // Method to check if the token is expired
  bool _isTokenExpired() {
    if (_tokenExpiryTime == null) return true;
    return DateTime.now().isAfter(_tokenExpiryTime!);
  }

  /// Fetches new releases from Spotify API.
  void _loadSpotifyNewReleases(String? token) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.spotify.com/v1/browse/new-releases'),
        headers: {
          'Authorization': 'Bearer $token',
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
      final token = await _getSpotifyAuthToken();
      if (query.isEmpty) {
        _loadSpotifyNewReleases(token); // Load new releases if query is empty
        return;
      }

      // Calculate offset for pagination
      int offset = loadMore ? _offset + _limit : 0;

      final response = await http.get(
        Uri.parse(
            'https://api.spotify.com/v1/search?q=$query&type=album&offset=$offset&limit=$_limit'),
        headers: {
          'Authorization': 'Bearer $token',
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
      final encodedQuery = Uri.encodeComponent(songName);
      final response = await http.get(
        Uri.parse(
          'https://www.googleapis.com/youtube/v3/search?part=snippet&q=$encodedQuery&key=AIzaSyBK9VVmGblxMCFYj7ftfUSMEHkvuIgcQvY&type=video&maxResults=1',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _youtubeTracks = data['items'];
        });
        if (_youtubeTracks.isNotEmpty) {
          final videoId = _youtubeTracks[0]['id']['videoId'];
          await _playTrack(videoId, trackName: songName);
          setState(() {
            _currentTrackIndex =
                _spotifyTracks.indexWhere((track) => track['name'] == songName);
          });
        }
      } else {
        throw Exception('Failed to search on YouTube: ${response.statusCode}');
      }
    } catch (e) {
      print('Error searching on YouTube: $e');
    }
  }

  /// Plays a track from YouTube using its video ID.
  Future<void> _playTrack(String videoId, {String? trackName}) async {
    try {
      var manifest = await yt.videos.streamsClient.getManifest(videoId);
      var streamInfo = manifest.audioOnly.withHighestBitrate();
      var streamUrl = streamInfo.url.toString();
      log('STREAMMM =>$streamUrl');
      await _audioPlayer.setUrl(streamUrl);
      _audioPlayer.play();
      setState(() {
        _isPlaying = true;
        _currentTrackName = trackName ?? 'Unknown Track';
      });
      logger.d('Playing track: $_currentTrackName');
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  /// Plays the next track in the playlist.
  void _playNext() {
    if (_currentTrackIndex < _spotifyTracks.length - 1) {
      _currentTrackIndex++;
      final nextTrack = _spotifyTracks[_currentTrackIndex];
      _searchAndPlay(nextTrack['name']);
    }
  }

  /// Plays the previous track in the playlist.
  void _playPrevious() {
    if (_currentTrackIndex > 0) {
      _currentTrackIndex--;
      final prevTrack = _spotifyTracks[_currentTrackIndex];
      _searchAndPlay(prevTrack['name']);
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
      _currentTrackName = null;
      _currentTrackIndex = -1; // Reset current track index
    });
  }

  /// Formats duration to display in UI.
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  /// Listens to scroll events to load more tracks when user reaches end of list.
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // trigger before exact end
      // User has scrolled near the end, load more results
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                            setState(() {
                              _currentTrackIndex = index;
                            });
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
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(
                                          Icons.music_note,
                                          size: 50,
                                          color: Colors.grey,
                                        );
                                      },
                                      loadingBuilder:
                                          (context, child, progress) {
                                        if (progress == null) return child;
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                // Track name
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    track['name'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
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
            child: Column(
              children: [
                if (_currentTrackName !=
                    null) // Show the track name if it's set
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      _currentTrackName!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.skip_previous),
                      onPressed: _currentTrackIndex > 0 ? _playPrevious : null,
                    ),
                    IconButton(
                      icon: _isPlaying
                          ? const Icon(Icons.pause)
                          : const Icon(Icons.play_arrow),
                      onPressed:
                          _isPlaying ? _pauseTrack : _playTrackFromCurrent,
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next),
                      onPressed: _currentTrackIndex < _spotifyTracks.length - 1
                          ? _playNext
                          : null,
                    ),
                  ],
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
                    value: _position.inSeconds
                        .toDouble()
                        .clamp(0.0, _duration.inSeconds.toDouble()),
                    max: _duration.inSeconds.toDouble(),
                    onChanged: (value) {
                      final newPosition = Duration(seconds: value.toInt());
                      _audioPlayer.seek(newPosition);
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
    if (_currentTrackIndex >= 0 && _currentTrackIndex < _spotifyTracks.length) {
      final currentTrack = _spotifyTracks[_currentTrackIndex];
      _searchAndPlay(currentTrack['name']);
    } else if (_spotifyTracks.isNotEmpty) {
      _currentTrackIndex = 0;
      final firstTrack = _spotifyTracks[0];
      _searchAndPlay(firstTrack['name']);
    }
  }
}
