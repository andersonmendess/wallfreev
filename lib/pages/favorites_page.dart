import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/src/provider.dart';
import 'package:wallfreev/controllers/app_controller.dart';
import 'package:wallfreev/utils/debouncer.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  bool showBottomBar = true;

  final images = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color targetColor = context.watch<AppController>().primaryColor;

    final colorWhited =
        Color.alphaBlend(Colors.white.withAlpha(190), targetColor);

    final blacked = Color.alphaBlend(Colors.black.withAlpha(210), targetColor);

    return CustomScrollView(slivers: [
      SliverAppBar(
        shadowColor: targetColor,
        flexibleSpace: FlexibleSpaceBar(
          title: Text(
            "Favorites",
            style: TextStyle(
                fontSize: 27, fontWeight: FontWeight.w400, color: colorWhited),
          ),
          collapseMode: CollapseMode.pin,
          titlePadding: const EdgeInsets.only(left: 20, bottom: 12),
          background: Container(
            margin: const EdgeInsets.only(left: 180, bottom: 80),
            child: Icon(Icons.favorite,
                size: 210, color: colorWhited.withOpacity(.1)),
          ),
        ),
        expandedHeight: 230,
        pinned: true,
        backgroundColor: blacked,
        elevation: 0,
      ),
    ]);
  }
}
