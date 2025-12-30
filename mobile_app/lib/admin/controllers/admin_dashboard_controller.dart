import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:mobile_app/api/api_client.dart';
import 'package:mobile_app/api/api_endpoints.dart';
import 'package:mobile_app/models/admin_dashboard_models.dart';

class AdminDashboardController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();

  // Dashboard stats
  var totalUsers = 0.obs;
  var totalResponses = 0.obs;
  var totalQuestions = 0.obs;
  var averageScore = 0.0.obs;
  
  // Responses list
  var responses = PaginatedResponses(data: [], currentPage: 1, lastPage: 1, total: 0).obs;
  
  // UI state
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  // Filters
  var selectedRiskLevelFilter = 'All'.obs;
  
  final int _perPage = 10;

  @override
  void onInit() {
    fetchDashboardData();
    fetchResponses(1);
    super.onInit();
  }

  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;
      final response = await _apiClient.dio.get(ApiEndpoints.adminDashboard);
      totalUsers.value = response.data['totalEmployees'] ?? 0;
      totalResponses.value = response.data['totalResponses'] ?? 0;
      averageScore.value = (response.data['averageGlobalScore'] ?? 0.0).toDouble();
    } on DioException catch (e) {
      Get.snackbar('Error', e.response?.data['message'] ?? 'Failed to load dashboard data');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchResponses(int page) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final response = await _apiClient.dio.get(
        ApiEndpoints.adminResponses,
        queryParameters: {
          'page': page,
          'per_page': _perPage,
          'risk_level': selectedRiskLevelFilter.value == 'All' ? null : selectedRiskLevelFilter.value,
        },
      );
      responses.value = PaginatedResponses.fromJson(response.data);
    } on DioException catch (e) {
      errorMessage.value = e.response?.data['message'] ?? 'Failed to load responses';
      Get.snackbar('Error', errorMessage.value);
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred: $e';
      Get.snackbar('Error', errorMessage.value);
    }
    finally {
      isLoading.value = false;
    }
  }

  void setRiskLevelFilter(String? riskLevel) {
    selectedRiskLevelFilter.value = riskLevel ?? 'All';
    fetchResponses(1);
  }

  void nextPage() {
    if (responses.value.currentPage < responses.value.lastPage) {
      fetchResponses(responses.value.currentPage + 1);
    }
  }

  void previousPage() {
    if (responses.value.currentPage > 1) {
      fetchResponses(responses.value.currentPage - 1);
    }
  }
}
