import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:notestoaudio/machine_learning/docs_pdf.dart';

class SummarizationPage extends StatefulWidget {
  const SummarizationPage({super.key});

  @override
  _SummarizationPageState createState() => _SummarizationPageState();
}

class _SummarizationPageState extends State<SummarizationPage> {
  final DocsPdf _docsPdf = DocsPdf();
  File? selectedFile;
  String _summary = "";

  void _summarizeText() {
    if(selectedFile != null){
      _docsPdf.extractTextFromPdf(selectedFile!);
    }
    String textToSummarize = selectedFile != null ? _docsPdf.extractedText.text : _docsPdf.textController.text;
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
      _summary = '${sentences.take(summaryLength).join('. ')}.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Summarize Your Notes'), 
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(onPressed: (){
            Get.toNamed('/random');
          },
          icon: Icon(Icons.bubble_chart_outlined))
        ],
        ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.upload_file),
              label: Text('Upload PDF/DOCX'),
              onPressed: ()async{
                File? _file = await _docsPdf.pickFile();
                setState((){
                  selectedFile = _file;
                });
              }     
            ),
            const SizedBox(height: 10),
            Text(
              selectedFile != null ? 'File Selected: ${selectedFile!.path.split('/').last}' : 'No file selected',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _docsPdf.textController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Or paste your notes here...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: 
                () => selectedFile != null ? _docsPdf.summarizeText(selectedFile: selectedFile) : _docsPdf.summarizeText(),
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
                child: HtmlWidget(_docsPdf.summary.text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
