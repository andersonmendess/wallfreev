import 'package:flutter/material.dart';

const LIGHTER_COLOR_INTENSITY = 190;
const DARKER_COLOR_INTENSITY = 210;

abstract class ThemeUtils {
  static Color buildColorLighter(Color color,
          {int intensity = LIGHTER_COLOR_INTENSITY}) =>
      Color.alphaBlend(Colors.white.withAlpha(intensity), color);

  static Color buildColorDarker(Color color,
          {int intensity = DARKER_COLOR_INTENSITY}) =>
      Color.alphaBlend(Colors.black.withAlpha(intensity), color);
}
