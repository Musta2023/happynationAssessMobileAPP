import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:mobile_app/api/api_client.dart';
import 'package:mobile_app/models/question.dart'; // Import the Question model

class AdminQuestionsState {
  final List<Question> questions;
  final bool isLoading;
  final String? errorMessage;
  final bool isCreating;
  final bool isUpdating;
  final bool isDeleting;

  AdminQuestionsState({
    this.questions = const [],
    this.isLoading = false,
    this.errorMessage,
    this.isCreating = false,
    this.isUpdating = false,
    this.isDeleting = false,
  });

  AdminQuestionsState copyWith({
    List<Question>? questions,
    bool? isLoading,
    String? errorMessage,
    bool? isCreating,
    bool? isUpdating,
    bool? isDeleting,
  }) {
    return AdminQuestionsState(
      questions: questions ?? this.questions,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isCreating: isCreating ?? this.isCreating,
      isUpdating: isUpdating ?? this.isUpdating,
      isDeleting: isDeleting ?? this.isDeleting,
    );
  }
}

final adminQuestionsProvider = StateNotifierProvider<AdminQuestionsNotifier, AdminQuestionsState>(
  (ref) => AdminQuestionsNotifier(ref),
);

class AdminQuestionsNotifier extends StateNotifier<AdminQuestionsState> {
  AdminQuestionsNotifier(this._ref) : super(AdminQuestionsState()) {
    _ref.onDispose(() {
      _isDisposed = true;
    });
  }

  final Ref _ref;
  bool _isDisposed = false;

  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<void> fetchQuestions() async {
    if (_isDisposed) return;
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final response = await _apiClient.getAllQuestions();

      if (_isDisposed) return; // Check again after await
      final List<Question> questions = (response.data as List)
          .map((item) => Question.fromJson(item as Map<String, dynamic>))
          .toList();

      state = state.copyWith(questions: questions, isLoading: false);
    } on DioException catch (e) {
      if (_isDisposed) return; // Check again after await

      state = state.copyWith(
          errorMessage: 'Failed to load questions: ${e.response?.data['message'] ?? e.message}',
          isLoading: false);
    } catch (e) {
      if (_isDisposed) return; // Check again after await
      state = state.copyWith(
          errorMessage: 'An unexpected error occurred: $e', isLoading: false);
    }
  }

  Future<bool> createQuestion(Map<String, dynamic> data) async {
    if (_isDisposed) return false;
    state = state.copyWith(isCreating: true, errorMessage: null);
    try {
      final response = await _apiClient.createQuestion(data);
      if (_isDisposed) return false; // Check again after await
      final Question newQuestion = Question.fromJson(response.data);
      state = state.copyWith(
        questions: [...state.questions, newQuestion],
        isCreating: false,
      );
      return true;
    } on DioException catch (e) {
      if (_isDisposed) return false; // Check again after await

      state = state.copyWith(
          errorMessage: 'Failed to create question: ${e.response?.data['message'] ?? e.message}',
          isCreating: false);
      return false;
    } catch (e) {
      if (_isDisposed) return false; // Check again after await
      state = state.copyWith(
          errorMessage: 'An unexpected error occurred: $e',
          isCreating: false);
      return false;
    }
  }

  Future<bool> updateQuestion(String questionId, Map<String, dynamic> data) async {
    if (_isDisposed) return false;
    state = state.copyWith(isUpdating: true, errorMessage: null);
    try {
      final response = await _apiClient.updateQuestion(questionId, data);
      if (_isDisposed) return false; // Check again after await
      final Question updatedQuestion = Question.fromJson(response.data);
      state = state.copyWith(
        questions: state.questions
            .map((q) => q.id.toString() == questionId ? updatedQuestion : q)
            .toList(),
        isUpdating: false,
      );
      return true;
    } on DioException catch (e) {
      if (_isDisposed) return false; // Check again after await

      state = state.copyWith(
          errorMessage: 'Failed to update question: ${e.response?.data['message'] ?? e.message}',
          isUpdating: false);
      return false;
    } catch (e) {
      if (_isDisposed) return false; // Check again after await
      state = state.copyWith(
          errorMessage: 'An unexpected error occurred: $e',
          isUpdating: false);
      return false;
    }
  }

  Future<bool> deleteQuestion(String questionId) async {
    if (_isDisposed) return false;
    state = state.copyWith(isDeleting: true, errorMessage: null);
    try {
      await _apiClient.deleteQuestion(questionId);
      if (_isDisposed) return false; // Check again after await
      state = state.copyWith(
        questions: state.questions.where((q) => q.id.toString() != questionId).toList(),
        isDeleting: false,
      );
      return true;
    } on DioException catch (e) {
      if (_isDisposed) return false; // Check again after await

      state = state.copyWith(
          errorMessage: 'Failed to delete question: ${e.response?.data['message'] ?? e.message}',
          isDeleting: false);
      return false;
    } catch (e) {
      if (_isDisposed) return false; // Check again after await
      state = state.copyWith(
          errorMessage: 'An unexpected error occurred: $e',
          isDeleting: false);
      return false;
    }
  }
}
