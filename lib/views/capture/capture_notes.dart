import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notestoaudio/machine_learning/text_recognition.dart';
import 'package:notestoaudio/views/capture/edit_notes.dart';
import 'package:notestoaudio/views/random_buttons.dart';

class CaptureNotesPage extends StatefulWidget {
  const CaptureNotesPage({super.key});

  @override
  _CaptureNotesPageState createState() => _CaptureNotesPageState();
}

class _CaptureNotesPageState extends State<CaptureNotesPage> {
  final ImagePicker _picker = ImagePicker();
  final List<File> _images = [];
  final TextRecognition _textRecognition = TextRecognition();

  Future<void> _pickImage(ImageSource source) async {
    if (_images.length >= 5) {
      Get.snackbar(
        'Limit reached',
        'You can only select up to 5 images',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black,
        colorText: Colors.white,
      );
      return;
    } // Limit to 5 images
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  void _navigateToEditNotes() {
    _textRecognition.extractTextFromImages(_images);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditNotesPage(images: _images)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Capture Notes'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context)=>RandomButtonsScreen())
            );
          },
          icon: Icon(Icons.bubble_chart_outlined))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _images.isNotEmpty
                ? SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _images.length,
                    itemBuilder:
                        (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Image.file(
                                _images[index],
                                height: 200,
                                width: 150,
                                fit: BoxFit.cover,
                              ),
                              IconButton(
                                icon: Icon(Icons.cancel, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    _images.removeAt(index);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                  ),
                )
                : Container(
                  height: 300,
                  width: 200,
                  color: Colors.grey[300],
                  child: Icon(Icons.image, size: 100, color: Colors.grey[600]),
                ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.camera_alt, color: Colors.white),
                  label: Text('Capture'),
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
                  onPressed: () => _pickImage(ImageSource.camera),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  icon: Icon(Icons.upload, color: Colors.white),
                  label: Text('Upload'),
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
                  onPressed: () => _pickImage(ImageSource.gallery),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed:
                  _images.isNotEmpty
                      ? () {
                        _navigateToEditNotes();
                      }
                      : null,
              style:
                  _images.isNotEmpty
                      ? ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      )
                      : null,
              child: Text('Scan & Edit Notes', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
