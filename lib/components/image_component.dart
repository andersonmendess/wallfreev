import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/src/provider.dart';
import 'package:wallfreev/controllers/app_controller.dart';
import 'package:wallfreev/services/cache_service.dart';
import 'package:wallfreev/utils/theme_utils.dart';

enum _ImageComponentLifecycleState {
  registered,
  active,
  scheduledToDestroy,
}

class ImageComponentLimiterScope {
  ImageComponentLimiterScope(this.maxActiveCount);
  final int maxActiveCount;

  static ImageComponentLimiterScope of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<
          InheritedImageComponentLimiterScope>()!
      .scope;

  final Queue<_ImageComponentState> _active = Queue();
  final Map<_ImageComponentState, _ImageComponentLifecycleState> _registered =
      {};

  /// An [ImageComponent] was mounted.
  void register(_ImageComponentState self) {
    if (_registered.containsKey(self)) {
      throw StateError('register called more than once!');
    }
    _registered[self] = _ImageComponentLifecycleState.registered;

    _maybeScheduleToDestroy();
  }

  /// An [ImageComponent] loaded an image.
  void setActive(_ImageComponentState self) {
    final currentState = _registered[self];
    if (currentState != _ImageComponentLifecycleState.registered) {
      final String beforeOrAfter;
      switch (currentState) {
        case _ImageComponentLifecycleState.registered:
          beforeOrAfter = '';
          break;
        case _ImageComponentLifecycleState.active:
        case _ImageComponentLifecycleState.scheduledToDestroy:
          beforeOrAfter = 'after';
          break;
        case null:
          beforeOrAfter = 'before';
      }
      final String stateTransitionMethod;
      switch (currentState) {
        case _ImageComponentLifecycleState.registered:
          stateTransitionMethod = '';
          break;
        case _ImageComponentLifecycleState.active:
          stateTransitionMethod = 'setActive';
          break;
        case _ImageComponentLifecycleState.scheduledToDestroy:
          stateTransitionMethod = '_scheduleToDestroy';
          break;
        case null:
          stateTransitionMethod = 'register';
      }
      throw StateError(
        'Cannot call setActive $beforeOrAfter calling $stateTransitionMethod',
      );
    }
    _registered[self] = _ImageComponentLifecycleState.active;
    _active.add(self);

    _maybeScheduleToDestroy();
  }

  /// An [ImageComponent] was disposed.
  void unregister(_ImageComponentState self) {
    _active.remove(self);
    _registered.remove(self);

    _maybeScheduleToDestroy();
  }

  void _scheduleToDestroy(_ImageComponentState state) {
    _registered[state] = _ImageComponentLifecycleState.scheduledToDestroy;
    state.scheduleToDestroy();
  }

  void _maybeScheduleToDestroy() {
    while (_active.length > maxActiveCount) {
      _scheduleToDestroy(_active.removeFirst());
    }
  }
}

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

class InheritedImageComponentLimiterScope extends InheritedWidget {
  final ImageComponentLimiterScope scope;

  const InheritedImageComponentLimiterScope({
    Key? key,
    required this.scope,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedImageComponentLimiterScope oldWidget) =>
      oldWidget.scope != scope;
}

class _ImageComponentState extends State<ImageComponent>
    with AutomaticKeepAliveClientMixin {
  bool isReady = false;
  CacheService? cacheService;
  late File image;
  int? decodeWidth;
  ImageComponentLimiterScope? _scope;

  @override
  void initState() {
    super.initState();
    widget.cacheService.download(widget.url).then((value) {
      if (!mounted) {
        return;
      }
      _scope?.setActive(this);
      image = value;
      // The component is now useful, so it may be kept alive
      wantKeepAlive = true;
      updateKeepAlive();
      setState(() {
        isReady = true;
      });

      if (widget.onLoaded != null) {
        widget.onLoaded!(value);
      }
    });
  }

  void _maybeRegisterScope() {
    final scope = ImageComponentLimiterScope.of(context);
    if (_scope != scope) {
      _scope?.unregister(this);
      unscheduleToDestroy();
      _scope = scope;
    }

    scope.register(this);
    if (isReady) {
      // The image was fetched before registering the scope. May only be
      // possible if the cacheService future was called before the next
      // microtask, which would happen in the next frame, after the tree is
      // built.
      scope.setActive(this);
    }
  }

  @override
  bool wantKeepAlive = false;

  void unscheduleToDestroy() {
    if (wantKeepAlive) {
      return;
    }
    if (!isReady) {
      return;
    }

    wantKeepAlive = true;
    updateKeepAlive();
  }

  void scheduleToDestroy() {
    wantKeepAlive = false;
    updateKeepAlive();
  }

  @override
  void dispose() {
    _scope?.unregister(this);
    _scope = null;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _maybeRegisterScope();
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
    return LayoutBuilder(builder: (context, constraints) {
      decodeWidth ??=
          (constraints.biggest.height * MediaQuery.of(context).devicePixelRatio)
              .toInt();
      return Material(
        borderRadius: BorderRadius.circular(8),
        color: ThemeUtils.buildColorLighter(targetColor).withOpacity(.5),
        clipBehavior: Clip.antiAlias,
        child: Image.file(
          image,
          fit: BoxFit.cover,
          cacheHeight: decodeWidth,
        ),
      );
    });
  }
}
