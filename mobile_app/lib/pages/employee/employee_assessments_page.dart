import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/controllers/employee_assessments_controller.dart';
import 'package:mobile_app/pages/questionnaire/questionnaire_page.dart';

class EmployeeAssessmentsPage extends StatelessWidget {
  final EmployeeAssessmentsController _controller = Get.put(EmployeeAssessmentsController());

  EmployeeAssessmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_controller.assessments.isEmpty) {
          return const Center(child: Text('No assessments available.'));
        }
        return ListView.builder(
          itemCount: _controller.assessments.length,
          itemBuilder: (context, index) {
            final assessment = _controller.assessments[index];
            final isAnswered = assessment.isAnswered ?? false;
            return ListTile(
              title: Text(assessment.title),
              subtitle: Text(assessment.description ?? ''),
              trailing: isAnswered
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : const Icon(Icons.keyboard_arrow_right),
              onTap: isAnswered
                  ? null
                  : () {
                      // Navigate to QuestionnairePage with assessment id
                      Get.to(() => QuestionnairePage(assessmentId: assessment.id));
                    },
            );
          },
        );
      }),
    );
  }
}
