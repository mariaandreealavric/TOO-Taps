import 'package:fingerfy/Providers/profile_provider.dart';
import 'package:fingerfy/Widgets/Navigazione/navigazione_home.dart';
import 'package:fingerfy/Widgets/bottoni/bottone_profilo.dart';
import 'package:fingerfy/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart'; // Importa il pacchetto logger

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
    final profileProvider = Provider.of<ProfileProvider>(context, listen: true); // Ensure correct context
    _logger.i('ImageListPage: profileProvider is $profileProvider');

    final profile = profileProvider.profile;

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
                          /*StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(widget.userID)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Text('Errore: ${snapshot.error}');
                              }
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }

                              userData = snapshot.data?.data() as Map<String, dynamic>?;

                              if (userData != null && !_isWelcomeMessageShown) {
                                _isWelcomeMessageShown = true;
                                _showWelcomeSnackbar(userData!['displayName'] ?? 'User');
                              }

                              return IconButton(
                                icon: const Icon(Icons.accessibility_new, color: Colors.white),
                                onPressed: () {},
                              );
                            },
                          ),*/
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
  }
}
