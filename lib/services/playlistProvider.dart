// import 'dart:async';

// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/foundation.dart';
// import 'package:logger/logger.dart';
// import 'package:musicmate/models/spotify/recommended_songs.dart';
// import 'package:musicmate/repositories/spotify_repository.dart';
// import 'package:musicmate/services/spotify_authentication.dart';
// import 'package:youtube_explode_dart/youtube_explode_dart.dart';

// class PlaylistProvider with ChangeNotifier {
//   late AudioPlayer _audioPlayer;
//   late YoutubeExplode _yt;
//   // List<Map<String, dynamic>> _playlist = [];
//   List<dynamic> _playlist = [];

//   int _currentSongIndex = 0;
//   bool _isPlaying = false;
//   Duration? _duration;
//   Duration? _position;
//   PlayerState? _playerState;
//   late SpotifyAuthentication spotifyAuthentication;

//   PlaylistProvider() {
//     _audioPlayer = AudioPlayer();
//     _yt = YoutubeExplode();
//     _initAudioPlayer();
//     spotifyAuthentication = SpotifyAuthentication();
//   }

//   // Initialize audio player settings
//   void _initAudioPlayer() {
//     _audioPlayer.setReleaseMode(ReleaseMode.stop);

//     _audioPlayer.onDurationChanged.listen((duration) {
//       _duration = duration;
//       notifyListeners();
//     });

//     _audioPlayer.onPositionChanged.listen((position) {
//       _position = position;
//       notifyListeners();
//     });

//     _audioPlayer.onPlayerStateChanged.listen((state) {
//       _playerState = state;
//       if (_playerState == PlayerState.completed) {
//         _isPlaying = false;
//         _position = _duration;
//       }
//       notifyListeners();
//     });
//   }

//   bool get isPlaying => _isPlaying;
//   PlayerState? get playerState => _playerState;
//   Duration? get duration => _duration;
//   Duration? get position => _position;
//   // List<Map<String, dynamic>> get playlist => _playlist;
//   List<dynamic> get playlist => _playlist;

//   int get currentSongIndex => _currentSongIndex;

//   // Set the playlist
//   void setPlaylist(List<dynamic> playlist) {
//     _playlist = playlist;
//     _currentSongIndex = 0;
//     notifyListeners();

//     Logger().d('playlist => $_playlist');
//   }

//   // Play the audio at the specified index
//   Future<void> play(int index) async {
//     String videoId = '';
//     if (index < 0 || index >= _playlist.length) return;

//     if (_playlist[index] is Map<String, dynamic>) {
//       videoId = _playlist[index]['videoId'];
//     } else {
//       final Track track = _playlist[index];
//       Logger().d(track.name);

//       final String songName = track.name!;
//       final List<String> artistsName =
//           track.artists!.map((artist) => artist.name!).toList();
//       videoId = await getVideoId(songName, artistsName);
//     }

//     String streamUrl = await _getAudioStreamUrl(videoId);
//     if (streamUrl.isEmpty) return;
//     Logger().d(streamUrl);
//     await _audioPlayer.stop();
//     await _audioPlayer.play(UrlSource(streamUrl));
//     _isPlaying = true;
//     _currentSongIndex = index;
//     notifyListeners();

//     // Adjust according to your map structure
//   }

//   // Play the current song
//   Future<void> playCurrentSong() async {
//     if (_currentSongIndex >= 0 && _currentSongIndex < _playlist.length) {
//       // final Track playlisttt = Track.fromJson(_playlist[_currentSongIndex]);
//       Logger().d('playlistt t=> ${_playlist[currentSongIndex]}');

//       // await play(_currentSongIndex);
//     }
//   }

//   // Pause the audio
//   Future<void> pause() async {
//     await _audioPlayer.pause();
//     _isPlaying = false;
//     notifyListeners();
//   }

//   // Resume playback
//   Future<void> resume() async {
//     await _audioPlayer.resume();
//     _isPlaying = true;
//     notifyListeners();
//   }

//   // Stop playback
//   Future<void> stop() async {
//     await _audioPlayer.stop();
//     _isPlaying = false;
//     _currentSongIndex = -1;
//     notifyListeners();
//   }

//   // Seek to a specific position in the audio
//   Future<void> seek(Duration position) async {
//     await _audioPlayer.seek(position);
//   }

//   // Play the next song in the playlist
//   void next() {

//      playCurrentSong();
//     // if (_currentSongIndex < _playlist.length - 1) {
//     //   _currentSongIndex++;
//     //   // getTrackId(_playlist[_currentSongIndex].)
//     //   Logger().d('next song => ${_playlist[_currentSongIndex]}');
//     //   playCurrentSong();
//     // }
//   }

//   Future<String> getVideoId(String songName, List<String> artistName) async {
//     final data =
//         await spotifyAuthentication.fetchSearchSong(songName, artistName);
//     final videoId = data!['items'][0]['id']['videoId'];

//     return videoId;
//   }
//   // void getTrackId(songName, artistList){
//   //    final List<String> songNames = recommendedTracks!
//   //       .where((song) => song != null) // Remove null values
//   //       .map(
//   //           (song) => song!.album.name) // Extract the album name from each song
//   //       .toList();

//   //   final List<List<String>> artistNames = recommendedTracks!
//   //       .where((song) => song != null) // Remove null values
//   //       .map((song) => song!.artists.map((artist) => artist.name).toList())
//   //       .toList();
//   //   final listOfIds = BlocProvider.of<PlaybackBloc>(context)
//   //       .add(onGetListOfVideoIds(songName: songNames, artistName: artistNames));
//   // }

//   // Play the previous song in the playlist
//   void previous() {
//     if (_currentSongIndex > 0) {
//       _currentSongIndex--;
//       playCurrentSong();
//     }
//   }

//   // Get audio stream URL for the given videoId
//   Future<String> _getAudioStreamUrl(String videoId) async {
//     try {
//       var manifest = await _yt.videos.streamsClient.getManifest(videoId);
//       var streamInfo = manifest.audioOnly.withHighestBitrate();
//       return streamInfo.url.toString();
//     } catch (e) {
//       print('Error retrieving stream URL: $e');
//       return '';
//     }
//   }

//   @override
//   void dispose() {
//     _audioPlayer.dispose();
//     _yt.close();
//     super.dispose();
//   }
// }
