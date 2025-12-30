import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/services/auth_service.dart';

/// Middleware to protect routes based on user role.
class RoleMiddleware extends GetMiddleware {
  final String requiredRole;

  RoleMiddleware(this.requiredRole);

  @override
  int? get priority => 2;

  @override
  RouteSettings? redirect(String? route) {
    final authService = Get.find<AuthService>();

    if (!authService.isLoggedIn || authService.userRole != requiredRole) {
      // If user is not logged in or doesn't have the required role,
      // redirect them to their default page.
      return RouteSettings(name: authService.getInitialRoute());
    }

    return null;
  }
}
