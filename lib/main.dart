import 'package:fingerfy/Services/auth_service.dart';
import 'package:fingerfy/Views/challenge.dart';
import 'package:fingerfy/Views/classifica_page.dart';
import 'package:fingerfy/Views/profilo.dart';
import 'package:fingerfy/Views/scroll_meter.dart';
// import 'package:fingerfy/config/firebase_options.dart'; // Commentato per evitare l'utilizzo di Firebase
import 'package:fingerfy/providers/challenge_provider.dart';
import 'package:fingerfy/providers/profile_provider.dart';
import 'package:fingerfy/providers/theme_provider.dart';
import 'package:fingerfy/services/notification_service.dart';
import 'package:fingerfy/views/auth/login_page.dart';
import 'package:fingerfy/views/auth/signup_page.dart';
import 'package:fingerfy/views/image_list_page.dart';
// import 'package:firebase_auth/firebase_auth.dart'; // Commentato per evitare l'utilizzo di Firebase
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:firebase_core/firebase_core.dart'; // Commentato per evitare l'utilizzo di Firebase
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:logger/logger.dart';

import 'Models/mock_models.dart.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /*
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  */

  tz.initializeTimeZones();

  final notificationService = NotificationService();
  await notificationService.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ChallengeProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        // Usa i mock models qui
        Provider<MockAuthModel>(create: (_) => MockAuthModel()),
        Provider<MockProfileModel>(create: (_) => MockProfileModel()),
        /*
        StreamProvider<User?>.value(
          value: FirebaseAuth.instance.authStateChanges(),
          initialData: null,
        ),
        */
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
      title: 'Image Broker',
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

        if (settings.name == '/imageList' ||
            settings.name == '/scrollMeter' ||
            settings.name == '/classifica' ||
            settings.name == '/profile' ||
            settings.name == '/challenge') {
          return MaterialPageRoute(
            builder: (context) => AuthCheck(
              builder: (context, userID) {
                return MultiProvider(
                  providers: [
                    // Ensure ProfileProvider is available here.
                    Provider<ProfileProvider>(create: (_) => ProfileProvider()),
                  ],
                  child: _buildPageForRoute(settings.name!, userID),
                );
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
      case '/imageList':
        return ImageListPage(userID: userID);
      case '/scrollMeter':
        return ScrollMeterPage(userID: userID);
      case '/classifica':
        return ClassificaPage(userID: userID);
      case '/profile':
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

      if (mockAuth != null) {
        profileProvider.setMockProfile(mockAuth.uid);
        _logger.i('Profile set for mock user: ${mockAuth.uid}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mockAuth = Provider.of<MockAuthModel>(context);
    _logger.i('AuthCheck: user is $mockAuth');

    if (mockAuth == null) {
      return const LoginPage();
    }

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
