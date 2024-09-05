import 'package:fingerfy/Widgets/Navigazione/navigazione.dart';
import 'package:fingerfy/Widgets/bottoni/bottone_profilo.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';
import '../controllers/theme_controller.dart'; // Import the GetX ThemeController

class TapsHomePage extends StatefulWidget {
  final String userID;

  const TapsHomePage({super.key, required this.userID});

  @override
  TapsHomePageState createState() => TapsHomePageState();
}

class TapsHomePageState extends State<TapsHomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isWelcomeMessageShown = false;
  Map<String, dynamic>? userData;
  final Logger _logger = Logger(); // Instance of Logger

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showWelcomeSnackbar(String userName) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Get.snackbar(
          'Welcome',
          'Welcome, $userName',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      }
    });
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Get.offAllNamed('/'); // Use GetX for navigation after sign out
    }
  }

  @override
  Widget build(BuildContext context) {
    _logger.i('TapsHomePage: Building with userID ${widget.userID}');

    // Use GetX for ThemeController
    final themeController = Get.find<ThemeController>();
    final profileController = Get.find<ProfileController>(); // GetX ProfileController

    // Controlla lo stato di caricamento del profilo
    if (profileController.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }

    final profile = profileController.profile.value; // Usa .value per accedere al ProfileModel

    // Se il profilo non è caricato, mostra un indicatore di caricamento
    if (profile == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_isWelcomeMessageShown) {
      _isWelcomeMessageShown = true;
      _showWelcomeSnackbar(profile.displayName); // Accedi a displayName tramite profile
    }

    return GestureDetector(
      onTap: () {
        if (mounted) {
          profileController.incrementTouches(); // Usa il metodo del controller GetX
          profileController.incrementScrolls();   // Un altro metodo del controller GetX
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Custom Page',
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            const ProfileButton(),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _signOut,
            ),
          ],
        ),
        body: Container(
          decoration: themeController.boxDecoration, // Usa il GetX controller per la gestione del tema
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Welcome, ${profile.displayName}', // Usa .value per accedere alle proprietà
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Touches: ${profile.touches}', // Usa .value per accedere alle proprietà
                            style: const TextStyle(color: Colors.white, fontSize: 80),
                          ),
                          IconButton(
                            icon: const Icon(Icons.accessibility_new, color: Colors.white),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: constraints.maxWidth,
                    color: Colors.transparent,
                    child: Navigation(profile: profile), // Passa l'argomento profile
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
