import 'package:flutter/material.dart';
import 'package:fingerfy/Views/pod.dart';
import 'package:fingerfy/Views/taps_home.dart';
import 'package:fingerfy/Views/profilo.dart';
import 'package:fingerfy/Views/scrolling.dart';
import 'package:fingerfy/Views/challenge.dart';
import 'package:fingerfy/main.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments as String?;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => const HomePage());
      case '/taps_home':
        return MaterialPageRoute(builder: (context) => TapsHomePage(userID: args ?? 'default_user_id'));  // Provide default if args are null
      case '/scrolling':
        return MaterialPageRoute(builder: (context) => ScrollingPage(userID: args ?? 'default_user_id'));  // Provide default
      case '/pod':
        return MaterialPageRoute(builder: (context) => const PodPage());
      case '/profilo':
        return MaterialPageRoute(builder: (context) => ProfilePage(userID: args ?? 'default_user_id'));  // Provide default if args are null
      case '/challenge':
        return MaterialPageRoute(builder: (context) => ChallengePage(userID: args ?? 'default_user_id'));  // Provide default if args are null
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Error'),
          ),
          body: const Center(
            child: Text('ERROR: Route not found'),
          ),
        );
      },
    );
  }
}
