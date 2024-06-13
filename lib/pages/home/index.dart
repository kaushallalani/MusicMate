import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:musicmate/components/index.dart';
import 'package:musicmate/constants/theme.dart';
import 'package:musicmate/models/playlistProvider.dart';
import 'package:musicmate/models/song.dart';
import 'package:musicmate/models/user.dart';
import 'package:musicmate/navigation/app_navigation.dart';
import 'package:musicmate/pages/dashboard/bloc/dashboard_bloc.dart';
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
  bool isLoading = true;
  late UserModel? _userDetails;

  @override
  void initState() {
    super.initState();
    playlistProvider = Provider.of<Playlistprovider>(context, listen: false);
    _userDetails = UserModel();
    context.read<DashboardBloc>().add(GetUserDetails());
    // getUserDetail();
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
    return BlocConsumer<DashboardBloc, DashboardState>(
      listener: (context, state) {
        if (state is DashboardInitial) {}
        if (state is DashboardLoadingState) {
          Timer(const Duration(milliseconds: 1000), () {
            setState(() {
              isLoading = state.isLoading;
            });
          });
        }
        if (state is DashboardSuccessState) {
          setState(() {
            _userDetails = state.currentUser!;
          });
        }

        if (state is DashboardFailureState) {
        }
      },
      builder: (context, state) {
        Logger().d(isLoading);
        print(_userDetails!.email);
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            title: Text('Welcome ${_userDetails!.fullName}'),
          ),
          drawer: const Mydrawer(),
          body: Consumer<Playlistprovider>(
            builder: (context, value, child) {
              // get the list

              final List<Song> playlist = value.playlist;

              return (isLoading == true
                  ? Container(
                      color: Colors.white,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColor.aquaBlue,
                        ),
                      ),
                    )
                  : SizedBox(
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
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return Padding(
                                      padding: EdgeInsets.all(
                                          Metrics.width(context) * 0.02));
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    color: Colors.blue,
                                    child: const Row(),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    color: Colors.amber,
                                    child: SliderTheme(
                                      data: SliderTheme.of(context)
                                          .copyWith(trackHeight: 5),
                                      child: Slider(
                                        min: 0,
                                        max: 3.05,
                                        value: sliderValue,
                                        activeColor: Colors.green,
                                        onChanged: (value) {
                                          setState(() {
                                            sliderValue = value;
                                          });
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
                    ));
            },
          ),
        );
      },
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