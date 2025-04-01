import 'package:bazar_books_app/core/l10n_generated/l10n.dart';
import 'package:bazar_books_app/features/auth/blocs/auth_bloc.dart';
import 'package:bazar_books_design/bazar_books_design.dart';
import 'package:bazar_books_design/core/responsive/size_extension.dart';
import 'package:bazar_books_design/widgets/texts/texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _passwordController.addListener(_onPasswordChanged);
  }

  void _onPasswordChanged() {
    context
        .read<AuthBloc>()
        .add(PasswordValidationChanged(_passwordController.text));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 23.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BazUiH4Text(
                    text: S.of(context).signInPageSignUp,
                  ),
                  SizedBox(height: 10.0.h),
                  Text(
                    S.of(context).signUpPageSubtitle,
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
                          labelText: S.of(context).signUpPageName,
                          hintText: S.of(context).signUpPageYourName,
                          controller: _nameController,
                          validator: Constants.nameValidator,
                          keyboardType: TextInputType.name,
                        ),
                        SizedBox(height: 16.0.h),
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
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  BazUiTextField(
                                    obscureText: isObscured,
                                    labelText: context.bazS.signInPagePassword,
                                    hintText:
                                        context.bazS.signInPageYourPassword,
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        context.read<AuthBloc>().add(
                                              TogglePasswordVisibilityEvent(),
                                            );
                                      },
                                      icon: isObscured
                                          ? BazUiBuiltInImage.icPassword(
                                              color:
                                                  context.colorScheme.tertiary,
                                            )
                                          : BazUiBuiltInImage.icUnPassword(
                                              color: context.colorScheme
                                                  .onSecondaryContainer,
                                            ),
                                    ),
                                    validator: Constants.passwordValidator,
                                    controller: _passwordController,
                                  ),
                                  SizedBox(height: 10.0.h),
                                  BlocBuilder<AuthBloc, AuthState>(
                                    builder: (context, state) {
                                      if (state is PasswordValidationState) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            _buildPasswordValidationRow(
                                              context,
                                              context.bazS.hasMinLength,
                                              state.hasMinLength,
                                            ),
                                            _buildPasswordValidationRow(
                                              context,
                                              context.bazS.hasNumber,
                                              state.hasNumber,
                                            ),
                                            _buildPasswordValidationRow(
                                              context,
                                              context.bazS.hasLetter,
                                              state.hasLetter,
                                            ),
                                          ],
                                        );
                                      }
                                      return Container();
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.0.h),
                  BlocConsumer<AuthBloc, AuthState>(
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
                                  SignUpSubmitted(
                                    _nameController.text,
                                    _emailController.text,
                                    _passwordController.text,
                                  ),
                                );
                          }
                        },
                        text: S.of(context).signUpPageRegister,
                      );
                    },
                    listener: (context, state) {
                      if (state is SignUpSuccess) {
                        context.go(RoutePaths.congratulations);
                      } else if (state is SignUpFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.error)),
                        );
                      }
                    },
                  ),
                  SizedBox(height: 20.0.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        S.of(context).signUnPageHaveAnAccount,
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: context.colorScheme.tertiary,
                          fontSize: 14.0.sp,
                        ),
                      ),
                      SizedBox(width: 5.0.w),
                      BazUiTextButton(
                        text: S.of(context).signInPageSignIn,
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: context.colorScheme.primary,
                          fontSize: 14.0.sp,
                        ),
                        onPressed: () {
                          context.go(RoutePaths.login);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0.h),
                ],
              ),
            ),
            SizedBox(height: 50.0.h),
            Text(
              S.of(context).signUpPageTextBottom,
              style: context.textTheme.bodyLarge!.copyWith(
                color: context.colorScheme.tertiary,
                fontWeight: FontWeight.w400,
                fontSize: 16.0.sp,
              ),
            ),
            BazUiTextButton(
              text: S.of(context).signUpPageTerms,
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.colorScheme.primary,
                fontSize: 14.0.sp,
              ),
              onPressed: () {},
            ),
            SizedBox(height: 20.0.h),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordValidationRow(
      BuildContext context, String text, bool isValid) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check : Icons.close,
          color: isValid ? Colors.green : Colors.red,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: context.textTheme.bodyLarge?.copyWith(
            color: isValid ? Colors.green : Colors.red,
            fontSize: 14.0.sp,
          ),
        ),
      ],
    );
  }
}
