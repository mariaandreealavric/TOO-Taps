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
import 'controllers/theme_controller.dart';
import 'services/notification_service.dart';
import 'views/auth/login_page.dart';
import 'views/auth/signup_page.dart';
import 'Models/mock_models.dart.dart';
import 'Views/taps_home.dart';
import 'Widgets/Navigazione/route_generator.dart';  // Import the RouteGenerator

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final notificationService = NotificationService();
  await notificationService.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ThemeController()),
        ChangeNotifierProvider(create: (_) => ChallengeProvider()),
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
    // Debug log to check if ThemeProvider is available
    final themeProviderAvailable = Provider.of<ThemeController>(context, listen: false) != null;
    print('Debug: ThemeProvider is available: $themeProviderAvailable');

    return MaterialApp(
      title: 'TOO-Taps',
      theme: context.watch<ThemeController>().currentTheme,
      home: const AuthWrapper(),
      onGenerateRoute: RouteGenerator.generateRoute,  // Use RouteGenerator for route generation
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Debug log to check if ProfileProvider is available in AuthWrapper
    final profileProviderAvailable = Provider.of<ProfileProvider>(context, listen: false) != null;
    print('Debug: ProfileProvider is available in AuthWrapper: $profileProviderAvailable');

    return AuthCheck(
      builder: (context, userID) {
        return const HomePage();  // Adjust this part based on your navigation flow
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
  void initState() {
    super.initState();
    _initializeProfile();
  }

  Future<void> _initializeProfile() async {
    // Debug log to check if ProfileProvider is available during profile initialization
    final profileProviderExists = Provider.of<ProfileProvider>(context, listen: false) != null;
    _logger.i('Debug: ProfileProvider is available in _initializeProfile: $profileProviderExists');

    if (profileProviderExists) {
      final profileProvider = context.read<ProfileProvider>();
      final mockAuth = context.read<MockAuthModel>();

      // Load profile with a delay to ensure the provider is ready
      await Future.delayed(Duration.zero);
      profileProvider.setMockProfile(mockAuth.uid);
      _logger.i('Profile set for mock user: ${mockAuth.uid}');
    } else {
      _logger.e('ProfileProvider is not available in _initializeProfile');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Debug log to check if MockAuthModel is available
    final mockAuthExists = Provider.of<MockAuthModel>(context, listen: false) != null;
    _logger.i('Debug: MockAuthModel is available in AuthCheck build: $mockAuthExists');

    final mockAuth = context.watch<MockAuthModel>();
    _logger.i('AuthCheck: user is $mockAuth');

    return widget.builder(context, mockAuth.uid);
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeController>();

    // Debug log to check if ProfileProvider is available in HomePage
    final profileProviderAvailable = Provider.of<ProfileProvider>(context, listen: false) != null;
    print('Debug: ProfileProvider is available in HomePage: $profileProviderAvailable');

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/taps_home',
            arguments: 'some_user_id',  // Pass arguments where required
          );  // Ensure context here has access to the providers
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
                    height: 100),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
