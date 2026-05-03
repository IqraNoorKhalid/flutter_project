// lib/widgets/site_page_header.dart
import 'package:flutter/material.dart';
import '../core/layout/app_layout.dart';
import '../core/constants/app_sizes.dart';

/// Shared “site chrome”: brand accent stripe + surface header + bottom divider.
/// Use on scroll pages instead of one-off gradient heroes so every screen matches.
class SitePageHeader extends StatelessWidget {
  const SitePageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing = const [],
    this.bottom,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget> trailing;
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final top = MediaQuery.paddingOf(context).top;
    final gutter = AppLayout.pageGutter(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ColoredBox(
          color: scheme.primary,
          child: const SizedBox(height: 3, width: double.infinity),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: scheme.surface,
            border: Border(
              bottom: BorderSide(
                color: scheme.outlineVariant.withValues(alpha: 0.65),
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: scheme.shadow.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(gutter, top + AppSizes.md, gutter, AppSizes.md),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: AppLayout.maxContentWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (leading != null) ...[
                          leading!,
                          const SizedBox(width: AppSizes.sm),
                        ],
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.4,
                                      color: scheme.onSurface,
                                    ),
                              ),
                              if (subtitle != null && subtitle!.isNotEmpty) ...[
                                const SizedBox(height: 6),
                                Text(
                                  subtitle!,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: scheme.onSurfaceVariant,
                                        height: 1.35,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        if (trailing.isNotEmpty)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: trailing,
                          ),
                      ],
                    ),
                    if (bottom != null) ...[
                      const SizedBox(height: AppSizes.md),
                      bottom!,
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
