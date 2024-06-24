import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:musicmate/main.dart';
import 'package:musicmate/models/song.dart';
import 'package:musicmate/services/audio_handlers.dart';

class Playlistprovider extends ChangeNotifier {
  final List<Song> _playlist = [
    Song(
      songName: "Tum Se",
      artistName: "Neyo",
      duration: 261,
      albumArtImagePath:
          "https://firebasestorage.googleapis.com/v0/b/musicmate-d438a.appspot.com/o/images%2FTum_Se.jpg?alt=media&token=d45037c3-d8f5-44f5-b35b-ca5682d67f3d",
      audioPath:
          "https://firebasestorage.googleapis.com/v0/b/musicmate-d438a.appspot.com/o/audio%2FTum_Se.mp3?alt=media&token=4b9e241a-facc-4245-b342-a25e935305fe",
    ),
    Song(
      songName: "Thodi Der",
      artistName: "Neyo",
      duration: 314,
      albumArtImagePath:
          "https://firebasestorage.googleapis.com/v0/b/musicmate-d438a.appspot.com/o/images%2FThodi_Der.jpg?alt=media&token=33cd2c54-6f97-4452-962c-47e2347d864f",
      audioPath:
          "https://firebasestorage.googleapis.com/v0/b/musicmate-d438a.appspot.com/o/audio%2FThodi_Der.mp3?alt=media&token=1dc3c25d-ec13-4f2a-a1c4-091daa235872",
    ),
    Song(
      songName: "Maiyya Mainu",
      artistName: "Neyo",
      duration: 241,
      albumArtImagePath:
          "https://firebasestorage.googleapis.com/v0/b/musicmate-d438a.appspot.com/o/images%2FMaiyya_Mainu.jpg?alt=media&token=d5032949-c369-44e3-a18a-6de483d259a8",
      audioPath:
          "https://firebasestorage.googleapis.com/v0/b/musicmate-d438a.appspot.com/o/audio%2FMaiyya_Mainu.mp3?alt=media&token=12622c80-0059-4b03-9526-ee861581f2df",
    ),
    Song(
      songName: "Lae Dooba",
      artistName: "Neyo",
      duration: 235,
      albumArtImagePath:
          "https://firebasestorage.googleapis.com/v0/b/musicmate-d438a.appspot.com/o/images%2FLae_Dooba.jpg?alt=media&token=795a7608-db77-40b1-b856-65997f253e27",
      audioPath:
          "https://firebasestorage.googleapis.com/v0/b/musicmate-d438a.appspot.com/o/audio%2FLae_Dooba.mp3?alt=media&token=95cc4483-d0c0-4d81-88ad-e017e7231b1d",
    ),
    Song(
      songName: "Baarish Yaariyan",
      artistName: "Neyo",
      duration: 228,
      albumArtImagePath:
          "https://firebasestorage.googleapis.com/v0/b/musicmate-d438a.appspot.com/o/images%2FBaarish_Yaariyan.jpg?alt=media&token=43d2c39b-9e9b-4af6-8a08-5aa6279545ff",
      audioPath:
          "https://firebasestorage.googleapis.com/v0/b/musicmate-d438a.appspot.com/o/audio%2FBaarish_Yaariyan.mp3?alt=media&token=c4ae0825-4034-42ea-80ef-12ef193039af",
    ),
  ];

  int? _currentSongIndex;
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;
  bool _isPlaying = false;

  final AudioHandler _audioHandler = getIt<AudioHandler>();

  Playlistprovider() {
    initializeQueue();
    listenToDuration();
    listenToCurrentSong();
  }

  Future<void> initializeQueue() async {
    final mediaItems = _playlist.map((song) {
      return MediaItem(
        id: song.audioPath,
        album: "Album Name",
        title: song.songName,
        artist: song.artistName,
        duration: Duration(seconds: song.duration),
        artUri: Uri.parse(song.albumArtImagePath),
      );
    }).toList();
    await _audioHandler.addQueueItems(mediaItems);
  }

  Future<void> play() async {
    if (_currentSongIndex == null || _currentSongIndex! >= _playlist.length)
      return;

    final song = _playlist[_currentSongIndex!];
    final path = song.audioPath;
    final duration = song.duration;

    final mediaItem = MediaItem(
      id: path,
      album: "Album Name",
      title: song.songName,
      artist: song.artistName,
      duration: Duration(seconds: duration),
      artUri: Uri.parse(song.albumArtImagePath),
    );

    // Clear the queue before adding the new media item
    await _audioHandler.addQueueItem(mediaItem);
    _isPlaying = true;
    await _audioHandler.play();
    notifyListeners();
  }

  void pause() async {
    _isPlaying = false;
    await _audioHandler.pause();
    notifyListeners();
  }

  void resume() async {
    _isPlaying = true;
    await _audioHandler.play();
    notifyListeners();
  }

  void pauseOrResume() async {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
  }

  void seek(Duration position) async {
    await _audioHandler.seek(position);
  }

  Future<void> playNextSong() async {
    if (_currentSongIndex == null) return;

    if (_currentSongIndex! < _playlist.length - 1) {
      _currentSongIndex = _currentSongIndex! + 1;
      await play();
    } else {
      _currentSongIndex = 0;
      await play();
    }
  }

  Future<void> playPreviousSong() async {
    if (_currentSongIndex == null) return;

    if (_currentSongIndex! > 0) {
      _currentSongIndex = _currentSongIndex! - 1;
      await play();
    } else {
      await play();
    }
  }

  void listenToDuration() {
    _audioHandler.playbackState.listen((playbackState) {
      _isPlaying = playbackState.playing;
      notifyListeners();
    });

    _audioHandler.mediaItem.listen((mediaItem) {
      if (mediaItem != null) {
        _totalDuration = mediaItem.duration ?? Duration.zero;
        notifyListeners();
      }
    });

    // Listen to the position stream from AudioService
    AudioService.position.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });

    // Listen for when playback completes (current song ends)
    _audioHandler.playbackState.listen((playbackState) {
      if (playbackState.processingState == AudioProcessingState.completed) {
        playNextSong();
      }
    });

    _audioHandler.playbackState.listen((state) {
      if (_currentSongIndex != state.queueIndex) {
        _currentSongIndex = state.queueIndex;
        notifyListeners();
      }
    });
  }

  void listenToCurrentSong() {
    _audioHandler.queue.listen((queue) {
      if (queue.isNotEmpty) {
        final currentMediaItem = queue.firstWhere(
            (mediaItem) => mediaItem.id == _audioHandler.mediaItem.value?.id,
            orElse: () => queue.first);
        final newIndex = _playlist
            .indexWhere((song) => song.audioPath == currentMediaItem.id);
        if (newIndex != _currentSongIndex) {
          _currentSongIndex = newIndex;
          notifyListeners();
        }
      }
    });
  }

  List<Song> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;

  set currentSongIndex(int? newIndex) {
    _currentSongIndex = newIndex;
    if (newIndex != null) {
      play();
    }
    notifyListeners();
  }
}
