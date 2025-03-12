import 'dart:io';
import 'package:flutter/material.dart';
import 'package:notestoaudio/controllers/capture_controller.dart';

class EditNotesPage extends StatelessWidget {
  final List<File> images;
  final CaptureController _captureController = CaptureController();
  EditNotesPage({required this.images});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Scanned Notes'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: TextFormField(
                controller: _captureController.notesController,
                keyboardType: TextInputType.multiline,
                maxLines: 10500,
                // expands: true,
                decoration: InputDecoration(
                  labelText: 'Edit your notes here...',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.audiotrack, color: Colors.white),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    label: Text('Play Audio'),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/audio');
                    },
                  ),
                  SizedBox(width: 5),
                  ElevatedButton.icon(
                    icon: Icon(Icons.picture_as_pdf, color: Colors.white),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    label: Text('Download PDF'),
                    onPressed: () {},
                  ),
                  SizedBox(width: 5),
                  ElevatedButton.icon(
                    icon: Icon(Icons.description, color: Colors.white),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    label: Text('Download DOCX'),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
