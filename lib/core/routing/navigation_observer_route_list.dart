import 'package:flutter/material.dart';

class NavigationObserverRouteList {
  NavigationObserverRouteList._();

  static final List<String> _screenRouteList = <String>[];

  static List<String> get screenRouteList => _screenRouteList;

  static void updateScreenRoutes({
    required bool isPushed,
    String? routeName,
  }) {
    if (routeName != null) {
      if (isPushed) {
        _screenRouteList.add(routeName);
      } else {
        _screenRouteList.remove(routeName);
      }
    } else {
      if (!isPushed) {
        _screenRouteList.removeLast();
      }
    }
    debugPrint('screen routes: $screenRouteList');
  }
}
