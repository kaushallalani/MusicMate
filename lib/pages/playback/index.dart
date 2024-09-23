// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';
// import 'package:logger/logger.dart';
// import 'package:logger/web.dart';
// import 'package:musicmate/bloc/playback/playback_bloc.dart';
// import 'package:musicmate/bloc/session/session_bloc.dart';
// import 'package:musicmate/components/index.dart';
// import 'package:musicmate/components/newBox.dart';
// import 'package:musicmate/constants/index.dart';
// import 'package:musicmate/models/spotify/albums_data.dart';
// import 'package:musicmate/models/spotify/recommended_songs.dart';
// import 'package:musicmate/navigation/app_navigation.dart';
// import 'package:musicmate/services/playlistProvider.dart';
// import 'package:provider/provider.dart';

// class Playback extends StatefulWidget {
//   final dynamic currentSong;
//   final String? currentSongType;
//   const Playback({super.key, this.currentSong, this.currentSongType});

//   @override
//   State<Playback> createState() => _PlaybackState();
// }

// class _PlaybackState extends State<Playback> {
//   late dynamic _currentSong;
//   List<Track?>? recommendedTracks;
//   List<dynamic>? nextTracks;
//   List<String>? videoIds;
//   String? currentVideoId;
//   bool isLoading = true;
//   bool _isPlaying = false;
//   late PlaylistProvider playlistProvider;

//   @override
//   void initState() {
//     super.initState();
//     _currentSong = widget.currentSong!;
//     Logger().d('currentSong => ${widget.currentSong}');
//     Logger().d('currentSongType => ${widget.currentSongType}');

//     playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);

//     handleRecommendedSongs();
//   }

//   handleRecommendedSongs() {
//     Logger().d('in rec ${widget.currentSongType}');
//     List<String>? artistIds;
//     switch (widget.currentSongType) {
//       case 'AlbumItem':
//         final AlbumItem albumData = AlbumItem.fromJson(_currentSong);
//         artistIds = albumData.artists!.map((artist) => artist.id!).toList();
//         break;

//       case 'Track':
//         Logger().d('in track rec');
//         final Track trackData = Track.fromJson(_currentSong);
//         Logger().d(trackData.artists![0].name);
//         BlocProvider.of<PlaybackBloc>(context).add(OnPlaySong(
//             songName: trackData.name!,
//             artistName:
//                 trackData.artists!.map((artist) => artist.name!).toList()));
//         artistIds = trackData.artists!.map((artist) => artist.id!).toList();
//     }

//     BlocProvider.of<PlaybackBloc>(context)
//         .add(OnGetRecommendedSongs(artistId: artistIds!));
//   }

//   String _formatDuration(Duration duration) {
//     return duration.toString().split('.').first.padLeft(8, '0');
//   }

//   // handleGetTrackIds() {
//   //   final List<String> songNames = recommendedTracks!
//   //       .where((song) => song != null) // Remove null values
//   //       .map(
//   //           (song) => song!.album.name) // Extract the album name from each song
//   //       .toList();

//   //   final List<List<String>> artistNames = recommendedTracks!
//   //       .where((song) => song != null) // Remove null values
//   //       .map((song) => song!.artists.map((artist) => artist.name).toList())
//   //       .toList();
//   //   final listOfIds = BlocProvider.of<PlaybackBloc>(context)
//   //       .add(onGetListOfVideoIds(songName: songNames, artistName: artistNames));
//   // }

//   handleCreateNextTrackPlaylist() {
//     final List<Map<String, dynamic>> newTrackPlaylist = [];

//     final List<dynamic> playlist = [];

//     if (widget.currentSong != null) {
//       playlist.add({
//         'track': widget.currentSong,
//         'videoId':
//             currentVideoId, // Add the correct video ID for the current song
//       });
//     }

//     recommendedTracks!.forEach((val) => playlist.add(val));

//     for (int i = 1; i < recommendedTracks!.length; i++) {
//       var song = recommendedTracks![i]!;
//       // Logger().d(song.album);

