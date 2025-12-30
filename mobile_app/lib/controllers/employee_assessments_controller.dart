import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:mobile_app/api/api_client.dart';
import 'package:mobile_app/models/assessment.dart';

class EmployeeAssessmentsController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();
  
  var assessments = <Assessment>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchAssessments();
    super.onInit();
  }

  Future<void> fetchAssessments() async {
    try {
      isLoading.value = true;
      // This method does not exist yet in ApiClient, I will add it.
      final response = await _apiClient.getEmployeeAssessments();
      assessments.value = (response.data as List)
          .map((item) => Assessment.fromJson(item))
          .toList();
    } on DioException catch (e) {
      Get.snackbar('Error', e.response?.data['message'] ?? 'Failed to fetch assessments');
    } finally {
      isLoading.value = false;
    }
  }
}
