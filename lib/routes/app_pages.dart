import 'package:get/get.dart';
import 'package:notestoaudio/views/capture/audio.dart';
import 'package:notestoaudio/views/navigation.dart';

class AppPages{
  static const String navigation = '/navigation';
  static const String audio = '/audio';
  
  static final routes = [
    GetPage(name: navigation, page: () => NavigationScreen()),
    GetPage(name: audio, page: () => AudioPlayerScreen()),
  ];
}