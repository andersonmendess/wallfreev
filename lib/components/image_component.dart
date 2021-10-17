import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/src/provider.dart';
import 'package:wallfreev/controllers/app_controller.dart';
import 'package:wallfreev/services/cache_service.dart';
import 'package:wallfreev/utils/theme_utils.dart';

class ImageComponent extends StatefulWidget {
  final String url;
  final CacheService cacheService;
  final Function(File)? onLoaded;
  const ImageComponent(
      {Key? key, required this.url, required this.cacheService, this.onLoaded})
      : super(key: key);

  @override
  _ImageComponentState createState() => _ImageComponentState();
}

class _ImageComponentState extends State<ImageComponent>
    with AutomaticKeepAliveClientMixin {
  bool isReady = false;
  CacheService? cacheService;
  late File image;

  @override
  void initState() {
    super.initState();
    widget.cacheService.download(widget.url).then((value) {
      image = value;
      setState(() {
        isReady = true;
      });

      if (widget.onLoaded != null) {
        widget.onLoaded!(value);
      }
    });
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    final targetColor = context.watch<AppController>().primaryColor;
    if (!isReady) {
      return Container(
        decoration: BoxDecoration(
          color: ThemeUtils.buildColorLighter(targetColor).withOpacity(.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: CircularProgressIndicator(
            color: ThemeUtils.buildColorDarker(targetColor),
            backgroundColor:
                ThemeUtils.buildColorDarker(targetColor).withOpacity(.2),
          ),
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: FileImage(image),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
