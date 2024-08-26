import 'package:fingerfy/Providers/profile_provider.dart';
import 'package:fingerfy/Widgets/Navigazione/navigazione_home.dart';
import 'package:fingerfy/Widgets/bottoni/bottone_profilo.dart';
import 'package:fingerfy/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:firebase_auth/firebase_auth.dart'; // Commentato per evitare l'utilizzo di Firebase
import 'package:logger/logger.dart';
import 'package:fingerfy/Models/mock_models.dart.dart'; // Importa i Mock Models

class TapsHomePage extends StatefulWidget {
  final String userID;

  const TapsHomePage({super.key, required this.userID});

  @override
  TapsHomePageState createState() => TapsHomePageState();
}

class TapsHomePageState extends State<TapsHomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isWelcomeMessageShown = false;
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

  @override
  Widget build(BuildContext context) {
    _logger.i('TapsHomePage: Building with userID ${widget.userID}');

    return Builder(
      builder: (context) {
        final themeProvider = Provider.of<ThemeProvider>(context, listen: true);
        final profileProvider = Provider.of<ProfileProvider>(context, listen: true);
        final mockProfile = Provider.of<MockProfileModel>(context, listen: false);

        _logger.i('TapsHomePage: profileProvider is $profileProvider');

        final profile = profileProvider.profile ?? mockProfile; // Utilizza il profilo mock se necessario

        if (profile == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!_isWelcomeMessageShown) {
          _isWelcomeMessageShown = true;
          _showWelcomeSnackbar(profile.displayName);
        }

        return GestureDetector(
          onTap: () {
            if (mounted) {
              profileProvider.incrementTouches();
              profileProvider.incrementScrolls();
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
                    // Puoi aggiungere logica mock per il logout se necessario
                    Navigator.pushReplacementNamed(context, '/');
                  },
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
                                'Welcome, ${profile.displayName}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                'Touches: ${profile.touches}',
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
      },
    );
  }
}
