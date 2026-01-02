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
      final assessmentResponse = await _apiClient.getEmployeeAssessments();
      var assessmentsList = (assessmentResponse.data as List)
          .map((item) => Assessment.fromJson(item))
          .toList();

      // 2. Fetch user's history
      final historyResponse = await _apiClient.getResponsesHistory();
      // Assuming historyResponse.data is a List<dynamic> where each item has an 'assessment_id'
      var historyList = historyResponse.data as List<dynamic>;
      
      // 3. Mark assessments as answered if their ID exists in history
      for (var assessment in assessmentsList) {
        bool alreadyDone = historyList.any((response) => response['assessment_id']?.toString() == assessment.id);
        assessment.isAnswered = alreadyDone;
      }

      assessments.assignAll(assessmentsList);
    } on DioException catch (e) {
      Get.snackbar('Error', e.response?.data['message'] ?? 'Failed to fetch assessments');
    } finally {
      isLoading.value = false;
    }
  }
}
