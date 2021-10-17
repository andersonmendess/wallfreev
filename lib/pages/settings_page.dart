import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/src/provider.dart';
import 'package:wallfreev/controllers/app_controller.dart';
import 'package:wallfreev/utils/debouncer.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:wallfreev/utils/theme_utils.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';

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

  Widget _buildColorButton(Color color, Function cb) {
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
          color: color,
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  onChangeColor(Color color) {
    context.read<AppController>().changePrimaryColor(color);
  }

  void _showDialog() {
    final targetColor = context.read<AppController>().primaryColor;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ThemeUtils.buildColorDarker(targetColor),
          title: Text("Select the color",
              style: TextStyle(
                  fontSize: 28,
                  color: ThemeUtils.buildColorLighter(targetColor),
                  fontWeight: FontWeight.normal)),
          content: Container(
            height: 80,
            child: Wrap(
              children: [
                _buildColorButton(const Color(0xFF5E9CAB), onChangeColor),
                _buildColorButton(const Color(0xFFE3C139), onChangeColor),
                _buildColorButton(const Color(0xFFA0336D), onChangeColor),
                _buildColorButton(const Color(0xFFF4C3C6), onChangeColor),
                _buildColorButton(const Color(0xFFADC965), onChangeColor),
                _buildColorButton(const Color(0xFFC55152), onChangeColor),
                _buildColorButton(const Color(0xFFFE6601), onChangeColor),
                _buildColorButton(const Color(0xFF8E80C0), onChangeColor),
                _buildColorButton(const Color(0xFFB4F8C8), onChangeColor),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                "OK",
                style: TextStyle(color: targetColor),
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

    return Scaffold(
      backgroundColor: ThemeUtils.buildColorDarker(targetColor),
      body: CustomScrollView(slivers: [
        SliverAppBar(
          shadowColor: targetColor,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              "Settings",
              style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w400,
                  color: ThemeUtils.buildColorLighter(targetColor)),
            ),
            collapseMode: CollapseMode.pin,
            titlePadding: const EdgeInsets.only(left: 20, bottom: 12),
            background: Container(
              margin: const EdgeInsets.only(left: 180, bottom: 80),
              child: Icon(Icons.settings,
                  size: 210,
                  color: ThemeUtils.buildColorLighter(targetColor)
                      .withOpacity(.1)),
            ),
          ),
          expandedHeight: 230,
          pinned: true,
          backgroundColor: ThemeUtils.buildColorDarker(targetColor),
          elevation: 0,
        ),
        SliverPadding(
          padding: const EdgeInsets.all(12.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate.fixed([
              SwitchListTile(
                onChanged: (bool value) {},
                value: true,
                title: Text(
                  "Dark theme",
                  style: TextStyle(
                      fontSize: 22,
                      color: ThemeUtils.buildColorLighter(targetColor)),
                ),
                subtitle: Text(
                  "Change app theme",
                  style: TextStyle(
                      fontSize: 14,
                      color: ThemeUtils.buildColorLighter(targetColor)
                          .withOpacity(.7)),
                ),
              ),
              ListTile(
                title: Text(
                  "Colors",
                  style: TextStyle(
                      fontSize: 22,
                      color: ThemeUtils.buildColorLighter(targetColor)),
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
                      color: ThemeUtils.buildColorLighter(targetColor)
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
