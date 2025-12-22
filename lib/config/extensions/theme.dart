import 'package:flutter/material.dart';

extension ThemeX on BuildContext {
  ThemeData get theme => Theme.of(this); // ThemeData كامل
  TextTheme get text => theme.textTheme; // TextTheme
  ColorScheme get colors => theme.colorScheme; // ColorScheme
}
