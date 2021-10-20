import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallfreev/components/image_component.dart';
import 'package:wallfreev/controllers/app_controller.dart';
import 'package:wallfreev/pages/categories_page.dart';
import 'package:wallfreev/pages/home_page.dart';
import 'package:flutter/services.dart';
import 'package:wallfreev/utils/theme_utils.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final targetColor = context.watch<AppController>().primaryColor;
    final isDarkTheme = context.watch<AppController>().useDarkTheme;
    final maxLoadedWallpapers =
        context.watch<AppController>().maxLoadedWallpapers;

    late Color darkerColor;
    late Color lighterColor;

    if (isDarkTheme) {
      darkerColor = ThemeUtils.buildColorLighter(targetColor);
      lighterColor = ThemeUtils.buildColorDarker(targetColor);
    } else {
      darkerColor = ThemeUtils.buildColorDarker(targetColor);
      lighterColor = ThemeUtils.buildColorLighter(targetColor, intensity: 220);
    }

    return InheritedImageComponentLimiterScope(
      scope: ImageComponentLimiterScope(maxLoadedWallpapers),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: lighterColor,
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
                selectedItemColor: darkerColor,
                backgroundColor: lighterColor,
                unselectedItemColor: darkerColor.withOpacity(.4)),
            appBarTheme: AppBarTheme(
              iconTheme: IconThemeData(
                color: darkerColor,
              ),
              backgroundColor: lighterColor,
              foregroundColor: darkerColor,
              titleTextStyle: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w400,
                  color: darkerColor),
            ),
            sliderTheme: SliderThemeData(
              activeTrackColor: targetColor.withOpacity(.8),
              thumbColor: targetColor,
              inactiveTrackColor: targetColor.withOpacity(.24),
              inactiveTickMarkColor: targetColor,
            ),
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: ZoomPageTransitionsBuilder(),
              },
            ),
            switchTheme: SwitchThemeData(
              thumbColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return isDarkTheme ? targetColor : darkerColor;
                }
                return isDarkTheme ? lighterColor : darkerColor;
              }),
              trackColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return (isDarkTheme ? targetColor : darkerColor)
                      .withOpacity(.3);
                }
                return (isDarkTheme ? lighterColor : darkerColor)
                    .withOpacity(.2);
              }),
            )),
        home: const HomePage(),
      ),
    );
  }
}
