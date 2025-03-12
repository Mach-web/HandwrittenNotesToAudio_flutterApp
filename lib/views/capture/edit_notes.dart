import 'dart:io';
import 'package:flutter/material.dart';

class EditNotesPage extends StatelessWidget {
  final List<File> images;
  EditNotesPage({required this.images});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Notes')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Edit your notes here...',
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
                    icon: Icon(Icons.audiotrack, color: Colors.white,),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    label: Text('Play Audio'),
                    onPressed: () {},
                  ),
                  SizedBox(width: 5,),
                  ElevatedButton.icon(
                    icon: Icon(Icons.picture_as_pdf, color: Colors.white,),
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
                   SizedBox(width: 5,),
                  ElevatedButton.icon(
                    icon: Icon(Icons.description, color: Colors.white,),
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
