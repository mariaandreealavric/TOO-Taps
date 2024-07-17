import 'package:fingerfy/Providers/Contatori/scroll_counter.dart';
import 'package:fingerfy/Providers/Contatori/touch_counter.dart';
import 'package:fingerfy/Services/auth_service.dart';
import 'package:fingerfy/Views/challenge.dart';
import 'package:fingerfy/Views/classifica_page.dart';
import 'package:fingerfy/Views/profilo.dart';
import 'package:fingerfy/Views/scroll_meter.dart';
import 'package:fingerfy/config/firebase_options.dart';
import 'package:fingerfy/providers/challenge_provider.dart';
import 'package:fingerfy/providers/profile_provider.dart';
import 'package:fingerfy/providers/theme_provider.dart';
import 'package:fingerfy/services/notification_service.dart';
import 'package:fingerfy/views/auth/login_page.dart';
import 'package:fingerfy/views/auth/signup_page.dart';
import 'package:fingerfy/views/image_list_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:logger/logger.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
        StreamProvider<User?>.value(
          value: FirebaseAuth.instance.authStateChanges(),
          initialData: null,
        ),
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
                switch (settings.name) {
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
}

class AuthCheck extends StatefulWidget {
  final Widget Function(BuildContext, String) builder;

  const AuthCheck({super.key, required this.builder});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  late Future<void> _initFuture;
  final Logger _logger = Logger();

  @override
  void initState() {
    super.initState();
    _initFuture = _initializeProfileProvider();
  }

  Future<void> _initializeProfileProvider() async {
    final user = Provider.of<User?>(context, listen: false);
    if (user != null) {
      _logger.i('Initializing ProfileProvider for user ${user.uid}');
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      await profileProvider.ensureProfileExists(user.uid); // Assicurati che il profilo esista
      await profileProvider.startListening(user.uid);
    } else {
      _logger.i('No user found');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    _logger.i('AuthCheck: user is $user');

    if (user == null) {
      return const LoginPage();
    }

    return FutureBuilder<void>(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          _logger.e('Error in FutureBuilder: ${snapshot.error}');
          return const Center(child: Text('Errore nel caricamento del profilo'));
        } else {
          final profileProvider = Provider.of<ProfileProvider>(context);
          _logger.i('ProfileProvider state: isLoading=${profileProvider.isLoading}, profile=${profileProvider.profile}, error=${profileProvider.errorMessage}');
          if (profileProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (profileProvider.profile != null) {
            return MultiProvider(
              providers: [
                ChangeNotifierProxyProvider<ProfileProvider, TouchCounter>(
                  create: (_) => TouchCounter(profileProvider.profile!),
                  update: (_, profileProvider, touchCounter) => touchCounter!..updateProfile(profileProvider.profile!),
                ),
                ChangeNotifierProxyProvider<ProfileProvider, ScrollCounter>(
                  create: (_) => ScrollCounter(profileProvider.profile!),
                  update: (_, profileProvider, scrollCounter) => scrollCounter!..updateProfile(profileProvider.profile!),
                ),
              ],
              child: Builder(
                builder: (context) {
                  _logger.i('AuthCheck: Building builder context');
                  return widget.builder(context, user.uid);
                },
              ),
            );
          } else {
            return const Center(child: Text('Errore nel caricamento del profilo'));
          }
        }
      },
    );
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
          Navigator.pushNamed(context, '/imageList');
        },
        child: Container(
          decoration: themeProvider.boxDecoration,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(
                  Icons.rocket,
                  size: 100,
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Image Broker',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 20),
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: const Text('Registrati'),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text('Accedi'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
