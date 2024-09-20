import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'package:musicmate/models/index.dart';
import 'package:musicmate/pages/playback/demo.dart';

class PlaybackFragment extends StatelessWidget {
  final dynamic currentSong;
  final String? currentSongType;

  const PlaybackFragment({super.key, this.currentSong, this.currentSongType});

  @override
  Widget build(BuildContext context) {
    final albumItem = AlbumItem.fromJson(currentSong);
    Logger().d(albumItem.toJson());
    return Playback(
      currentSong: albumItem,
      currentSongType: currentSongType,
    );
  }
}
