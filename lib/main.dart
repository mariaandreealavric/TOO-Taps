import 'package:fingerfy/Services/auth_service.dart';
import 'package:fingerfy/Views/challenge.dart';
import 'package:fingerfy/Views/pod.dart';
import 'package:fingerfy/Views/profilo.dart';
import 'package:fingerfy/Views/scrolling.dart';
// import 'package:fingerfy/config/firebase_options.dart'; // Commentato per evitare l'utilizzo di Firebase
import 'package:fingerfy/providers/challenge_provider.dart';
import 'package:fingerfy/providers/profile_provider.dart';
import 'package:fingerfy/providers/theme_provider.dart';
import 'package:fingerfy/services/notification_service.dart';
import 'package:fingerfy/views/auth/login_page.dart';
import 'package:fingerfy/views/auth/signup_page.dart';
// import 'package:firebase_auth/firebase_auth.dart'; // Commentato per evitare l'utilizzo di Firebase
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:firebase_core/firebase_core.dart'; // Commentato per evitare l'utilizzo di Firebase
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:timezone/data/latest.dart' as tz;
import 'package:logger/logger.dart';

import 'Models/mock_models.dart.dart';
import 'Views/taps_home.dart';
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services here
  final notificationService = NotificationService();
  await notificationService.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ChallengeProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()), // Ensure it's in the root context
        // Mock models
        Provider<MockAuthModel>(create: (_) => MockAuthModel()),
        Provider<MockProfileModel>(create: (_) => MockProfileModel()),
      ],
      child: const MyApp(),
    ),
  );

  notificationService.scheduleDailyNotification();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TOO-Taps',
      theme: Provider.of<ThemeProvider>(context).currentTheme,
      home: const HomePage(),
      onGenerateRoute: (settings) {
        final routes = {
          '/signup': (context) => const SignUpPage(),
          '/login': (context) => const LoginPage(),
        };

        if (settings.name == null) {
          return null;
        }

        // For routes that require authentication
        if (settings.name == '/taps_home' ||
            settings.name == '/scrolling' ||
            settings.name == '/pod' ||
            settings.name == '/profilo' ||
            settings.name == '/challenge') {
          return MaterialPageRoute(
            builder: (context) => AuthCheck(
              builder: (context, userID) {
                return _buildPageForRoute(settings.name!, userID);
              },
            ),
          );
        }

        final builder = routes[settings.name];
        if (builder != null) {
          return MaterialPageRoute(builder: builder);
        }

        return null;
      },
    );
  }

  Widget _buildPageForRoute(String name, String userID) {
    switch (name) {
      case '/taps_home':
        return TapsHomePage(userID: userID);
      case '/scrolling':
        return ScrollingPage(userID: userID);
      case '/pod':
        return const PodPage();
      case '/profilo':
        return ProfilePage(userID: userID);
      case '/challenge':
        return ChallengePage(userID: userID);
      default:
        return const LoginPage();
    }
  }
}

class AuthCheck extends StatefulWidget {
  final Widget Function(BuildContext, String) builder;

  const AuthCheck({super.key, required this.builder});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  final Logger _logger = Logger();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      final mockAuth = Provider.of<MockAuthModel>(context, listen: false);

      profileProvider.setMockProfile(mockAuth.uid);
      _logger.i('Profile set for mock user: ${mockAuth.uid}');
        });
  }

  @override
  Widget build(BuildContext context) {
    final mockAuth = Provider.of<MockAuthModel>(context);
    _logger.i('AuthCheck: user is $mockAuth');

    return widget.builder(context, mockAuth.uid);
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          // Naviga direttamente a '/imageList' quando qualsiasi parte della pagina viene toccata
          Navigator.pushNamed(context, '/imageList');
        },
        child: Container(
          decoration: themeProvider.boxDecoration,
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.rocket,
                  size: 100,
                  color: Colors.white,
                ),
                SizedBox(height: 20),
                Text(
                  'Image Broker',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(height: 20),
                // Commentato i pulsanti "Registrati" e "Accedi"
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: <Widget>[
                //     ElevatedButton(
                //       onPressed: () {
                //         Navigator.pushNamed(context, '/imageList'); // Bypass signup
                //       },
                //       child: const Text('Registrati'),
                //     ),
                //     const SizedBox(width: 20),
                //     ElevatedButton(
                //       onPressed: () {
                //         Navigator.pushNamed(context, '/imageList'); // Bypass login
                //       },
                //       child: const Text('Accedi'),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
