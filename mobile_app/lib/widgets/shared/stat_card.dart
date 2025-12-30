// lib/widgets/shared/stat_card.dart
import 'package:flutter/material.dart';
import 'package:mobile_app/styles/dashboard_styles.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData? icon;
  final Color? color;
  final Color? textColor;
  final double width;
  final String? trend;
  final Color? trendColor;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.icon,
    this.color,
    this.textColor,
    this.width = 180,
    this.trend,
    this.trendColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardBackgroundColor = color ?? theme.colorScheme.surface;
    final cardTextColor = textColor ?? theme.colorScheme.onSurface;
    final actualTrendColor = trendColor ?? theme.colorScheme.onSurface;

    debugPrint('Building StatCard: $title. Width: $width, Background: $cardBackgroundColor, Text Color: $cardTextColor');

    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      decoration: DashboardStyles.cardDecoration(color: cardBackgroundColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: cardTextColor.withValues(alpha: 0.8),
              size: 24.0,
            ),
          ],
          Text(
            title,
            style: theme.textTheme.labelLarge?.copyWith(
              color: cardTextColor.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  value,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: cardTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              if (trend != null && trend!.isNotEmpty) ...[
                const SizedBox(width: 4.0),
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        trend!.startsWith('+') ? Icons.arrow_upward : Icons.arrow_downward,
                        color: actualTrendColor,
                        size: 14.0,
                      ),
                      const SizedBox(width: 2.0),
                      Flexible(
                        child: Text(
                          trend!,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: actualTrendColor,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
