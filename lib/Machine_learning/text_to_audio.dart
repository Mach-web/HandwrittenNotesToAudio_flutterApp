import 'dart:io';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';

class TTSHelper {
  final FlutterTts _flutterTts = FlutterTts();
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<String?> generateAudioFromText(String text) async {
    try {
      // Set TTS options
      await _flutterTts.setLanguage("en-US");
      await _flutterTts.setPitch(1.0);
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);

      // Get the directory to save the audio file
      Directory tempDir = await getTemporaryDirectory();
      String filePath = '${tempDir.path}/tts_audio.wav';

      // Generate audio file
      await _flutterTts.synthesizeToFile(text, filePath);

      return filePath;
    } catch (e) {
      print("Error generating TTS audio: $e");
      return null;
    }
  }

  Future<void> playAudio(String filePath) async {
    try {
      await _audioPlayer.play(DeviceFileSource(filePath));
    } catch (e) {
      print("Error playing audio: $e");
    }
  }
}
