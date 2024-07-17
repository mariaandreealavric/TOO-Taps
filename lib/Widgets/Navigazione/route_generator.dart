import 'package:fingerfy/Views/classifica_page.dart';
import 'package:fingerfy/Views/image_list_page.dart';
import 'package:fingerfy/Views/profilo.dart';
import 'package:fingerfy/Views/scroll_meter.dart';
import 'package:fingerfy/main.dart';
import 'package:flutter/material.dart';


class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments as String?;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => const HomePage());
      case '/imageList':
        if (args != null) {
          return MaterialPageRoute(builder: (context) => ImageListPage(userID: args));
        }
        return _errorRoute();
      case '/scrollMeter':
        return MaterialPageRoute(builder: (context) => const ScrollMeterPage(userID: '',));
      case '/classifica':
        return MaterialPageRoute(builder: (context) => const ClassificaPage(userID: '',));
      case '/Profilo':
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
