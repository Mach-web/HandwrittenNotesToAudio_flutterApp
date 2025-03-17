import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

Future<List<String>> extractTextFromImages(List<File> images) async {
  final textRecognizer = TextRecognizer();
  List<String> extractedTexts = [];

  for (File image in images) {
    final inputImage = InputImage.fromFile(image);
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    
    extractedTexts.add(recognizedText.text); // Store recognized text
  }

  textRecognizer.close();
  return extractedTexts;
}
