import 'package:just_audio/just_audio.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();

  final List<AudioSource> _playlist;

  Stream<int?> get currentIndexStream => _player.currentIndexStream;

  Stream<SequenceState?> get sequenceStateStream => _player.sequenceStateStream;

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  AudioService({required List<String> urls})
      : _playlist = urls.map((url) => AudioSource.uri(Uri.parse(url))).toList();

  Future<void> initPlaylist(
      {bool loopPlaylist = true, bool loopSingle = false}) async {
    final concatenated = ConcatenatingAudioSource(children: _playlist);

    try {
      await _player.setAudioSource(concatenated);

      await _player.setLoopMode(loopPlaylist ? LoopMode.all : LoopMode.off);
    } catch (e) {
      print('❌ Error setting audio source: $e');
    }
  }

  Future<void> play() => _player.play();

  Future<void> pause() => _player.pause();

  Future<void> stop() => _player.stop();

  Future<void> dispose() async {
    await _player.dispose();
  }

  String getCurrentTitle(int? index, List<String> titles) {
    if (index != null && index >= 0 && index < titles.length) {
      return titles[index];
    }
    return 'Unknown Title';
  }

  String getCurrentArtist(int? index, List<String> artists) {
    if (index != null && index >= 0 && index < artists.length) {
      return artists[index];
    }
    return 'Unknown Artist';
  }
}
