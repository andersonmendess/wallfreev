import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:wallfreev/controllers/app_controller.dart';
import 'package:wallfreev/utils/theme_utils.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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

  Widget _buildColorButton(String color, Function cb) {
    return InkWell(
      onTap: () {
        cb(color);
        Navigator.of(context).pop();
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        width: 40,
        height: 40,
        margin: const EdgeInsets.only(right: 10, bottom: 10),
        decoration: BoxDecoration(
          color: Color(int.parse(color)),
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  onChangeColor(String color) {
    context.read<AppController>().changePrimaryColor(color);
  }

  void _showDialog() {
    final targetColor = context.read<AppController>().primaryColor;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text("Select the color",
              style: Theme.of(context).appBarTheme.titleTextStyle),
          content: Container(
            height: 80,
            child: Wrap(
              children: [
                _buildColorButton("0xFF5E9CAB", onChangeColor),
                _buildColorButton("0xFFE3C139", onChangeColor),
                _buildColorButton("0xFFA0336D", onChangeColor),
                _buildColorButton("0xFFF4C3C6", onChangeColor),
                _buildColorButton("0xFFADC965", onChangeColor),
                _buildColorButton("0xFFC55152", onChangeColor),
                _buildColorButton("0xFFFE6601", onChangeColor),
                _buildColorButton("0xFF8E80C0", onChangeColor),
                _buildColorButton("0xFFB4F8C8", onChangeColor),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                "OK",
                style: TextStyle(
                    color: Theme.of(context).appBarTheme.titleTextStyle!.color),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final targetColor = context.watch<AppController>().primaryColor;
    final useDarkTheme = context.watch<AppController>().useDarkTheme;
    final maxLoadedWallpapers =
        context.watch<AppController>().maxLoadedWallpapers;

    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              "Settings",
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
            collapseMode: CollapseMode.pin,
            titlePadding: const EdgeInsets.only(left: 20, bottom: 12),
            background: Container(
              margin: const EdgeInsets.only(left: 180, bottom: 80),
              child: Icon(Icons.settings_outlined,
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
              SwitchListTile(
                onChanged: (bool value) {
                  context.read<AppController>().changeTheme(value);
                },
                value: useDarkTheme,
                title: Text(
                  "Dark theme",
                  style: TextStyle(
                      fontSize: 22,
                      color:
                          Theme.of(context).appBarTheme.titleTextStyle!.color),
                ),
                subtitle: Text(
                  "Change app theme",
                  style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context)
                          .appBarTheme
                          .titleTextStyle!
                          .color!
                          .withOpacity(.7)),
                ),
              ),
              ListTile(
                title: Text(
                  "Colors",
                  style: TextStyle(
                      fontSize: 22,
                      color:
                          Theme.of(context).appBarTheme.titleTextStyle!.color!),
                ),
                trailing: Container(
                  width: 30,
                  height: 30,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: targetColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onTap: () {
                  _showDialog();
                },
                subtitle: Text(
                  "Change app color",
                  style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context)
                          .appBarTheme
                          .titleTextStyle!
                          .color!
                          .withOpacity(.7)),
                ),
              ),
              ListTile(
              ListTile(
                title: Text(
                  "Loaded wallpapers limit",
                  style: TextStyle(
                      fontSize: 22,
                      color:
                          Theme.of(context).appBarTheme.titleTextStyle!.color),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "The maximum amount of loaded wallpapers in the app.\n"
                      "Lowering this may make the app feel more responsive",
                      style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context)
                              .appBarTheme
                              .titleTextStyle!
                              .color!
                              .withOpacity(.7)),
                    ),
                    Slider(
                      value: maxLoadedWallpapers.toDouble(),
                      min: 3 * 9,
                      max: 23 * 9,
                      divisions: 10,
                      label: maxLoadedWallpapers.toString(),
                      onChanged: (v) => context
                          .read<AppController>()
                          .changeMaxLoadedWallpapers(v.toInt()),
                    )
                  ],
                ),
              ),
                title: Text(
                  "Version",
                  style: TextStyle(
                      fontSize: 22,
                      color:
                          Theme.of(context).appBarTheme.titleTextStyle!.color),
                ),
                subtitle: Text(
                  "1.0.0 (private beta)",
                  style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context)
                          .appBarTheme
                          .titleTextStyle!
                          .color!
                          .withOpacity(.7)),
                ),
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}
