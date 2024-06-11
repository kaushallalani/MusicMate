import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:musicmate/components/index.dart';
import 'package:musicmate/constants/theme.dart';
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
  double sliderValue = 0;
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

        return Container(
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Metrics.width(context) * 0.04),
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(
                        vertical: Metrics.width(context) * 0.04),
                    shrinkWrap: true,
                    itemCount: playlist.length,
                    itemBuilder: (context, index) {
                      //get individual song
                      final Song song = playlist[index];

                      //return ist tile ui

                      return CustomSongTile(
                        songs: song,
                        onTap: () => goToSong(index, context),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Padding(
                          padding:
                              EdgeInsets.all(Metrics.width(context) * 0.02));
                    },
                  ),
                ),
              ),
              FooterComponent(
                footerMargin: const EdgeInsets.all(10),
                footerSize: SizedBox(
                  height: Metrics.height(context) * 0.1,
                ),
                footerStyle: const BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        color: Colors.blue,
                        child: Row(),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        color: Colors.amber,
                        child: SliderTheme(
                          data:
                              SliderTheme.of(context).copyWith(trackHeight: 5),
                          child: Slider(
                            min: 0,
                            max: 3.05,
                            value: sliderValue,
                            activeColor: Colors.green,
                            onChanged: (value) {
                              setState(() {
                                sliderValue = value;
                              });
                              // during when the user is liding around
                            },
                            onChangeEnd: (double double) {
                              // slading has finished go to that position in the song
                              // value.seek(Duration(seconds: double.toInt()));
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}


//  Column(
//                   children: [
//                     Flexible(
//                       child: Container(
//                         height: 50,
//                         color: Colors.amber,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Flexible(
//                               child: Container(
//                                 width: Metrics.width(context) * 0.15,
//                                 height: Metrics.width(context) * 0.2,
//                                 child: ClipRRect(
//                                   borderRadius: const BorderRadius.all(
//                                       Radius.circular(5)),
//                                   child: Image.asset(
//                                     'assets/images/Lae_Dooba.jpg',
//                                     height: Metrics.width(context) * 0.2,
//                                     width: Metrics.width(context) * 0.15,
//                                     fit: BoxFit.fill,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Flexible(
//                               child: Container(
//                                 // width: Metrics.width(context) * 0.5,

//                                 margin: EdgeInsets.symmetric(
//                                     horizontal: Metrics.width(context) * 0.04),
//                                 child: const Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Expanded(
//                                       flex: 0,
//                                       child: TextComponent(
//                                         text: "songName",
//                                         textAlign: TextAlign.left,
//                                         textStyle: TextStyle(
//                                           fontWeight: FontWeight.w700,
//                                         ),
//                                       ),
//                                     ),
//                                     Expanded(
//                                       child: TextComponent(
//                                         text: "artistName",
//                                         textAlign: TextAlign.left,
//                                         textStyle:
//                                             TextStyle(color: Colors.green),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               flex: 1,
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   IconButton(
//                                     icon: const Icon(FontAwesome.heart_empty),
//                                     onPressed: () {},
//                                   ),
//                                   IconButton(
//                                     icon: const Icon(FontAwesome.play),
//                                     onPressed: () {},
//                                   )
//                                 ],
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                     Slider(
//                       min: 0,
//                       max: 3.05,
//                       value: 1.05,
//                       activeColor: Colors.green,
//                       onChanged: (value) {
//                         // during when the user is liding around
//                       },
//                       onChangeEnd: (double double) {
//                         // slading has finished go to that position in the song
//                         // value.seek(Duration(seconds: double.toInt()));
//                       },
//                     ),
//                   ],
//                 ),