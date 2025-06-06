import 'package:finance_tracker/core/constants/app_colors.dart';
import 'package:finance_tracker/core/global_data/global_theme/bloc/theme_bloc.dart';
import 'package:finance_tracker/core/global_data/language_bloc/bloc/language_bloc.dart';
import 'package:finance_tracker/core/global_data/global_localizations/l10n_helper/l10n_helper.dart';
import 'package:finance_tracker/core/routing/route_name.dart';
import 'package:finance_tracker/helper/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  final _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text(AppLocalizations.of(context)!.title)),
      appBar: AppBar(title: Text("Expense Tracker")),
      body: Column(
        children: [
          Text("Expense tracker"),
          ElevatedButton(
            onPressed: () {
              context.read<LanguageBloc>().add(
                ChangeLanguageEvent(Locale('ne')),
              );
            },
            child: Text('Change to Nepali'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<LanguageBloc>().add(
                ChangeLanguageEvent(Locale('en')),
              );
            },
            child: Text('Change to English'),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: getColorByTheme(
                context: context,
                colorClass: AppColors.btnColor,
              ),
            ),
            onPressed: () {
              context.read<ThemeBloc>().add(ToggleThemeEvent());
            },
            child: Text(
              'Toggle Theme',
              style: TextStyle(
                color: getColorByTheme(
                  context: context,
                  colorClass: AppColors.btnTextColor,
                ),
              ),
            ),
          ),

          20.verticalSpace,
          ElevatedButton(
            onPressed: () {
              _auth.signOut();
              context.go(RouteName.loginTemplateRoute);
            },
            child: Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
