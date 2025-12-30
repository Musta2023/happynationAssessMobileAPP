import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:mobile_app/controllers/history_controller.dart';
import 'package:mobile_app/routes/app_pages.dart';
import 'package:mobile_app/services/auth_service.dart'; // Import AuthService

/// A page that lists the current user's submission history.
///
/// FIXED: Imported `intl` package to resolve `DateFormat` error.
class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final HistoryController controller = Get.put(HistoryController());
    final authService = Get.find<AuthService>(); // Find AuthService

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authService.logout(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.historyList.isEmpty) {
          return const Center(child: Text('You have no submission history.'));
        }
        return ListView.builder(
          itemCount: controller.historyList.length,
          itemBuilder: (context, index) {
            final history = controller.historyList[index];
            return ListTile(
              title: Text(
                // Use DateFormat to format the date
                'Submission from ${history.createdAt != null ? DateFormat.yMd().format(history.createdAt!) : 'N/A'}'
              ),
              onTap: () {
                Get.toNamed(Routes.historyDetail, arguments: history);
              },
            );
          },
        );
      }),
    );
  }
}