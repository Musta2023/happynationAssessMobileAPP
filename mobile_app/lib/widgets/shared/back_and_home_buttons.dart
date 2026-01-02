import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/services/auth_service.dart';
import 'package:mobile_app/routes/app_pages.dart';

class BackAndHomeButtons extends StatelessWidget {
  final bool showHomeButton;

  const BackAndHomeButtons({super.key, this.showHomeButton = true});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Get.find<AuthService>();

    void goToHome() {
      final role = authService.userRole;
      if (role == 'admin') {
        Get.offAllNamed(Routes.adminDashboard);
      } else {
        Get.offAllNamed(Routes.employeeMain);
      }
    }

    return Row(
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        if (showHomeButton)
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: goToHome,
          ),
      ],
    );
  }
}
