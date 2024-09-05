// widgets/navigazione/route_generator.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fingerfy/views/pod.dart';
import 'package:fingerfy/views/taps_home.dart';
import 'package:fingerfy/views/profilo.dart';
import 'package:fingerfy/views/scrolling.dart';
import 'package:fingerfy/views/challenge.dart';
import 'package:fingerfy/views/home_page.dart';

class RouteGenerator {
  // Lista delle pagine definite come static
  static final List<GetPage<dynamic>> getPages = [
    GetPage(
      name: '/',
      page: () => const HomePage(),
    ),
    GetPage(
      name: '/taps_home',
      page: () => const TapsHomePage(userID: 'default_user_id'),
    ),
    GetPage(
      name: '/scrolling',
      page: () => const ScrollingPage(userID: 'default_user_id'),
    ),
    GetPage(
      name: '/pod',
      page: () => const PodPage(),
    ),
    GetPage(
      name: '/profilo',
      page: () => const ProfilePage(userID: 'default_user_id'),
    ),
    GetPage(
      name: '/challenge',
      page: () => const ChallengePage(userID: 'default_user_id'),
    ),
  ];

  // Questo metodo gestisce eventuali errori di routing
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
