import 'package:finance_tracker/features/email-verify/screens/email_verify_screen.dart';
import 'package:finance_tracker/features/forgot-password/forgot_password_screen.dart';
import 'package:finance_tracker/features/home/presentation/screens/homepage_screen.dart';
import 'package:finance_tracker/features/login/presentation/screens/login_screen.dart';
import 'package:finance_tracker/features/sign-up/presentation/screens/sign_up_screen.dart';
import 'package:finance_tracker/features/wrapper/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../custom_go_route.dart';
import '../navigation_animation.dart';
import '../route_name.dart';

List<RouteBase> get authRouteList => <RouteBase>[
  customGoRoute(path: RouteName.loginTemplateRoute, child: LoginScreen()),
  customGoRoute(path: RouteName.signupTemplateRoute, child: SignUpScreen()),
  customGoRoute(
    path: RouteName.forgotpassTemplateRoute,
    child: ForgotPasswordScreen(),
  ),
  customGoRoute(path: RouteName.homeTemplateRoute, child: HomepageScreen()),
  customGoRoute(path: RouteName.wrapperTemplateRoute, child: Wrapper()),
  customGoRoute(
    path: RouteName.verifyemailTemplateRoute,
    child: EmailVerifyScreen(),
  ),
];
