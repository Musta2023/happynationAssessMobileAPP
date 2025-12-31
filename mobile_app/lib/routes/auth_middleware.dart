import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/services/auth_service.dart';
import 'package:mobile_app/routes/app_pages.dart';

/// AuthMiddleware: The "Security Guard" of your application
/// It prevents unauthenticated users from accessing protected Pro UI pagess 
class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    // 1. Get the AuthService instance
    final authService = Get.find<AuthService>();
    
    // 2. Security Check: If the user is NOT logged in, send them to Login
    if (!authService.isLoggedIn) {
     
      
      return const RouteSettings(name: Routes.login);
    }
    
    // 3. Success: Allow them to see the beautiful Pro UI
    return null;
  }
}
