import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notestoaudio/routes/app_routings.dart';
import 'package:notestoaudio/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
// Initialize the Vertex AI service and the generative model
// Specify a model that supports your use case
final model =
      FirebaseVertexAI.instance.generativeModel(model: 'gemini-2.0-flash');
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

