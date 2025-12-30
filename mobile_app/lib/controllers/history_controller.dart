import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:mobile_app/api/api_client.dart';
import 'package:mobile_app/api/api_endpoints.dart';
import 'package:mobile_app/models/analysis_result.dart'; // Assuming AnalysisResult can also represent history items

class HistoryController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();

  var isLoading = true.obs;
  var historyList = <AnalysisResult>[].obs; // Assuming history items are AnalysisResult-like

  @override
  void onInit() {
    fetchHistory();
    super.onInit();
  }

  Future<void> fetchHistory() async {
    try {
      isLoading.value = true;
      final response = await _apiClient.dio.get(ApiEndpoints.history);
      if (response.statusCode == 200) {
        historyList.value = (response.data as List)
            .map((item) => AnalysisResult.fromJson(item)) // Assuming history items are AnalysisResult-like
            .toList();
      } else {
        Get.snackbar('Error', 'Failed to fetch history. Status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      Get.snackbar('Error', e.response?.data['message'] ?? 'Failed to fetch history');
    } finally {
      isLoading.value = false;
    }
  }
}
