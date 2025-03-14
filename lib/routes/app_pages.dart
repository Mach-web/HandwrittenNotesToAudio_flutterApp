import 'package:get/get.dart';
import 'package:notestoaudio/views/capture/audio.dart';
import 'package:notestoaudio/views/navigation.dart';
import 'package:notestoaudio/views/random_buttons.dart';

class AppPages{
  static const String navigation = '/navigation';
  static const String audio = '/audio';
  static const String random = '/random';
  
  static final routes = [
    GetPage(name: navigation, page: () => NavigationScreen()),
    GetPage(name: audio, page: () => AudioPlayerScreen()),
    GetPage(name: random, page: () => RandomButtonsScreen())
  ];
}