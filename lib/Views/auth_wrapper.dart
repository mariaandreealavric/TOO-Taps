// views/auth_wrapper.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../main.dart';
import 'auth_check.dart';
import 'home_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();

    return AuthCheck(
      builder: (context, userID) {
        return const HomePage();
      },
    );
  }
}
