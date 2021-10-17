import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/src/provider.dart';
import 'package:wallfreev/controllers/app_controller.dart';
import 'package:wallfreev/services/cache_service.dart';
import 'package:wallfreev/services/wallpaper_service.dart';
import 'package:wallfreev/utils/theme_utils.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';
import 'package:android_path_provider/android_path_provider.dart';

class WallpaperViewPage extends StatefulWidget {
  final Map image;
  const WallpaperViewPage({Key? key, required this.image}) : super(key: key);

  @override
  _WallpaperViewPageState createState() => _WallpaperViewPageState();
}

class _WallpaperViewPageState extends State<WallpaperViewPage> {
  bool loading = false;
  File? file;

  Future<void> downloadFile() async {
    file = await DefaultCacheManager().getSingleFile(widget.image['url']);
  }

  void saveGallery() async {
    if (file == null && !file!.existsSync()) return;

    final appDocDir = await AndroidPathProvider.downloadsPath;

    file!.copy(appDocDir + "/" + file!.basename);
  }

  void _showOptions(BuildContext context) {
    downloadFile();
    Color targetColor = context.read<AppController>().primaryColor;

    showModalBottomSheet(
        context: context,
        backgroundColor: ThemeUtils.buildColorDarker(targetColor),
        builder: (BuildContext bc) {
          return Container(
            padding: const EdgeInsets.all(12).copyWith(bottom: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.all(8.0).copyWith(bottom: 3, top: 14),
                  child: Text(
                    widget.image['name'],
                    style: TextStyle(fontSize: 33),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.all(8.0).copyWith(top: 3, bottom: 14),
                  child: Text(
                    widget.image['author'],
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Divider(
                  color:
                      ThemeUtils.buildColorLighter(targetColor).withOpacity(.5),
                ),
                ListTile(
                  leading: const Icon(Icons.select_all),
                  title: const Text('Set home & lock'),
                  onTap: () {
                    if (file == null) return;
                    WallpaperService.updateDeviceWallpaper(file!,
                        type: WallpaperManagerFlutter.BOTH_SCREENS);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                    leading: const Icon(Icons.smartphone_outlined),
                    title: const Text('Set as home only'),
                    onTap: () {
                      if (file == null) return;
                      WallpaperService.updateDeviceWallpaper(file!,
                          type: WallpaperManagerFlutter.HOME_SCREEN);
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.lock_outline),
                  title: const Text('Set as lock only'),
                  onTap: () {
                    if (file == null) return;
                    WallpaperService.updateDeviceWallpaper(file!,
                        type: WallpaperManagerFlutter.LOCK_SCREEN);
                    Navigator.of(context).pop();
                  },
                ),
                Divider(
                  color:
                      ThemeUtils.buildColorLighter(targetColor).withOpacity(.5),
                ),
                ListTile(
                  leading: Icon(Icons.copy),
                  title: Text('Copy url'),
                  onTap: () => {},
                ),
                ListTile(
                  leading: Icon(Icons.download),
                  title: Text('Download to gallery'),
                  onTap: () {
                    saveGallery();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Color targetColor = context.read<AppController>().primaryColor;

    return Scaffold(
      backgroundColor: ThemeUtils.buildColorDarker(targetColor),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.download),
        onPressed: () {
          //setWallpaper(widget.image['url']);
          _showOptions(
            context,
          );
        },
        backgroundColor: ThemeUtils.buildColorLighter(targetColor),
      ),
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 120),
            child: Center(
              child: Text(
                "Oh dude, wait...",
                style: TextStyle(
                  fontSize: 25,
                  color: ThemeUtils.buildColorLighter(targetColor),
                ),
              ),
            ),
          ),
          SizedBox.expand(
            child: Image.network(
              widget.image['url'],
              loadingBuilder: (_, el, chunk) {
                if (chunk == null) return el;
                return Center(
                  child: CircularProgressIndicator(
                    color: ThemeUtils.buildColorLighter(targetColor),
                    value: (chunk.cumulativeBytesLoaded /
                            (chunk.expectedTotalBytes as int)) *
                        1.0,
                  ),
                );
                return Text(chunk.cumulativeBytesLoaded.toString());
              },
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
            ),
          ),
        ],
      ),
    );
  }
}
