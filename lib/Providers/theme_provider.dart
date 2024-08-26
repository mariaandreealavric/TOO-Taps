import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  late BoxDecoration _boxDecoration;
  late Color _cardColor;
  late Color _shadowColor;
  late ThemeData _currentTheme;
  late Color _listTileColor;

  ThemeProvider() {
    _boxDecoration = const BoxDecoration(
      color: Colors.black,  // Aggiunta dello sfondo nero
    );
    _cardColor = Colors.transparent;
    _shadowColor = Colors.blue.withOpacity(0.4);
    _currentTheme = ThemeData.light();
    _listTileColor = Colors.blue;
  }

  ThemeData get currentTheme => _currentTheme;
  Color get cardColor => _cardColor;
  Color get shadowColor => _shadowColor;
  BoxDecoration get boxDecoration => _boxDecoration;
  Color get listTileColor => _listTileColor;

  void switchTheme() {
    if (_currentTheme == ThemeData.light()) {
      _currentTheme = ThemeData.dark();
      _boxDecoration = const BoxDecoration(
        color: Colors.black,  // Sfondo nero per il tema scuro
        gradient: LinearGradient(
          colors: [Colors.black, Colors.red],  // Sfondo nero con un gradiente
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      );
      _cardColor = Colors.green;
    } else {
      _currentTheme = ThemeData.light();
      _boxDecoration = const BoxDecoration(
        color: Colors.black,  // Sfondo nero per il tema chiaro
        gradient: LinearGradient(
          colors: [Colors.black, Colors.blue],  // Sfondo nero con un gradiente
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      );
      _cardColor = Colors.blue;
    }
    _shadowColor = _cardColor.withOpacity(0.4);
    _listTileColor = _cardColor;
    notifyListeners();
  }
}