//       newTrackPlaylist.add({'track': song});
//       // Logger().d(Track.fromJson(newTrackPlaylist[i]).name);
//     }

//     Logger().d('next => ${playlist[1]}');

//     setState(() {
//       nextTracks = playlist;
//     });
//     playlistProvider.setPlaylist(playlist);
//     // playlistProvider.playCurrentSong();
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<String>? artistList = [];
//     String? imageUrl;
//     String? name;

//     final colors= Theme.of(context).customColors;

//     // Logger().d(_currentSong.runtimeType);
//     switch (widget.currentSongType) {
//       case "AlbumItem":
//         Logger().d('in album');
//         final AlbumItem albumData = AlbumItem.fromJson(_currentSong);
//         name = albumData.name;
//         imageUrl = albumData.images![0].url;
//         artistList = albumData.artists!.map((artist) => artist.name!).toList();
//         break;

//       case "Track":
//         Logger().d('in track');
//         final Track trackData = Track.fromJson(_currentSong);
//         name = trackData.name!;
//         imageUrl = trackData.album!.images![0].url!;
//         artistList = trackData.artists!.map((artist) => artist.name!).toList();
//         break;
//     }

//     return BlocConsumer<PlaybackBloc, PlaybackState>(
//       listener: (context, state) {
//         if (state is PlaybackInitial) {}
//         if (state is PlaybackLoading) {
//           setState(() {
//             isLoading = state.isLoading;
//           });
//         }
//         if (state is PlaybackSuccess) {
//           if (state.videoId != null) {
//             Logger().d('videooo => ${state.videoId}');
//             setState(() {
//               currentVideoId = state.videoId;
//             });
//           }

//           if (state.recommendedSongs != null) {
//             Logger().d('reccc=> ${state.recommendedSongs![0]!.name}');

//             setState(() {
//               recommendedTracks = state.recommendedSongs;
//             });
//             // handleGetTrackIds();
//             handleCreateNextTrackPlaylist();
//           }
//           // Logger().d('playback success');

//           if (state.nextTrackIds != null) {
//             Logger().d('ids => ${state.nextTrackIds}');
//             setState(() {
//               videoIds = state.nextTrackIds;
//             });

