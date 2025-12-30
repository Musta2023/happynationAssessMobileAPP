import 'dart:convert';
import 'package:get/get.dart';
import 'package:mobile_app/models/user.dart';
import 'package:mobile_app/routes/app_pages.dart';
import 'package:mobile_app/services/secure_storage_service.dart';

/// Manages the authentication state of the application.
/// It handles storing and retrieving user data and authentication tokens.
class AuthService extends GetxService {
  final SecureStorageService _storage = Get.find<SecureStorageService>();

  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'auth_user';

  String? _token;
  User? _user;

  /// Indicates if a user is currently authenticated.
  bool get isLoggedIn => _token != null && _user != null;

  /// Returns the authenticated user's role. Defaults to 'employee'.
  String get userRole => _user?.role ?? 'employee';

  /// Returns the authenticated user.
  User? get user => _user;

  /// Initializes the service by loading the token and user data from storage.
  Future<AuthService> init() async {
    _token = await _storage.read(_tokenKey);
    String? userJson = await _storage.read(_userKey);

    if (userJson != null) {
      try {
        _user = User.fromJson(jsonDecode(userJson));
      } catch (e) {
        // If decoding fails, treat the user as logged out.
        await logout();
      }
    }

    return this;
  }

  /// Saves the authentication token and user data to secure storage.
  Future<void> saveTokenAndUser(String token, User user) async {
    _token = token;
    _user = user;
    await _storage.write(_tokenKey, token);
    await _storage.write(_userKey, jsonEncode(user.toJson()));
  }

  /// Retrieves the authentication token.
  Future<String?> getToken() async {
    _token ??= await _storage.read(_tokenKey);
    return _token;
  }

  /// Logs out the user by clearing all authentication data.
  Future<void> logout() async {
    _token = null;
    _user = null;
    await _storage.delete(_tokenKey);
    await _storage.delete(_userKey);
    // Redirect to login, removing all previous routes.
    Get.offAllNamed(Routes.login);
  }

  /// Determines the initial route based on the user's login status and role.
  String getInitialRoute() {
    if (!isLoggedIn) {
      return Routes.login;
    }

    if (userRole == 'admin') {
      return Routes.adminDashboard;
    } else {
      return Routes.employeeMain; // Redirect employees to the new main screen
    }
  }
}