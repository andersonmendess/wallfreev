import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wallfreev/services/cache_service.dart';

class AppController with ChangeNotifier {
  CacheService cacheService = CacheService();

  Color primaryColor = Colors.yellow;
  ThemeMode themeMode = ThemeMode.dark;

  void changePrimaryColor(Color newPrimary) {
    primaryColor = newPrimary;
    notifyListeners();
  }
}
