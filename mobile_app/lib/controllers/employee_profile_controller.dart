import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:mobile_app/api/api_client.dart';
import 'package:mobile_app/models/admin_dashboard_models.dart';

class EmployeeProfileState {
  final List<EmployeeResponse>? responses;
  final bool isLoading;
  final String? errorMessage;

  EmployeeProfileState({
    this.responses,
    this.isLoading = false,
    this.errorMessage,
  });

  EmployeeProfileState copyWith({
    List<EmployeeResponse>? responses,
    bool? isLoading,
    String? errorMessage,
  }) {
    return EmployeeProfileState(
      responses: responses ?? this.responses,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

final employeeProfileProvider = StateNotifierProvider.autoDispose
    .family<EmployeeProfileNotifier, EmployeeProfileState, String>(
        (ref, userId) => EmployeeProfileNotifier(userId));

class EmployeeProfileNotifier extends StateNotifier<EmployeeProfileState> {
  EmployeeProfileNotifier(this.userId) : super(EmployeeProfileState());

  final String userId;
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<void> fetchEmployeeResponses() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final response = await _apiClient.getEmployeeResponses(userId);
      // Assuming the API returns a List directly for employee-specific responses
      final List<EmployeeResponse> responses = (response.data as List)
          .map((item) => EmployeeResponse.fromJson(item as Map<String, dynamic>))
          .toList();
      state = state.copyWith(responses: responses, isLoading: false);
    } on DioException catch (e) {
      String message = 'Failed to load employee responses.';
      if (e.response?.statusCode == 404) {
        message = 'Employee responses not found. Check the API endpoint for user ID: $userId';
      } else if (e.message != null) {
        message = 'Failed to load employee responses: ${e.message}';
      }
      state = state.copyWith(errorMessage: message, isLoading: false);
    } catch (e) {
      state = state.copyWith(
          errorMessage: 'An unexpected error occurred: $e', isLoading: false);
    }
  }
}
