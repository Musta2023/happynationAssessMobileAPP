import 'package:get/get.dart' hide Response; 
import 'package:dio/dio.dart';
import 'package:mobile_app/services/auth_service.dart';
import 'api_endpoints.dart';

class ApiClient extends GetxService {
  late final Dio _dio;
  final AuthService _authService = Get.find<AuthService>();

  ApiClient({Dio? dio}) {
    _dio = dio ?? Dio(BaseOptions(
      baseUrl: ApiEndpoints.baseUrl, // Ensure this is http://10.0.2.2:8000/api for Emulator!
      
      // FIXED: Increased from 10s to 15s
      connectTimeout: const Duration(seconds: 15), 
      
      // FIXED: Increased from 3000ms (3s) to 30s
      receiveTimeout: const Duration(seconds: 30), 
      
      // Recommended: Add headers here to avoid repeating them
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ));

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _authService.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          // Note: 'Accept' is already set in BaseOptions above, but keeping it here is fine too.
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
    
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  Dio get dio => _dio;

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
      data: {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'department': department,
      },
    );
  }

  Future<Response> login({required String email, required String password}) {
    return _dio.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );
  }

  Future<Response> adminLogin({required String email, required String password}) {
    return _dio.post(
      ApiEndpoints.adminLogin,
      data: {'email': email, 'password': password},
    );
  }

  Future<Response> getDepartments() {
    return _dio.get(ApiEndpoints.adminDepartments);
  }

  Future<Response> getAdminStatistics({String? startDate, String? endDate, String? department}) {
    final Map<String, dynamic> queryParameters = {};
    if (startDate != null) queryParameters['start_date'] = startDate;
    if (endDate != null) queryParameters['end_date'] = endDate;
    if (department != null) queryParameters['department'] = department;

    return _dio.get(
      ApiEndpoints.adminStatistics,
      queryParameters: queryParameters,
    );
  }

  Future<Response> getAdminResponses({required int page, String? startDate, String? endDate, String? department}) {
    final Map<String, dynamic> queryParameters = {'page': page};
    if (startDate != null) queryParameters['start_date'] = startDate;
    if (endDate != null) queryParameters['end_date'] = endDate;
    if (department != null) queryParameters['department'] = department;

    return _dio.get(
      ApiEndpoints.adminResponses,
      queryParameters: queryParameters,
    );
  }

  Future<Response> getEmployeeResponses(String userId) {
    return _dio.get(ApiEndpoints.adminUserResponses(userId));
  }

  Future<Response> getEmployeeAssessments() {
    return _dio.get(ApiEndpoints.employeeAssessments);
  }

  Future<Response> getAssessmentQuestions(String assessmentId) {
    return _dio.get(ApiEndpoints.assessmentQuestions(assessmentId));
  }

  // Admin Users Management
  Future<Response> getAllUsers() {
    return _dio.get(ApiEndpoints.adminUsersList);
  }

  Future<Response> deleteUser(String userId) {
    return _dio.delete(ApiEndpoints.adminUserDelete(userId));
  }

  Future<Response> createUser(Map<String, dynamic> data) {
    return _dio.post(ApiEndpoints.adminUserCreate, data: data);
  }

  // Admin Questions Management
  Future<Response> getAllQuestions() {
    return _dio.get(ApiEndpoints.adminQuestionsList);
  }

  Future<Response> createQuestion(Map<String, dynamic> data) {
    return _dio.post(ApiEndpoints.adminQuestionCreate, data: data);
  }

  Future<Response> getQuestion(String questionId) {
    return _dio.get(ApiEndpoints.adminQuestionShow(questionId));
  }

  Future<Response> updateQuestion(String questionId, Map<String, dynamic> data) {
    final Map<String, dynamic> spoofedData = {
      ...data,
      '_method': 'PUT',
    };
    return _dio.post(ApiEndpoints.adminQuestionUpdate(questionId), data: spoofedData);
  }

  Future<Response> deleteQuestion(String questionId) {
    return _dio.delete(ApiEndpoints.adminQuestionDelete(questionId));
  }

  // Admin Assessments Management
  Future<Response> getAllAssessments() {
    return _dio.get(ApiEndpoints.adminAssessmentsList);
  }

  Future<Response> createAssessment(Map<String, dynamic> data) {
    return _dio.post(ApiEndpoints.adminAssessmentCreate, data: data);
  }

  Future<Response> getAssessment(String assessmentId) {
    return _dio.get(ApiEndpoints.adminAssessmentShow(assessmentId));
  }

  Future<Response> updateAssessment(String assessmentId, Map<String, dynamic> data) {
    return _dio.put(ApiEndpoints.adminAssessmentUpdate(assessmentId), data: data);
  }

  Future<Response> deleteAssessment(String assessmentId) {
    return _dio.delete(ApiEndpoints.adminAssessmentDelete(assessmentId));
  }

  Future<Response> getAssessmentAnalytics(String assessmentId) {
    return _dio.get(ApiEndpoints.adminAssessmentAnalytics(assessmentId));
  }
}
