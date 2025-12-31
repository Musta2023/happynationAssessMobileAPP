import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/controllers/employee_assessments_controller.dart';
import 'package:mobile_app/pages/questionnaire/questionnaire_page.dart';

class EmployeeAssessmentsPage extends StatelessWidget {
  final EmployeeAssessmentsController _controller = Get.put(EmployeeAssessmentsController());

  EmployeeAssessmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Matches Main Screen background
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(strokeWidth: 3),
          );
        }

        if (_controller.assessments.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.assignment_turned_in_outlined, size: 80, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  'No assessments available.',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async => _controller.fetchAssessments(),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            itemCount: _controller.assessments.length,
            itemBuilder: (context, index) {
              final assessment = _controller.assessments[index];
              final isAnswered = assessment.isAnswered ?? false;

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    onTap: isAnswered 
                        ? null 
                        : () => Get.to(() => QuestionnairePage(assessmentId: assessment.id)),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          // 1. Icon Section
                          Container(
                            height: 56,
                            width: 56,
                            decoration: BoxDecoration(
                              color: isAnswered 
                                  ? Colors.green.withValues(alpha: 0.1) 
                                  : theme.colorScheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              isAnswered ? Icons.check_rounded : Icons.pending_actions_rounded,
                              color: isAnswered ? Colors.green : theme.colorScheme.primary,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          
                          // 2. Text Content Section
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  assessment.title,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1A202C),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  assessment.description ?? 'Tap to start this assessment',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // 3. Status Badge Section
                          const SizedBox(width: 8),
                          _buildStatusBadge(isAnswered, theme),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  // Helper Widget for the Status Badge
  Widget _buildStatusBadge(bool isAnswered, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isAnswered ? Colors.green.withValues(alpha: 0.1) : Colors.blue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: isAnswered 
        ? const Icon(Icons.check_circle, color: Colors.green, size: 20)
        : Icon(Icons.arrow_forward_ios_rounded, color: theme.colorScheme.primary, size: 14),
    );
  }
}
