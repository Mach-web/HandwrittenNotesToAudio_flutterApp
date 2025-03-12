import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notestoaudio/routes/app_routings.dart';
import 'package:notestoaudio/themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Notes To Audio',
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: AppRouting.initialRoute,
      getPages: AppRouting.getPages,
    );
  }
}

