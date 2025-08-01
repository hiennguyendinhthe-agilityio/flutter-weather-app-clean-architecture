import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/di/injection.dart';
import 'core/enums/auth_state.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/signup_page.dart';
import 'presentation/providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await configureDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => getIt<UserProvider>()..initialize(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Auth Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        // Configure proper routing
        initialRoute: '/',
        routes: {
          '/': (context) => const AuthWrapper(),
          '/login': (context) => const LoginPage(),
          '/signup': (context) => const SignUpPage(),
          '/home': (context) => const HomePage(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        debugPrint(
          '🔄 AuthWrapper: Current auth state = ${userProvider.authState}',
        );

        // Handle authentication status checking on app startup
        switch (userProvider.authState) {
          case AuthState.initial:
          case AuthState.loading:
            debugPrint('⏳ AuthWrapper: Showing loading screen');
            // Show loading screen while checking authentication status
            return const Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading...', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            );

          case AuthState.authenticated:
            debugPrint('✅ AuthWrapper: User authenticated, showing HomePage');
            // User is authenticated, show home page
            return const HomePage();

          case AuthState.unauthenticated:
          case AuthState.error:
            debugPrint(
              '❌ AuthWrapper: User not authenticated, showing LoginPage',
            );
            // User is not authenticated or error occurred, show login page
            return const LoginPage();
        }
      },
    );
  }
}
