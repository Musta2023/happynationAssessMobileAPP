import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/models/analysis_result.dart';
import 'package:mobile_app/main.dart'; // Import AppColors

class HistoryDetailPage extends StatelessWidget {
  final AnalysisResult result;

  HistoryDetailPage({super.key}) : result = Get.arguments as AnalysisResult;

  Color _riskColor(String risk) {
    switch (risk.toLowerCase()) {
      case 'high':
        return AppColors.statusHigh;
      case 'medium':
        return AppColors.statusMedium;
      case 'low':
        return AppColors.statusLow;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assessment Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: ListTile(
                title: const SelectableText('Global Score'),
                trailing: SelectableText('${result.globalScore}', style: Get.textTheme.headlineSmall),
              ),
            ),
            Card(
              child: ListTile(
                title: const SelectableText('Risk Level'),
                trailing: SelectableText(
                  result.riskLevel.toUpperCase(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _riskColor(result.riskLevel),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SelectableText('Category Scores', style: Get.textTheme.titleLarge),
            Card(
              child: Column(
                children: [
                  ListTile(title: const SelectableText('Stress'), trailing: SelectableText('${result.stressScore}')),
                  ListTile(title: const SelectableText('Motivation'), trailing: SelectableText('${result.motivationScore}')),
                  ListTile(title: const SelectableText('Satisfaction'), trailing: SelectableText('${result.satisfactionScore}')),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SelectableText('AI Summary', style: Get.textTheme.titleLarge),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SelectableText(result.summary),
              ),
            ),
            const SizedBox(height: 16),
            SelectableText('Recommendations', style: Get.textTheme.titleLarge),
            ...result.recommendations.map((rec) => Card(child: ListTile(title: SelectableText(rec)))),
          ],
        ),
      ),
    );
  }
}
