import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:notestoaudio/download.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:docx_template/docx_template.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:notestoaudio/machine_learning/transcription.dart';

class AudioRecordingPage extends StatefulWidget {
  const AudioRecordingPage({super.key});

  @override
  _AudioRecordingPageState createState() => _AudioRecordingPageState();
}

class _AudioRecordingPageState extends State<AudioRecordingPage> {
  final Download _download = Download();
  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;
  bool _isRecording = false;
  bool _isPlaying = false;
  String? _audioPath;
  // String _convertedText = "";
  Duration _recordingDuration = Duration.zero;
  Duration _playingPosition = Duration.zero;
  Duration _playingTotalDuration = Duration.zero;
  final TextEditingController _textController = TextEditingController();
  final Transcription _transcription = Transcription();

  @override
  void initState() {
    super.initState();
    _recorder = FlutterSoundRecorder();
    _player = FlutterSoundPlayer();
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    PermissionStatus status = await Permission.microphone.request();
    PermissionStatus speechStatus = await Permission.speech.request();
    if (status != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Microphone and speech permission required')),
      );
      return;
    }
    await _recorder!.openRecorder();
    await _player!.openPlayer();

    await _recorder!.setSubscriptionDuration(
      Duration(milliseconds: 100), // 100 ms
    );
    await _player!.setSubscriptionDuration(
      Duration(milliseconds: 100), // 100 ms
    );

    _recorder!.onProgress!.listen((e) {
      if (_isRecording) {
        setState(() {
          _recordingDuration = e.duration;
        });
      }
    });

    _player!.onProgress!.listen((e) {
      if (_isPlaying) {
        setState(() {
          _playingPosition = e.position;
          _playingTotalDuration = e.duration;
        });
      }
    });
  }

  Future<void> _startRecording() async {
    if (_isPlaying) await _stopAudio(); // Stop playback before recording
    Directory tempDir = await getApplicationDocumentsDirectory();
    _audioPath = '${tempDir.path}/recorded_audio.aac';
    await _recorder!.startRecorder(toFile: _audioPath);
    setState(() => _isRecording = true);
  }

  Future<void> _stopRecording() async {
    await _recorder!.stopRecorder();
    setState(() {
      _isRecording = false;
      _recordingDuration = Duration.zero;
    });
  }

  Future<void> _playAudio() async {
    if (_audioPath == null) return;
    if (_isRecording) await _stopRecording(); // Stop recording before playback
    await _player!.startPlayer(
      fromURI: _audioPath,
      whenFinished: () {
        setState(() {
          _isPlaying = false;
          _playingPosition = Duration.zero;
        });
      },
    );
    setState(() => _isPlaying = true);
  }

  void _pauseAudio() async {
    await _player!.pausePlayer();
    setState(() => _isPlaying = false);
  }

  Future<void> _stopAudio() async {
    await _player!.stopPlayer();
    setState(() {
      _isPlaying = false;
      _playingPosition = Duration.zero;
    });
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _recorder!.closeRecorder();
    _player!.closePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Record & Convert Audio'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            icon: Icon(Icons.mic),
            color:
                _isRecording
                    ? Colors.red
                    : null, // Red when recording, default otherwise
            tooltip: 'listen',
            onPressed: () {
              if (_isRecording) {
                _stopRecording();
              } else {
                _startRecording();
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _isRecording
                ? Text(
                  'Recording: ${_formatDuration(_recordingDuration)}',
                  style: TextStyle(fontSize: 16),
                )
                : _audioPath != null
                ? _playerWidget()
                : Text('Ready', style: TextStyle(fontSize: 16)),
            // Text(
            //   _isRecording
            //       ? 'Recording: ${_formatDuration(_recordingDuration)}'
            //       : _isPlaying
            //       ? 'Playing: ${_formatDuration(_playingPosition)} / ${_formatDuration(_playingTotalDuration)}'
            //       : 'Ready',
            //   style: TextStyle(fontSize: 16),
            // ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(_isRecording ? Icons.stop : Icons.mic),
              label: Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
              onPressed: _isRecording ? _stopRecording : _startRecording,
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: Icon(Icons.text_fields),
              label: Text('Convert to Text'),
              onPressed: () {
                if (_audioPath != null) {
                  _transcription.transcribeAudioAndCleanup(_audioPath!);
                }
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Converted Text:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _textController.text.isNotEmpty
                      ? _textController.text
                      : 'No text converted yet.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: Icon(Icons.summarize, color: Colors.white),
              label: Text('Summarize Text'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {},
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.picture_as_pdf, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  label: Text('Save as PDF'),
                  onPressed:
                      () => _download.downloadAsPDF(
                        context: context,
                        convertedText: _textController.text,
                      ),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.description, color: Colors.white),
                  label: Text('Save as DOCX'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed:
                      () => _download.downloadAsDOCX(
                        context: context,
                        convertedText: _textController.text,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _seekAudio(Duration newPosition) async {
    await _player!.seekToPlayer(newPosition);
  }

  Widget _playerWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Slider(
          min: 0,
          max: _playingTotalDuration.inSeconds.toDouble(),
          value: _playingPosition.inSeconds.toDouble(),
          onChanged: (value) {
            _seekAudio(Duration(seconds: value.toInt()));
          },
          inactiveColor: Colors.grey,
        ),
        Text(
          "${_formatDuration(_playingPosition)} / ${_formatDuration(_playingTotalDuration)}",
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                _isPlaying
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_filled,
                size: 35,
              ),
              onPressed: _isPlaying ? _pauseAudio : _playAudio,
            ),
            const SizedBox(width: 20),
            IconButton(
              icon: Icon(Icons.download, size: 35),
              onPressed:
                  () => _download.saveAudio(
                    context: context,
                    audioPath: _audioPath ?? '',
                  ),
            ),
          ],
        ),
      ],
    );
  }
}
