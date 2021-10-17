import 'dart:io';

import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';

abstract class WallpaperService {
  static Future<void> updateDeviceWallpaper(File file,
      {int type = WallpaperManagerFlutter.BOTH_SCREENS}) async {
// final cachedimage = await DefaultCacheManager()
//         .getSingleFile("https://i.imgur.com/VBFs4sQ.jpg"); //image file
//     print("CACHED");

    int location = WallpaperManagerFlutter.BOTH_SCREENS; //Choose screen type

    // final cachedimage = await DefaultCacheManager()
    //     .getFileFromCache("https://i.imgur.com/NczobN4.png");

    // print(cachedimage!.file.path);

    try {
      await WallpaperManagerFlutter().setwallpaperfromFile(file, location);
    } catch (err) {
      rethrow;
    }
  }
}
