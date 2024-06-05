// ignore_for_file: deprecated_member_use

import 'package:demo/components/myDrawer.dart';
import 'package:demo/pages/songsPage/index.dart';
import 'package:flutter/material.dart';
import 'package:demo/models/playlistProvider.dart';
import 'package:demo/models/song.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
// get the playlist provider
  late final dynamic playlistProvider;
  @override
  void initState() {
    super.initState();
// get playlist provider
    playlistProvider = Provider.of<Playlistprovider>(context, listen: false);
  }

// go to a song
  void goToSong(int songIndex) {
// update current song index
    playlistProvider.currentSongIndex = songIndex;
// navigate to song page

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SongPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('P L A Y L I S T'),
      ),
      drawer: const Mydrawer(),
      body: Consumer<Playlistprovider>(builder: (context, value, child) {
        // get the list

        final List<Song> playlist = value.playlist;

        //return lst view UI

        return ListView.builder(
          itemCount: playlist.length,
          itemBuilder: (context, index) {
            //get individual song
            final Song song = playlist[index];

            //return ist tile ui

            return ListTile(
              title: Text(song.songName),
              subtitle: Text(song.artistName),
              leading: Image.asset(song.albumArtImagePath),
              onTap: () => goToSong(index),
            );
          },
        );
      }),
    );
  }
}
