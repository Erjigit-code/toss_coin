import 'package:audioplayers/audioplayers.dart';

class AudioPlayerProvider {
  static final AudioPlayer tossAudioPlayer = AudioPlayer();
  static final AudioPlayer dropAudioPlayer = AudioPlayer();

  static void preloadAudio() async {
    await tossAudioPlayer.setSource(AssetSource('sounds/coin_toss.mp3'));
    await dropAudioPlayer.setSource(AssetSource('sounds/coin_drop.mp3'));
  }

  static void addAudioListeners() {
    tossAudioPlayer.onPlayerComplete.listen((event) {
      dropAudioPlayer.play(AssetSource('sounds/coin_drop.mp3'));
    });
  }
}
