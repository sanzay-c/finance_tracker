import 'package:finance_tracker/common/features/bottom_nav_bar/presentation/bottom_nav_bar.dart';
import 'package:finance_tracker/core/global_data/global_localizations/app_local/app_local.dart';
import 'package:finance_tracker/core/global_data/global_theme/bloc/theme_bloc.dart';
import 'package:finance_tracker/core/global_data/language_bloc/bloc/language_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //yo yedi web ma run vako xa vane
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyDuNxl8-nwVyS4n5S0_TRW1GUI2JcxTHOw",
        authDomain: "flutter-firebase-implement.firebaseapp.com",
        projectId: "flutter-firebase-implement",
        storageBucket: "flutter-firebase-implement.firebasestorage.app",
        messagingSenderId: "434484011784",
        appId: "1:434484011784:web:e73b69545f9a5657c682bd",
      ),
    );
  } // yo yedi android or ios ma run vako xa vane
  else {
    await Firebase.initializeApp();
  }
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => LanguageBloc()..add(LoadLanguageEvent()), // Language
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
              home: BottomNavBar(),
            );
          },
        );
      },
    );
  }
}
