import 'package:flutter/material.dart';

extension NavigatorExtension on BuildContext {
  Future<T?> pushPage<T>(Widget page) {
    return Navigator.of(this).push<T>(MaterialPageRoute(builder: (_) => page));
  }

  Future<T?> pushReplacementPage<T, TO>(Widget page) {
    return Navigator.of(
      this,
    ).pushReplacement<T, TO>(MaterialPageRoute(builder: (_) => page));
  }

  void popPage<T extends Object?>([T? result]) {
    Navigator.of(this).pop(result);
  }

  void popUntilFirst() {
    Navigator.of(this).popUntil((route) => route.isFirst);
  }
}
