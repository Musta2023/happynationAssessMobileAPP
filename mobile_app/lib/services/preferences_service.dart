import 'package:shared_preferences/shared_preferences.dart';

/// A service for managing non-sensitive user preferences using [SharedPreferences].
///
/// This service abstracts the details of storing and retrieving simple key-value
/// data, such as the user's email for the "Remember Me" feature.
class PreferencesService {
  /// The key used to store the remembered email in [SharedPreferences].
  static const _emailKey = 'remembered_email';

  /// Saves the user's email to local storage.
  ///
  /// This is typically used for the "Remember Me" feature on the login screen.
  ///
  /// - [email]: The email address to save.
  Future<void> saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
  }

  /// Retrieves the saved email from local storage.
  ///
  /// Returns the email [String] if it exists, otherwise returns `null`.
  Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  /// Clears the saved email from local storage.
  ///
  /// This is used when the user unchecks "Remember Me" or logs out.
  Future<void> clearEmail() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_emailKey);
  }
}