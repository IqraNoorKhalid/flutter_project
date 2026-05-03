// lib/screens/splash/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/routes/app_router.dart';
import '../../core/layout/app_layout.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100));
    _scale = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _opacity = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
    _navigateNext();
  }

  Future<void> _navigateNext() async {
    await Future<void>.delayed(const Duration(milliseconds: 1600));
    if (!mounted) return;
    final prefs = await SharedPreferences.getInstance();
    final done = prefs.getBool('onboarding_done') ?? false;
    if (!mounted) return;
    context.go(done ? AppRouter.home : AppRouter.onboarding);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surfaceContainerLowest,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ColoredBox(
            color: scheme.primary,
            child: const SizedBox(height: 3),
          ),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: AppLayout.maxContentWidth),
                child: FadeTransition(
                  opacity: _opacity,
                  child: ScaleTransition(
                    scale: _scale,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 112,
                          height: 112,
                          decoration: BoxDecoration(
                            color: scheme.surface,
                            borderRadius: BorderRadius.circular(AppSizes.radiusXl),
                            border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.45)),
                            boxShadow: [
                              BoxShadow(
                                color: scheme.shadow.withValues(alpha: 0.12),
                                blurRadius: 28,
                                offset: const Offset(0, 14),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.shopping_basket_rounded,
                            size: 56,
                            color: scheme.primary,
                          ),
                        ),
                        const SizedBox(height: AppSizes.lg),
                        Text(
                          AppStrings.appName,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: scheme.onSurface,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                        ),
                        const SizedBox(height: AppSizes.sm),
                        Text(
                          AppStrings.tagline,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                        ),
                        const SizedBox(height: AppSizes.xxl),
                        SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: scheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
