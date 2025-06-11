import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/common/features/add_transactions/data/data_remote_source/transaction_remote_data_source.dart';
import 'package:finance_tracker/common/features/add_transactions/data/repo_impl/transaction_repo_impl.dart';
import 'package:finance_tracker/common/features/add_transactions/domain/usecases/wallet_total_income.dart';
import 'package:finance_tracker/common/features/bottom_nav_bar/presentation/bottom_nav_bar.dart';
import 'package:finance_tracker/common/features/wallet/data/remote_data_source/wallet_remote_data_source.dart';
import 'package:finance_tracker/common/features/wallet/data/repo_impl.dart/wallet_repo_impl.dart';
import 'package:finance_tracker/common/features/wallet/domain/usecases/add_wallet.dart';
import 'package:finance_tracker/common/features/wallet/domain/usecases/get_wallet.dart';
import 'package:finance_tracker/common/features/wallet/presentation/bloc/bloc/add_wallet_bloc.dart';
import 'package:finance_tracker/core/global_data/global_localizations/app_local/app_local.dart';
import 'package:finance_tracker/core/global_data/global_theme/bloc/theme_bloc.dart';
import 'package:finance_tracker/core/global_data/language_bloc/bloc/language_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        BlocProvider(
          create:
              (context) => AddWalletBloc(
                walletTotalIncome: WalletTotalIncome(
                  repository: TransactionRepositoryImpl(
                    remoteDataSource: TransactionRemoteDataSourceImpl(
                      firestore: FirebaseFirestore.instance,
                    ),
                  ),
                ),
                addWallet: AddWallet(
                  repository: WalletRepositoryImpl(
                    remoteDataSource: WalletRemoteDataSource(
                      firestore: FirebaseFirestore.instance,
                    ),
                  ),
                ),
                getWallets: GetWallets(
                  repository: WalletRepositoryImpl(
                    remoteDataSource: WalletRemoteDataSource(
                      firestore: FirebaseFirestore.instance,
                    ),
                  ),
                ),
              ),
        ),
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
    return ScreenUtilInit(
      designSize: Size(720, 1280),
      minTextAdapt: true,
      builder: (context, child) {
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
      },
    );
  }
}
