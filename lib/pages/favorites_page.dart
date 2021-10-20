import 'package:flutter/material.dart';

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
    return CustomScrollView(slivers: [
      SliverAppBar(
        flexibleSpace: FlexibleSpaceBar(
          title: Text(
            "Favorites",
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
          collapseMode: CollapseMode.pin,
          titlePadding: const EdgeInsets.only(left: 20, bottom: 12),
          background: Container(
            margin: const EdgeInsets.only(left: 180, bottom: 80),
            child: Icon(Icons.favorite_outline,
                size: 210,
                color: Theme.of(context)
                    .appBarTheme
                    .titleTextStyle!
                    .color!
                    .withOpacity(.1)),
          ),
        ),
        expandedHeight: 230,
        pinned: true,
        elevation: 0,
      ),
    ]);
  }
}
