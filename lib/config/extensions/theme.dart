import 'package:complaint_app/config/themes/app_colors.dart';
import 'package:flutter/material.dart';

extension ThemeX on BuildContext {
  ThemeData get theme => Theme.of(this);           // ThemeData كامل
  TextTheme get text => theme.textTheme;      // TextTheme
  ColorScheme get colors => theme.colorScheme; 
}
