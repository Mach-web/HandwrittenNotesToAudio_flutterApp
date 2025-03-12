import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:notestoaudio/views/navigation.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child:
                MediaQuery.of(context).platformBrightness == Brightness.dark
                    ? Lottie.asset(
                      'assets/animations/homepage_dark.json',
                      key: ValueKey('dark'),
                      height: 300,
                      fit: BoxFit.fitWidth,
                      animate: true,
                    )
                    : Lottie.asset(
                      'assets/animations/homepage_light.json',
                      key: ValueKey('light'),
                      height: 300,
                      fit: BoxFit.fitWidth,
                      animate: true,
                    ),
          ),
          const SizedBox(height: 20),
          Text(
            'Welcome to Notes To Audio',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'Capture, summarize, and convert your notes to audio with ease.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          FadeTransition(
              opacity: _fadeAnimation,
              child: ElevatedButton(
                onPressed: () {
                  // Add navigation to a tutorial or demo screen here
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NavigationScreen(selectedIndex: 1,),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
