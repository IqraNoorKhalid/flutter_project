// lib/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_router.dart';
import 'providers/theme_provider.dart';

class SmartCartApp extends ConsumerWidget {
  const SmartCartApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final router = AppRouter.createRouter(ref);

    return MaterialApp.router(
      title: 'SmartCart',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      ),
    );
  }
}