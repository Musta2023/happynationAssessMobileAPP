// mobile_app/lib/styles/dashboard_styles.dart
import 'package:flutter/material.dart';

class DashboardStyles {
  // Consistent border radius for cards and containers
  static const BorderRadius cardBorderRadius = BorderRadius.all(Radius.circular(24.0));
  static const double cardBorderRadiusValue = 24.0;

  // Consistent box shadow for elevation effect
  static const List<BoxShadow> cardBoxShadow = [
    BoxShadow(
      color: Color(0x1A000000), // 10% black, subtle shadow
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
  ];

  // Decoration for custom cards (replaces Flutter's Card widget)
  static BoxDecoration cardDecoration({Color? color}) {
    return BoxDecoration(
      color: color ?? Colors.white,
      borderRadius: cardBorderRadius,
      boxShadow: cardBoxShadow,
    );
  }

  // Text styles (can be integrated with Theme.of(context).textTheme later)
  static TextStyle headlineStyle(BuildContext context) => Theme.of(context).textTheme.headlineSmall!.copyWith(
    fontWeight: FontWeight.bold,
    color: Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle titleStyle(BuildContext context) => Theme.of(context).textTheme.titleLarge!.copyWith(
    fontWeight: FontWeight.bold,
    color: Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle subtitleStyle(BuildContext context) => Theme.of(context).textTheme.titleMedium!.copyWith(
    fontWeight: FontWeight.bold,
  );

  static TextStyle bodyStyle(BuildContext context) => Theme.of(context).textTheme.bodyMedium!.copyWith(
    color: Theme.of(context).colorScheme.onSurfaceVariant,
  );
}
