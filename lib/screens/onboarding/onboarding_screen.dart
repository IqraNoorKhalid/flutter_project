// lib/screens/onboarding/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_sizes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _page = 0;

  static const _pages = [
    _OnboardPageData(
      icon: Icons.storefront_rounded,
      title: 'Browse like a pro',
      subtitle: 'Categories, deals, and smart search — all in one place.',
      colors: [AppColors.heroStart, AppColors.heroEnd],
    ),
    _OnboardPageData(
      icon: Icons.compare_arrows_rounded,
      title: 'Compare & track',
      subtitle: 'See store prices side by side and follow trends over time.',
      colors: [AppColors.accentIndigo, Color(0xFF283593)],
    ),
    _OnboardPageData(
      icon: Icons.savings_rounded,
      title: 'Save on every trip',
      subtitle: 'Lists, alerts, and your cart — tuned for real grocery runs.',
      colors: [AppColors.secondary, AppColors.secondaryDark],
    ),
  ];

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);
    if (!mounted) return;
    context.go('/home');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _finish,
                child: const Text(AppStrings.skip),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (context, index) {
                  final p = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: p.colors,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: p.colors.first.withValues(alpha: 0.45),
                                blurRadius: 32,
                                offset: const Offset(0, 16),
                              ),
                            ],
                          ),
                          child: Icon(p.icon, size: 88, color: Colors.white),
                        ),
                        const SizedBox(height: AppSizes.xxl),
                        Text(
                          p.title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: AppSizes.md),
                        Text(
                          p.subtitle,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppColors.textSecondary,
                                height: 1.4,
                              ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: _page == i ? 28 : 8,
                  decoration: BoxDecoration(
                    color: _page == i ? AppColors.primary : AppColors.divider,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.lg),
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSizes.lg, 0, AppSizes.lg, AppSizes.lg),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    if (_page < _pages.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeOutCubic,
                      );
                    } else {
                      _finish();
                    }
                  },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
                  ),
                  child: Text(_page < _pages.length - 1 ? AppStrings.next : AppStrings.getStarted),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardPageData {
  const _OnboardPageData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.colors,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> colors;
}
