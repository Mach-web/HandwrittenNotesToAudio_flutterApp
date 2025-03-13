import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class SummarizationPage extends StatefulWidget {
  @override
  _SummarizationPageState createState() => _SummarizationPageState();
}

class _SummarizationPageState extends State<SummarizationPage> {
  File? _selectedFile;
  String _extractedText = "";
  TextEditingController _textController = TextEditingController();
  String _summary = "";

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx'],
    );

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });

      if (_selectedFile!.path.endsWith('.pdf')) {
        await _extractTextFromPdf(_selectedFile!);
      } else {
        setState(() {
          _extractedText = "Text extraction for DOCX is not yet implemented.";
        });
      }
    }
  }

  Future<void> _extractTextFromPdf(File file) async {
    try {
      PdfDocument document = PdfDocument(inputBytes: await file.readAsBytes());
      String text = PdfTextExtractor(document).extractText();
      document.dispose();

      setState(() {
        _extractedText = text;
      });
    } catch (e) {
      setState(() {
        _extractedText = "Failed to extract text from PDF.";
      });
    }
  }

  void _summarizeText() {
    String textToSummarize = _selectedFile != null ? _extractedText : _textController.text;
    if (textToSummarize.isEmpty) {
      setState(() {
        _summary = "No text provided to summarize.";
      });
      return;
    }

    List<String> sentences = textToSummarize.split('. ');
    int summaryLength = (sentences.length * 0.3).toInt(); // Summarizing to 30% of original text
    summaryLength = summaryLength > 0 ? summaryLength : 1;

    setState(() {
      _summary = sentences.take(summaryLength).join('. ') + '.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Summarize Your Notes'), backgroundColor: Theme.of(context).colorScheme.primary,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.upload_file),
              label: Text('Upload PDF/DOCX'),
              onPressed: _pickFile,
            ),
            const SizedBox(height: 10),
            Text(
              _selectedFile != null ? 'File Selected: ${_selectedFile!.path.split('/').last}' : 'No file selected',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _textController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Or paste your notes here...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _summarizeText,
              style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
              child: Text('Summarize'),
            ),
            const SizedBox(height: 20),
            Text(
              'Summary:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: HtmlWidget(_summary.isNotEmpty ? _summary : 'No summary generated yet.'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
