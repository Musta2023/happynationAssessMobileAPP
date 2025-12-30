import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/models/response_history.dart';
 // Import AppColors
import 'package:mobile_app/services/auth_service.dart'; // Import AuthService
import 'package:intl/intl.dart'; // Import the intl package

class AdminResponseDetailPage extends StatelessWidget {
  const AdminResponseDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    // The response object should be passed as arguments
    final ResponseHistory? response = Get.arguments as ResponseHistory?;

    if (response == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Response Detail')),
        body: const Center(child: Text('Response data not found.')),
      );
    }

    final AuthService authService = Get.find<AuthService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Response Detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authService.logout(),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User: ${response.user?.fullName ?? 'Unknown User'}',
                      style: Get.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Email: ${response.user?.email ?? 'N/A'}',
                      style: Get.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Submitted: ${DateFormat.yMd().add_Hms().format(response.submittedAt)}',
                      style: Get.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Global Score: ${response.globalScore}',
              style: Get.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8.0),
            Text(
              'Risk Level: ${response.risk ?? 'N/A'}',
              style: Get.textTheme.headlineSmall,
            ),
            
          ],
        ),
      ),
    );
  }
}
