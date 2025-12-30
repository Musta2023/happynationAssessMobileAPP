// mobile_app/lib/widgets/shared/no_data_found_widget.dart
import 'package:flutter/material.dart';
import 'package:mobile_app/styles/dashboard_styles.dart';

class NoDataFoundWidget extends StatelessWidget {
  final String message;
  final IconData icon;

  const NoDataFoundWidget({
    super.key,
    this.message = 'No data available at the moment.',
    this.icon = Icons.info_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: DashboardStyles.subtitleStyle(context).copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
