import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:mobile_app/api/api_client.dart';
import 'package:mobile_app/api/api_endpoints.dart';
import 'package:mobile_app/models/response_history.dart';

/// Controller for managing user responses in the admin panel.
///
/// FIXED: Now uses the unified ApiClient and handles DioException correctly.
class AdminResponseController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();

  var responses = <ResponseHistory>[].obs;
  var isLoading = true.obs;
  var totalResponses = 0.obs;
  var averageScore = 0.0.obs;

  @override
  void onInit() {
    fetchResponses();
    fetchStatistics();
    super.onInit();
  }

  Future<void> fetchResponses() async {
    try {
      isLoading.value = true;
      final response = await _apiClient.dio.get(ApiEndpoints.adminResponses);
      responses.value = (response.data as List)
          .map((item) => ResponseHistory.fromJson(item))
          .toList();
    } on DioException catch (e) {
      Get.snackbar('Error', e.response?.data['message'] ?? 'Failed to fetch responses');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchStatistics() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.adminStatistics);
      totalResponses.value = response.data['total_responses'] ?? 0;
      averageScore.value = (response.data['average_global_score'] ?? 0.0).toDouble();
    } on DioException catch (e) {
      Get.snackbar('Error', e.response?.data['message'] ?? 'Failed to fetch statistics');
    }
  }
}
