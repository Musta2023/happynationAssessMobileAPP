
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A utility class to provide standardized UI feedback, such as SnackBars.
///
/// This centralizes the presentation of messages to the user, ensuring a
/// consistent look and feel for feedback like errors and success notifications.
class UiHelper {
  /// Shows a standardized error SnackBar.
  ///
  /// - [message]: The error message to display.
  static void showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade600,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      icon: const Icon(Icons.error_outline, color: Colors.white),
    );
  }

  /// Shows a standardized success SnackBar.
  ///
  /// - [message]: The success message to display.
  static void showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade600,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
    );
  }
}
