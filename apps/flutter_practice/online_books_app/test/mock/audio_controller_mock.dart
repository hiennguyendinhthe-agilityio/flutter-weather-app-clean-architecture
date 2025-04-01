import 'package:dio/dio.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

class MockAudioPlayer extends Mock implements AudioPlayer {}
