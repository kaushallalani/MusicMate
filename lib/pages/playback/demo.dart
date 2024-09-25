import 'dart:convert';
import 'dart:developer';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:logger/web.dart';
import 'package:musicmate/bloc/playback/playback_bloc.dart';
import 'package:musicmate/components/index.dart';
import 'package:musicmate/components/newBox.dart';
import 'package:musicmate/components/progress.dart';
import 'package:musicmate/constants/index.dart';
import 'package:musicmate/constants/utils/audio_cache_manager.dart';
import 'package:musicmate/models/song_model.dart';
import 'package:musicmate/models/spotify/albums_data.dart';
import 'package:musicmate/models/spotify/recommended_songs.dart';
import 'package:musicmate/navigation/app_navigation.dart';
import 'package:shimmer/shimmer.dart'; // Import the cache manager
import 'package:just_audio/just_audio.dart';

class Playback extends StatefulWidget {
  final AlbumItem? currentSong;
  final String? currentSongType;
  const Playback({super.key, this.currentSong, this.currentSongType});

  @override
  State<Playback> createState() => _PlaybackState();
}

class _PlaybackState extends State<Playback> {
  List<Track?>? recommendedTracks;
  List<SongModel>? nextTracks;
  List<String>? videoIds;
  AudioPlayer? audioPlayer;
  ConcatenatingAudioSource? audioTrackList;
  bool isLoading = false;
  bool isAudioLoading = true;
  bool _isPlaying = true;
  List<SongModel?>? playList = [];
  String? currentVideoId;
  Duration currentDuration = Duration.zero;
  Duration totalDuration = Duration.zero;
  double sliderValue = 0.0;
  final AudioCacheManager audioCacheManager = AudioCacheManager();
  ProcessingState currentPlayerState = ProcessingState.idle;
  SwiperController songsSwiper = SwiperController();
  @override
  void initState() {
    super.initState();
    Logger().d('currentSong => ${widget.currentSong!.name}');
    Logger().d('currentSongType => ${widget.currentSongType}');
    initializeAudioPlayer();

    // playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);

    handleGetAudioID();
    handleRecommendedSongs();
  }

  handleGetAudioID() async {
    final artistList =
        widget.currentSong!.artists!.map((artist) => artist.name!).toList();

    final videoID = await getVideoId(widget.currentSong!.name!, artistList);
    if (videoID != null) {
      await getAudioData(videoID);
      if (mounted) {
        setState(() {
          currentVideoId = videoID;
        });
      }
      if (mounted) {
        BlocProvider.of<SongsPlaybackBloc>(context)
            .add(onSaveCurrentAudioId(videoId: videoID!));
      }
    }
  }

  handleRecommendedSongs() {
    Logger().d('in rec ${widget.currentSongType}');
    List<String>? artistIds;
    switch (widget.currentSongType) {
      case 'AlbumItem':
        final AlbumItem albumData = widget.currentSong!;
        artistIds = albumData.artists!.map((artist) => artist.id!).toList();
        break;

      case 'Track':
        Logger().d('in track rec');
      // final Track trackData = Track.fromJson(_currentSong);
      // Logger().d(trackData.artists![0].name);
      // BlocProvider.of<PlaybackBloc>(context).add(OnPlaySong(
      //     songName: trackData.name!,
      //     artistName:
      //         trackData.artists!.map((artist) => artist.name!).toList()));
      // artistIds = trackData.artists!.map((artist) => artist.id!).toList();
    }

    BlocProvider.of<SongsPlaybackBloc>(context)
        .add(OnGetRecommendedSongs(artistId: artistIds!));
  }

