// mobile_app/lib/widgets/shared/custom_chart_card.dart
import 'package:flutter/material.dart';
import 'package:mobile_app/styles/dashboard_styles.dart';

class CustomChartCard extends StatelessWidget {
  final String title;
  final Widget chartWidget;
  final double height;

  const CustomChartCard({
    super.key,
    required this.title,
    required this.chartWidget,
    this.height = 250, // Default height for charts
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: DashboardStyles.cardDecoration(), // Use custom decoration
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: DashboardStyles.subtitleStyle(context), // Use consistent subtitle style
          ),
          const SizedBox(height: 16.0),
          SizedBox(
            height: height,
            child: chartWidget,
          ),
        ],
      ),
    );
  }
}
