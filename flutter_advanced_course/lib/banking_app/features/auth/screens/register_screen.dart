import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/banking_app/core/constants/app_colors.dart';
import 'package:flutter_advanced_course/banking_app/core/router/app_router.dart';
import 'package:flutter_advanced_course/banking_app/features/auth/providers/auth_provider.dart';
import 'package:flutter_advanced_course/banking_app/shared/widgets/app_button.dart';
import 'package:flutter_advanced_course/banking_app/shared/widgets/app_text_field.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  late AnimationController _animCtrl;
  late List<Animation<double>> _anims;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _anims = List.generate(5, (i) {
      final s = i * 0.14;
      final e = (s + 0.4).clamp(0.0, 1.0);
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _animCtrl,
          curve: Interval(s, e, curve: Curves.easeOut),
        ),
      );
    });
    _animCtrl
      ..addListener(() => setState(() {}))
      ..forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final auth = context.read<AuthProvider>();
    final ok = await auth.register(
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text,
      fullName: _nameCtrl.text.trim(),
    );

    if (ok && mounted) {
      await Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: size.width > 600 ? 80 : 24,
            vertical: 16,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fade(
                  0,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppColors.grey900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Join and manage your finances',
                        style: TextStyle(
                          fontSize: 15,
                          color: isDark ? Colors.white54 : AppColors.grey600,
                        ),
                      ),
                      const SizedBox(height: 28),
                    ],
                  ),
                ),
                _fade(
                  1,
                  AppTextField(
                    label: 'Full Name',
                    hint: 'Enter your full name',
                    controller: _nameCtrl,
                    prefixIcon: Icons.person_outlined,
                    validator: (v) =>
                        (v?.trim().isEmpty ?? true) ? 'Name is required' : null,
                  ),
                ),
                const SizedBox(height: 14),
                _fade(
                  2,
                  AppTextField(
                    label: 'Email',
                    hint: 'Enter your email',
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    validator: (v) {
                      if (v?.isEmpty ?? true) {
                        return 'Required';
                      }
                      if (!v!.contains('@')) {
                        return 'Invalid email';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 14),
                _fade(
                  3,
                  AppTextField(
                    label: 'Password',
                    hint: 'Min 6 characters',
                    controller: _passCtrl,
                    isPassword: true,
                    prefixIcon: Icons.lock_outlined,
                    validator: (v) {
                      if (v?.isEmpty ?? true) {
                        return 'Required';
                      }
                      if (v!.length < 6) {
                        return 'Min 6 chars';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 14),
                _fade(
                  3,
                  AppTextField(
                    label: 'Confirm Password',
                    hint: 'Re-enter password',
                    controller: _confirmCtrl,
                    isPassword: true,
                    prefixIcon: Icons.lock_outlined,
                    validator: (v) =>
                        v != _passCtrl.text ? 'Passwords do not match' : null,
                  ),
                ),
                const SizedBox(height: 28),
                _fade(
                  4,
                  Consumer<AuthProvider>(
                    builder: (_, auth, _) => Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (auth.errorMessage != null) ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.error.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              auth.errorMessage!,
                              style: const TextStyle(
                                color: AppColors.error,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                        ],
                        AppButton(
                          label: 'Create Account',
                          isLoading: auth.isLoading,
                          onPressed: _submit,
                        ),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _fade(int i, Widget child) {
    if (i >= _anims.length) return child;
    return Opacity(
      opacity: _anims[i].value.clamp(0.0, 1.0),
      child: Transform.translate(
        offset: Offset(0, (1 - _anims[i].value) * 16),
        child: child,
      ),
    );
  }
}
