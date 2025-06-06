import 'package:finance_tracker/common/models/color_model.dart';
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static ColorModel backgroundColor = ColorModel(
    darkModeColor: Colors.black,
    lightModeColor: const Color(0xFFFCFCFC),
  );

  static ColorModel cardColor = ColorModel(
    darkModeColor: const Color(0xFF1F1F1F),
    lightModeColor: const Color(0xFFFAFAFA),
  );

  static ColorModel btnColor = ColorModel(
    darkModeColor: const Color.fromARGB(255, 57, 57, 57),
    lightModeColor: const Color.fromARGB(255, 151, 60, 173),
  );

  static ColorModel btnTextColor = ColorModel(
    darkModeColor: Colors.white,
    lightModeColor: Colors.black,
  );
}

extension ThemeContextExtension on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}

Color getColorByTheme({
  required BuildContext context,
  required ColorModel? colorClass,
  Color fallbackLight = Colors.black,
  Color fallbackDark = Colors.white,
}) {
  final isDark = context.isDark;
  if (colorClass == null) return isDark ? fallbackDark : fallbackLight;
  return isDark ? colorClass.darkModeColor : colorClass.lightModeColor;
}
