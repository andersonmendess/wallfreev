import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:wallfreev/pages/categories_page.dart';
import 'package:wallfreev/pages/favorites_page.dart';
import 'package:wallfreev/pages/wallpaper_view_page.dart';
import 'package:wallfreev/utils/debouncer.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
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
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    targetColor = Colors.amber;

    final colorWhited =
        Color.alphaBlend(Colors.white.withAlpha(190), targetColor);

    final blacked = Color.alphaBlend(Colors.black.withAlpha(210), targetColor);

    return Scaffold(
      backgroundColor: blacked,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: blacked,
        currentIndex: indexPage,
        onTap: (index) {
          setState(() {
            indexPage = index;
          });
        },
        unselectedItemColor: colorWhited.withOpacity(.5),
        elevation: 0,
        selectedItemColor: colorWhited,
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
  HomePageContent({Key? key}) : super(key: key);

  final images = [
    "https://i.imgur.com/bR1LQ7c.png",
    "https://i.imgur.com/CdONVgx.png",
    "https://i.imgur.com/DfKGQ4C.png",
    "https://i.imgur.com/gko7qrX.png",
    "https://i.imgur.com/qvdjZ0L.png",
    "https://i.imgur.com/A5MGTpV.png",
    "https://i.imgur.com/Z94xuS1.png",
    "https://i.imgur.com/QVOLFAj.png",
    "https://i.imgur.com/qq76wc3.png",
    "https://i.imgur.com/F8AuP4D.png",
    "https://i.imgur.com/vtZ8htd.png",
    "https://i.imgur.com/FKFtoVl.png",
    "https://i.imgur.com/BJj5hhN.png",
    "https://i.imgur.com/c95Vjlu.png",
    "https://i.imgur.com/44Tp4sQ.png",
    "https://i.imgur.com/TA19UIe.png",
    "https://i.imgur.com/b3EyVjq.png",
    "https://i.imgur.com/mxqDe1R.png",
    "https://i.imgur.com/7P3Iyjn.png",
    "https://i.imgur.com/P973Z99.png",
    "https://i.imgur.com/3eS4TGQ.png",
    "https://i.imgur.com/GHRQzRn.png",
    "https://i.imgur.com/dtjoNAg.png",
    "https://i.imgur.com/kslC2Qt.png",
    "https://i.imgur.com/mwkSERB.png",
    "https://i.imgur.com/KpsmUBk.png",
    "https://i.imgur.com/Jnhvw4u.png",
    "https://i.imgur.com/8ok4WNX.png",
    "https://i.imgur.com/1w6givO.png",
    "https://i.imgur.com/vIhaaVB.png",
    "https://i.imgur.com/kePZOQ0.png",
    "https://i.imgur.com/WhQKr9g.png",
    "https://i.imgur.com/wzptVFG.png",
    "https://i.imgur.com/qycD5NA.png",
    "https://i.imgur.com/lBWCcs8.png",
    "https://i.imgur.com/vWbWT8h.png",
    "https://i.imgur.com/TH3L4Z7.png",
    "https://i.imgur.com/kYmh8pV.png",
    "https://i.imgur.com/ssx0Z9X.png",
    "https://i.imgur.com/7e693VX.png",
    "https://i.imgur.com/ghwJutD.png",
    "https://i.imgur.com/22Q4chX.png",
    "https://i.imgur.com/5TiytXU.png",
    "https://i.imgur.com/dm21ekb.png",
    "https://i.imgur.com/S5K91Hl.png",
    "https://i.imgur.com/OSE2CXn.png",
    "https://i.imgur.com/Qrjpneu.png",
    "https://i.imgur.com/mmZto8A.png",
    "https://i.imgur.com/pvkV81w.png",
    "https://i.imgur.com/MEEKqDA.png",
    "https://i.imgur.com/Zi622LM.png",
    "https://i.imgur.com/6F2evCa.png",
    "https://i.imgur.com/eH6GWqZ.png",
    "https://i.imgur.com/5ufwiSk.png",
    "https://i.imgur.com/pNnlB6Y.png",
    "https://i.imgur.com/GqyOD4U.png",
    "https://i.imgur.com/exMx2DP.png",
    "https://i.imgur.com/7As8nkZ.png",
    "https://i.imgur.com/u1FVmzW.png",
    "https://i.imgur.com/6QlZO6l.png",
    "https://i.imgur.com/sS0bFM9.png",
    "https://i.imgur.com/bHkYYIt.png",
    "https://i.imgur.com/gPDhWuh.png",
    "https://i.imgur.com/INXru4o.png",
    "https://i.imgur.com/vsjcoCS.png",
    "https://i.imgur.com/ldE3mlS.png",
    "https://i.imgur.com/eObskvb.png",
    "https://i.imgur.com/YzfB6ZX.png",
    "https://i.imgur.com/4NaPq52.png",
    "https://i.imgur.com/JDHrh2p.png",
    "https://i.imgur.com/rHBJ27p.png",
    "https://i.imgur.com/vpDNZUw.png",
    "https://i.imgur.com/U82R160.png",
    "https://i.imgur.com/cX9hAaU.png",
    "https://i.imgur.com/sA7cUgv.png",
    "https://i.imgur.com/ig3kphZ.png",
    "https://i.imgur.com/SQzx3u6.png",
    "https://i.imgur.com/SC4Hltu.png",
    "https://i.imgur.com/DaQCHUj.png",
    "https://i.imgur.com/qzou1le.png",
    "https://i.imgur.com/fapFMtb.png",
    "https://i.imgur.com/oG3CtbT.png",
    "https://i.imgur.com/Sp2bYw3.png",
    "https://i.imgur.com/YbSEbz5.png",
    "https://i.imgur.com/1Y30i4m.png",
    "https://i.imgur.com/fGH0tmf.png",
    "https://i.imgur.com/i3oSiKi.png",
    "https://i.imgur.com/6l3y2Qy.png",
    "https://i.imgur.com/qmEc4ec.png",
    "https://i.imgur.com/R0nREKi.png",
    "https://i.imgur.com/d9ZmUge.png",
    "https://i.imgur.com/1kDT071.png",
    "https://i.imgur.com/Huwpt6e.png",
  ];

  @override
  Widget build(BuildContext context) {
    Color targetColor = Colors.amber;

    final colorWhited =
        Color.alphaBlend(Colors.white.withAlpha(190), targetColor);

    final blacked = Color.alphaBlend(Colors.black.withAlpha(210), targetColor);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
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
                ...images
                    .map((image) => InkWell(
                          onTap: () async {
                            //setWallpaper(image);

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => const WallpaperViewPage()),
                            );
                          },
                          child: SizedBox.expand(
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(image),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
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
