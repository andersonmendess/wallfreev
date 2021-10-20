import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:wallfreev/components/image_component.dart';
import 'package:wallfreev/controllers/app_controller.dart';
import 'package:wallfreev/data/wallpaper_data.dart';
import 'package:wallfreev/pages/categories_page.dart';
import 'package:wallfreev/pages/favorites_page.dart';
import 'package:wallfreev/pages/settings_page.dart';
import 'package:wallfreev/pages/wallpaper_view_page.dart';
import 'package:wallfreev/utils/theme_utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showBottomBar = true;
  Color targetColor = Colors.yellow;
  int indexPage = 0;

  final pages = const [
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
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: indexPage,
        onTap: (index) {
          setState(() {
            indexPage = index;
          });
        },
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.landscape_outlined), label: "Wallpapers"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline_outlined), label: "Favorites"),
          BottomNavigationBarItem(
              icon: Icon(Icons.category_outlined), label: "Categories")
        ],
      ),
      body: IndexedStack(
        children: pages,
        index: indexPage,
      ),
    );
  }
}

class HomePageContent extends StatelessWidget {
  const HomePageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cacheService = context.watch<AppController>().cacheService;

    return CustomScrollView(
      // Keep 3 pages of wallpapers loaded
      cacheExtent: MediaQuery.of(context).size.height * 3,
      slivers: [
        SliverAppBar(
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SettingsPage()),
                );
              },
              icon: Icon(Icons.settings_outlined),
            )
          ],
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              "Wallpapers",
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
            collapseMode: CollapseMode.pin,
            titlePadding: const EdgeInsets.only(left: 20, bottom: 12),
            background: Container(
              margin: const EdgeInsets.only(left: 180, bottom: 80),
              child: Icon(
                Icons.landscape_outlined,
                size: 210,
                color: Theme.of(context)
                    .appBarTheme
                    .titleTextStyle!
                    .color!
                    .withOpacity(.1),
              ),
            ),
          ),
          expandedHeight: 230,
          pinned: true,
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
            maxCrossAxisExtent: 150.0,
          ),
        )
      ],
    );
  }
}
