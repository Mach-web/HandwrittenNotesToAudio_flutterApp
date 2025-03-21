import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:notestoaudio/Machine_learning/text_to_audio.dart';
import 'package:notestoaudio/controllers/text_controller.dart';
import 'package:notestoaudio/download.dart';

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({super.key});

  @override
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Download _download = Download();
  final CaptureController _captureController = Get.put(CaptureController());
  final TTSHelper _ttsHelper = TTSHelper();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  String? _filePath;

  @override
  void initState() {
    super.initState();
    _generateAudio();
    _audioPlayer.onPositionChanged.listen((p) {
      setState(() => position = p);
    });

    _audioPlayer.onDurationChanged.listen((d) {
      setState(() => duration = d);
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        isPlaying = false;
        position = Duration.zero;
      });
    });
  }

  void _generateAudio() async {
    _filePath = await _ttsHelper.generateAudioFromText(
      _captureController.notesController.text,
    );
  }

  void _playAudio() async {
    if (_filePath == null) {
      Get.snackbar(
        "Converting...",
        "Wait for text to audio conversion to finish",
        backgroundColor: Colors.black,
        colorText: Colors.white,
        duration: Duration(seconds: 5),
        isDismissible: true,
      );
      return;
    }
    print("Audio path: $_filePath");
    await _audioPlayer.play(DeviceFileSource(_filePath!, mimeType: "wav"));
    setState(() => isPlaying = true);
  }

  void _pauseAudio() async {
    await _audioPlayer.pause();
    setState(() => isPlaying = false);
  }

  void _stopAudio() async {
    await _audioPlayer.stop();
    setState(() {
      isPlaying = false;
      position = Duration.zero;
    });
  }

  void _seekAudio(Duration newPosition) async {
    await _audioPlayer.seek(newPosition);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Audio Player')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.audiotrack, size: 100, color: Colors.blue),
            const SizedBox(height: 20),
            Text(
              'Now Playing: Sample Audio',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Slider(
              min: 0,
              max: duration.inSeconds.toDouble(),
              value: position.inSeconds.toDouble(),
              onChanged: (value) {
                _seekAudio(Duration(seconds: value.toInt()));
              },
              inactiveColor: Colors.grey,
            ),
            Text(
              "${position.inMinutes}:${position.inSeconds.remainder(60).toString().padLeft(2, '0')} / "
              "${duration.inMinutes}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}",
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_filled,
                    size: 50,
                  ),
                  onPressed: isPlaying ? _pauseAudio : _playAudio,
                ),
                const SizedBox(width: 20),
                IconButton(
                  icon: Icon(Icons.stop_circle, size: 50, color: Colors.red),
                  onPressed: _stopAudio,
                ),
              ],
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: Icon(Icons.download, color: Colors.white),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                label: Text('Download Audio', style: TextStyle(fontSize: 17)),
                onPressed: () {
                  if (_filePath == null) {
                    _download.saveAudio(
                      context: context,
                      audioPath: _filePath!,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
