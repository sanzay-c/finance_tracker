import 'package:finance_tracker/core/routing/route_config.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static GlobalKey<NavigatorState> shellANavigatorKey =
      GlobalKey<NavigatorState>();
  static GlobalKey<NavigatorState> shellBNavigatorKey =
      GlobalKey<NavigatorState>();

  static BuildContext? get ctx =>
      router.routerDelegate.navigatorKey.currentContext;

  Future<T?> pushNamed<T extends Object?>(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) => ctx!.pushNamed(
    name,
    extra: extra,
    pathParameters: pathParameters,
    queryParameters: queryParameters,
  );

  void pop<T extends Object?>([T? result]) => ctx!.pop(result);

  bool canPop() => ctx!.canPop();

  void goBackUntil(String desiredRoute) {
    return navigatorKey.currentState!.popUntil((Route<dynamic> route) {
      return route.settings.name == desiredRoute;
    });
  }

  void pushReplacementNamed(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) => ctx!.pushReplacementNamed(
    name,
    pathParameters: pathParameters,
    queryParameters: queryParameters,
    extra: extra,
  );

  void pushNamedAndRemoveUntil(
    String route,
    bool popToInitial, {
    dynamic arguments,
  }) {
    return ctx!.goNamed(route, extra: arguments);
  }

  BuildContext getNavigationContext() => ctx!;
}
