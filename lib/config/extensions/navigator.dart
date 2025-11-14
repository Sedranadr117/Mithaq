import 'package:flutter/material.dart';

extension NavigatorExtension on BuildContext {
  // Push صفحة جديدة
  Future<T?> pushPage<T>(Widget page) {
    return Navigator.of(this).push<T>(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  // Push واستبدال الصفحة الحالية
  Future<T?> pushReplacementPage<T, TO>(Widget page) {
    return Navigator.of(this).pushReplacement<T, TO>(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  // Pop الصفحة الحالية
  void popPage<T extends Object?>([T? result]) {
    Navigator.of(this).pop(result);
  }

  // Pop حتى الصفحة الأولى
  void popUntilFirst() {
    Navigator.of(this).popUntil((route) => route.isFirst);
  }
}
