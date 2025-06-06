import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'navigation_animation.dart';
import 'navigation_observer_route_list.dart';

int systemBackCount = 0;

GoRoute customGoRoute<T>({
  required String path,
  required Widget child,
  GoRouterWidgetBuilder? builder,
  List<RouteBase>? routes,
  GlobalKey<NavigatorState>? parentNavigatorKey,
  GoRouterPageBuilder? pageBuilder,
}) {
  return GoRoute(
    path: path,
    name: path,
    builder: builder,
    routes: routes ?? <RouteBase>[],
    parentNavigatorKey: parentNavigatorKey,
    pageBuilder:
        pageBuilder ??
        (BuildContext context, GoRouterState state) {
          return fadeTransition(context: context, state: state, child: child);
        },
  );
}
