import 'dart:io';
import 'package:docx_template/docx_template.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';

class Download {
  Future<void> saveAudio({
    required BuildContext context,
    required String audioPath,
  }) async {
    if (audioPath.isEmpty) return;
    bool hasPermission = await requestStoragePermission();
    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Storage permission required to save audio')),
      );
      return;
    }

    Directory downloadsDir = Directory('/storage/emulated/0/Download');
    if (!downloadsDir.existsSync()) {
      downloadsDir = await getExternalStorageDirectory() ?? Directory('');
    }

    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String newPath = '${downloadsDir.path}/recorded_audio_$timestamp.aac';

    File audioFile = File(audioPath);
    await audioFile.copy(newPath);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Audio saved to $newPath'), duration: Duration(seconds: 5),));
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

  Future<bool> requestStoragePermission() async {
    PermissionStatus status = await Permission.storage.status;

    if (status.isGranted) {
      return true; // Permission already granted
    } else if (status.isDenied) {
      print("Permission denied....");
      status = await Permission.storage.request();
      if(!status.isGranted){
        status = await Permission.manageExternalStorage.request();
      }
      return status.isGranted;
    } else if (status.isPermanentlyDenied) {
      // Open app settings so the user can enable the permission manually
      await openAppSettings();
      return false;
    }

    return false;
  }
}
