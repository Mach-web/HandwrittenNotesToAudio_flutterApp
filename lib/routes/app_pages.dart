import 'package:get/get.dart';
import 'package:orthocannon/views/onboarding_screen.dart';

class AppPages{
  static const String onboarding = '/Onboarding';
  
  static final routes = [
    GetPage(name: onboarding, page: () => const OnboardingScreen()),
  ];
}