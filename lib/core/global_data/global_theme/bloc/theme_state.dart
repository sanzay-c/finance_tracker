part of 'theme_bloc.dart';

@immutable
abstract class ThemeState {
  final ThemeMode themeMode;
  ThemeState(this.themeMode);
}


class LightThemeState extends ThemeState {
  LightThemeState() : super(ThemeMode.light);
}

class DarkThemeState extends ThemeState {
  DarkThemeState() : super(ThemeMode.dark);
}