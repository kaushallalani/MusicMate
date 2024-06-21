// import 'package:flutter/material.dart';
// import 'package:musicmate/components/newBox.dart';
// import 'package:musicmate/models/playlistProvider.dart';
// import 'package:provider/provider.dart';

// class SongsPage extends StatelessWidget {
//   const SongsPage({super.key});

// //convert dru in to min:sec

//   String formatTime(Duration duration) {
//     String twoDigitSeconds =
//         duration.inSeconds.remainder(60).toString().padLeft(2, '0');
//     String formattedTime = "${duration.inMinutes}:$twoDigitSeconds";

//     return formattedTime;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<Playlistprovider>(builder: (context, value, child) {
//       //get playlist

//       final playlist = value.playlist;
//       // get current song
//       final currentSong = playlist[value.currentSongIndex ?? 0];
//       //return scaffold UI
//       return Scaffold(
//         backgroundColor: Theme.of(context).colorScheme.surface,
//         body: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     IconButton(
//                       onPressed: () => Navigator.pop(context),
//                       icon: const Icon(Icons.arrow_back),
//                     ),
//                     const Text("P L A Y L I S T"),
//                     IconButton(
//                       onPressed: () {},
//                       icon: const Icon(Icons.menu),
//                     )
//                   ],
//                 ),
//                 const SizedBox(height: 25),
//                 NewBox(
//                   child: Column(
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(8),
//                         child: Image.asset(currentSong.albumArtImagePath),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(15.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   currentSong.songName,
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 20,
//                                   ),
//                                 ),
//                                 Text(currentSong.artistName)
//                               ],
//                             ),
//                             const Icon(
//                               Icons.favorite,
//                               color: Colors.red,
//                             )
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 25),
//                 Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 25.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           //start
//                           Text(formatTime(value.currentDuration)),
//                           //shuffle
//                           const Icon(Icons.shuffle),
//                           //repert
//                           const Icon(Icons.repeat),
//                           //end
//                           Text(formatTime(value.totalDuration)),
//                         ],
//                       ),
//                     ),
//                     SliderTheme(
//                       data: SliderTheme.of(context).copyWith(
//                         thumbShape:
//                             const RoundSliderThumbShape(enabledThumbRadius: 0),
//                       ),
//                       child: Slider(
//                         min: 0,
//                         max: value.totalDuration.inSeconds.toDouble(),
//                         value: value.currentDuration.inSeconds.toDouble(),
//                         activeColor: Colors.green,
//                         onChanged: (value) {
//                           // during when the user is liding around
//                         },
//                         onChangeEnd: (double double) {
//                           // slading has finished go to that position in the song
//                           value.seek(Duration(seconds: double.toInt()));
//                         },
//                       ),
//                     )
//                   ],
//                 ),
//                 const SizedBox(height: 25),
//                 Row(
//                   children: [
//                     //skip
//                     Expanded(
//                       child: GestureDetector(
//                         onTap: value.playPreviousSong,
//                         child: const NewBox(
//                           child: Icon(Icons.skip_previous),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 20),
//                     //play
//                     Expanded(
//                       flex: 2,
//                       child: GestureDetector(
//                         onTap: value.pauseOrResume,
//                         child: NewBox(
//                           child: Icon(
//                               value.isPlaying ? Icons.pause : Icons.play_arrow),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 20),
//                     //skip
//                     Expanded(
//                       child: GestureDetector(
//                         onTap: value.playNextSong,
//                         child: const NewBox(
//                           child: Icon(Icons.skip_next),
//                         ),
//                       ),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ),
//       );
//     });
//   }
// }
