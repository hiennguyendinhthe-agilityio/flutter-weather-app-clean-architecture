// ignore_for_file: depend_on_referenced_packages

import 'package:bazar_books_app/features/auth/blocs/auth_bloc.dart';
import 'package:bazar_books_app/features/auth/blocs/auth_event.dart';
import 'package:bazar_books_app/features/auth/blocs/auth_state.dart';
import 'package:bazar_books_app/features/home/home_page.dart';
import 'package:bazar_books_design/bazar_books_design.dart';
import 'package:bazar_books_design/constants.dart';
import 'package:bazar_books_design/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocProvider(
        create: (context) => AuthBloc(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 23.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BazUiTextField(
                            labelText: context.bazS.signInPageEmail,
                            hintText: context.bazS.signInPageYourEmail,
                            validator: Constants.emailValidator,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                bool isObscured = true;
                                if (state is PasswordVisibilityChanged) {
                                  isObscured = state.isObscured;
                                }
                                return BazUiTextField(
                                  obscureText: isObscured,
                                  labelText: context.bazS.signInPagePassword,
                                  hintText: context.bazS.signInPageYourPassword,
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      context
                                          .read<AuthBloc>()
                                          .add(TogglePasswordVisibilityEvent());
                                    },
                                    icon: isObscured
                                        ? BazUiBuiltInImage.icPassword(
                                            color: context.colorScheme.tertiary,
                                          )
                                        : BazUiBuiltInImage.icUnPassword(
                                            color: context.colorScheme
                                                .onSecondaryContainer,
                                          ),
                                  ),
                                  validator: Constants.passwordValidator,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: BazUiTextButton(
                        text: context.bazS.signInPageForgotPassword,
                        style: context.textTheme.bodySmall,
                        onSeeAllPressed: () {},
                      ),
                    ),
                    const SizedBox(height: 30),
                    BazUiElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                          );
                        }
                      },
                      text: context.bazS.signInPageLogin,
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
                    const SizedBox(height: 20),
                  ],
                ),
              ),
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
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
