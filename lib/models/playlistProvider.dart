// // ignore: file_names
// import 'package:flutter/material.dart';
// import 'package:musicmate/models/song.dart';
// import 'package:audioplayers/audioplayers.dart';

// class Playlistprovider extends ChangeNotifier {

//   // current song playing index
//   int? _currentSongIndex;
// //audio player
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   Duration _currentDuration = Duration.zero;
//   Duration _totalDuration = Duration.zero;

// //constructor
//   Playlistprovider() {
//     listenToDuration();
//   }

// // initinal not playing
//   bool _isPlaying = false;

//   //play the song
//   void play() async {
//     // final String path = _playlist[_currentSongIndex!].audioPath;
//     await _audioPlayer.stop();
//     await _audioPlayer.play(AssetSource(path));
//     _isPlaying = true;
//     notifyListeners();
//   }

//   //pause the song
//   void pause() async {
//     await _audioPlayer.pause();
//     _isPlaying = false;
//     notifyListeners();
//   }
//   //resung playing

//   void resume() async {
//     await _audioPlayer.resume();
//     _isPlaying = true;
//     notifyListeners();
//   }

//   //pause or resume
//   void pauseOrResume() async {
//     if (_isPlaying) {
//       pause();
//     } else {
//       resume();
//     }
//     notifyListeners();
//   }

//   // seek to play
//   void seek(Duration position) async {
//     await _audioPlayer.seek(position);
//   }

//   //play next song
//   void playNextSong() {
//     if (_currentSongIndex != null) {
//       if (_currentSongIndex! < _playlist.length - 1) {
//         // go to next song if it is not last song
//         currentSongIndex = _currentSongIndex! + 1;
//       } else {
//         //if it's the last song loop back
//         currentSongIndex = 0;
//       }
//     }
//   }

//   //play previous song

//   void playPreviousSong() async {
//     // if more then 2 sec have passed restart the song
//     if (_currentDuration.inSeconds > 2) {
//       seek(Duration.zero);
//     }
//     // if it is within 2 sec go to previous song
//     else {
//       if (_currentSongIndex! > 0) {
//         currentSongIndex = _currentSongIndex! - 1;
//       } else {
//         currentSongIndex = _playlist.length - 1;
//       }
//     }
//   }

// // listen to duration

//   void listenToDuration() {
//     // listen for total duration
//     _audioPlayer.onDurationChanged.listen((newDuration) {
//       _totalDuration = newDuration;
//       notifyListeners();
//     });
//     // listen for current duration
//     _audioPlayer.onPositionChanged.listen((newPosition) {
//       _currentDuration = newPosition;
//       notifyListeners();
//     });
//     //listen for song completion

//     _audioPlayer.onPlayerComplete.listen((event) {
//       playNextSong();
//     });
//   }

// /*
// GETTERS
// */
//   int? get currentSongIndex => _currentSongIndex;
//   bool get isPlaying => _isPlaying;
//   Duration get currentDuration => _currentDuration;
//   Duration get totalDuration => _totalDuration;
// /*
// SETTERS
// */

//   set currentSongIndex(int? newIndex) {
// // update current song index
//     _currentSongIndex = newIndex;

//     if (newIndex != null) {
//       play();
//     }
// // update UI
//     notifyListeners();
//   }
// }
