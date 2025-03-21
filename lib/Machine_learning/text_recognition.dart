import 'dart:io';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:notestoaudio/controllers/text_controller.dart';

class TextRecognition {
  Future<List<String>> extractTextFromImages(List<File> images) async {
    final textRecognizer = TextRecognizer();
    final CaptureController controller = Get.put(CaptureController());
    List<String> extractedTexts = [];

    for (File image in images) {
      final inputImage = InputImage.fromFile(image);
      final RecognizedText recognizedText = await textRecognizer.processImage(
        inputImage,
      );

      extractedTexts.add(recognizedText.text); // Store recognized text
      controller.notesController.text = extractedTexts.join("\n");
    }

    textRecognizer.close();
    return extractedTexts;
  }
}
