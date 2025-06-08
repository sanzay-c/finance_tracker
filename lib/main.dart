import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/data/repositories/expense_repository_impl.dart';
import 'package:finance_tracker/domain/usecases/add_expense_usecase.dart';
import 'package:finance_tracker/domain/usecases/delete_expense_usecase.dart';
import 'package:finance_tracker/domain/usecases/update_expense_usecase.dart';
import 'package:finance_tracker/homepage.dart';
import 'package:finance_tracker/presentation/blocs/add_expense/add_expense_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:finance_tracker/screens/add_expense_screen.dart';
import 'package:finance_tracker/core/global_data/language_bloc/bloc/language_bloc.dart';
import 'package:finance_tracker/core/global_data/global_theme/bloc/theme_bloc.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final expenseRepository = ExpenseRepositoryImpl(FirebaseFirestore.instance);

  final addExpenseUseCase = AddExpenseUseCase(expenseRepository);
  final updateExpenseUseCase = UpdateExpenseUseCase(expenseRepository);
  final deleteExpenseUseCase = DeleteExpenseUseCase(expenseRepository);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LanguageBloc()..add(LoadLanguageEvent())),
        BlocProvider(create: (_) => ThemeBloc()),
        BlocProvider(
          create:
              (_) => ExpenseBloc(
                addExpenseUseCase: addExpenseUseCase,
                updateExpenseUseCase: updateExpenseUseCase,
                deleteExpenseUseCase: deleteExpenseUseCase,
              ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return BlocBuilder<LanguageBloc, LanguageState>(
          builder: (context, langState) {
            Locale locale = const Locale('en');
            if (langState is LanguageChanged) {
              locale = langState.locale;
            }

            return MaterialApp(
              navigatorKey: navigatorKey,
              title: 'Expense Tracker',
              locale: locale,
              supportedLocales: const [Locale('en'), Locale('ne')],
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                AppLocalizations.delegate,
              ],
              themeMode: themeState.themeMode,
              theme: ThemeData(
                textTheme: GoogleFonts.poppinsTextTheme(),
                brightness: Brightness.light,
              ),
              darkTheme: ThemeData(
                textTheme: GoogleFonts.poppinsTextTheme(),
                brightness: Brightness.dark,
              ),
              debugShowCheckedModeBanner: false,
              home: const Homepage(),
            );
          },
        );
      },
    );
  }
}
