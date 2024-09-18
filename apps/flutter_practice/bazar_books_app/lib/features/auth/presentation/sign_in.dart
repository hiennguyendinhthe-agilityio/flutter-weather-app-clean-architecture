// ignore_for_file: depend_on_referenced_packages

import 'package:bazar_books_app/features/auth/blocs/auth_bloc.dart';
import 'package:bazar_books_app/features/auth/blocs/auth_event.dart';
import 'package:bazar_books_app/features/auth/blocs/auth_state.dart';
import 'package:bazar_books_app/features/home/home_page.dart';
import 'package:bazar_books_design/bazar_books_design.dart';
import 'package:bazar_books_design/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  // Initially password is obscure
  bool _obscureText = true;

  // Toggles the password show status
  void toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: BazUiBuiltInImage.icArrowLeft(),
          onPressed: () {
            // Handle back action
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocProvider(
        create: (context) => AuthBloc(),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            } else if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      context.bazS.signInPageWelcomeBack,
                      style: context.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      context.bazS.signInPageYourAccount,
                      style: context.textTheme.bodyLarge!.copyWith(
                        color: context.colorScheme.tertiary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 40),
                    BazUiTextField(
                      controller: emailController,
                      labelText: context.bazS.signInPageEmail,
                      hintText: context.bazS.signInPageYourEmail,
                    ),
                    const SizedBox(height: 20),
                    BazUiTextField(
                      obscureText: _obscureText,
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            icon: _obscureText
                                ? BazUiBuiltInImage.icPassword(
                                    color: context.colorScheme.tertiary,
                                  )
                                : BazUiBuiltInImage.icUnPassword(
                                    color: context
                                        .colorScheme.onSecondaryContainer,
                                  )),
                      ),
                      controller: passwordController,
                      labelText: context.bazS.signInPagePassword,
                      hintText: context.bazS.signInPageYourPassword,
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        context.bazS.signInPageForgotPassword,
                        style: context.textTheme.bodySmall,
                      ),
                    ),
                    const SizedBox(height: 30),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        if (state is LoginLoading) {
                          return const BazUiCircularProgressIndicator();
                        }
                        return BazUiElevatedButton(
                          onPressed: () {
                            BlocProvider.of<AuthBloc>(context).add(
                              LoginButtonPressed(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              ),
                            );
                          },
                          text: context.bazS.signInPageLogin,
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          context.bazS.signInPageDontHaveAnAccount,
                          style: context.textTheme.bodyLarge!.copyWith(
                            color: context.colorScheme.tertiary,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          context.bazS.signInPageSignUp,
                          style: context.textTheme.bodyLarge!.copyWith(
                            color: context.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: Divider(thickness: 1, color: Colors.grey[300]),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      context.bazS.signInPageOrWith,
                      style: context.textTheme.bodySmall!.copyWith(
                        color: context.colorScheme.tertiary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(thickness: 1, color: Colors.grey[300]),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    BazUiOutLinedButton.icon(
                      text: context.bazS.signInPageWithGoogle,
                      icon: BazUiBuiltInImage.icGoogleOriginal(),
                    ),
                    BazUiOutLinedButton.icon(
                      text: context.bazS.signInPageWithApple,
                      icon: BazUiBuiltInImage.icAppleOriginal(),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
