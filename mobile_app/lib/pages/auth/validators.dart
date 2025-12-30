/// A utility class containing static methods for common form validation logic.
///
/// This helps keep validation logic clean, reusable, and separate from the UI code.
class FormValidators {
  /// Validates that a form field value is not null or empty.
  ///
  /// Returns an error message if the value is empty, otherwise returns `null`.
  static String? validateNotEmpty(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field cannot be empty.';
    }
    return null;
  }

  /// Validates that a form field value is a properly formatted email address.
  ///
  /// Returns an error message if the value is empty or invalid, otherwise `null`.
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email.';
    }
    // This regex is a common and reasonably effective pattern for email validation.
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  /// Validates that a password meets the minimum length requirement.
  ///
  /// Returns an error message if the password is empty or too short, otherwise `null`.
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password.';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long.';
    }
    return null;
  }

  /// Validates that the password confirmation field matches the password field.
  ///
  /// Returns an error message if the value is empty or does not match, otherwise `null`.
  ///
  /// - [value]: The value from the password confirmation field.
  /// - [password]: The value from the original password field to compare against.
  static String? validatePasswordConfirmation(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password.';
    }
    if (value != password) {
      return 'Passwords do not match.';
    }
    return null;
  }
}