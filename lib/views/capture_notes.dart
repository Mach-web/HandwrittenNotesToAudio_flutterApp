import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notestoaudio/themes.dart';

class CaptureNotesPage extends StatefulWidget {
  @override
  _CaptureNotesPageState createState() => _CaptureNotesPageState();
}

class _CaptureNotesPageState extends State<CaptureNotesPage> {
  final ImagePicker _picker = ImagePicker();
  List<File> _images = [];

  Future<void> _pickImage(ImageSource source) async {
    if (_images.length >= 5) return; // Limit to 5 images
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Capture Notes'), backgroundColor: Theme.of(context).colorScheme.primary,),
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
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Image.file(_images[index], height: 200, width: 150, fit: BoxFit.cover),
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
                  icon: Icon(Icons.camera_alt),
                  label: Text('Capture'),
                  onPressed: () => _pickImage(ImageSource.camera),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  icon: Icon(Icons.upload),
                  label: Text('Upload'),
                  onPressed: () => _pickImage(ImageSource.gallery),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _images.isNotEmpty ? () {/* Navigate to scanning & editing page */} : null,
              style: _images.isNotEmpty
                  ? ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
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
