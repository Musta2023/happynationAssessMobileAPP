import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/api/api_client.dart';
import 'package:mobile_app/models/user.dart';
import 'package:mobile_app/services/auth_service.dart';
import 'package:mobile_app/main.dart'; // Import AppColors

/// Controller for the Admin Login screen.
///
/// FIXED: Now uses the enhanced ApiClient for making the login request,
/// rather than using dio directly. This cleans up the code and centralizes logic.
class AdminAuthController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();
  final AuthService _authService = Get.find<AuthService>();
  
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var isLoading = false.obs;

  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      try {
        final response = await _apiClient.adminLogin(
          email: emailController.text,
          password: passwordController.text,
        );
        // On success, save the admin token and user, then navigate.
        final token = response.data['token'];
        final user = User.fromJson(response.data['user']);
        await _authService.saveTokenAndUser(token, user);

        Get.offAllNamed(_authService.getInitialRoute());
      } on DioException catch (e) {
        // Show an error message on failure.
        Get.snackbar(
          'Error',
          e.response?.data['message'] ?? e.response?.data['error'] ?? 'Login failed',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.danger, // Use AppColors.danger
          colorText: Colors.white,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}