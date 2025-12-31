import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/controllers/history_controller.dart';
import 'package:intl/intl.dart'; // For date formatting

class HistoryPage extends StatelessWidget {
  final HistoryController _controller = Get.put(HistoryController());

  HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Assessment History'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        centerTitle: false,
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(strokeWidth: 3),
          );
        }

        if (_controller.responses.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history_toggle_off, size: 80, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  'No completed assessments yet.',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'Complete assessments to see your history here.',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async => _controller.fetchResponsesHistory(),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            itemCount: _controller.responses.length,
            itemBuilder: (context, index) {
              final response = _controller.responses[index];
              final assessmentTitle = response.assessment?.title ?? 'Unknown Assessment';
              final formattedDate = DateFormat('MMM d, yyyy HH:mm').format(response.createdAt);

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () {
                    // TODO: Navigate to Response Detail Page (Part of future task)
                    // Get.toNamed(Routes.responseDetail, arguments: response);
                    Get.snackbar(
                      'Details',
                      'Tap to view details for "$assessmentTitle" - will be implemented soon!',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          assessmentTitle,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Completed On: $formattedDate',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildScoreChip('Global Score', response.globalScore, theme),
                            _buildScoreChip('Risk Level', response.risk, theme, isRisk: true),
                          ],
                        ),
                      ],
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

  Widget _buildScoreChip(String label, dynamic value, ThemeData theme, {bool isRisk = false}) {
    Color chipColor;
    Color textColor = Colors.white;

    if (isRisk) {
      switch (value.toLowerCase()) {
        case 'low':
          chipColor = Colors.green;
          break;
        case 'medium':
          chipColor = Colors.orange;
          break;
        case 'high':
          chipColor = Colors.red;
          break;
        default:
          chipColor = Colors.grey;
          break;
      }
    } else {
      // For scores, a simple gradient or fixed color based on value (e.g., higher is better)
      if (value >= 70) {
        chipColor = Colors.green;
      } else if (value >= 40) {
        chipColor = Colors.orange;
      } else {
        chipColor = Colors.red;
      }
    }

    return Chip(
      label: Text(
        '$label: ${value.toString()}',
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
      ),
      backgroundColor: chipColor,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}