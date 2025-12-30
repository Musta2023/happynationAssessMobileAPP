import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/models/analysis_result.dart';
import 'package:mobile_app/main.dart'; // Import AppColors

class ResultsPage extends StatelessWidget {
  ResultsPage({super.key});

  Color _riskColor(String risk) {
    switch (risk.toLowerCase()) {
      case 'high':
        return AppColors.statusHigh;   // Green
      case 'medium':
        return AppColors.statusMedium; // Blue
      case 'low':
        return AppColors.statusLow;    // Red
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AnalysisResult result = AnalysisResult.fromJson(Get.arguments as Map<String, dynamic>);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assessment Results'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(), // Go back to the previous page
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: ListTile(
                title: const Text('Global Score'),
                trailing: Text('${result.globalScore}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('Risk Level'),
                trailing: Text(
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
            const Text('Category Scores', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Card(
              child: Column(
                children: [
                  ListTile(title: const Text('Stress'), trailing: Text('${result.stressScore}')),
                  ListTile(title: const Text('Motivation'), trailing: Text('${result.motivationScore}')),
                  ListTile(title: const Text('Satisfaction'), trailing: Text('${result.satisfactionScore}')),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text('AI Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(result.summary),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Recommendations', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...result.recommendations.map((rec) => Card(child: ListTile(title: Text(rec)))),
            const SizedBox(height: 32),
            // Removed Back to Home button, navigation handled by bottom nav
          ],
        ),
      ),
    );
  }
}