  void initializeAudioPlayer() {
    audioPlayer = AudioPlayer();

    audioPlayer!.playbackEventStream.listen((stateData) {
      // log('SEEEEKING =>${stateData.processingState}');
      switch (stateData.processingState) {
        case ProcessingState.loading:
          if (mounted) {
            setState(() {
              isAudioLoading = true;
            });
          }
          break;

        case ProcessingState.ready:
          if (mounted) {
            setState(() {
              isAudioLoading = false;
            });
          }
        case ProcessingState.idle:
          log('dEfult');
          break;
        case ProcessingState.buffering:
          break;
        // TODO: Handle this case.
        case ProcessingState.completed:
          setState(() {
            _isPlaying = false;
          });
      }
    });

    audioPlayer!.positionStream.listen((pos) {
      if (mounted) {
        setState(() {
          sliderValue = getSliderValue();
        });
      }
      log('Post =>$pos');
    });
  }

  getAudioData(videoId) async {
    try {
      log('HEREEe');
      final audioUrl = await getAudioStreamUrl(videoId!);
      // final audioUrl = 'https://www.youtube.com/watch?v=h8rhLGhsa2M';
      if (audioUrl != null) {
        log('HEREEe =>$audioUrl');

        await audioPlayer!.setUrl(audioUrl);

        final duration = audioPlayer!.duration;
        setState(() {
          totalDuration = duration!;
        });
        audioCacheManager.updatePlayedItem(videoId!, {'duration': duration});

        log('DURR =>$duration');

        playList!.add(SongModel(
            albumItem: widget.currentSong,
            videoId: videoId,
            audioUrl: audioUrl));
        setState(() {
          audioTrackList = ConcatenatingAudioSource(
              children: [AudioSource.uri(Uri.parse(audioUrl))],
              shuffleOrder: DefaultShuffleOrder(),
              useLazyPreparation: true);
        });

        await audioPlayer!.setAudioSource(audioTrackList!,
            initialIndex: 0, initialPosition: Duration.zero);

        if (_isPlaying == true) {
          // await audioPlayer!.play();
        }
      }
      log('doing222');
      return audioUrl;
    } catch (e) {}
  }

  double getSliderValue() {
    if (totalDuration.inSeconds > 0) {
      return audioPlayer!.position.inSeconds / totalDuration.inSeconds;
    }
    return 0.0;
  }

  @override
  void dispose() {
    audioPlayer!.dispose();
    // Dispose the scroll controller
    super.dispose();
  }

  void handleAudioPlayPause() {
    if (_isPlaying == true) {
      setState(() {
        _isPlaying = false;
      });
      audioPlayer!.pause();
    } else {
      setState(() {
        _isPlaying = true;
      });
      audioPlayer!.play();
    }
  }

  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    audioPlayer!.seek(newDuration);

