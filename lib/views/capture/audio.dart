import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({super.key});

  @override
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();

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

  void _playAudio() async {
    // String audioUrl = "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3"; // Replace with your audio file
    await _audioPlayer.play(
      AssetSource(
        "audio/audio1.mp3"), 
      // UrlSource(audioUrl)
      );
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
                  icon: Icon(isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled, size: 50),
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
                label: Text('Download Audio', style: TextStyle(fontSize: 17),),
                onPressed: () {
                  
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
