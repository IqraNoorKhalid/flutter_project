// lib/screens/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_sizes.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final err = await ref.read(authProvider.notifier).login(
          email: _emailCtrl.text,
          password: _passwordCtrl.text,
        );
    if (!mounted) return;
    setState(() => _loading = false);
    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
      return;
    }
    HapticFeedback.mediumImpact();
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(AppSizes.md, top + AppSizes.md, AppSizes.md, AppSizes.xl),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.heroStart, AppColors.heroEnd],
                ),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(AppSizes.radiusXl),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      if (context.canPop()) context.pop();
                    },
                    style: IconButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.white.withValues(alpha: 0.15),
                    ),
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  const SizedBox(height: AppSizes.md),
                  Text(
                    AppStrings.loginTitle,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  Text(
                    AppStrings.loginSubtitle,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          height: 1.35,
                        ),
                  ),
                  const SizedBox(height: AppSizes.lg),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.lock_person_rounded, size: 48, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.lg),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: AppStrings.email,
                        hintText: AppStrings.emailHint,
                        prefixIcon: Icon(Icons.mail_outline_rounded),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return AppStrings.fieldRequired;
                        if (!v.contains('@')) return AppStrings.invalidEmail;
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.md),
                    TextFormField(
                      controller: _passwordCtrl,
                      obscureText: _obscure,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submit(),
                      autofillHints: const [AutofillHints.password],
                      decoration: InputDecoration(
                        labelText: AppStrings.password,
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        suffixIcon: IconButton(
                          onPressed: () => setState(() => _obscure = !_obscure),
                          icon: Icon(_obscure ? Icons.visibility_rounded : Icons.visibility_off_rounded),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return AppStrings.fieldRequired;
                        if (v.length < 6) return AppStrings.passwordTooShort;
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.lg),
                    FilledButton(
                      onPressed: _loading ? null : _submit,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _loading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : Text(AppStrings.signIn),
                    ),
                    const SizedBox(height: AppSizes.md),
                    Text(
                      AppStrings.loginDemoHint,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: AppSizes.fontSizeSm, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