    log('added here5');
    setState(() {
      _isPlaying = true;
    });
    audioCacheManager
        .updatePlayedItem(currentVideoId!, {'position': newDuration});
  }
  // handleGetTrackIds() {
  //   final List<String> songNames = recommendedTracks!
  //       .where((song) => song != null) // Remove null values
  //       .map(
  //           (song) => song!.album.name) // Extract the album name from each song
  //       .toList();

  //   final List<List<String>> artistNames = recommendedTracks!
  //       .where((song) => song != null) // Remove null values
  //       .map((song) => song!.artists.map((artist) => artist.name).toList())
  //       .toList();
  //   final listOfIds = BlocProvider.of<PlaybackBloc>(context)
  //       .add(onGetListOfVideoIds(songName: songNames, artistName: artistNames));
  // }

  handleCreateNextTrackPlaylist() async {
    final List<SongModel> playlist = [];

    for (int i = 0; i < recommendedTracks!.length; i++) {
      log('hereeeee =>${recommendedTracks!.length}');
      var song = recommendedTracks![i]!;
      final artistList = song.artists!.map((artist) => artist.name!).toList();
      final idData = await getVideoId(song.name!, artistList);
      if (idData != null) {
        final audioUrl = await getAudioStreamUrl(idData);
        log('DATTTTTT => ${idData}  ${artistList} $audioUrl');
        Logger().d(song.album);
        if (audioTrackList != null) {
          audioTrackList!.children.add(AudioSource.uri(Uri.parse(audioUrl!)));
        }

        playlist.add(SongModel(
            albumItem: song.album, videoId: idData, audioUrl: audioUrl));
      }
      // Logger().d(Track.fromJson(newTrackPlaylist[i]).name);
    }

    // Logger()
    //     .d('next => ${playlist.length}  ${audioTrackList!.children.length}');
    if (mounted) {
      setState(() {
        playList = [...playList!, ...playlist];
      });
    }

    // playlistProvider.playCurrentSong();
  }

  @override
  Widget build(BuildContext context) {
    List<String>? artistList = [];
    String? imageUrl;
    String? name;
    final colors = Theme.of(context).customColors;

    switch (widget.currentSongType) {
      case "AlbumItem":
        final AlbumItem albumData = widget.currentSong!;
        name = albumData.name;
        imageUrl = albumData.images![0].url;
        artistList = albumData.artists!.map((artist) => artist.name!).toList();
        break;

      // case "Track":
      //   Logger().d('in track');
      //   final Track trackData = Track.fromJson(_currentSong);
      //   name = trackData.name!;
      //   imageUrl = trackData.album!.images![0].url!;
      //   artistList = trackData.artists!.map((artist) => artist.name!).toList();
      //   break;
    }

    log('PLAYYLIST =>${playList!.length}');
    return BlocConsumer<SongsPlaybackBloc, SongsPlaybackState>(
      listener: (context, state) {
        if (state is PlaybackInitial) {}
        if (state is PlaybackLoading) {
          setState(() {
            isLoading = state.isLoading;
          });
        }
        if (state is PlaybackSuccess) {
          if (state.videoId != null) {
            Logger().d('videooo => ${state.videoId}');
            setState(() {
              currentVideoId = state.videoId;
            });
          }

          if (state.recommendedSongs != null) {
            Logger().d(
                'reccc=> ${state.recommendedSongs![0]!.name} lenn ${state.recommendedSongs!.length}');

            setState(() {
              recommendedTracks = state.recommendedSongs;
            });
            handleCreateNextTrackPlaylist();
          }

          if (state.nextTrackIds != null) {
            Logger().d('ids => ${state.nextTrackIds}');
            setState(() {
              videoIds = state.nextTrackIds;
            });

            // handleCreateNextTrackPlaylist();
          }
        }
        if (state is PlaybackError) {}
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: colors.whiteColor,
            leadingWidth: 40,
            titleSpacing: 0,
            leading: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Metrics.width(context) * 0.0),
              child: IconButton(
                icon: const Icon(Entypo.down_open_big),
                onPressed: () {
                  Logger().d('removee');
                  context.pop();
                },
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
              ),
            ],
          ),
          backgroundColor: colors.whiteColor,
          body: isLoading == true
              ? Container(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: colors.redColor,
                    ),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(Metrics.width(context) * 0.04),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              height: Metrics.getResponsiveSize(context, 1),
                              child: playList != null && playList!.length != 0
                                  ? Swiper(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: playList!.length,

                                      // pagination: SwiperPagination(),
                                      controller: songsSwiper,
                                      itemBuilder: (context, index) {
                                        final SongModel songData =
                                            playList![index]!;
                                        final artistData = songData
                                            .albumItem!.artists!
                                            .map((artist) => artist.name!)
                                            .toList();

                                        log('INDex => $index  ');
                                        return NewBox(
                                          boxMargin: EdgeInsets.symmetric(
                                              horizontal:
                                                  Metrics.width(context) *
                                                      0.02),
                                          child: Column(
                                            children: [
                                              Flexible(
                                                child: Container(
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Image.network(
                                                        height: Metrics
                                                            .getResponsiveSize(
                                                                context, 0.8),
                                                        filterQuality:
                                                            FilterQuality.high,
                                                        songData.albumItem!
                                                            .images![0].url!,
                                                        width: Metrics.width(
                                                            context),
                                                        fit: BoxFit.cover,
                                                        frameBuilder: (context,
                                                            child,
                                                            frame,
                                                            wasSynchronouslyLoaded) {
                                                      if (frame == null) {
                                                        return Container(
                                                          width: Metrics.width(
                                                              context),
                                                          height: Metrics
                                                              .getResponsiveSize(
                                                                  context, 0.8),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          child: Shimmer
                                                              .fromColors(
                                                            baseColor:
                                                                const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    224,
                                                                    224,
                                                                    224),
                                                            highlightColor:
                                                                Colors.grey
                                                                    .shade100,
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                            ),
                                                          ),
                                                        );
                                                      } else {
                                                        return child;
                                                      }
                                                    }),
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                flex: 0,
                                                child: Padding(
                                                  padding: EdgeInsets.all(
                                                      Metrics.width(context) *
                                                          0.02),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            TextComponent(
                                                              text: songData
                                                                  .albumItem!
                                                                  .name!,
                                                              textStyle:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize:
                                                                    FontSize
                                                                        .medium,
                                                              ),
                                                            ),
                                                            Text(artistData
                                                                .join(' , '))
                                                          ],
                                                        ),
                                                      ),
                                                      const Icon(
                                                        Icons.favorite_border,
                                                        color: Colors.red,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      })
                                  : Container(
                                      width: Metrics.width(context),
                                      height: Metrics.getResponsiveSize(
                                          context, 0.8),
                                      margin: EdgeInsets.symmetric(
                                          horizontal:
                                              Metrics.width(context) * 0.02),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Shimmer.fromColors(
                                        baseColor: const Color.fromARGB(
                                            255, 224, 224, 224),
                                        highlightColor: Colors.grey.shade100,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                        ),
                                      ),
                                    ),
                            ),
                            Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: Metrics.width(context) * 0.05),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: Metrics.baseMargin),
                                  child: Column(
                                    children: [
                                      Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          child: isAudioLoading == false
                                              ? SliderTheme(
                                                  data: SliderTheme.of(context)
                                                      .copyWith(
                                                    trackHeight: 5,
                                                    overlayShape:
                                                        SliderComponentShape
                                                            .noOverlay,
                                                    thumbShape:
                                                        const RoundSliderThumbShape(
                                                            enabledThumbRadius:
                                                                5),
                                                  ),
                                                  child: Slider(
                                                    value: sliderValue,
                                                    activeColor:
                                                        colors.blackColor,
                                                    inactiveColor: Colors.grey,
                                                    min: 0.0,
                                                    max: 1.0,
                                                    onChanged: (double value) {
                                                      final newPosition = (value *
                                                              (audioPlayer!
                                                                  .duration!
                                                                  .inSeconds))
                                                          .toInt();
                                                      seekToSecond(newPosition);
                                                      setState(() {
                                                        sliderValue = value;
                                                      });
                                                    },
                                                  ),
                                                )
                                              : LinearProgressIndicator(
                                                  minHeight: 5,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: colors.headerBorder,
                                                  backgroundColor:
                                                      colors.greyColor)),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextComponent(
                                              text: formatDuration(
                                                  audioPlayer!.position),
                                              textStyle: const TextStyle(
                                                  fontSize: FontSize.normal,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            TextComponent(
                                              text:
                                                  formatDuration(totalDuration),
                                              textStyle: const TextStyle(
                                                  fontSize: FontSize.normal,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                //skip
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      // value.playPreviousSong,
                                    },
                                    child: const NewBox(
                                      child: Icon(Icons.skip_previous),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                //play
                                Expanded(
                                  flex: 2,
                                  child: GestureDetector(
                                    onTap: () {
                                      handleAudioPlayPause();
                                      //  value.pauseOrResume,
                                    },
                                    child: NewBox(
                                      child: Icon(_isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                //skip
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      songsSwiper.next();
                                      audioPlayer!.seekToNext();
                                      Logger().d(
                                          'pressed =>${audioPlayer!.duration}');

                                      // context.goNamed(NAVIGATION.playback,
                                      //     queryParameters: {
                                      //       'currentSong': json,
                                      //       'currentSongType': 'Track'
                                      //     });
                                    },
                                    child: const NewBox(
                                      child: Icon(Icons.skip_next),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   playlistProvider.dispose();
  // }
}
