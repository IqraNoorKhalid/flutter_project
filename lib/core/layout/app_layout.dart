// lib/core/layout/app_layout.dart
import 'package:flutter/material.dart';
import '../constants/app_sizes.dart';

/// Web-style centered column and horizontal gutters for every page.
class AppLayout {
  AppLayout._();

  static const double maxContentWidth = 720;

  /// Side inset: on narrow screens [AppSizes.md]; on wide screens centers a [maxContentWidth] column.
  static double pageGutter(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w <= maxContentWidth) return AppSizes.md;
    return (w - maxContentWidth) / 2;
  }

  static EdgeInsets pagePadding(BuildContext context) {
    return EdgeInsets.symmetric(horizontal: pageGutter(context));
  }

  static EdgeInsets pagePaddingWith({
    required BuildContext context,
    double top = 0,
    double bottom = 0,
  }) {
    final g = pageGutter(context);
    return EdgeInsets.fromLTRB(g, top, g, bottom);
  }

  /// Wraps [child] in a centered column capped at [maxContentWidth] (plus optional extra horizontal [pad]).
  static Widget constrainBody({
    required BuildContext context,
    required Widget child,
    double extraHorizontal = 0,
  }) {
    final g = pageGutter(context) + extraHorizontal;
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: maxContentWidth),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: g > AppSizes.md ? 0 : AppSizes.md),
          child: child,
        ),
      ),
    );
  }
}
