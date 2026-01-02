import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:mobile_app/api/api_client.dart';
import 'package:mobile_app/models/assessment.dart'; // Add this import
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
      
      // 1. Fetch all assessments to get their details (like title)
      final assessmentsResponse = await _apiClient.getEmployeeAssessments();
      final allAssessments = (assessmentsResponse.data as List)
          .map((item) => Assessment.fromJson(item))
          .toList();

      // 2. Fetch user's response history
      final historyApiResponse = await _apiClient.getResponsesHistory();

      if (historyApiResponse.statusCode == 200) {
        List<EmployeeResponse> historyResponses = (historyApiResponse.data as List)
            .map((item) => EmployeeResponse.fromJson(item))
            .toList();
        
        // 3. Match assessments with responses if the backend didn't nest it
        for (var response in historyResponses) {
          if (response.assessment == null && response.assessmentId != null) {
            final assessment = allAssessments.firstWhere(
              (a) => a.id == response.assessmentId.toString(),
              orElse: () => Assessment(id: response.assessmentId.toString(), title: "Unknown Assessment"),
            );
            response.assessment = assessment;
          }
        }
        
        responses.value = historyResponses;

      } else {
        Get.snackbar('Error', 'Failed to fetch history: ${historyApiResponse.statusMessage}');
      }
    } on DioException catch (e) {
      Get.snackbar('Error', e.response?.data['message'] ?? 'Failed to fetch history.');
    } finally {
      isLoading.value = false;
    }
  }
}