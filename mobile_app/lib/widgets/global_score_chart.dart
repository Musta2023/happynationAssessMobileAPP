import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GlobalScoreChart extends StatelessWidget {
  final double globalScore;

  const GlobalScoreChart({super.key, required this.globalScore});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  value: globalScore,
                  color: Theme.of(context).colorScheme.primary,
                  radius: 50,
                  showTitle: false,
                ),
                PieChartSectionData(
                  value: 100 - globalScore,
                  color: Colors.grey.shade300,
                  radius: 50,
                  showTitle: false,
                ),
              ],
              startDegreeOffset: -90,
              sectionsSpace: 0,
              centerSpaceRadius: 40,
            ),
          ),
          Text(
            '${globalScore.toStringAsFixed(1)}%',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      ),
    );
  }
}
