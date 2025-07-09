import 'package:finance_tracker/common/models/color_model.dart';
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static ColorModel backgroundColor = ColorModel(
    lightModeColor: const Color(0xFFFCFCFC),
    darkModeColor: Colors.black,
  );

  static ColorModel cardColor = ColorModel(
    lightModeColor: const Color(0xFFFAFAFA),
    darkModeColor: const Color(0xFF1F1F1F),
  );

  static ColorModel btnColor = ColorModel(
    lightModeColor: const Color.fromARGB(255, 151, 60, 173),
    darkModeColor: const Color.fromARGB(255, 57, 57, 57),
  );

  static ColorModel btnTextColor = ColorModel(
    lightModeColor: Colors.black,
    darkModeColor: Colors.white,
  );
  static ColorModel containerBorderColor = ColorModel(
    lightModeColor: Colors.grey,
    darkModeColor: Colors.white,
  );
  static ColorModel profileBoxColor = ColorModel(
    lightModeColor: Colors.white,
    darkModeColor: Colors.black,
  );
  static ColorModel profileIconColor = ColorModel(
    lightModeColor: Colors.grey,
    darkModeColor: Colors.white,
  );
  static ColorModel profileTextColor = ColorModel(
    lightModeColor: Colors.black,
    darkModeColor: Colors.white,
  );
  static ColorModel bottomNavColor = ColorModel(
    lightModeColor:Color.fromARGB(156, 255, 255, 255)
,
    darkModeColor: const Color.fromARGB(151, 0, 0, 0),
  );
  static ColorModel textColor = ColorModel(
    lightModeColor: Colors.black,
    darkModeColor: Colors.white,
  );
  static ColorModel buttonBorderSide = ColorModel(
    lightModeColor: Colors.black,
    darkModeColor: Colors.white,
  );
  static ColorModel selectedIndex = ColorModel(
    lightModeColor: Colors.black,
    darkModeColor: Colors.white,
  );
  static ColorModel unSelectedIndex = ColorModel(
    lightModeColor: const Color.fromARGB(255, 71, 70, 70),
    darkModeColor: const Color.fromARGB(255, 255, 255, 255),
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
