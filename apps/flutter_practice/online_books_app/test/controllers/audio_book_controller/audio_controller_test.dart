import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:online_books_app/presentation/audio_books/controller/audio_controller.dart';

import '../../mock/audio_controller_mock.dart';

void main() {
  late AudioController audioController;
  late MockAudioPlayer mockAudioPlayer;
  const testAudioUrl =
      'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';

  setUp(() {
    mockAudioPlayer = MockAudioPlayer();
    audioController = AudioController(audioUrl: testAudioUrl);
    audioController.audioPlayer = mockAudioPlayer;

    // Setup mock responses
    when(() => mockAudioPlayer.play()).thenAnswer((_) async {});
    when(() => mockAudioPlayer.pause()).thenAnswer((_) async {});
    when(() => mockAudioPlayer.seek(any())).thenAnswer((_) async {});
    when(() => mockAudioPlayer.setUrl(any())).thenAnswer((_) async {
      return null;
    });
    when(() => mockAudioPlayer.dispose()).thenAnswer((_) async {});
  });

  tearDown(() {
    audioController.onClose();
    Get.reset();
  });

  group('Initialization', () {
    test('should initialize with default values', () {
      expect(audioController.isPlaying.value, false);
      expect(audioController.duration.value, Duration.zero);
      expect(audioController.position.value, Duration.zero);
      expect(audioController.bufferedPosition.value, Duration.zero);
    });

    test('onInit should call _initAudioPlayer', () async {
      // Arrange
      final controller = AudioController(audioUrl: testAudioUrl);
      controller.audioPlayer = mockAudioPlayer;

      // Setup stream mocks
      final playerStateController = StreamController<PlayerState>();
      final durationController = StreamController<Duration?>();
      final positionController = StreamController<Duration>();
      final bufferedPositionController = StreamController<Duration>();

      when(() => mockAudioPlayer.playerStateStream)
          .thenAnswer((_) => playerStateController.stream);
      when(() => mockAudioPlayer.durationStream)
          .thenAnswer((_) => durationController.stream);
      when(() => mockAudioPlayer.positionStream)
          .thenAnswer((_) => positionController.stream);
      when(() => mockAudioPlayer.bufferedPositionStream)
          .thenAnswer((_) => bufferedPositionController.stream);

      // Act
      controller.onInit();

      // Assert
      verify(() => mockAudioPlayer.setUrl(testAudioUrl)).called(1);

      // Cleanup
      await playerStateController.close();
      await durationController.close();
      await positionController.close();
      await bufferedPositionController.close();
    });
  });

  group('Playback Controls', () {
    test('play() should call audioPlayer.play()', () async {
      // Act
      audioController.play();

      // Assert
      verify(() => mockAudioPlayer.play()).called(1);
    });

    test('pause() should call audioPlayer.pause()', () async {
      // Act
      audioController.pause();

      // Assert
      verify(() => mockAudioPlayer.pause()).called(1);
    });

    test('seek() should call audioPlayer.seek() with correct position',
        () async {
      // Arrange
      const testPosition = Duration(seconds: 30);

      // Act
      audioController.seek(testPosition);

      // Assert
      verify(() => mockAudioPlayer.seek(testPosition)).called(1);
    });
  });

  group('Skip Controls', () {
    setUp(() {
      audioController.duration.value = const Duration(minutes: 5);
      audioController.position.value = const Duration(seconds: 30);
    });

    test('skipForward() should seek forward by 10 seconds', () async {
      // Act
      audioController.skipForward();

      // Assert
      verify(() => mockAudioPlayer.seek(const Duration(seconds: 40))).called(1);
    });

    test('skipForward() should not exceed duration', () async {
      // Arrange
      audioController.position.value = const Duration(minutes: 4, seconds: 55);

      // Act
      audioController.skipForward();

      // Assert
      verify(() => mockAudioPlayer.seek(const Duration(minutes: 5))).called(1);
    });

    test('skipBackward() should seek backward by 10 seconds', () async {
      // Act
      audioController.skipBackward();

      // Assert
      verify(() => mockAudioPlayer.seek(const Duration(seconds: 20))).called(1);
    });

    test('skipBackward() should not go below zero', () async {
      // Arrange
      audioController.position.value = const Duration(seconds: 5);

      // Act
      audioController.skipBackward();

      // Assert
      verify(() => mockAudioPlayer.seek(Duration.zero)).called(1);
    });
  });

  group('Streams', () {
    test('positionDataStream should combine latest streams correctly',
        () async {
      // Arrange
      const testPosition = Duration(seconds: 10);
      const testBufferedPosition = Duration(seconds: 20);
      const testDuration = Duration(minutes: 3);

      when(() => mockAudioPlayer.positionStream)
          .thenAnswer((_) => Stream.value(testPosition));
      when(() => mockAudioPlayer.bufferedPositionStream)
          .thenAnswer((_) => Stream.value(testBufferedPosition));
      when(() => mockAudioPlayer.durationStream)
          .thenAnswer((_) => Stream.value(testDuration));

      // Act
      final result = await audioController.positionDataStream.first;

      // Assert
      expect(result.position, testPosition);
      expect(result.bufferedPosition, testBufferedPosition);
      expect(result.duration, testDuration);
    });

    test('should update isPlaying when player state changes', () async {
      // Arrange
      final controller = AudioController(audioUrl: testAudioUrl);
      controller.audioPlayer = mockAudioPlayer;

      final playerStateController = StreamController<PlayerState>();
      when(() => mockAudioPlayer.playerStateStream)
          .thenAnswer((_) => playerStateController.stream);

      controller.onInit();

      // Act & Assert
      expect(controller.isPlaying.value, false);

      playerStateController.add(PlayerState(true, ProcessingState.ready));
      await Future.delayed(Duration.zero);
      expect(controller.isPlaying.value, true);

      playerStateController.add(PlayerState(false, ProcessingState.ready));
      await Future.delayed(Duration.zero);
      expect(controller.isPlaying.value, false);

      await playerStateController.close();
    });

    test('should update duration when duration changes', () async {
      // Arrange
      final controller = AudioController(audioUrl: testAudioUrl);
      controller.audioPlayer = mockAudioPlayer;

      final durationController = StreamController<Duration?>();
      when(() => mockAudioPlayer.durationStream)
          .thenAnswer((_) => durationController.stream);

      controller.onInit();

      // Act & Assert
      expect(controller.duration.value, Duration.zero);

      const testDuration = Duration(minutes: 5);
      durationController.add(testDuration);
      await Future.delayed(Duration.zero);
      expect(controller.duration.value, testDuration);

      await durationController.close();
    });
  });

  group('Error Handling', () {
    test('should handle audio loading errors', () async {
      // Arrange
      final controller = AudioController(audioUrl: testAudioUrl);
      controller.audioPlayer = mockAudioPlayer;

      when(() => mockAudioPlayer.setUrl(testAudioUrl))
          .thenThrow(Exception('Network error'));

      // Act
      await controller.initAudioPlayer();

      // Assert
      verify(() => mockAudioPlayer.setUrl(testAudioUrl)).called(1);
      // You might want to verify snackbar was shown here
    });
  });

  group('Cleanup', () {
    test('onClose() should dispose audio player', () async {
      // Act
      audioController.onClose();

      // Assert
      verify(() => mockAudioPlayer.dispose()).called(1);
    });
  });
}
