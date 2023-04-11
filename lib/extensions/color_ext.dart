import 'package:flutter/material.dart';

extension ColorExt on Color {
  Brightness get brightness {
    return ThemeData.estimateBrightnessForColor(this);
  }

  Color darken([int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    final double f = 1 - percent / 100;
    return Color.fromARGB(
      alpha,
      (red * f).round(),
      (green * f).round(),
      (blue * f).round(),
    );
  }

  Color brighten([int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    final double p = percent / 100;
    return Color.fromARGB(
      alpha,
      red + ((255 - red) * p).round(),
      green + ((255 - green) * p).round(),
      blue + ((255 - blue) * p).round(),
    );
  }
}
