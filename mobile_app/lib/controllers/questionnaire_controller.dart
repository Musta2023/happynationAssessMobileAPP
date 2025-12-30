import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:mobile_app/api/api_client.dart';
import 'package:mobile_app/api/api_endpoints.dart';
import 'package:mobile_app/models/question.dart';
import 'package:mobile_app/routes/app_pages.dart';

class QuestionnaireController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();
  final String? assessmentId;

  var questions = <Question>[].obs;
  var userAnswers = <int, dynamic>{}.obs;
  var isLoading = true.obs;
  var currentQuestionIndex = 0.obs;

  QuestionnaireController({this.assessmentId});

  @override
  void onInit() {
    fetchQuestions();
    super.onInit();
  }

  /// Fetches the list of questions from the server.
  Future<void> fetchQuestions() async {
    try {
      isLoading.value = true;
      final response = assessmentId != null
          ? await _apiClient.getAssessmentQuestions(assessmentId!)
          : await _apiClient.dio.get(ApiEndpoints.questions);
          
      if (response.statusCode == 200) {
        questions.value = (response.data as List)
            .map((item) => Question.fromJson(item))
            .toList();
      } else {
        Get.snackbar('Error', 'Failed to fetch questions. Status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      Get.snackbar('Error', e.response?.data['message'] ?? 'Failed to fetch questions');
    } finally {
      isLoading.value = false;
    }
  }

  /// Stores the user's answer for a given question.
  void answerQuestion(int questionId, dynamic answer) {
    userAnswers[questionId] = answer;
  }

  /// Moves to the next question in the list.
  void nextQuestion() {
    if (currentQuestionIndex.value < questions.length - 1) {
      currentQuestionIndex.value++;
    } else {
      // If it's the last question, submit the answers.
      submitAnswers();
    }
  }

  /// Submits all collected answers to the server.
  Future<void> submitAnswers() async {
    try {
      isLoading.value = true;
      final formattedAnswers = userAnswers.entries
          .map((e) => {'question_id': e.key, 'answer_value': e.value})
          .toList();

      final response = await _apiClient.dio.post(
        ApiEndpoints.submitResponse,
        data: {
          'assessment_id': assessmentId,
          'answers': formattedAnswers,
        },
      );
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        // On success, navigate to the results screen.
        Get.offAllNamed(Routes.results, arguments: response.data);
      }
    } on DioException catch (e) {
      Get.snackbar('Error', e.response?.data['message'] ?? 'Failed to submit answers');
    } finally {
      isLoading.value = false;
    }
  }
}