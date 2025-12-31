import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:mobile_app/api/api_client.dart';
import 'package:mobile_app/models/employee_response.dart'; // Import the new EmployeeResponse model

class HistoryController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();

  var responses = <EmployeeResponse>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchResponsesHistory();
    super.onInit();
  }

  Future<void> fetchResponsesHistory() async {
    try {
      isLoading.value = true;
      final response = await _apiClient.getResponsesHistory();
      if (response.statusCode == 200) {
        responses.value = (response.data as List)
            .map((item) => EmployeeResponse.fromJson(item))
            .toList();
      } else {
        Get.snackbar('Error', 'Failed to fetch history: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      Get.snackbar('Error', e.response?.data['message'] ?? 'Failed to fetch history.');
    } finally {
      isLoading.value = false;
    }
  }
}