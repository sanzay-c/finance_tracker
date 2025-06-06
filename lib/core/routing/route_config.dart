import 'package:finance_tracker/core/routing/route_config/auth_route_config.dart';
import 'package:finance_tracker/core/routing/route_name.dart';
import 'package:go_router/go_router.dart';
import 'navigation_service.dart';

GoRouter get router => GoRouter(
  routes: <RouteBase>[...authRouteList],
  navigatorKey: NavigationService.navigatorKey,
  initialLocation:
      RouteName
          .wrapperTemplateRoute, //wrapper le nai kata navigate garne vanera vandinxa
);
