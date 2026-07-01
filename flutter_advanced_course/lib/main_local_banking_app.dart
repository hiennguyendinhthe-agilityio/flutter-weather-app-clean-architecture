import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as legacy;

import 'package:flutter_advanced_course/banking_app/core/router/app_router.dart';
import 'package:flutter_advanced_course/banking_app/core/theme/app_theme.dart';
import 'package:flutter_advanced_course/banking_app/features/auth/providers/auth_provider.dart';
import 'package:flutter_advanced_course/banking_app/features/home/providers/home_provider.dart';
import 'package:flutter_advanced_course/banking_app/features/portfolio/providers/transaction_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: BankingApp()));
}

class BankingApp extends StatelessWidget {
  const BankingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return legacy.MultiProvider(
      providers: [
        legacy.ChangeNotifierProvider(
          create: (_) => AuthProvider()..checkStatus(),
        ),
        legacy.ChangeNotifierProvider(create: (_) => HomeProvider()),
        legacy.ChangeNotifierProvider(create: (_) => TransactionProvider()),
      ],
      child: MaterialApp(
        title: 'Premium Banking App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: ThemeMode.system,
        initialRoute: AppRoutes.login,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
