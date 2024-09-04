import 'package:fingerfy/Widgets/Navigazione/navigazione_home.dart';
import 'package:fingerfy/Widgets/bottoni/bottone_profilo.dart';
import 'package:fingerfy/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

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
  final Logger _logger = Logger(); // Istanzia Logger

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Welcome, $userName'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    _logger.i('ImageListPage: Building with userID ${widget.userID}');
    final themeProvider = Provider.of<ThemeProvider>(context, listen: true); // Ensure correct context
    final profileController = Get.find<ProfileController>(); // GetX ProfileController

    final profile = profileController.profile.value; // Use .value to access the actual ProfileModel

    if (profile == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_isWelcomeMessageShown) {
      _isWelcomeMessageShown = true;
      _showWelcomeSnackbar(profile.displayName); // Access displayName via profile
    }

    return GestureDetector(
      onTap: () {
        if (mounted) {
          profileController.incrementTouches(); // Use GetX controller method
          profileController.incrementScrolls();
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
          decoration: themeProvider.boxDecoration,
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
                            'Welcome, ${profile.displayName}', // Use .value to access properties
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Touches: ${profile.touches}', // Use .value to access properties
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
                    child: const NavigationHome(),
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
