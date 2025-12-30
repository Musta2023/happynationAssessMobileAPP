import 'package:get/get.dart';
import 'package:mobile_app/api/api_client.dart';
import 'package:mobile_app/models/user.dart';
import 'package:mobile_app/services/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; 
import 'package:shared_preferences/shared_preferences.dart'; 

import 'dart:math'; 

void main() async {
  await Get.putAsync(() async => const FlutterSecureStorage());
  await Get.putAsync(() async => SharedPreferences.getInstance());
  await Get.putAsync(() async => AuthService());
  await Get.putAsync(() async => ApiClient());

  final ApiClient apiClient = Get.find<ApiClient>();
  final AuthService authService = Get.find<AuthService>();

  final String uniqueEmail = 'test_user_${Random().nextInt(100000)}@example.com';
  const String password = 'Password123!';
  const String firstName = 'Test';
  const String lastName = 'User';
  const String department = 'Testing';

  try {
    final registerResponse = await apiClient.register(
      firstName: firstName,
      lastName: lastName,
      email: uniqueEmail,
      password: password,
      passwordConfirmation: password,
      department: department,
    );

    if (registerResponse.statusCode == 200 || registerResponse.statusCode == 201) {
      final String? token = registerResponse.data['token'];
      final user = User.fromJson(registerResponse.data['user']);
      if (token != null) {
        await authService.saveTokenAndUser(token, user);
      }
    }
  } catch (e) {
    //
  }

  try {
    final loginResponse = await apiClient.login(
      email: uniqueEmail,
      password: password,
    );

    if (loginResponse.statusCode == 200) {
      final String? token = loginResponse.data['token'];
      final user = User.fromJson(loginResponse.data['user']);
      if (token != null) {
        await authService.saveTokenAndUser(token, user);
      }
    }
  } catch (e) {
    //
  }
}
