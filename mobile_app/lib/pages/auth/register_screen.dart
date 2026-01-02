import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/api/api_client.dart';
import 'package:mobile_app/models/user.dart';
import 'package:mobile_app/widgets/shared/back_and_home_buttons.dart';
import 'package:mobile_app/services/auth_service.dart';
import 'package:mobile_app/main.dart'; // Import AppColors
import 'validators.dart';

/// The primary user registration screen.
///
/// FIXED: Updated to use the unified ApiClient and AuthService.
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final ApiClient _apiClient = Get.find<ApiClient>();
  final AuthService _authService = Get.find<AuthService>();

  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();
  final _departmentController = TextEditingController();

  var isLoading = false.obs;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    isLoading.value = true;
    try {
      final response = await _apiClient.register(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        passwordConfirmation: _passwordConfirmationController.text,
        department: _departmentController.text.trim(),
      );

      // Extract token and user, then save
      final token = response.data['token'];
      final user = User.fromJson(response.data['user']);
      await _authService.saveTokenAndUser(token, user);

      // Navigate based on role
      Get.offAllNamed(_authService.getInitialRoute());
      Get.snackbar('Success', 'Registration successful!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.success, // Use AppColors.success
          colorText: Colors.white,
      );

    } on DioException catch (e) {
      String errorMessage = 'An unknown error occurred.';
      if (e.response?.data != null && e.response!.data is Map) {
        final Map<String, dynamic> errorData = e.response!.data;
        if (errorData.containsKey('message') && errorData['message'] is Map) {
          errorMessage = (errorData['message'] as Map).values.expand((errors) => errors).join('\n');
        } else if (errorData.containsKey('message') && errorData['message'] is String) {
          errorMessage = errorData['message'];
        }
      }
      Get.snackbar(
        'Registration Failed',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.danger, // Use AppColors.danger
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
        automaticallyImplyLeading: false,
        actions: const [
          BackAndHomeButtons(showHomeButton: false),
        ],
      ),
      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(labelText: 'First Name'),
                  validator: FormValidators.validateNotEmpty,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(labelText: 'Last Name'),
                  validator: FormValidators.validateNotEmpty,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: FormValidators.validateEmail,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: FormValidators.validatePassword,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordConfirmationController,
                  decoration: const InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                  validator: (value) => FormValidators.validatePasswordConfirmation(
                    value, _passwordController.text,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _departmentController,
                  decoration: const InputDecoration(labelText: 'Department'),
                  validator: FormValidators.validateNotEmpty,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: isLoading.value ? null : _submit,
                  child: isLoading.value
                      ? const CircularProgressIndicator()
                      : const Text('Register'),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}