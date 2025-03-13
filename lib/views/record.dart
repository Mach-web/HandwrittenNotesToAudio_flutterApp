import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:docx_template/docx_template.dart';

class AudioRecordingPage extends StatefulWidget {
  @override
  _AudioRecordingPageState createState() => _AudioRecordingPageState();
}

class _AudioRecordingPageState extends State<AudioRecordingPage> {
  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;
  bool _isRecording = false;
  bool _isPlaying = false;
  String? _audioPath;
  stt.SpeechToText _speechToText = stt.SpeechToText();
  String _convertedText = "";

  @override
  void initState() {
    super.initState();
    _recorder = FlutterSoundRecorder();
    _player = FlutterSoundPlayer();
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    await _recorder!.openRecorder();
    // await _recorder!.openAudioSession();
    await _player!.openPlayer();
    // await _player!.openAudioSession();
  }

  Future<void> _startRecording() async {
    Directory tempDir = await getApplicationDocumentsDirectory();
    _audioPath = '${tempDir.path}/recorded_audio.aac';
    await _recorder!.startRecorder(toFile: _audioPath);
    setState(() => _isRecording = true);
  }

  Future<void> _stopRecording() async {
    await _recorder!.stopRecorder();
    setState(() => _isRecording = false);
  }

  Future<void> _playAudio() async {
    if (_audioPath == null) return;
    await _player!.startPlayer(fromURI: _audioPath, whenFinished: () {
      setState(() => _isPlaying = false);
    });
    setState(() => _isPlaying = true);
  }

  Future<void> _stopAudio() async {
    await _player!.stopPlayer();
    setState(() => _isPlaying = false);
  }

  Future<void> _convertSpeechToText() async {
    bool available = await _speechToText.initialize();
    if (available && _audioPath != null) {
      await _speechToText.listen(
        onResult: (result) {
          setState(() {
            _convertedText = result.recognizedWords;
          });
        },
      );
    }
  }

  Future<void> _downloadAsPDF() async {
    PdfDocument document = PdfDocument();
    document.pages.add().graphics.drawString(_convertedText, PdfStandardFont(PdfFontFamily.helvetica, 12));
    List<int> bytes = document.saveSync();
    document.dispose();
    Directory tempDir = await getApplicationDocumentsDirectory();
    File pdfFile = File('${tempDir.path}/notes.pdf');
    await pdfFile.writeAsBytes(bytes);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('PDF saved to ${pdfFile.path}')));
  }

  Future<void> _downloadAsDOCX() async {
    final f = File("template.docx");
  final docx = await DocxTemplate.fromBytes(await f.readAsBytes());
  
    Content content = Content();
    content.add(TextContent("body", _convertedText));
    Directory tempDir = await getApplicationDocumentsDirectory();
    File file = File('${tempDir.path}/notes.docx');
    await file.writeAsBytes(await docx.generate(content) ?? []);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('DOCX saved to ${file.path}')));
  }

  void _summarizeText() {
    List<String> sentences = _convertedText.split('. ');
    int summaryLength = (sentences.length * 0.3).toInt();
    summaryLength = summaryLength > 0 ? summaryLength : 1;
    setState(() {
      _convertedText = sentences.take(summaryLength).join('. ') + '.';
    });
  }

  @override
  void dispose() {
    _recorder!.closeRecorder();
    // _recorder!.closeAudioSession();
    _player!.closePlayer();
    // _player!.closeAudioSession();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Record & Convert Audio')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              icon: Icon(_isRecording ? Icons.stop : Icons.mic),
              label: Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
              onPressed: _isRecording ? _stopRecording : _startRecording,
            ),
            const SizedBox(height: 10),
            if (_audioPath != null)
              ElevatedButton.icon(
                icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
                label: Text(_isPlaying ? 'Stop Playback' : 'Play Audio'),
                onPressed: _isPlaying ? _stopAudio : _playAudio,
              ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.text_fields),
              label: Text('Convert to Text'),
              onPressed: _convertSpeechToText,
            ),
            const SizedBox(height: 20),
            Text(
              'Converted Text:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _convertedText.isNotEmpty ? _convertedText : 'No text converted yet.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: Icon(Icons.summarize),
              label: Text('Summarize Text'),
              onPressed: _summarizeText,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.picture_as_pdf),
                  label: Text('Save as PDF'),
                  onPressed: _downloadAsPDF,
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.description),
                  label: Text('Save as DOCX'),
                  onPressed: _downloadAsDOCX,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
