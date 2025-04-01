import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart' as rxdart;

import '../model/position_data_model.dart';

class AudioController extends GetxController {
  AudioPlayer _audioPlayer = AudioPlayer();
  final String audioUrl;

  // Observable variables
  final isPlaying = false.obs;
  final duration = Duration.zero.obs;
  final position = Duration.zero.obs;
  final bufferedPosition = Duration.zero.obs;

  AudioController({required this.audioUrl});

  @override
  void onInit() {
    super.onInit();
    _initAudioPlayer();
  }

  AudioPlayer get audioBookPlayer => _audioPlayer;
  set audioPlayer(AudioPlayer player) => _audioPlayer = player;

  Future<void> initAudioPlayer() async => _initAudioPlayer();
  Future<void> _initAudioPlayer() async {
    // Set up stream listeners
    _audioPlayer.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
    });

    // Listen for duration changes
    _audioPlayer.durationStream.listen((newDuration) {
      if (newDuration != null) {
        duration.value = newDuration;
      }
    });

    // Listen for position changes
    _audioPlayer.positionStream.listen((newPosition) {
      position.value = newPosition;
    });

    // Listen for buffered position changes
    _audioPlayer.bufferedPositionStream.listen((newBufferedPosition) {
      bufferedPosition.value = newBufferedPosition;
    });

    // Load the audio file
    try {
      await _audioPlayer.setUrl(audioUrl);
    } catch (e) {
      Get.snackbar('Error', 'Could not load audio: $e');
    }
  }

  // Get a combined stream for UI updates
  Stream<PositionData> get positionDataStream =>
      rxdart.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _audioPlayer.positionStream,
        _audioPlayer.bufferedPositionStream,
        _audioPlayer.durationStream,
        (position, bufferedPosition, duration) => PositionData(
          position: position,
          bufferedPosition: bufferedPosition,
          duration: duration ?? Duration.zero,
        ),
      );

  void play() {
    _audioPlayer.play();
  }

  void pause() {
    _audioPlayer.pause();
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  void skipForward() {
    final newPosition = position.value + const Duration(seconds: 10);
    if (newPosition < duration.value) {
      seek(newPosition);
    } else {
      seek(duration.value);
    }
  }

  void skipBackward() {
    final newPosition = position.value - const Duration(seconds: 10);
    if (newPosition > Duration.zero) {
      seek(newPosition);
    } else {
      seek(Duration.zero);
    }
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }
}
