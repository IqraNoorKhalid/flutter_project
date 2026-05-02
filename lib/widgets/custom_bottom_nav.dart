// lib/widgets/custom_bottom_nav.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/constants/app_strings.dart';
import '../core/constants/app_colors.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
  });

  void _go(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/lists');
        break;
      case 2:
        context.go('/shop');
        break;
      case 3:
        context.go('/tracker');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      elevation: 8,
      shadowColor: AppColors.shadow,
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: NavigationBar(
          height: 68,
          selectedIndex: currentIndex,
          onDestinationSelected: (i) => _go(context, i),
          backgroundColor: scheme.surface,
          surfaceTintColor: scheme.surfaceTint,
          indicatorColor: scheme.primaryContainer,
          shadowColor: Colors.transparent,
          elevation: 0,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, color: scheme.onSurfaceVariant),
              selectedIcon: Icon(Icons.home_rounded, color: scheme.primary),
              label: AppStrings.home,
            ),
            NavigationDestination(
              icon: Icon(Icons.checklist_rtl_rounded, color: scheme.onSurfaceVariant),
              selectedIcon: Icon(Icons.checklist_rtl_rounded, color: scheme.primary),
              label: AppStrings.lists,
            ),
            NavigationDestination(
              icon: Icon(Icons.storefront_outlined, color: scheme.onSurfaceVariant),
              selectedIcon: Icon(Icons.storefront_rounded, color: scheme.primary),
              label: AppStrings.shop,
            ),
            NavigationDestination(
              icon: Icon(Icons.show_chart_rounded, color: scheme.onSurfaceVariant),
              selectedIcon: Icon(Icons.trending_up_rounded, color: scheme.primary),
              label: AppStrings.tracker,
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded, color: scheme.onSurfaceVariant),
              selectedIcon: Icon(Icons.person_rounded, color: scheme.primary),
              label: AppStrings.profile,
            ),
          ],
        ),
      ),
    );
  }
}
