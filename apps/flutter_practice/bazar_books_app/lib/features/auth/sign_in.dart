import 'package:bazar_books_app/features/auth/blocs/auth_bloc.dart';
import 'package:bazar_books_app/features/auth/blocs/auth_event.dart';
import 'package:bazar_books_app/features/auth/blocs/auth_state.dart';
import 'package:bazar_books_design/bazar_books_design.dart';
import 'package:bazar_books_design/constants.dart';
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

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context, designWidth: 375, designHeight: 812);

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
                        fontSize: 16.0.sp, // Scale font size
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
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 16.0.h), // Scale padding
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
                    SizedBox(height: 20.0.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: BazUiTextButton(
                        text: context.bazS.signInPageForgotPassword,
                        style: context.textTheme.bodySmall?.copyWith(
                          fontSize: 14.0.sp, // Scale font size
                        ),
                        onSeeAllPressed: () {},
                      ),
                    ),
                    SizedBox(height: 30.0.h),
                    BazUiElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          context.go('/home');
                        }
                      },
                      text: context.bazS.signInPageLogin,
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
                        Text(
                          context.bazS.signInPageSignUp,
                          style: context.textTheme.bodyLarge?.copyWith(
                            color: context.colorScheme.primary,
                            fontSize: 14.0.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0.h),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                        thickness: 1.0.h,
                        color: Colors.grey[300]), // Scale thickness
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.0.w), // Scale padding
                    child: Text(
                      context.bazS.signInPageOrWith,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.tertiary,
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0.sp, // Scale font size
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                        thickness: 1.0.h,
                        color: Colors.grey[300]), // Scale thickness
                  ),
                ],
              ),
              SizedBox(height: 20.0.h),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 24.0.w), // Scale padding
                child: Column(
                  children: [
                    BazUiOutLinedButton.icon(
                      text: context.bazS.signInPageWithGoogle,
                      icon: BazUiBuiltInImage.icGoogleOriginal(),
                    ),
                    SizedBox(height: 20.0.h), //
                    BazUiOutLinedButton.icon(
                      text: context.bazS.signInPageWithApple,
                      icon: BazUiBuiltInImage.icAppleOriginal(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0.h),
            ],
          ),
        ),
      ),
    );
  }
}
