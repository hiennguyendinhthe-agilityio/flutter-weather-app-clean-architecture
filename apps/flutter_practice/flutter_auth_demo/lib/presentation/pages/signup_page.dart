import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/validators.dart';
import '../providers/user_provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/error_message.dart';
import '../widgets/loading_button.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  String? _successMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final userProvider = context.read<UserProvider>();
    
    final success = await userProvider.signUp(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (success && mounted) {
      setState(() {
        _successMessage = 'Account created successfully! Please log in.';
      });
      
      // Clear form
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();
      
      // Navigate to login page after a short delay
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/login');
        }
      });
    }
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      key: const Key('signupPage'),
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                
                // Header
                Text(
                  'Create Account',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign up to get started',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Success Message
                if (_successMessage != null)
                  Column(
                    children: [
                      SuccessMessage(
                        message: _successMessage!,
                        onDismiss: () {
                          setState(() {
                            _successMessage = null;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),

                // Error Message
                Consumer<UserProvider>(
                  builder: (context, userProvider, child) {
                    if (userProvider.errorMessage != null) {
                      return Column(
                        children: [
                          ErrorMessage(
                            message: userProvider.errorMessage!,
                            onDismiss: () {
                              userProvider.clearError();
                            },
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),

                // Name Field
                CustomTextField(
                  key: const Key('nameField'),
                  label: 'Full Name',
                  controller: _nameController,
                  validator: Validators.validateName,
                  prefixIcon: const Icon(Icons.person_outline),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 20),

                // Email Field
                CustomTextField(
                  key: const Key('emailField'),
                  label: 'Email',
                  controller: _emailController,
                  validator: Validators.validateEmail,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 20),

                // Password Field
                CustomTextField(
                  key: const Key('passwordField'),
                  label: 'Password',
                  controller: _passwordController,
                  validator: Validators.validatePassword,
                  obscureText: _obscurePassword,
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: _togglePasswordVisibility,
                  ),
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 32),

                // Sign Up Button
                Consumer<UserProvider>(
                  builder: (context, userProvider, child) {
                    return LoadingButton(
                      text: 'Create Account',
                      onPressed: _handleSignUp,
                      isLoading: userProvider.isLoading,
                      icon: const Icon(Icons.person_add),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    GestureDetector(
                      onTap: _navigateToLogin,
                      child: Text(
                        'Sign In',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
