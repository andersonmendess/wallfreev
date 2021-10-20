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

class CategoryPage extends StatefulWidget {
  final String name;
  const CategoryPage({Key? key, required this.name}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List categoryWalls = [];

  @override
  void initState() {
    super.initState();
    categoryWalls = wallpapers
        .where((element) => element['collections'] == widget.name)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final cacheService = context.read<AppController>().cacheService;

    return Scaffold(
      body: CustomScrollView(
        // Keep 3 pages of wallpapers loaded
        cacheExtent: MediaQuery.of(context).size.height * 3,
        slivers: [
          SliverAppBar(
            leading: Container(),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.name,
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
                ...categoryWalls
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
      ),
    );
  }
}
