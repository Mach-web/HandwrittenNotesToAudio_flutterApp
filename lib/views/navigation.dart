import 'package:flutter/material.dart';
import 'package:notestoaudio/views/capture/capture_notes.dart';
import 'package:notestoaudio/views/home_page.dart';
import 'package:notestoaudio/views/record.dart';
import 'package:notestoaudio/views/summarization.dart';

class NavigationScreen extends StatefulWidget {
  int selectedIndex;
  NavigationScreen({super.key, this.selectedIndex = 0});
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

class ChatbotPage extends StatelessWidget {
  const ChatbotPage({super.key});

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
