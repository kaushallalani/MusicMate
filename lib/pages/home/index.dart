import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:musicmate/components/index.dart';
import 'package:musicmate/constants/theme.dart';
import 'package:musicmate/services/playlistProvider.dart';
import 'package:musicmate/models/song.dart';
import 'package:musicmate/models/spotify/albums_data.dart';
import 'package:musicmate/models/user.dart';
import 'package:musicmate/navigation/app_navigation.dart';
import 'package:musicmate/bloc/dashboard/dashboard_bloc.dart';
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
  Albums? albumsData;
  final scrollController = ScrollController();
  bool hasMoreData = true;

  @override
  void initState() {
    super.initState();
    print('in homee');
    // playlistProvider = Provider.of<Playlistprovider>(context, listen: false);
    _userDetails = UserModel();
    context.read<DashboardBloc>().add(GetUserDetails());

    Timer(const Duration(seconds: 1), () {
      context.read<DashboardBloc>().add(GetToken());
    });
    // getUserDetail();
  }

  void reinitializeState() {
    // playlistProvider = Provider.of<Playlistprovider>(context, listen: false);
    // _userDetails = UserModel();
    context.read<DashboardBloc>().add(GetUserDetails());
  }

// go to a song
  void goToSong(
      String songName, List<String> artistList, AlbumItem currentItem) {
    BlocProvider.of<DashboardBloc>(context)
        .add(OnPlaySong(songName: songName, artistName: artistList));

    context.pushNamed(NAVIGATION.playback, queryParameters: {
      'currentSong': jsonEncode(currentItem.toJson()),
      "currentSongType": 'AlbumItem'
    }).then((onValue) {
      reinitializeState();
    });
  }

  void onListenTogether() {
    GoRouter.of(context).pushNamed(NAVIGATION.listenTogether, queryParameters: {
      'id': '123'
    }).then((val) => {print('back to home'), reinitializeState()});
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardBloc, DashboardState>(
      listener: (context, state) {
        if (state is DashboardInitial) {}
        if (state is DashboardLoadingState) {
          if (mounted) {
            Timer(const Duration(seconds: 1), () {
              setState(() {
                isLoading = state.isLoading;
              });
            });
          }
        }
        if (state is DashboardSuccessState) {
          if (state.currentUser != null) {
            setState(() {
              _userDetails = state.currentUser!;
            });
          }

          if (state.accessToken != null) {
            BlocProvider.of<DashboardBloc>(context).add(GetNewReleases());
          }
          if (state.albumsData != null) {
            print('in thisss');
            setState(() {
              albumsData = state.albumsData;
            });
          }
        }

        if (state is DashboardFailureState) {}
      },
      builder: (context, state) {
        print(_userDetails!.toJson());

        if (albumsData != null) {
          Logger().d('link => ${albumsData!.next}');
        }
        return WillPopScope(
          onWillPop: () async {
            return exit(0); // Exit the app
          },
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            appBar: AppBar(
              leadingWidth: 25,
              title: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Metrics.width(context) * 0),
                child: Text('Welcome ${_userDetails!.fullName}'),
              ),
            ),
            drawer: const Mydrawer(),
            body: isLoading == true
                ? Container(
                    color: Colors.white,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColor.aquaBlue,
                      ),
                    ),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: NotificationListener<ScrollEndNotification>(
                          onNotification: (notification) {
                            final metrics = notification.metrics;
                            if (metrics.atEdge) {
                              bool isTop = metrics.pixels == 0;
                              if (isTop) {
                                print('At the top');
                              } else {
                                if (albumsData!.next != null) {
                                  BlocProvider.of<DashboardBloc>(context).add(
                                      FetchMoreReleases(
                                          nextUrl: albumsData!.next!));
                                } else {
                                  Fluttertoast.showToast(
                                      msg: 'No More Data',
                                      toastLength: Toast.LENGTH_SHORT);
                                }
                              }
                            }
                            return true;
                          },
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Metrics.width(context) * 0.04),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: ButtonComponent(
                                      btnTitle: 'Listen Together',
                                      btnSize: SizedBox(
                                          width: Metrics.width(context) * 0.4),
                                      onPressed: onListenTogether,
                                      btnStyle: BoxDecoration(
                                        color: AppColor.white,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: AppColor.headerBorder),
                                      ),
                                    ),
                                  ),
                                  if (albumsData != null)
                                    ListView.separated(
                                      physics: NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.only(
                                        top: 10,
                                        bottom:
                                            MediaQuery.of(context).size.height *
                                                0,
                                      ),
                                      shrinkWrap: true,
                                      itemCount: albumsData!.items!.length,
                                      itemBuilder: (context, index) {
                                        final AlbumItem albumItem =
                                            albumsData!.items![index];

                                        final artistList = albumItem.artists!
                                            .map((artist) => artist.name!)
                                            .toList();

                                        if (albumItem.albumType ==
                                            AlbumTypeEnum.SINGLE) {
                                          return InkWell(
                                            onTap: () {
                                              goToSong(albumItem.name!,
                                                  artistList, albumItem);
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(),
                                                  ),
                                                  width:
                                                      Metrics.width(context) *
                                                          0.15,
                                                  height:
                                                      Metrics.width(context) *
                                                          0.15,
                                                  child: Image.network(
                                                    albumItem.images![1].url!,
                                                    height:
                                                        Metrics.width(context) *
                                                            0.15,
                                                    width:
                                                        Metrics.width(context) *
                                                            0.15,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                      horizontal: Metrics.width(
                                                              context) *
                                                          0.04,
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        TextComponent(
                                                          text: albumItem.name!,
                                                          textAlign:
                                                              TextAlign.left,
                                                          textStyle:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize:
                                                                FontSize.normal,
                                                          ),
                                                        ),
                                                        TextComponent(
                                                          text: artistList
                                                              .join(' | '),
                                                          textAlign:
                                                              TextAlign.left,
                                                          textStyle:
                                                              const TextStyle(
                                                            fontSize:
                                                                FontSize.msmall,
                                                            color:
                                                                AppColor.grey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                    flex: 0,
                                                    child: IconButton(
                                                      icon:
                                                          Icon(Icons.more_vert),
                                                      onPressed: () {},
                                                    ))
                                              ],
                                            ),
                                          );
                                        } else {
                                          return Container();
                                        }
                                      },
                                      separatorBuilder: (context, index) {
                                        return Padding(
                                          padding: EdgeInsets.all(
                                              Metrics.width(context) * 0.02),
                                        );
                                      },
                                    )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      FooterComponent(
                        flex: 0,
                        footerMargin: EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: Metrics.width(context) * 0.04,
                        ),
                        footerSize: SizedBox(
                          height: Metrics.height(context) * 0.1,
                        ),
                        footerStyle: const BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 0,
                              child: Container(
                                padding: EdgeInsets.all(
                                    Metrics.width(context) * 0.02),
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5)),
                                      child: Image.asset(
                                        'assets/images/Lae_Dooba.jpg',
                                        height: Metrics.width(context) * 0.15,
                                        width: Metrics.width(context) * 0.15,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    Container(
                                      width: Metrics.width(context) * 0.4,
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            Metrics.width(context) * 0.02,
                                      ),
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
                                            textStyle:
                                                TextStyle(color: Colors.green),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Flexible(
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
                                    Flexible(
                                      child: IconButton(
                                        padding: const EdgeInsets.all(0),
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.pause,
                                          size: 25,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: IconButton(
                                        padding: const EdgeInsets.all(0),
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.add_circle,
                                          size: 25,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                width: double.infinity,
                                child: SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    trackHeight: 5,
                                    trackShape:
                                        const RectangularSliderTrackShape(),
                                    thumbShape: const RoundSliderThumbShape(
                                      elevation: 0,
                                      pressedElevation: 0,
                                      enabledThumbRadius: 0.0,
                                    ),
                                  ),
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
                                    onChangeEnd: (double value) {
                                      // Sliding has finished go to that position in the song
                                      // value.seek(Duration(seconds: value.toInt()));
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
