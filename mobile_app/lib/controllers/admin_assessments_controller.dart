import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:mobile_app/api/api_client.dart';
import 'package:mobile_app/models/assessment.dart'; // Import the Assessment model

class AdminAssessmentsState {
  final List<Assessment> assessments;
  final bool isLoading;
  final String? errorMessage;
  final bool isCreating;
  final bool isUpdating;
  final bool isDeleting;

  AdminAssessmentsState({
    this.assessments = const [],
    this.isLoading = false,
    this.errorMessage,
    this.isCreating = false,
    this.isUpdating = false,
    this.isDeleting = false,
  });

  AdminAssessmentsState copyWith({
    List<Assessment>? assessments,
    bool? isLoading,
    String? errorMessage,
    bool? isCreating,
    bool? isUpdating,
    bool? isDeleting,
  }) {
    return AdminAssessmentsState(
      assessments: assessments ?? this.assessments,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isCreating: isCreating ?? this.isCreating,
      isUpdating: isUpdating ?? this.isUpdating,
      isDeleting: isDeleting ?? this.isDeleting,
    );
  }
}

final adminAssessmentsProvider = StateNotifierProvider.autoDispose<AdminAssessmentsNotifier, AdminAssessmentsState>(
  (ref) => AdminAssessmentsNotifier(),
);

class AdminAssessmentsNotifier extends StateNotifier<AdminAssessmentsState> {
  AdminAssessmentsNotifier() : super(AdminAssessmentsState());

  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<void> fetchAssessments() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final response = await _apiClient.getAllAssessments();
      final List<Assessment> assessments = (response.data as List)
          .map((item) => Assessment.fromJson(item as Map<String, dynamic>))
          .toList();
      state = state.copyWith(assessments: assessments, isLoading: false);
    } on DioException catch (e) {
      state = state.copyWith(
          errorMessage: 'Failed to load assessments: ${e.message}',
          isLoading: false);
    } catch (e) {
      state = state.copyWith(
          errorMessage: 'An unexpected error occurred: $e', isLoading: false);
    }
  }

  Future<bool> createAssessment(Map<String, dynamic> data) async {
    state = state.copyWith(isCreating: true, errorMessage: null);
    try {
      final response = await _apiClient.createAssessment(data);
      final Assessment newAssessment = Assessment.fromJson(response.data);
      state = state.copyWith(
        assessments: [...state.assessments, newAssessment],
        isCreating: false,
      );
      return true;
    } on DioException catch (e) {
      state = state.copyWith(
          errorMessage: 'Failed to create assessment: ${e.message}',
          isCreating: false);
      return false;
    } catch (e) {
      state = state.copyWith(
          errorMessage: 'An unexpected error occurred: $e',
          isCreating: false);
      return false;
    }
  }

  Future<bool> updateAssessment(String assessmentId, Map<String, dynamic> data) async {
    state = state.copyWith(isUpdating: true, errorMessage: null);
    try {
      final response = await _apiClient.updateAssessment(assessmentId, data);
      final Assessment updatedAssessment = Assessment.fromJson(response.data);
      state = state.copyWith(
        assessments: state.assessments
            .map((a) => a.id == assessmentId ? updatedAssessment : a)
            .toList(),
        isUpdating: false,
      );
      return true;
    } on DioException catch (e) {
      state = state.copyWith(
          errorMessage: 'Failed to update assessment: ${e.message}',
          isUpdating: false);
      return false;
    } catch (e) {
      state = state.copyWith(
          errorMessage: 'An unexpected error occurred: $e',
          isUpdating: false);
      return false;
    }
  }

  Future<bool> deleteAssessment(String assessmentId) async {
    state = state.copyWith(isDeleting: true, errorMessage: null);
    try {
      await _apiClient.deleteAssessment(assessmentId);
      state = state.copyWith(
        assessments: state.assessments.where((a) => a.id != assessmentId).toList(),
        isDeleting: false,
      );
      return true;
    } on DioException catch (e) {
      state = state.copyWith(
          errorMessage: 'Failed to delete assessment: ${e.message}',
          isDeleting: false);
      return false;
    } catch (e) {
      state = state.copyWith(
          errorMessage: 'An unexpected error occurred: $e',
          isDeleting: false);
      return false;
    }
  }
}
