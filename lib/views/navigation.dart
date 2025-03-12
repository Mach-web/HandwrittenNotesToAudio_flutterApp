import 'package:flutter/material.dart';


// Main screen with bottom navigation
class NavigationScreen extends StatefulWidget {
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    NotesScreen(),
    ChatbotScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.notes),
            label: 'Notes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chatbot',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

// Notes screen with a list of notes
class NotesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: ListView.builder(
        itemCount: 10, // Placeholder for note count
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Note $index'),
            subtitle: Text('This is a note'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NoteDetailScreen()),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewNoteScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

// Chatbot screen with a simple chat interface
class ChatbotScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chatbot'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Placeholder for message count
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Message $index'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    // Placeholder for sending message
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Camera screen placeholder
class CameraScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Take Picture'),
      ),
      body: Center(
        child: Text('Camera Preview'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Placeholder for capturing image
        },
        child: Icon(Icons.camera),
      ),
    );
  }
}

// Audio recording screen placeholder
class RecordAudioScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Record Audio'),
      ),
      body: Center(
        child: Text('Recording Controls'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Placeholder for start/stop recording
        },
        child: Icon(Icons.mic),
      ),
    );
  }
}

// Screen for creating a new note
class NewNoteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Title',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Content',
              ),
              maxLines: 5,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Return to notes screen
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

// Screen for viewing note details
class NoteDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Note Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Note Title',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Note content goes here...',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Placeholder for summarizing note
                  },
                  child: Text('Summarize'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Placeholder for listening to note
                  },
                  child: Text('Listen'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Placeholder for exporting note
                  },
                  child: Text('Export'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}