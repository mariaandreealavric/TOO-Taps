// views/auth_check.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../controllers/profile_controller.dart';
import '../models/mock_models.dart';

class AuthCheck extends StatefulWidget {
  final Widget Function(BuildContext, String) builder;

  const AuthCheck({super.key, required this.builder});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  final Logger _logger = Logger();
  final ProfileController profileController = Get.find<ProfileController>();
  final MockAuthModel mockAuth = Get.find<MockAuthModel>();

  @override
  void initState() {
    super.initState();
    _initializeProfile();
  }

  Future<void> _initializeProfile() async {
    _logger.i('Debug: Initializing profile...');
    await Future.delayed(Duration.zero);
    profileController.setMockProfile(mockAuth.uid);
    _logger.i('Profile set for mock user: ${mockAuth.uid}');
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, mockAuth.uid);
  }
}
