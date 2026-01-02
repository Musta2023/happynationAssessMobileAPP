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
      backgroundColor: const Color(0xFFF8F9FA),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(strokeWidth: 3));
        }

        if (_controller.assessments.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.assignment_turned_in_outlined, size: 80, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text('No assessments available.', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
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
              // Check if it's answered
              final bool isAnswered = assessment.isAnswered ?? false;

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
                    // If answered, clicking does nothing (or you could show a "Completed" message)
                    onTap: isAnswered 
                        ? () => Get.snackbar("Status", "You have already completed this assessment.") 
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
                              isAnswered ? Icons.task_alt_rounded : Icons.pending_actions_rounded,
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
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF1A202C),
                                    decoration: isAnswered ? TextDecoration.none : null,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  isAnswered ? "Assessment completed" : (assessment.description ?? 'Tap to start'),
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
                          _buildStatusBadge(isAnswered),
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

  // UPDATED: Better Status Badge with labels
  Widget _buildStatusBadge(bool isAnswered) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isAnswered ? Colors.green.withValues(alpha:0.1) : Colors.orange.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isAnswered ? Colors.green.withValues(alpha: 0.3) : Colors.orange.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isAnswered ? Icons.check_circle_outline : Icons.schedule,
            size: 14,
            color: isAnswered ? Colors.green : Colors.orange,
          ),
          const SizedBox(width: 4),
          Text(
            isAnswered ? "Answered" : "Open",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isAnswered ? Colors.green : Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}
