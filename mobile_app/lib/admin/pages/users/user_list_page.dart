import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/admin/controllers/user_controller.dart';
import 'package:mobile_app/main.dart'; // For AppColors

class AdminUserListPage extends StatelessWidget {
  const AdminUserListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject the UserController
    final UserController controller = Get.put(UserController());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back(); // Using GetX navigation for consistency
          },
        ),
        title: const Text('Manage Users'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        if (controller.users.isEmpty) {
          return const Center(child: Text('No users found.'));
        }

        return ListView.builder(
          itemCount: controller.users.length,
          itemBuilder: (context, index) {
            final user = controller.users[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(user.fullName),
                subtitle: Text(user.email),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: AppColors.danger),
                  onPressed: () {
                    Get.defaultDialog(
                      title: 'Delete User',
                      middleText: 'Are you sure you want to delete ${user.fullName}?',
                      textConfirm: 'Delete',
                      textCancel: 'Cancel',
                      confirmTextColor: Colors.white,
                      buttonColor: AppColors.danger,
                      onConfirm: () {
                        Get.back(); // Close the dialog
                        controller.deleteUser(user.id);
                      },
                      onCancel: () {
                        Get.back(); // Close the dialog
                        Get.snackbar(
                          'Cancelled',
                          'Deletion cancelled for ${user.fullName}',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppColors.info,
                          colorText: Colors.white,
                        );
                      },
                    );
                  },
                ),
                onTap: () {
                  // This onTap can be used for viewing user details if implemented later
                  // For now, we prioritize the delete functionality.
                },
              ),
            );
          },
        );
      }),
    );
  }
}
