import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:wallfreev/components/image_component.dart';
import 'package:wallfreev/controllers/app_controller.dart';
import 'package:wallfreev/data/wallpaper_data.dart';
import 'package:wallfreev/pages/categories_page.dart';
import 'package:wallfreev/pages/favorites_page.dart';
import 'package:wallfreev/pages/settings_page.dart';
import 'package:wallfreev/pages/wallpaper_view_page.dart';
import 'package:wallfreev/utils/debouncer.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:wallfreev/utils/theme_utils.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showBottomBar = true;
  Color targetColor = Colors.yellow;
  int indexPage = 0;

  final pages = [
    HomePageContent(),
    FavoritesPage(),
    CategoriesPage(),
  ];

  @override
  void initState() {
    super.initState();

    () async {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
    }();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    targetColor = context.watch<AppController>().primaryColor;

    return Scaffold(
      backgroundColor: ThemeUtils.buildColorDarker(targetColor),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: ThemeUtils.buildColorDarker(targetColor),
        currentIndex: indexPage,
        onTap: (index) {
          context.read<AppController>().changePrimaryColor(Colors.green);
          setState(() {
            indexPage = index;
          });
        },
        unselectedItemColor:
            ThemeUtils.buildColorLighter(targetColor).withOpacity(.5),
        elevation: 0,
        selectedItemColor: ThemeUtils.buildColorLighter(targetColor),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: "Favorites"),
          BottomNavigationBarItem(
              icon: Icon(Icons.category), label: "Categories")
        ],
      ),
      body: pages[indexPage],
    );
  }
}

class HomePageContent extends StatelessWidget {
  const HomePageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color targetColor = context.watch<AppController>().primaryColor;
    final cacheService = context.watch<AppController>().cacheService;

    final colorWhited =
        Color.alphaBlend(Colors.white.withAlpha(190), targetColor);

    final blacked = Color.alphaBlend(Colors.black.withAlpha(210), targetColor);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SettingsPage()),
                );
              },
              icon: Icon(Icons.settings, color: colorWhited),
            )
          ],
          shadowColor: targetColor,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              "Wallpapers",
              style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w400,
                  color: colorWhited),
            ),
            collapseMode: CollapseMode.pin,
            titlePadding: const EdgeInsets.only(left: 20, bottom: 12),
            background: Container(
              margin: const EdgeInsets.only(left: 180, bottom: 80),
              child: Icon(Icons.landscape_rounded,
                  size: 210, color: colorWhited.withOpacity(.1)),
            ),
          ),
          expandedHeight: 230,
          pinned: true,
          backgroundColor: blacked,
          elevation: 0,
        ),
        SliverPadding(
          padding: const EdgeInsets.all(8.0),
          sliver: SliverGrid.extent(
              childAspectRatio: 9 / 18,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              children: [
                ...wallpapers
                    .map((image) => InkWell(
                          onTap: () async {
                            //setWallpaper(image);

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => WallpaperViewPage(
                                  image: image,
                                ),
                              ),
                            );
                          },
                          child: SizedBox.expand(
                            child: ImageComponent(
                              url: image['thumbnail'],
                              cacheService: cacheService,
                            ),
                          ),
                        ))
                    .toList()
              ],
              maxCrossAxisExtent: 150.0),
        )
      ],
    );
  }
}
