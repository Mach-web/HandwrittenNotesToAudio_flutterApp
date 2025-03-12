import 'package:flutter/material.dart';
import 'package:notestoaudio/views/capture_notes.dart';
import 'package:notestoaudio/views/home_page.dart';

class NavigationScreen extends StatefulWidget {
  int selectedIndex;
  NavigationScreen({Key? key, this.selectedIndex = 0}) : super(key: key);
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  static final List<Widget> _screens = <Widget>[
    HomePage(),
    CaptureNotesPage(),
    SummarizationPage(),
    AudioRecordingPage(),
    ChatbotPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Capture',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.text_snippet),
            label: 'Summarize',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.mic), label: 'Record'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chatbot'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor:
            Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
        unselectedItemColor:
            Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
        onTap: _onItemTapped,
      ),
    );
  }
}

class SummarizationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Summarize Your Notes',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}

class AudioRecordingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Record and Transcribe Audio',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}

class ChatbotPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Ask AI Your Questions',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
