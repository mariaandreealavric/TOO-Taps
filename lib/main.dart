// main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/profile_controller.dart';
import 'controllers/theme_controller.dart';
import 'services/notification_service.dart';
import 'widgets/navigazione/route_generator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final notificationService = NotificationService();
  await notificationService.initialize();

  Get.put(ProfileController());
  Get.put(ThemeController());

  notificationService.scheduleDailyNotification();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return GetMaterialApp(
      title: 'TOO-Taps',
      theme: themeController.currentTheme,
      initialRoute: '/',
      getPages: RouteGenerator.getPages,  // Utilizzo corretto di getPages da RouteGenerator
    );
  }
}
