
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/services/auth_service.dart';
import 'package:mobile_app/routes/app_pages.dart';

/// Middleware to protect routes that require authentication.
///
/// FIXED: Now correctly imports and uses the unified `AuthService` instead of
/// the deleted `AuthController`.
class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    // Find the global AuthService instance.
    final authService = Get.find<AuthService>();
    
    // If the user is not logged in, redirect to the login page.
    if (!authService.isLoggedIn) {
      return const RouteSettings(name: Routes.login);
    }
    
    // Otherwise, allow navigation.
    return null;
  }
}
