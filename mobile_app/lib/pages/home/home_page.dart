import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/routes/app_pages.dart';
import 'package:mobile_app/services/auth_service.dart';

/// The main home page for a logged-in employee.
///
/// FIXED: The routes referenced here are now defined in `app_routes.dart`,
/// so this file should no longer have analysis errors.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Get.find<AuthService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authService.logout(),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Get.toNamed(Routes.questionnaire),
              child: const Text('Start Questionnaire'),
            ),
            ElevatedButton(
              onPressed: () => Get.toNamed(Routes.history),
              child: const Text('View History'),
            ),
          ],
        ),
      ),
    );
  }
}