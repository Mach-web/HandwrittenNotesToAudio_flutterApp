import 'dart:io';
import 'package:docx_template/docx_template.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class Download {
  Future<void> saveAudio({
    required BuildContext context,
    required String audioPath,
  }) async {
    if (audioPath == null) return;
    Directory docsDir = await getApplicationDocumentsDirectory();
    String notesToAudioDir = '${docsDir.path}/NotestoAudio';
    Directory notesDir = Directory(notesToAudioDir);
    if (!await notesDir.exists()) {
      await notesDir.create();
    }
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String newPath = '${notesDir.path}/recorded_audio_$timestamp.aac';
    File audioFile = File(audioPath!);
    await audioFile.copy(newPath);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Audio saved to $newPath')));
  }

  Future<void> downloadAsPDF({
    required BuildContext context,
    required String convertedText,
  }) async {
    PdfDocument document = PdfDocument();
    document.pages.add().graphics.drawString(
      convertedText,
      PdfStandardFont(PdfFontFamily.helvetica, 12),
    );
    List<int> bytes = document.saveSync();
    document.dispose();

    // Get the application's documents directory
    Directory docsDir = await getApplicationDocumentsDirectory();
    // Define the "NotestoAudio" folder path
    String notesToAudioDir = '${docsDir.path}/NotestoAudio';
    Directory notesDir = Directory(notesToAudioDir);

    // Create the folder if it doesn't exist
    if (!await notesDir.exists()) {
      await notesDir.create();
    }

    // Generate a unique file name using a timestamp
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String pdfPath = '${notesDir.path}/notes_$timestamp.pdf';
    File pdfFile = File(pdfPath);

    // Save the PDF file
    await pdfFile.writeAsBytes(bytes);

    // Show the user where the file was saved
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('PDF saved to $pdfPath')));
  }

  Future<void> downloadAsDOCX({
    required BuildContext context,
    required String convertedText,
  }) async {
    final f = File("template.docx");
    final docx = await DocxTemplate.fromBytes(await f.readAsBytes());
    Content content = Content();
    content.add(TextContent("body", convertedText));

    // Get the application's documents directory
    Directory docsDir = await getApplicationDocumentsDirectory();
    // Define the "NotestoAudio" folder path
    String notesToAudioDir = '${docsDir.path}/NotestoAudio';
    Directory notesDir = Directory(notesToAudioDir);

    // Create the folder if it doesn't exist
    if (!await notesDir.exists()) {
      await notesDir.create();
    }

    // Generate a unique file name using a timestamp
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String docxPath = '${notesDir.path}/notes_$timestamp.docx';
    File file = File(docxPath);

    // Save the DOCX file
    await file.writeAsBytes(await docx.generate(content) ?? []);

    // Show the user where the file was saved
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('DOCX saved to $docxPath')));
  }
}
