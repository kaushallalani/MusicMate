import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:musicmate/components/index.dart';
import 'package:musicmate/models/playlistProvider.dart';
import 'package:musicmate/models/song.dart';
import 'package:musicmate/navigation/app_navigation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
// get the playlist provider
  late final dynamic playlistProvider;
  int currentIndex = 0;
  dynamic userDetails;
  @override
  void initState() {
    super.initState();
// get playlist provider
    playlistProvider = Provider.of<Playlistprovider>(context, listen: false);
    getUserDetail();
  }

  void getUserDetail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var user = prefs.getString('user');
    print("objectfsdfdsff");
    print(user);
    if (user != null) {
      setState(() {
        userDetails = jsonDecode(user);
      });
    }
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
      body: Consumer<Playlistprovider>(builder: (context, value, child) {
        // get the list

        final List<Song> playlist = value.playlist;

        //return lst view UI
        return Column(
          children: [
            Flexible(
                child: userDetails != null
                    ? Text("Welcome, ${userDetails['fullName']}")
                    : const Text("Welcome, User")),
            Flexible(
              child: ListView.builder(
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
              ),
            ),
          ],
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