import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';

import 'Services/auth_service.dart';
import 'Views/challenge.dart';
import 'Views/pod.dart';
import 'Views/profilo.dart';
import 'Views/scrolling.dart';
import 'providers/challenge_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/theme_provider.dart';
import 'services/notification_service.dart';
import 'views/auth/login_page.dart';
import 'views/auth/signup_page.dart';
import 'Models/mock_models.dart.dart';
import 'Views/taps_home.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final notificationService = NotificationService();
  await notificationService.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ChallengeProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
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
      theme: context.watch<ThemeProvider>().currentTheme,
      home: const AuthWrapper(),
      onGenerateRoute: (settings) {
        if (settings.name == null) return null;

        return MaterialPageRoute(
          builder: (context) {
            if (settings.name == '/signup') return const SignUpPage();
            if (settings.name == '/login') return const LoginPage();
            return AuthCheck(
              builder: (context, userID) {
                return _buildPageForRoute(context, settings.name!, userID);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildPageForRoute(BuildContext context, String name, String userID) {
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

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthCheck(
      builder: (context, userID) {
        return const HomePage(); // Cambia questa parte in base al tuo flusso di navigazione
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
  final Logger _logger = Logger();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final profileProvider = context.read<ProfileProvider>();
    final mockAuth = context.read<MockAuthModel>();

    Future.microtask(() {
      profileProvider.setMockProfile(mockAuth.uid);
      _logger.i('Profile set for mock user: ${mockAuth.uid}');
    });
  }

  @override
  Widget build(BuildContext context) {
    final mockAuth = context.watch<MockAuthModel>();
    _logger.i('AuthCheck: user is $mockAuth');

    return widget.builder(context, mockAuth.uid);
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/taps_home');
        },
        child: Container(
          decoration: themeProvider.boxDecoration,
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                  image: AssetImage('assets/logo.png'),
                  width: 100,
                  height: 100,
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
