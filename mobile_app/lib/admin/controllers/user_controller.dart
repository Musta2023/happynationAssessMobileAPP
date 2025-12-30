import 'package:get/get.dart';
import 'package:mobile_app/admin/services/user_service.dart';
import 'package:mobile_app/models/user.dart'; // Import the User model
import 'package:flutter/material.dart';

class UserController extends GetxController {
  final UserService _userService = Get.find<UserService>();
  var isLoading = true.obs;
  var users = <User>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  void fetchUsers() async {
    try {
      isLoading(true);
      var fetchedUsers = await _userService.getAllUsers();
      users.assignAll(fetchedUsers);
    } finally {
      isLoading(false);
    }
  }

  void deleteUser(int id) async {
    try {
      isLoading(true); // Show loading indicator
      await _userService.deleteUser(id);
      fetchUsers(); // Refresh the list after deletion
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete user: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false); // Hide loading indicator
    }
  }
}
