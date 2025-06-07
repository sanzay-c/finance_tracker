import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'navigation_animation.dart';
import 'navigation_observer_route_list.dart';

int systemBackCount = 0;

GoRoute customGoRoute<T>({
  required String path,
  Widget? child,
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
        (builder == null
            ? (BuildContext context, GoRouterState state) {
              if (child == null) {
                throw Exception(
                  "Either builder or child must be provided for route $path",
                );
              }
              return fadeTransition(
                context: context,
                state: state,
                child: child,
              );
            }
            : null),
  );
}
