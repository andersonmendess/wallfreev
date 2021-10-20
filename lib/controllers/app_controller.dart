import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wallfreev/services/cache_service.dart';
import 'package:wallfreev/services/prefs_service.dart';

class AppController with ChangeNotifier {
  CacheService cacheService = CacheService();
  PrefsService sharedPref = PrefsService();

  Color primaryColor = Colors.yellow;
  bool useDarkTheme = true;

  // ignore: non_constant_identifier_names
  final APP_THEME_COLOR_PREF = "app_theme_color";
  // ignore: non_constant_identifier_names
  final APP_DARK_THEME_PREF = "app_dark_theme";

  AppController() {
    sharedPref.read<String>(APP_THEME_COLOR_PREF).then((value) {
      if (value != null) changePrimaryColor(value, persist: false);
    });
    sharedPref.read<bool>(APP_DARK_THEME_PREF).then((value) {
      if (value != null) changeTheme(value, persist: false);
    });
  }

  void changePrimaryColor(String newPrimary, {bool persist = true}) {
    primaryColor = Color(int.parse(newPrimary));
    notifyListeners();

    if (persist) {
      sharedPref.save(APP_THEME_COLOR_PREF, newPrimary);
    }
  }

  void changeTheme(bool darkTheme, {bool persist = true}) {
    useDarkTheme = darkTheme;
    notifyListeners();

    if (persist) {
      sharedPref.save(APP_DARK_THEME_PREF, darkTheme);
    }
  }
}
