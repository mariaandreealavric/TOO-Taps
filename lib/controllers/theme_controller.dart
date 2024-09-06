// controllers/theme_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  final _boxDecoration = const BoxDecoration(
    color: Colors.black,
  ).obs;
  final _shadowColor = Colors.blue.withOpacity(0.4).obs;
  final _currentTheme = ThemeData.light().obs;
  final _listTileColor = Colors.blue.obs;

  ThemeData get currentTheme => _currentTheme.value;
  Color get shadowColor => _shadowColor.value;
  BoxDecoration get boxDecoration => _boxDecoration.value;
  Color get listTileColor => _listTileColor.value;

  void switchTheme() {
    if (_currentTheme.value == ThemeData.light()) {
      _currentTheme.value = ThemeData.dark();
      _boxDecoration.value = const BoxDecoration(
        color: Colors.black,
        gradient: LinearGradient(
          colors: [Colors.black, Colors.red],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      );
      _listTileColor.value = Colors.green;
    } else {
      _currentTheme.value = ThemeData.light();
      _boxDecoration.value = const BoxDecoration(
        color: Colors.black,
        gradient: LinearGradient(
          colors: [Colors.black, Colors.blue],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      );
      _listTileColor.value = Colors.blue;
    }
    _shadowColor.value = _listTileColor.value.withOpacity(0.4);
  }
}
