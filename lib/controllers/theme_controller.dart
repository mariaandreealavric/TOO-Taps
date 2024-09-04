// controllers/theme_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  var _boxDecoration = const BoxDecoration(
    color: Colors.black,
  ).obs;
  var _shadowColor = Colors.blue.withOpacity(0.4).obs;
  var _currentTheme = ThemeData.light().obs;
  var _listTileColor = Colors.blue.obs;

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
