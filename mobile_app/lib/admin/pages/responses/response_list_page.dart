import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:mobile_app/admin/controllers/admin_response_controller.dart';
import 'package:mobile_app/routes/app_pages.dart';

/// A page that lists all user responses for the admin.
///
/// FIXED: Imported `intl` package to fix `DateFormat` error.
class ResponseListPage extends StatelessWidget {
  const ResponseListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminResponseController controller = Get.put(AdminResponseController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Responses'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: controller.responses.length,
          itemBuilder: (context, index) {
            final response = controller.responses[index];
            return ListTile(
              title: Text('Response by: ${response.user?.fullName ?? 'Unknown User'}'),
              subtitle: Text(
                // Use DateFormat to format the date
                'Submitted: ${DateFormat.yMd().format(response.submittedAt)}'
              ),
              onTap: () {
                // Navigate to detail page
                Get.toNamed(Routes.adminResponseDetail, arguments: response);
              },
            );
          },
        );
      }),
    );
  }
}