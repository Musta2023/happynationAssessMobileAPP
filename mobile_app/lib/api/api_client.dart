import 'dart:convert';

import 'package:get/get.dart' hide Response;
import 'package:dio/dio.dart';
import 'package:mobile_app/services/auth_service.dart';
import 'api_endpoints.dart';

class ApiClient extends GetxService {
  late final Dio _dio;
  final AuthService _authService = Get.find<AuthService>();

  ApiClient({Dio? dio}) {
    _dio = dio ??
        Dio(
          BaseOptions(
            baseUrl: ApiEndpoints.baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 30),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          ),
        );

    // ===============================
    // INTERCEPTORS
    // ===============================
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // ⛔ Ne PAS envoyer Authorization sur login
          if (!options.path.contains('/auth/login') &&
              !options.path.contains('/admin/login') &&
              !options.path.contains('/auth/register')) {
            final token = await _authService.getToken();
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          if (e.response?.statusCode == 401) {
            _authService.logout();
          }
          return handler.next(e);
        },
      ),
    );

    // Logs (à garder en dev, optionnel en prod)
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    );
  }

  Dio get dio => _dio;

  // ===============================
  // AUTH
  // ===============================

  Future<Response> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String department,
  }) {
    return _dio.post(
      ApiEndpoints.register,
      data: jsonEncode({
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'department': department,
      }),
    );
  }

  /// ✅ LOGIN FIXÉ (JSON FORCÉ)
  Future<Response> login({
    required String email,
    required String password,
  }) {
    return _dio.post(
      ApiEndpoints.login,
      data: jsonEncode({
        'email': email,
        'password': password,
      }),
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  /// ✅ ADMIN LOGIN FIXÉ
  Future<Response> adminLogin({
    required String email,
    required String password,
  }) {
    return _dio.post(
      ApiEndpoints.adminLogin,
      data: jsonEncode({
        'email': email,
        'password': password,
      }),
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  Future<Response> logout() {
    return _dio.post(ApiEndpoints.logout);
  }

  Future<Response> getResponsesHistory() {
    return _dio.get(ApiEndpoints.history);
  }

  // ===============================
  // EMPLOYEE
  // ===============================

  Future<Response> getEmployeeAssessments() {
    return _dio.get(ApiEndpoints.employeeAssessments);
  }

  Future<Response> getAssessmentQuestions(String assessmentId) {
    return _dio.get(ApiEndpoints.assessmentQuestions(assessmentId));
  }

  // ===============================
  // ADMIN
  // ===============================

  Future<Response> getDepartments() {
    return _dio.get(ApiEndpoints.adminDepartments);
  }

  Future<Response> getAdminStatistics({
    String? startDate,
    String? endDate,
    String? department,
  }) {
    final query = <String, dynamic>{};
    if (startDate != null) query['start_date'] = startDate;
    if (endDate != null) query['end_date'] = endDate;
    if (department != null) query['department'] = department;

    return _dio.get(
      ApiEndpoints.adminStatistics,
      queryParameters: query,
    );
  }

  Future<Response> getAdminResponses({
    required int page,
    String? startDate,
    String? endDate,
    String? department,
  }) {
    final query = {'page': page};
    if (startDate != null) query['start_date'] = startDate as int;
    if (endDate != null) query['end_date'] = endDate as int;
    if (department != null) query['department'] = department as int;

    return _dio.get(
      ApiEndpoints.adminResponses,
      queryParameters: query,
    );
  }

  Future<Response> getEmployeeResponses(String userId) {
    return _dio.get(ApiEndpoints.adminUserResponses(userId));
  }

  // ===============================
  // ADMIN USERS
  // ===============================

  Future<Response> getAllUsers() {
    return _dio.get(ApiEndpoints.adminUsersList);
  }

  Future<Response> createUser(Map<String, dynamic> data) {
    return _dio.post(ApiEndpoints.adminUserCreate, data: jsonEncode(data));
  }

  Future<Response> deleteUser(String userId) {
    return _dio.delete(ApiEndpoints.adminUserDelete(userId));
  }

  // ===============================
  // ADMIN QUESTIONS
  // ===============================

  Future<Response> getAllQuestions() {
    return _dio.get(ApiEndpoints.adminQuestionsList);
  }

  Future<Response> createQuestion(Map<String, dynamic> data) {
    return _dio.post(ApiEndpoints.adminQuestionCreate, data: jsonEncode(data));
  }

  Future<Response> getQuestion(String id) {
    return _dio.get(ApiEndpoints.adminQuestionShow(id));
  }

  Future<Response> updateQuestion(String id, Map<String, dynamic> data) {
    return _dio.put(ApiEndpoints.adminQuestionUpdate(id), data: jsonEncode(data));
  }

  Future<Response> deleteQuestion(String id) {
    return _dio.delete(ApiEndpoints.adminQuestionDelete(id));
  }

  // ===============================
  // ADMIN ASSESSMENTS
  // ===============================

  Future<Response> getAllAssessments() {
    return _dio.get(ApiEndpoints.adminAssessmentsList);
  }

  Future<Response> createAssessment(Map<String, dynamic> data) {
    return _dio.post(ApiEndpoints.adminAssessmentCreate, data: jsonEncode(data));
  }

  Future<Response> getAssessment(String id) {
    return _dio.get(ApiEndpoints.adminAssessmentShow(id));
  }

  Future<Response> updateAssessment(String id, Map<String, dynamic> data) {
    return _dio.put(ApiEndpoints.adminAssessmentUpdate(id), data: jsonEncode(data));
  }

  Future<Response> deleteAssessment(String id) {
    return _dio.delete(ApiEndpoints.adminAssessmentDelete(id));
  }

  Future<Response> getAssessmentAnalytics(String id) {
    return _dio.get(ApiEndpoints.adminAssessmentAnalytics(id));
  }
}
