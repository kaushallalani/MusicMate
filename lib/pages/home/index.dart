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

  void onListenTogether() {
    // showDialog(
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     title: Text('hello'),
    //     content: TextComponent(text: 'This is the alert box for testing'),
    //     actions: <Widget>[
    //       ButtonComponent(
    //         btnStyle: BoxDecoration(
    //           color: Colors.blue[600],
    //         ),
    //         btnTitle: 'ok',
    //         onPressed: () => Navigator.of(context).pop(),
    //       ),
    //     ],
    //   ),
    // );
    GoRouter.of(context).push(NAVIGATION.listenTogether);
    // Timer(Duration(seconds: 2), () {
    // });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardBloc, DashboardState>(
      listener: (context, state) {
        if (state is DashboardInitial) {}
        if (state is DashboardLoadingState) {
          Timer(const Duration(milliseconds: 2000), () {
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

        if (state is DashboardFailureState) {}
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
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Metrics.width(context) * 0.04),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: ButtonComponent(
                                btnTitle: 'Listen Together',
                                btnSize: SizedBox(
                                  width: Metrics.width(context) * 0.4,
                                ),
                                onPressed: onListenTogether,
                                btnStyle: BoxDecoration(
                                    color: AppColor.white,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: AppColor.headerBorder)),
                              ),
                            ),
                            Expanded(
                              flex: 0,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 0),
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
                              footerMargin:
                                  const EdgeInsets.symmetric(vertical: 10),
                              // footerPadding: const EdgeInsets.all(5),
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
                                    flex: 0,
                                    child: Container(
                                      padding: EdgeInsets.all(
                                          Metrics.width(context) * 0.02),
                                      width: double.infinity,
                                      // color: Colors.blue,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5)),
                                            child: Image.asset(
                                              'assets/images/Lae_Dooba.jpg',
                                              height:
                                                  Metrics.width(context) * 0.15,
                                              width:
                                                  Metrics.width(context) * 0.15,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          Container(
                                            width: Metrics.width(context) * 0.4,
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    Metrics.width(context) *
                                                        0.02),
                                            child: const Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                TextComponent(
                                                  text: "songName",
                                                  textAlign: TextAlign.left,
                                                  textStyle: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                TextComponent(
                                                  text: "artistName",
                                                  textAlign: TextAlign.left,
                                                  textStyle: TextStyle(
                                                      color: Colors.green),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 0,
                                            child: IconButton(
                                              padding: const EdgeInsets.all(0),
                                              onPressed: () {},
                                              icon: const Icon(
                                                Icons.speaker,
                                                size: 25,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            //  flex: 0,
                                            child: IconButton(
                                                padding:
                                                    const EdgeInsets.all(0),
                                                onPressed: () {},
                                                icon: const Icon(
                                                  Iconic.pause,
                                                  size: 25,
                                                  color: Colors.white,
                                                )),
                                          ),
                                          Expanded(
                                            flex: 0,
                                            child: IconButton(
                                                padding:
                                                    const EdgeInsets.all(0),
                                                onPressed: () {},
                                                icon: const Icon(
                                                  Iconic.plus_circle,
                                                  size: 25,
                                                  color: Colors.white,
                                                )),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      child: SliderTheme(
                                        data: SliderTheme.of(context).copyWith(
                                            trackHeight: 5,
                                            trackShape:
                                                const RectangularSliderTrackShape(),
                                            thumbShape:
                                                const RoundSliderThumbShape(
                                                    elevation: 0,
                                                    pressedElevation: 0,
                                                    enabledThumbRadius: 0.0)),
                                        child: Slider(
                                          min: 0,
                                          max: 3.05,
                                          value: sliderValue,
                                          activeColor: Colors.green,
                                          thumbColor: Colors.transparent,
                                          onChanged: (value) {
                                            // setState(() {
                                            //   sliderValue = value;
                                            // });
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
                      ),
                    ));
            },
          ),
        );
      },
    );
  }
}
