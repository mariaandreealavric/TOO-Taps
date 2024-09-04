import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../Widgets/Navigazione/navigazione_home.dart';
import '../controllers/profile_provider.dart';



import '../controllers/theme_controller.dart';
import '../widgets/bottoni/bottone_profilo.dart';

class TapsHomePage extends StatefulWidget {
  final String userID;

  const TapsHomePage({super.key, required this.userID});

  @override
  TapsHomePageState createState() => TapsHomePageState();
}

class TapsHomePageState extends State<TapsHomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isWelcomeMessageShown = false;
  final Logger _logger = Logger();
  final ProfileController profileController = Get.put(ProfileController());
  final ThemeController themeController = Get.put(ThemeController());

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
          duration: const Duration(seconds: 3),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _logger.i('TapsHomePage: Building with userID ${widget.userID}');

    if (!_isWelcomeMessageShown) {
      _isWelcomeMessageShown = true;
      final profile = profileController.profile.value;
      if (profile != null) {
        _showWelcomeSnackbar(profile.displayName);
      }
    }

    return GestureDetector(
      onTap: () {
        if (mounted) {
          profileController.incrementTouches();
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
              onPressed: () {
                Get.offAllNamed('/');
              },
            ),
          ],
        ),
        body: Container(
          decoration: themeController.boxDecoration,
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
                            'Welcome, ${profileController.profile.value?.displayName ?? ''}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Touches: ${profileController.profile.value?.touches ?? 0}',
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
