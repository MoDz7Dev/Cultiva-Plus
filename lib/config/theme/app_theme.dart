import 'package:flutter/material.dart';

const Color _customColor = Color(0xFF49149F);
const Color kBackgroundColor = Color(0xFFebf2f2);

const List<Color> _colorTheme = [
  _customColor,
  Colors.blue,
  Colors.teal
];

class AppTheme {
  ThemeData theme() {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: _colorTheme[2] 
    );
  }
}