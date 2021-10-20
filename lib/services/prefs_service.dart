import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  SharedPreferences? _preferences;

  PrefsService() {
    SharedPreferences.getInstance().then((value) {
      _preferences = value;
    });
  }

  Future<T?> read<T>(String key) async {
    _preferences ??= await SharedPreferences.getInstance();
    return _preferences!.get(key) as T;
  }

  Future<bool> save(String key, dynamic value) async {
    _preferences ??= await SharedPreferences.getInstance();

    if (value is String) {
      return _preferences!.setString(key, value);
    }

    if (value is bool) {
      return _preferences!.setBool(key, value);
    }

    if (value is int) {
      return _preferences!.setInt(key, value);
    }

    if (value is double) {
      return _preferences!.setDouble(key, value);
    }

    throw Exception("Invalid type");
  }
}
