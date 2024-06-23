import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class MyAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final AudioPlayer _player = AudioPlayer();

  MyAudioHandler() {
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> skipToNext() async {
    final currentIndex = queue.value.indexOf(mediaItem.value!);
    if (currentIndex + 1 < queue.value.length) {
      await playMediaItem(queue.value[currentIndex + 1]);
    }
  }

  @override
  Future<void> skipToPrevious() async {
    final currentIndex = queue.value.indexOf(mediaItem.value!);
    if (currentIndex - 1 >= 0) {
      await playMediaItem(queue.value[currentIndex - 1]);
    }
  }

  @override
  Future<void> addQueueItem(MediaItem mediaItem) async {
    final newQueue = List.of(queue.value)..add(mediaItem);
    queue.add(newQueue);
    await playMediaItem(mediaItem);
  }

  @override
  Future<void> playMediaItem(MediaItem mediaItem) async {
    _player.setAudioSource(AudioSource.uri(Uri.parse(mediaItem.id)));
    this.mediaItem.add(mediaItem);  // Updated to use the proper mediaItem stream
    await _player.play();
  }

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.skipToNext,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 2], // Updated parameter name
      processingState: {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: queue.value.indexOf(mediaItem.value ?? const MediaItem(id: '', title: '')), // Handle null case
    );
  }
}
