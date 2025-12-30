import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/routes/app_pages.dart';
import 'package:mobile_app/services/auth_service.dart';

class EmployeeDrawer extends StatelessWidget {
  const EmployeeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Get.find<AuthService>();
    final user = authService.user; // Get the authenticated user

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(user?.fullName ?? 'Employee Name'), // Display user's full name
            accountEmail: Text(user?.email ?? 'employee@example.com'), // Display user's email
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 50, color: Colors.blue), // Profile icon
            ),
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.quiz),
            title: const Text('Questionnaire'),
            onTap: () {
              Get.back(); // Close the drawer
              Get.offAllNamed(Routes.questionnaire); // Navigate to questionnaire
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('My History'),
            onTap: () {
              Get.back(); // Close the drawer
              Get.toNamed(Routes.history); // Navigate to history page
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Get.back(); // Close the drawer
              authService.logout(); // Perform logout
            },
          ),
        ],
      ),
    );
  }
}
