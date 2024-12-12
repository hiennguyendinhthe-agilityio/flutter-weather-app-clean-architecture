import 'package:bazar_books_app/features/auth/blocs/auth_bloc.dart';
import 'package:bazar_books_design/bazar_books_design.dart';
import 'package:bazar_books_design/core/extensions/context_extension.dart';
import 'package:bazar_books_design/core/responsive/size_extension.dart';
import 'package:bazar_books_design/widgets/texts/texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context, designWidth: 375, designHeight: 812);

    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthenticationSuccess) {
            context.go('/home');
          } else if (state is AuthenticationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 23.0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BazUiH4Text(
                      text: context.bazS.signInPageWelcomeBack,
                    ),
                    SizedBox(height: 10.0.h),
                    Text(
                      context.bazS.signInPageYourAccount,
                      style: context.textTheme.bodyLarge!.copyWith(
                        color: context.colorScheme.tertiary,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.0.sp,
                      ),
                    ),
                    SizedBox(height: 40.0.h),
                    FormBuilder(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BazUiTextField(
                            labelText: context.bazS.signInPageEmail,
                            hintText: context.bazS.signInPageYourEmail,
                            validator: Constants.emailValidator,
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailController,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0.h),
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
                                      context.read<AuthBloc>().add(
                                            TogglePasswordVisibilityEvent(),
                                          );
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
                                  controller: _passwordController,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.0.h),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        if (state is AuthenticationLoading) {
                          return const Center(
                            child: BazUiCircularProgressIndicator(),
                          );
                        }
                        return BazUiElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              context.read<AuthBloc>().add(
                                    LogInRequested(
                                      _emailController.text,
                                      _passwordController.text,
                                    ),
                                  );
                            }
                          },
                          text: context.bazS.signInPageLogin,
                        );
                      },
                    ),
                    SizedBox(height: 20.0.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          context.bazS.signInPageDontHaveAnAccount,
                          style: context.textTheme.bodyLarge?.copyWith(
                            color: context.colorScheme.tertiary,
                            fontSize: 14.0.sp,
                          ),
                        ),
                        SizedBox(width: 5.0.w),
                        BazUiTextButton(
                          text: context.bazS.signInPageSignUp,
                          style: context.textTheme.bodyLarge?.copyWith(
                            color: context.colorScheme.primary,
                            fontSize: 14.0.sp,
                          ),
                          onPressed: () {
                            context.push(RoutePaths.signup);
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0.h),
                  ],
                ),
              ),
              SizedBox(height: 20.0.h),
            ],
          );
        },
      ),
    );
  }
}
