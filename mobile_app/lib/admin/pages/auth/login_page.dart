import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/admin/controllers/admin_auth_controller.dart';

class AdminLoginPage extends StatelessWidget {
  final AdminAuthController _authController = Get.put(AdminAuthController());

  AdminLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _authController.formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _authController.emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) =>
                    value!.isEmpty ? 'Email is required' : null,
              ),
              TextFormField(
                controller: _authController.passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) =>
                    value!.isEmpty ? 'Password is required' : null,
              ),
              const SizedBox(height: 20),
              Obx(() => _authController.isLoading.value
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _authController.login,
                      child: const Text('Login'),
                    )),
            ],
          ),
        ),
      ),
    );
  }
}
