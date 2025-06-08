import 'package:finance_tracker/core/constants/app_color.dart';
import 'package:finance_tracker/core/global_data/global_theme/bloc/theme_bloc.dart';
import 'package:finance_tracker/core/global_data/language_bloc/bloc/language_bloc.dart';
import 'package:finance_tracker/core/global_data/global_localizations/l10n_helper/l10n_helper.dart';
import 'package:finance_tracker/report_screen.dart';
import 'package:finance_tracker/screens/add_expense_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text(AppLocalizations.of(context)!.title)),
      appBar: AppBar(title: Text(l10(context).title)),

      body: Column(
        children: [
          Text(l10(context).expenseTracker),

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
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddExpenseScreen()),
              );
            },
            child: Text('Go to Add Expense Screen'),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReceiptScreen()),
              );
            },
            child: Text('Go to Report Page'),
          ),
        ],
      ),
    );
  }
}
