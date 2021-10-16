import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';

class WallpaperViewPage extends StatefulWidget {
  const WallpaperViewPage({Key? key}) : super(key: key);

  @override
  _WallpaperViewPageState createState() => _WallpaperViewPageState();
}

class _WallpaperViewPageState extends State<WallpaperViewPage> {
  bool loading = false;

  Future<void> setWallpaper() async {
    setState(() {
      loading = true;
    });
    print("CALLED SETWALLPAPER");
    final cachedimage = await DefaultCacheManager()
        .getSingleFile("https://i.imgur.com/VBFs4sQ.jpg"); //image file
    print("CACHED");

    int location = WallpaperManagerFlutter.BOTH_SCREENS; //Choose screen type

    // final cachedimage = await DefaultCacheManager()
    //     .getFileFromCache("https://i.imgur.com/NczobN4.png");

    // print(cachedimage!.file.path);

    WallpaperManagerFlutter().setwallpaperfromFile(
        cachedimage, location); // Wrap with try catch for error management.
    print("APPLIED SETWALLPAPER");
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.image),
        onPressed: setWallpaper,
      ),
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          SizedBox.expand(
            child: Image.network(
              "https://i.imgur.com/VBFs4sQ.jpg",
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
            ),
          ),
          loading
              ? Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  width: 300,
                  height: 100,
                  child: const Center(
                      child: Text(
                    "Aplicando Wallpaper",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  )),
                )
              : Container()
        ],
      ),
    );
  }
}
