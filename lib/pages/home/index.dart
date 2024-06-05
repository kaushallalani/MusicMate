import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:musicmate/components/index.dart';
import 'package:musicmate/constants/theme.dart';
import 'package:musicmate/models/playlistProvider.dart';
import 'package:musicmate/models/song.dart';
import 'package:musicmate/navigation/app_navigation.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
// get the playlist provider
  late final dynamic playlistProvider;
  int currentIndex = 0;
  @override
  void initState() {
    super.initState();
// get playlist provider
    playlistProvider = Provider.of<Playlistprovider>(context, listen: false);
  }

// go to a song
  void goToSong(int songIndex, BuildContext context) {
// update current song index
    playlistProvider.currentSongIndex = songIndex;
// navigate to song page

    context.push(NAVIGATION.songsPage);
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => SongsPage(),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('P L A Y L I S T'),
      ),
      drawer: const Mydrawer(),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          backgroundColor: Colors.white,
          selectedIconTheme: const IconThemeData(color: AppColor.aquaBlue),
          unselectedIconTheme: const IconThemeData(color: AppColor.black),
          selectedFontSize: FontSize.medium,
          unselectedFontSize: FontSize.normal,
          selectedItemColor: AppColor.aquaBlue,
          unselectedItemColor: AppColor.black,
          selectedLabelStyle: const TextStyle(color: AppColor.aquaBlue),
          type: BottomNavigationBarType.fixed,
          onTap: (value) {
            setState(() {
              currentIndex = value;
            });
          },
          items: [
            const BottomNavigationBarItem(
                icon: Icon(FontAwesome5.home), label: 'Home'),
            const BottomNavigationBarItem(
                icon: Icon(FontAwesome5.search), label: 'Search'),
            const BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Search')
          ]),
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
              onTap: () => goToSong(index, context),
            );
          },
        );
      }),
    );
  }
}


// Container(
//         // height: Metrics.height(context) * 0.08,
//         decoration: const BoxDecoration(
//             color: Colors.red,
//             border: Border(top: BorderSide(color: Colors.grey))),