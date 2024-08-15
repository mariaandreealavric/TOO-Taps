import 'package:fingerfy/Views/pod.dart';
import 'package:fingerfy/Views/taps_home.dart';
import 'package:fingerfy/Views/profilo.dart';
import 'package:fingerfy/Views/scrolling.dart';
import 'package:fingerfy/main.dart';
import 'package:flutter/material.dart';


class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments as String?;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => const HomePage());
      case '/taps_home':
        if (args != null) {
          return MaterialPageRoute(builder: (context) => TapsHomePage(userID: args));
        }
        return _errorRoute();
      case '/scrolling':
        return MaterialPageRoute(builder: (context) => const ScrollingPage(userID: '',));
      case '/pod':
        return MaterialPageRoute(builder: (context) => const PodPage());
      case '/profilo':
        if (args != null) {
          return MaterialPageRoute(builder: (context) => ProfilePage(userID: args));
        }
        return _errorRoute();
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
