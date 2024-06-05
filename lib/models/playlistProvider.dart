import 'package:flutter/material.dart';
import 'package:musicmate/models/song.dart';

class Playlistprovider extends ChangeNotifier {
  // playlist of songs

  final List<Song> _playlist = [
    // song 1
    Song(
      songName: "Tum Se",
      artistName: "Neyo",
      albumArtImagePath: "assets/images/Tum_Se.jpg",
      audioPath: "audio/Tum_Se.mp3",
    ),

    // song 2
    Song(
      songName: "Thodi Der",
      artistName: "Neyo",
      albumArtImagePath: "assets/images/Thodi_Der.jpg",
      audioPath: "audio/Thodi_Der.mp3",
    ),

    // song 3
    Song(
      songName: "Maiyya Mainu",
      artistName: "Neyo",
      albumArtImagePath: "assets/images/Maiyya_Mainu.jpg",
      audioPath: "audio/Maiyya_Mainu.mp3",
    ),

    // song 4
    Song(
      songName: "Lae Dooba",
      artistName: "Neyo",
      albumArtImagePath: "assets/images/Lae_Dooba.jpg",
      audioPath: "audio/Lae_Dooba.mp3",
    ),

    // song 5
    Song(
      songName: "Baarish Yaariyan",
      artistName: "Neyo",
      albumArtImagePath: "assets/images/Baarish_Yaariyan.jpg",
      audioPath: "audio/Baarish_Yaariyan.mp3",
    ),
  ];

  // current song playing index
  int? _currentSongIndex;
/*
GETTERS
*/
  List<Song> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
/*
SETTERS
*/

  set currentSongIndex(int? newIndex) {
// update current song index
    _currentSongIndex = newIndex;
// update UI
    notifyListeners();
  }
}
