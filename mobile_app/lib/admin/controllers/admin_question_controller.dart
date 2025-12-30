
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:mobile_app/api/api_client.dart';
import 'package:mobile_app/api/api_endpoints.dart';
import 'package:mobile_app/models/question.dart';

class AdminQuestionController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();
  
  var questions = <Question>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchQuestions();
    super.onInit();
  }

  Future<void> fetchQuestions() async {
    try {
      isLoading.value = true;
      final response = await _apiClient.dio.get(ApiEndpoints.adminQuestions);
      questions.value = (response.data as List)
          .map((item) => Question.fromJson(item))
          .toList();
    } on DioException catch (e) {
      Get.snackbar('Error', e.response?.data['message'] ?? 'Failed to fetch questions');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addQuestion(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio.post(ApiEndpoints.adminQuestions, data: data);
      final newQuestion = Question.fromJson(response.data);
      questions.insert(0, newQuestion); // Add to the top of the list
      // Go back to the list page
      Get.snackbar('Success', 'Question added successfully');
    } on DioException catch (e) {
      Get.snackbar('Error', e.response?.data['message'] ?? 'Failed to add question');
    }
  }

  Future<void> updateQuestion(int id, Map<String, dynamic> data) async {
    try {
      final spoofedData = {
        ...data,
        '_method': 'PUT',
      };
      final response = await _apiClient.dio.post('${ApiEndpoints.adminQuestions}/$id', data: spoofedData);
      final updatedQuestion = Question.fromJson(response.data);
      final index = questions.indexWhere((q) => q.id == id);
      if (index != -1) {
        questions[index] = updatedQuestion;
      }
       // Go back to the list page
      Get.snackbar('Success', 'Question updated successfully');
    } on DioException catch (e) {
      Get.snackbar('Error', e.response?.data['message'] ?? 'Failed to update question');
    }
  }

  Future<void> deleteQuestion(int id) async {
    try {
      await _apiClient.dio.delete('${ApiEndpoints.adminQuestions}/$id');
      questions.removeWhere((q) => q.id == id);
      Get.snackbar('Success', 'Question deleted successfully');
    } on DioException catch (e) {
      Get.snackbar('Error', e.response?.data['message'] ?? 'Failed to delete question');
    }
  }

  /// Toggles the active status of a question.
  /// FIXED: Added this missing method.
  Future<void> toggleQuestionStatus(int id) async {
    try {
      final response = await _apiClient.dio.patch(ApiEndpoints.adminQuestionToggle(id));
      final updatedQuestion = Question.fromJson(response.data);
      
      final index = questions.indexWhere((q) => q.id == id);
      if (index != -1) {
        questions[index] = updatedQuestion;
      }
    } on DioException catch (e) {
      Get.snackbar('Error', e.response?.data['message'] ?? 'Failed to toggle status');
    }
  }
}
