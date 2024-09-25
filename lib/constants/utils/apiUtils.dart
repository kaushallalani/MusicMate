import 'dart:developer';

import 'package:logger/logger.dart';
import 'package:musicmate/constants/utils/audio_cache_manager.dart';
import 'package:musicmate/services/spotify_authentication.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

// Get audio stream URL for the given videoId
Future<String?> getAudioStreamUrl(String videoId) async {
  try {
    // Check if the audio URL is already cached
    // final currentData = AudioCacheManager().getPlayedItem(videoId);
    // log('Current data from video ID: $currentData');

    // if (currentData != null && currentData['audioUrl'] != null) {
    //   log('Returning cached audio URL');
    //   return currentData['audioUrl'];
    // } else {
    log('Fetching new audio URL from YouTube =>$videoId');
    final yt = YoutubeExplode();

    // Get video information
    final video = await yt.videos.get(videoId);

    log('Fetching new video from YouTube =>${video.id}');

    // log('Fetched video ID: ${await yt.videos.streams.getManifest(video.id)}');

    // Get the stream manifest
    final manifest = await yt.videos.streams.getManifest(videoId);
    log('Stream manifest: ${manifest.audioOnly}');

    // Get the audio stream with the highest bitrate
    final audioStreamInfo = manifest.audioOnly.last;
    log('Selected audio stream: ${audioStreamInfo.toJson()}');

    // Cache the audio URL
    if (audioStreamInfo.url.toString().isNotEmpty) {
      AudioCacheManager().updatePlayedItem(
          videoId, {'audioUrl': audioStreamInfo.url.toString()});
    }
    log('Cached audio URL: ${audioStreamInfo.url.toString()}');

    return audioStreamInfo.url.toString();
    // }
  } catch (e) {
    log('Error fetching audio URL: $e');
    return null;
  }
}

Future<String?> getVideoId(String songName, List<String> artistName) async {
  try {
    final currentVideoId =
        AudioCacheManager().findVideoId(songName, artistName);
    log('fROM VIDEOO IDD =>$currentVideoId');

    if (currentVideoId != null) {
      log('fROM 1');
      return currentVideoId;
    } else {
      log('fROM 2');

      final jsonResponse =
          await SpotifyAuthentication().fetchSearchSong(songName, artistName);

      if (jsonResponse != null && jsonResponse['items'].length != 0) {
        final videoId = jsonResponse!['items'][0]['id']['videoId'];
        Logger().d('videoId => ${jsonResponse['items'][0]['id']['videoId']}');
        if (videoId != null) {
          AudioCacheManager().addToPlayedList(videoId, {
            'songName': songName,
            'artistName': artistName,
            'videoId': videoId,
            'duration': Duration.zero
          });
          return videoId;
        }
      }
    }
  } on Exception catch (e) {
    return Future.error(e);
  }
  return null;
}
