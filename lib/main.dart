import 'package:finance_tracker/core/global_data/global_localizations/app_local/app_local.dart';
import 'package:finance_tracker/core/global_data/global_theme/bloc/theme_bloc.dart';
import 'package:finance_tracker/core/global_data/language_bloc/bloc/language_bloc.dart';
import 'package:finance_tracker/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LanguageBloc()..add(LoadLanguageEvent()), // Language
        ),
        BlocProvider(create: (context) => ThemeBloc()), // Theme 
      ],
      child: (const MyApp()),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return BlocBuilder<LanguageBloc, LanguageState>(
          builder: (context, state) {
            Locale locale = const Locale('en');
            if (state is LanguageChanged) {
              locale = state.locale;
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
              home: Homepage(),
            );
          },
        );
      },
    );
  }
}


