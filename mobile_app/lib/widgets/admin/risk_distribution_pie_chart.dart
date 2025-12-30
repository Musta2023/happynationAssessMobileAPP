import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// A Material 3 designed pie chart to show risk distribution.
class RiskDistributionPieChart extends StatelessWidget {
  final int lowRiskCount;
  final int mediumRiskCount;
  final int highRiskCount;

  const RiskDistributionPieChart({
    super.key,
    required this.lowRiskCount,
    required this.mediumRiskCount,
    required this.highRiskCount,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final total = lowRiskCount + mediumRiskCount + highRiskCount;

    if (total == 0) {
      return const Center(child: Text('No risk data available.'));
    }

    return PieChart(
      PieChartData(
        sectionsSpace: 4,
        centerSpaceRadius: 40,
        startDegreeOffset: -90,
        sections: [
          _buildSection(
            value: lowRiskCount.toDouble(),
            title: '${((lowRiskCount / total) * 100).toStringAsFixed(0)}%',
            color: Colors.green,
            context: context,
          ),
          _buildSection(
            value: mediumRiskCount.toDouble(),
            title: '${((mediumRiskCount / total) * 100).toStringAsFixed(0)}%',
            color: Colors.orange,
            context: context,
          ),
          _buildSection(
            value: highRiskCount.toDouble(),
            title: '${((highRiskCount / total) * 100).toStringAsFixed(0)}%',
            color: colorScheme.error,
            context: context,
          ),
        ],
      ),
    );
  }

  PieChartSectionData _buildSection({
    required double value,
    required String title,
    required Color color,
    required BuildContext context,
  }) {
    return PieChartSectionData(
      value: value,
      title: title,
      color: color,
      radius: 60,
      titleStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
    );
  }
}
