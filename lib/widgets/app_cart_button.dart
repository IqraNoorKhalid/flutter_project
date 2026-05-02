// lib/widgets/app_cart_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/cart_provider.dart';
import '../core/constants/app_colors.dart';

class AppCartButton extends ConsumerWidget {
  const AppCartButton({super.key, this.foregroundColor});

  final Color? foregroundColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(cartCountProvider);
    final iconColor = foregroundColor ?? Theme.of(context).colorScheme.onSurface;

    return IconButton(
      onPressed: () => context.push('/cart'),
      icon: Badge(
        isLabelVisible: count > 0,
        label: Text(
          count > 99 ? '99+' : '$count',
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.secondary,
        child: Icon(Icons.shopping_bag_outlined, color: iconColor),
      ),
    );
  }
}
