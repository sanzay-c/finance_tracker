import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/features/add-expense/data/repository_impl/expense_repository_impl.dart';
import 'package:finance_tracker/features/add-expense/domain/usecase/add_expense_usecase.dart';
import 'package:finance_tracker/features/add-expense/presentation/bloc/add_expense_bloc.dart';
import 'package:finance_tracker/features/add-expense/presentation/screens/add_expense_screen.dart';
import 'package:finance_tracker/features/add-expense/presentation/screens/receipt_screen.dart';
import 'package:finance_tracker/features/email-verify/screens/email_verify_screen.dart';
import 'package:finance_tracker/features/forgot-password/forgot_password_screen.dart';
import 'package:finance_tracker/features/home/presentation/screens/homepage_screen.dart';
import 'package:finance_tracker/features/login/data/datasource/auth_remote_datasource.dart';
import 'package:finance_tracker/features/login/data/repository_impl/auth_repository_impl.dart';
import 'package:finance_tracker/features/sign-up/data/datasource/auth_remote_datasource.dart';
import 'package:finance_tracker/features/sign-up/data/repository_impl/auth_repository_impl.dart';
import 'package:finance_tracker/features/login/domain/usecase/login_user_usecase.dart';
import 'package:finance_tracker/features/login/presentation/cubit/cubit/login_cubit.dart';
import 'package:finance_tracker/features/login/presentation/screen/login_screen.dart';
import 'package:finance_tracker/features/sign-up/domain/usecase/signup_user_usecase.dart';
import 'package:finance_tracker/features/sign-up/presentation/cubit/signup_cubit.dart';
import 'package:finance_tracker/features/sign-up/presentation/screen/sign_up_screen.dart';
import 'package:finance_tracker/features/wrapper/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../custom_go_route.dart';
import '../route_name.dart';

List<RouteBase> get authRouteList => <RouteBase>[
  customGoRoute(
    path: RouteName.forgotpassTemplateRoute,
    child: ForgotPasswordScreen(),
  ),
  customGoRoute(path: RouteName.homeTemplateRoute, child: HomepageScreen()),
  customGoRoute(path: RouteName.wrapperTemplateRoute, child: Wrapper()),

  customGoRoute(
    path: RouteName.verifyemailTemplateRoute,
    builder: (context, state) {
      final email = state.extra as String;
      return EmailVerifyScreen(email: email);
    },
  ),

  customGoRoute(
    path: RouteName.loginTemplateRoute,
    builder: (context, state) {
      return BlocProvider(
        create:
            (_) => LoginCubit(
              LoginUserUseCase(
                LoginAuthRepositoryImpl(
                  LoginAuthRemoteDatasource(FirebaseAuth.instance),
                ),
              ),
            ),
        child: const LoginScreen(),
      );
    },
  ),

  customGoRoute(
    path: RouteName.signupTemplateRoute,
    builder: (context, state) {
      return BlocProvider(
        create:
            (_) => SignupCubit(
              SignupUserUsecase(
                SignUpAuthRepositoryImpl(
                  SignUpAuthRemoteDatasource(FirebaseAuth.instance),
                ),
              ),
            ),
        child: const SignUpScreen(),
      );
    },
  ),

  customGoRoute(
    path: RouteName.addexpenseTemplateRoute,
    builder: (context, state) {
      return BlocProvider(
        create:
            (_) => AddExpenseBloc(
              AddExpenseUseCase(
                ExpenseRepositoryImpl(FirebaseFirestore.instance),
              ),
            ),
        child: const AddExpenseScreen(),
      );
    },
  ),

  customGoRoute(path: RouteName.receiptTemplateRoute, child: ReceiptScreen()),
];
