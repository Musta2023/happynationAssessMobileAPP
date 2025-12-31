import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; 
import 'package:mobile_app/controllers/history_controller.dart';
import 'package:mobile_app/routes/app_pages.dart';
import 'package:mobile_app/main.dart'; // Import AppColors

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is initialized
    final HistoryController controller = Get.put(HistoryController());
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Professional light background
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(strokeWidth: 3),
          );
        }

        if (controller.historyList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history_toggle_off_rounded, size: 80, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  'No submission history found.',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your assessment results will appear here.',
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async => controller.fetchHistory(), // Assuming this method exists
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            itemCount: controller.historyList.length,
            itemBuilder: (context, index) {
              final history = controller.historyList[index];
              
              // Formatting the date nicely: e.g., "Oct 12, 2025"
              
              // Formatting the time: e.g., "14:30"
              final timeStr = history.createdAt != null 
                  ? DateFormat('HH:mm').format(history.createdAt!) 
                  : '';

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    onTap: () => Get.toNamed(Routes.historyDetail, arguments: history),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // 1. Date Circle Section
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  history.createdAt != null ? DateFormat('dd').format(history.createdAt!) : '?',
                                  style: TextStyle(
                                    fontSize: 20, 
                                    fontWeight: FontWeight.bold, 
                                    color: theme.colorScheme.primary
                                  ),
                                ),
                                Text(
                                  history.createdAt != null ? DateFormat('MMM').format(history.createdAt!).toUpperCase() : 'N/A',
                                  style: TextStyle(
                                    fontSize: 10, 
                                    fontWeight: FontWeight.w800, 
                                    color: theme.colorScheme.primary.withValues(alpha: 0.7)
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          
                          // 2. Middle Info Section
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Well-being Assessment",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.dark,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.access_time, size: 14, color: Colors.grey[400]),
                                    const SizedBox(width: 4),
                                    Text(
                                      "Submitted at $timeStr",
                                      style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          
                          // 3. Score/Arrow Section
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // If your history object has a score, display it here
                              // Text("${history.globalScore}%", style: ...), 
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.arrow_forward_ios_rounded, 
                                  size: 14, 
                                  color: AppColors.secondary
                                ),
                              ),
                            ],
                          ),
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
}
