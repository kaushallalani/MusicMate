import 'package:flutter/widgets.dart';
import 'package:musicmate/pages/playback/index.dart';

class PlaybackFragment extends StatelessWidget {
  final dynamic currentSong;
  final String? currentSongType;
  const PlaybackFragment({super.key, this.currentSong, this.currentSongType});

  @override
  Widget build(BuildContext context) {
    return Playback(
      currentSong: currentSong,
      currentSongType: currentSongType,
    );
  }
}
