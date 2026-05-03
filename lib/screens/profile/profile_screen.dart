// lib/screens/profile/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/theme_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/lists_provider.dart';
import '../../providers/products_provider.dart';
import '../../services/app_local_storage.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_sizes.dart';
import '../../widgets/custom_bottom_nav.dart';
import '../../widgets/store_badge.dart';
import '../../core/layout/app_layout.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _notificationsEnabled = true;
  final List<String> _preferredStores = ['Metro Store', 'CarreFour', 'Al-Fatah'];

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;
    final scheme = Theme.of(context).colorScheme;
    final session = ref.watch(authProvider);
    final displayName = session?.displayName ?? AppStrings.guestUser;
    final emailLine = session?.email ?? AppStrings.guestSubtitle;

    return Scaffold(
      backgroundColor: scheme.surfaceContainerLowest,
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: scheme.surface,
            surfaceTintColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                AppStrings.profile,
                style: TextStyle(
                  color: scheme.onSurface,
                  fontWeight: FontWeight.w800,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  ColoredBox(color: scheme.surface),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 3,
                    child: ColoredBox(color: scheme.primary),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      padding: EdgeInsets.only(
                        bottom: 56,
                        left: AppLayout.pageGutter(context),
                        right: AppLayout.pageGutter(context),
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: scheme.outlineVariant.withValues(alpha: 0.65),
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: scheme.primaryContainer.withValues(alpha: 0.5),
                            ),
                            child: CircleAvatar(
                              radius: 36,
                              backgroundColor: scheme.surface,
                              child: session == null
                                  ? Icon(
                                      Icons.person_rounded,
                                      size: 40,
                                      color: scheme.primary,
                                    )
                                  : Text(
                                      session.displayName.isNotEmpty
                                          ? session.displayName[0].toUpperCase()
                                          : '?',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: scheme.primary,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(width: AppSizes.md),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  displayName,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: scheme.onSurface,
                                  ),
                                ),
                                Text(
                                  emailLine,
                                  style: TextStyle(
                                    fontSize: AppSizes.fontSizeMd,
                                    color: scheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppLayout.pageGutter(context),
                AppSizes.md,
                AppLayout.pageGutter(context),
                AppSizes.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.account,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  Card(
                    child: session == null
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                contentPadding: const EdgeInsets.fromLTRB(
                                  AppSizes.md,
                                  AppSizes.md,
                                  AppSizes.md,
                                  AppSizes.sm,
                                ),
                                leading: CircleAvatar(
                                  backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                                  child: const Icon(Icons.person_outline_rounded, color: AppColors.primary),
                                ),
                                title: const Text(AppStrings.guestUser),
                                subtitle: const Text(AppStrings.guestSubtitle),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(AppSizes.md, 0, AppSizes.md, AppSizes.md),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: FilledButton(
                                    onPressed: () => context.push('/login'),
                                    child: const Text(AppStrings.signIn),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                                  child: Text(
                                    session.displayName.isNotEmpty
                                        ? session.displayName[0].toUpperCase()
                                        : '?',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                                title: Text(session.displayName),
                                subtitle: Text(session.email),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(AppSizes.md, 0, AppSizes.md, AppSizes.md),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    onPressed: () => _confirmLogout(context),
                                    icon: const Icon(Icons.logout_rounded),
                                    label: const Text(AppStrings.signOut),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                  const SizedBox(height: AppSizes.lg),
                  Text(
                    AppStrings.preferredStores,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  Wrap(
                    spacing: AppSizes.sm,
                    runSpacing: AppSizes.sm,
                    children: _preferredStores.map((store) {
                      return StoreBadge(
                        text: store,
                        color: AppColors.primary.withValues(alpha: 0.12),
                        textColor: AppColors.primary,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: AppSizes.lg),
                  Text(
                    AppStrings.settings,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.currency_rupee_rounded, color: scheme.primary),
                          title: const Text(AppStrings.currency),
                          trailing: const Text('PKR'),
                          onTap: () {},
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: Icon(Icons.language_rounded, color: scheme.primary),
                          title: const Text(AppStrings.language),
                          trailing: const Text('English'),
                          onTap: () {},
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: Icon(Icons.dark_mode_rounded, color: scheme.primary),
                          title: const Text(AppStrings.darkMode),
                          trailing: Switch(
                            value: isDarkMode,
                            onChanged: (_) {
                              ref.read(themeProvider.notifier).toggleTheme();
                            },
                          ),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: Icon(Icons.notifications_active_rounded, color: scheme.primary),
                          title: const Text(AppStrings.notificationsEnabled),
                          trailing: Switch(
                            value: _notificationsEnabled,
                            onChanged: (value) {
                              setState(() {
                                _notificationsEnabled = value;
                              });
                            },
                          ),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.delete_forever_rounded, color: AppColors.error),
                          title: const Text(
                            AppStrings.clearAllData,
                            style: TextStyle(color: AppColors.error),
                          ),
                          onTap: () => _showClearDataDialog(context),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: Icon(Icons.info_outline_rounded, color: scheme.primary),
                          title: const Text(AppStrings.about),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSizes.lg),
                  const Center(
                    child: Text(
                      AppStrings.version,
                      style: TextStyle(
                        fontSize: AppSizes.fontSizeSm,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.xxl),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 4),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.signOut),
        content: const Text(AppStrings.logoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text(AppStrings.loggedOut)),
                );
              }
            },
            child: const Text(AppStrings.signOut),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(AppStrings.clearDataConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () async {
              await AppLocalStorage.clearAll();
              ref.read(listsProvider.notifier).resetToDummy();
              ref.read(productsProvider.notifier).resetToDummy();
              if (context.mounted) Navigator.pop(context);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All data cleared')),
                );
              }
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
