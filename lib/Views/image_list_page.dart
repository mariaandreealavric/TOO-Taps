import 'package:fingerfy/Providers/profile_provider.dart';
import 'package:fingerfy/Widgets/Navigazione/navigazione_home.dart';
import 'package:fingerfy/Widgets/bottoni/bottone_profilo.dart';
import 'package:fingerfy/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart'; // Importa il pacchetto logger

class ImageListPage extends StatefulWidget {
  final String userID;

  const ImageListPage({super.key, required this.userID});

  @override
  ImageListPageState createState() => ImageListPageState();
}

class ImageListPageState extends State<ImageListPage> with SingleTickerProviderStateMixin {
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
    final themeProvider = context.watch<ThemeProvider>();
    final profileProvider = context.watch<ProfileProvider>();
    _logger.i('ImageListPage: profileProvider is $profileProvider');

    if (profileProvider.profile == null) {
      return const Center(child: CircularProgressIndicator());
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
                          StreamBuilder<DocumentSnapshot>(
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
                          ),
                          Consumer<ProfileProvider>(
                            builder: (context, provider, child) {
                              return Text(
                                '${provider.profile?.touches ?? 0}',
                                style: const TextStyle(fontSize: 80, color: Colors.white),
                              );
                            },
                          ),
                          if (userData != null)
                            Text(
                              'Welcome, ${userData!['displayName'] ?? 'User'}',
                              style: const TextStyle(color: Colors.white),
                            )
                          else
                            const Text(
                              'No user is currently signed in.',
                              style: TextStyle(color: Colors.white),
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
