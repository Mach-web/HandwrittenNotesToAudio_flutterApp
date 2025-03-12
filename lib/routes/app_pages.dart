import 'package:get/get.dart';
import 'package:notestoaudio/views/navigation.dart';

class AppPages{
  static const String navigation = '/navigation';
  
  static final routes = [
    GetPage(name: navigation, page: () => NavigationScreen()),
  ];
}