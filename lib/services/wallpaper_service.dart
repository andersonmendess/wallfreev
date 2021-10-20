import 'dart:io';

import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';

abstract class WallpaperService {
  static Future<void> updateDeviceWallpaper(File file,
      {int type = WallpaperManagerFlutter.BOTH_SCREENS}) async {
    try {
      await WallpaperManagerFlutter().setwallpaperfromFile(file, type);
    } catch (err) {
      rethrow;
    }
  }
}