//             handleCreateNextTrackPlaylist();
//           }
//         }
//         if (state is PlaybackError) {}
//       },
//       builder: (context, state) {
//         Logger().d('state => ${state}');
//         return Scaffold(
//           appBar: AppBar(
//             leadingWidth: 40,
//             titleSpacing: 0,
//             leading: Padding(
//               padding: EdgeInsets.symmetric(
//                   horizontal: Metrics.width(context) * 0.0),
//               child: IconButton(
//                 icon: const Icon(Entypo.down_open_big),
//                 onPressed: () {
//                   Logger().d('removee');
//                   context.pop();
//                 },
//               ),
//             ),
//             actions: [
//               IconButton(
//                 icon: const Icon(Icons.more_vert),
//                 onPressed: () {},
//               ),
//             ],
//           ),
//           backgroundColor: colors.whiteColor,
//           body: isLoading == true
//               ? Container(
//                   color: Colors.white,
//                   child:  Center(
//                     child: CircularProgressIndicator(
//                       color: colors.customColor2,
//                     ),
//                   ),
//                 )
//               : Column(
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.all(Metrics.width(context) * 0.04),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           NewBox(
//                             boxMargin: EdgeInsets.symmetric(
//                                 horizontal: Metrics.width(context) * 0.02),
//                             child: Column(
//                               children: [
//                                 Container(
//                                   padding: const EdgeInsets.all(5),
//                                   child: ClipRRect(
//                                     borderRadius: BorderRadius.circular(10),
//                                     child: Image.network(
//                                       "https://i.scdn.co/image/ab67616d00004851d45d964b438b8297eb908384",
//                                       width: Metrics.width(context),
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: EdgeInsets.all(
//                                       Metrics.width(context) * 0.02),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Expanded(
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             TextComponent(
//                                               text: name!,
//                                               textStyle: const TextStyle(
//                                                 fontWeight: FontWeight.w700,
//                                                 fontSize: FontSize.medium,
//                                               ),
//                                             ),
//                                             Text(artistList!.join(' , '))
//                                           ],
//                                         ),
//                                       ),
//                                       const Icon(
//                                         Icons.favorite_border,
//                                         color: Colors.red,
//                                       )
//                                     ],
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                           Column(
//                             children: [
//                               Container(
//                                 margin: EdgeInsets.symmetric(
//                                     vertical: Metrics.width(context) * 0.05),
//                                 padding: const EdgeInsets.symmetric(
//                                     vertical: Metrics.baseMargin),
//                                 child: Column(
//                                   children: [
//                                     SliderTheme(
//                                       data: SliderTheme.of(context).copyWith(
//                                         trackHeight: 5,
//                                         inactiveTrackColor: Colors.grey,
//                                         overlayShape:
//                                             SliderComponentShape.noOverlay,
//                                         thumbShape: const RoundSliderThumbShape(
//                                           elevation: 0,
//                                           pressedElevation: 0,
//                                           enabledThumbRadius: 10.0,
//                                         ),
//                                       ),
//                                       child: Slider(
//                                         min: 0,
//                                         max: 3.05,
//                                         value: 2.12,
//                                         activeColor: Colors.green,
//                                         thumbColor: Colors.green,
//                                         onChanged: (value) {
//                                           // setState(() {
//                                           //   sliderValue = value;
//                                           // });
//                                         },
//                                         onChangeEnd: (double value) {
//                                           // Sliding has finished go to that position in the song
//                                           // value.seek(Duration(seconds: value.toInt()));
//                                         },
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 10),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           TextComponent(
//                                             text:
//                                                 _formatDuration(Duration.zero),
//                                             textStyle: const TextStyle(
//                                                 fontSize: FontSize.normal,
//                                                 fontWeight: FontWeight.w500),
//                                           ),
//                                           TextComponent(
//                                             text:
//                                                 _formatDuration(Duration.zero),
//                                             textStyle: const TextStyle(
//                                                 fontSize: FontSize.normal,
//                                                 fontWeight: FontWeight.w500),
//                                           ),
//                                         ],
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               //skip
//                               Expanded(
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     // value.playPreviousSong,
//                                   },
//                                   child: const NewBox(
//                                     child: Icon(Icons.skip_previous),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 20),
//                               //play
//                               Expanded(
//                                 flex: 2,
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     //  value.pauseOrResume,
//                                   },
//                                   child: NewBox(
//                                     child: Icon(_isPlaying
//                                         ? Icons.pause
//                                         : Icons.play_arrow),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 20),
//                               //skip
//                               Expanded(
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     // value.playNextSong
//                                     Logger().d('pressed');
//                                     // playlistProvider.next();

//                                     Logger().d(
//                                         ' current index => ${playlistProvider.currentSongIndex}');

//                                     final json = jsonEncode(nextTracks![
//                                         playlistProvider.currentSongIndex + 1]);
//                                     // Logger().d(
//                                     //     'json => ${Track.fromJson(jsonDecode(json))}');

//                                     // Logger().d(jsonDecode(json));
//                                     // Logger()
//                                     //     .d(Track.fromJson(jsonDecode(json)).name);
//                                     Logger().d(
//                                         'next index => ${playlistProvider.currentSongIndex + 1}');

//                                     context.goNamed(NAVIGATION.playback,
//                                         queryParameters: {
//                                           'currentSong': json,
//                                           'currentSongType': 'Track'
//                                         });
//                                     // setState(() {
//                                     //   _currentSong = nextTracks![
//                                     //       playlistProvider.currentSongIndex];
//                                     // });
//                                   },
//                                   child: const NewBox(
//                                     child: Icon(Icons.skip_next),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//         );
//       },
//     );
//   }

//   // @override
//   // void dispose() {
//   //   super.dispose();
//   //   playlistProvider.dispose();
//   // }
// }
