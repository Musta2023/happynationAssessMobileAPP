import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/models/admin_dashboard_models.dart';
import 'package:mobile_app/widgets/shared/back_and_home_buttons.dart';
import 'package:mobile_app/main.dart'; // Import AppColors

class AdminResponseDetailPage extends StatelessWidget {
  final EmployeeResponse response;

  AdminResponseDetailPage({super.key}) : response = Get.arguments as EmployeeResponse;

  Color _riskColor(String? risk) {
    switch (risk?.toLowerCase()) {
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
        automaticallyImplyLeading: false,
        actions: const [
          BackAndHomeButtons(),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: ListTile(
                title: const SelectableText('Global Score'),
                trailing: SelectableText('${response.globalScore}', style: Get.textTheme.headlineSmall),
              ),
            ),
            Card(
              child: ListTile(
                title: const SelectableText('Risk Level'),
                trailing: SelectableText(
                  response.riskLevel.toUpperCase(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _riskColor(response.riskLevel),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SelectableText('Category Scores', style: Get.textTheme.titleLarge),
            Card(
              child: Column(
                children: [
                  ListTile(title: const SelectableText('Stress'), trailing: SelectableText('${response.stressScore ?? 'N/A'}')),
                  ListTile(title: const SelectableText('Motivation'), trailing: SelectableText('${response.motivationScore ?? 'N/A'}')),
                  ListTile(title: const SelectableText('Satisfaction'), trailing: SelectableText('${response.satisfactionScore ?? 'N/A'}')),
                ],
              ),
            ),
            if (response.summary != null) ...[
              const SizedBox(height: 16),
              SelectableText('AI Summary', style: Get.textTheme.titleLarge),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SelectableText(response.summary!),
                ),
              ),
            ],
            if (response.recommendations != null && response.recommendations!.isNotEmpty) ...[
              const SizedBox(height: 16),
              SelectableText('Recommendations', style: Get.textTheme.titleLarge),
              ...response.recommendations!.map((rec) => Card(child: ListTile(title: SelectableText(rec)))),
            ],
          ],
        ),
      ),
    );
  }
}
