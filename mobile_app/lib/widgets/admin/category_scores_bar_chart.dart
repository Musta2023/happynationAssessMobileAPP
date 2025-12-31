// lib/widgets/admin/category_scores_bar_chart.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CategoryScoresBarChart extends StatelessWidget {
  final Map<String, double> categoryScores;

  static const double _chartAspectRatio = 1.7;
  static const double _maxScore = 100.0;
  static const double _barWidth = 20;
  static const double _barRadiusValue = 4;
  static const double _highScoreThreshold = 75.0;
  static const double _mediumScoreThreshold = 50.0;
  static const double _alphaValue = 0.3;
  static const double _reservedSize = 30;
  static const double _intervalValue = 20;
  static const double _leftTitlesReservedSize = 30;
  static const double _bottomSpacing = 8;
  static const double _gridAlpha = 0.1;
  static const double _gridStrokeWidth = 1;
  static const double _bottomTitlesFontSize = 11.0;
  static const double _leftTitlesFontSize = 10.0;
  static const bool _showGridData = true;
  static const bool _showGridBorder = false;
  static const bool _drawVerticalLine = false;

  const CategoryScoresBarChart({super.key, required this.categoryScores});

  @override
  Widget build(BuildContext context) {
    final categories = categoryScores.keys.toList();

    // Generate Bar Groups
    List<BarChartGroupData> barGroups = List.generate(categories.length, (i) {
      final score = categoryScores[categories[i]] ?? 0.0;
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: score,
            // Executive Design: Dynamic professional colors
            color: _getScoreColor(score, context),
            width: _barWidth,
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(_barRadiusValue)),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: _maxScore,
              color: Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest
                  .withValues(alpha: _alphaValue),
            ),
          ),
        ],
      );
    });

    return AspectRatio(
      aspectRatio: _chartAspectRatio,
      child: BarChart(
        BarChartData(
          maxY: _maxScore,
          barGroups: barGroups,
          alignment: BarChartAlignment.spaceAround,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (group) => Colors.blueGrey.shade800,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${categories[group.x]}\n',
                  const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: rod.toY.toStringAsFixed(1),
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ],
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: _reservedSize,
                getTitlesWidget: (double value, TitleMeta meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= categories.length) {
                    return const SizedBox();
                  }

                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: _bottomSpacing,
                    child: Text(
                      categories[index],
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.outline,
                        fontWeight: FontWeight.w600,
                        fontSize: _bottomTitlesFontSize,
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: _leftTitlesReservedSize,
                interval: _intervalValue,
                getTitlesWidget: (value, meta) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: _bottomSpacing,
                    child: Text(
                      value.toInt().toString(),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.outline,
                        fontSize: _leftTitlesFontSize,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          gridData: FlGridData(
            show: _showGridData,
            drawVerticalLine: _drawVerticalLine,
            horizontalInterval: _intervalValue,
            getDrawingHorizontalLine: (value) => FlLine(
              color:
                  Theme.of(context).dividerColor.withValues(alpha: _gridAlpha),
              strokeWidth: _gridStrokeWidth,
            ),
          ),
          borderData: FlBorderData(show: _showGridBorder),
        ),
      ),
    );
  }

  Color _getScoreColor(double score, BuildContext context) {
    if (score >= _highScoreThreshold) return Colors.teal;
    if (score >= _mediumScoreThreshold) {
      return Theme.of(context).colorScheme.primary;
    }
    return Colors.orange;
  }
}
