import 'package:flutter/material.dart';
import 'package:musicmate/components/newBox.dart';
import 'package:musicmate/models/playlistProvider.dart';
import 'package:provider/provider.dart';

class SongsPage extends StatelessWidget {
  const SongsPage({super.key});

  String formatTime(Duration duration) {
    String twoDigitSeconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "${duration.inMinutes}:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Playlistprovider>(builder: (context, value, child) {
      final playlist = value.playlist;
      final currentSongIndex = value.currentSongIndex ?? 0;

      if (playlist.isEmpty) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: Center(
            child: Text(
              'No songs available',
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        );
      }

      if (currentSongIndex >= playlist.length) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: Center(
            child: Text(
              'No song selected',
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        );
      }

      final currentSong = playlist[currentSongIndex];

      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const Text("P L A Y L I S T"),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.menu),
                    )
                  ],
                ),
                const SizedBox(height: 25),
                NewBox(
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.network(
                      currentSong.albumArtImagePath,
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Text(
                  currentSong.songName,
                  style: TextStyle(
                    fontSize: 24,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  currentSong.artistName,
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 25),
                NewBox(
                  child: Slider(
                    activeColor: Colors.green,
                    inactiveColor: Colors.grey,
                    value: value.currentDuration.inSeconds.toDouble(),
                    max: value.totalDuration.inSeconds.toDouble() + 1.0,
                    onChanged: (newValue) {
                      value.seek(Duration(seconds: newValue.toInt()));
                    },
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatTime(value.currentDuration),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        formatTime(value.totalDuration),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: value.currentSongIndex! > 0
                          ? () {
                              value.playPreviousSong();
                            }
                          : null,
                      icon: const Icon(Icons.skip_previous, size: 40),
                    ),
                    IconButton(
                      onPressed: () {
                        value.pauseOrResume();
                      },
                      icon: Icon(
                        value.isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 40,
                      ),
                    ),
                    IconButton(
                      onPressed: value.currentSongIndex! < playlist.length - 1
                          ? () {
                              value.playNextSong();
                            }
                          : null,
                      icon: const Icon(Icons.skip_next, size: 40),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

