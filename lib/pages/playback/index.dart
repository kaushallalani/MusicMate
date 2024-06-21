import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';
import 'package:musicmate/bloc/playback/playback_bloc.dart';
import 'package:musicmate/bloc/session/session_bloc.dart';
import 'package:musicmate/components/index.dart';
import 'package:musicmate/components/newBox.dart';
import 'package:musicmate/constants/theme.dart';
import 'package:musicmate/models/spotify/albums_data.dart';

class Playback extends StatefulWidget {
  final AlbumItem? currentSong;
  const Playback({super.key, this.currentSong});

  @override
  State<Playback> createState() => _PlaybackState();
}

class _PlaybackState extends State<Playback> {
  late AlbumItem _currentSong;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _currentSong = widget.currentSong!;
    Logger().d('currentSong => ${widget.currentSong}');
    handleRecommendedSongs();
  }

  handleRecommendedSongs() {
    final artistIds =
        _currentSong.artists.map((artist) => artist.id).toList();

    BlocProvider.of<PlaybackBloc>(context)
        .add(OnGetRecommendedSongs(artistId: artistIds));
  }

  String _formatDuration(Duration duration) {
    return duration.toString().split('.').first.padLeft(8, '0');
  }

  @override
  Widget build(BuildContext context) {
    final artistList =
        _currentSong.artists.map((artist) => artist.name).toList();
    return BlocConsumer<PlaybackBloc, PlaybackState>(
      listener: (context, state) {
        if (state is PlaybackInitial) {
          Logger().d('playback initial');
        }
        if (state is PlaybackLoading) {
          Logger().d('playback loading');
        }
        if (state is PlaybackSuccess) {
          Logger().d('playback success');
        }
        if (state is PlaybackError) {
          Logger().d('playback error');
        }
      },
      builder: (context, state) {
        Logger().d(state);
        return Scaffold(
          appBar: AppBar(
            leadingWidth: 0,
            titleSpacing: 0,
            leading: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Metrics.width(context) * 0.04),
              child: IconButton(
                icon: const Icon(Entypo.down_open_big),
                onPressed: () {},
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
              ),
            ],
          ),
          backgroundColor: AppColor.white,
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(Metrics.width(context) * 0.04),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NewBox(
                      boxMargin: EdgeInsets.symmetric(
                          horizontal: Metrics.width(context) * 0.02),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                _currentSong.images[0].url,
                                width: Metrics.width(context),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.all(Metrics.width(context) * 0.02),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextComponent(
                                        text: _currentSong.name,
                                        textStyle: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: FontSize.medium,
                                        ),
                                      ),
                                      Text(artistList.join(' , '))
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.favorite_border,
                                  color: Colors.red,
                                )
                              ],
                            ),
                          )
                        ],
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
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  trackHeight: 5,
                                  inactiveTrackColor: Colors.grey,
                                  overlayShape: SliderComponentShape.noOverlay,
                                  thumbShape: const RoundSliderThumbShape(
                                    elevation: 0,
                                    pressedElevation: 0,
                                    enabledThumbRadius: 10.0,
                                  ),
                                ),
                                child: Slider(
                                  min: 0,
                                  max: 3.05,
                                  value: 2.12,
                                  activeColor: Colors.green,
                                  thumbColor: Colors.green,
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
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextComponent(
                                      text: _formatDuration(Duration.zero),
                                      textStyle: const TextStyle(
                                          fontSize: FontSize.normal,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    TextComponent(
                                      text: _formatDuration(Duration.zero),
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
                              //  value.pauseOrResume,
                            },
                            child: NewBox(
                              child: Icon(
                                  _isPlaying ? Icons.pause : Icons.play_arrow),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        //skip
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              // value.playNextSong
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
            ],
          ),
        );
      },
    );
  }
}
