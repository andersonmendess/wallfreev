import 'package:flutter/material.dart';
import 'package:wallfreev/data/wallpaper_data.dart';
import 'package:wallfreev/pages/category_page.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  bool showBottomBar = true;

  Map<String, int> cat = {};

  @override
  void initState() {
    super.initState();

    for (final element in wallpapers) {
      if (cat.containsKey(element['collections'])) {
        cat[element['collections']] = (cat[element['collections']]! + 1);
      } else {
        cat.addAll({element['collections']: 1});
      }
    }
    print(cat);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _buildCategories() {
      List<Widget> itens = [];

      cat.forEach((key, value) {
        itens.add(ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => CategoryPage(
                  name: key,
                ),
              ),
            );
          },
          title: Text(
            key,
            style: TextStyle(
                fontSize: 22,
                color: Theme.of(context).appBarTheme.titleTextStyle!.color),
          ),
          subtitle: Text(
            "$value wallpapers",
            style: TextStyle(
                fontSize: 14,
                color: Theme.of(context)
                    .appBarTheme
                    .titleTextStyle!
                    .color!
                    .withOpacity(.7)),
          ),
        ));
      });

      return itens;
    }

    return CustomScrollView(slivers: [
      SliverAppBar(
        flexibleSpace: FlexibleSpaceBar(
          title: Text(
            "Categories",
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
          collapseMode: CollapseMode.pin,
          titlePadding: const EdgeInsets.only(left: 20, bottom: 12),
          background: Container(
            margin: const EdgeInsets.only(left: 180, bottom: 80),
            child: Icon(Icons.category_outlined,
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
      SliverPadding(
        padding: const EdgeInsets.all(12.0),
        sliver: SliverList(
          delegate: SliverChildListDelegate.fixed([
            ..._buildCategories(),
          ]),
        ),
      ),
    ]);
  }
}
