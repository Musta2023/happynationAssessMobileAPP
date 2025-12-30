
import 'package:dio/dio.dart';
import 'package:flutter/material.dart'; // Import for debugPrint
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:mobile_app/api/api_client.dart';
import 'package:mobile_app/models/admin_dashboard_models.dart'; // Assuming EmployeeResponse and PaginatedResponses are here

// Define a state class that holds all responses data and status
class AdminAllResponsesState {
  final PaginatedResponses? responses;
  final bool isLoading;
  final String? errorMessage;
  final int currentPage;
  final String? selectedRiskLevelFilter;
  final List<String>? availableDepartments; // New: List of all departments
  final String? selectedDepartment; // New: Currently selected department
  final DateTime? startDate; // New: Start date for filter
  final DateTime? endDate; // New: End date for filter

  AdminAllResponsesState({
    this.responses,
    this.isLoading = false,
    this.errorMessage,
    this.currentPage = 1,
    this.selectedRiskLevelFilter,
    this.availableDepartments,
    this.selectedDepartment,
    this.startDate,
    this.endDate,
  });

  AdminAllResponsesState copyWith({
    PaginatedResponses? responses,
    bool? isLoading,
    String? errorMessage,
    int? currentPage,
    String? selectedRiskLevelFilter,
    List<String>? availableDepartments,
    String? selectedDepartment,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return AdminAllResponsesState(
      responses: responses ?? this.responses,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      selectedRiskLevelFilter: selectedRiskLevelFilter ?? this.selectedRiskLevelFilter,
      availableDepartments: availableDepartments ?? this.availableDepartments,
      selectedDepartment: selectedDepartment ?? this.selectedDepartment,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}

// Define the StateNotifier Provider
final adminAllResponsesProvider = StateNotifierProvider<AdminAllResponsesNotifier, AdminAllResponsesState>(
  (ref) => AdminAllResponsesNotifier(),
);

class AdminAllResponsesNotifier extends StateNotifier<AdminAllResponsesState> {
  AdminAllResponsesNotifier() : super(AdminAllResponsesState()) {
    fetchDepartments(); // Fetch departments when notifier is created
  }

  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<void> fetchResponses(int page) async {
    state = state.copyWith(isLoading: true, errorMessage: null, currentPage: page);

    try {
      final response = await _apiClient.getAdminResponses(
        page: page,
        startDate: state.startDate?.toIso8601String(),
        endDate: state.endDate?.toIso8601String(),
        department: state.selectedDepartment,
      );
      PaginatedResponses responses;

      if (response.data is Map<String, dynamic>) {
        responses = PaginatedResponses.fromJson(response.data);
      } else if (response.data is List) {
        final data = (response.data as List)
            .map((item) => EmployeeResponse.fromJson(item as Map<String, dynamic>))
            .toList();
        responses = PaginatedResponses(
          data: data,
          currentPage: 1,
          lastPage: 1,
          total: data.length,
        );
      } else {
        throw Exception('Unexpected response format');
      }

      // This logic for filtering should be ideally done on the backend via API parameters,
      // but for now, we'll keep the client-side filtering as it was.
      List<EmployeeResponse> filteredData = responses.data;
      if (state.selectedRiskLevelFilter != null && state.selectedRiskLevelFilter != 'All') {
        filteredData = responses.data
            .where((response) => response.riskLevel == state.selectedRiskLevelFilter)
            .toList();
      }

      final filteredResponses = PaginatedResponses(
        data: filteredData,
        currentPage: responses.currentPage,
        lastPage: responses.lastPage,
        total: responses.total,
      );

      state = state.copyWith(responses: filteredResponses, isLoading: false);

    } on DioException catch (e) {
      state = state.copyWith(errorMessage: 'Failed to load responses: ${e.message}', isLoading: false);
      debugPrint('Error fetching responses: $e');
    } catch (e) {
      state = state.copyWith(errorMessage: 'An unexpected error occurred: $e', isLoading: false);
      debugPrint('Error fetching responses: $e');
    }
  }

  Future<void> fetchDepartments() async {
    try {
      final response = await _apiClient.getDepartments();
      final departments = List<String>.from(response.data);
      state = state.copyWith(availableDepartments: departments);
    } on DioException catch (e) {
      debugPrint('Error fetching departments: ${e.message}');
    } catch (e) {
      debugPrint('An unexpected error occurred while fetching departments: $e');
    }
  }

  void setSelectedDepartment(String? department) {
    state = state.copyWith(selectedDepartment: department);
    fetchResponses(1); // Re-fetch data with new filter
  }

  void setStartDate(DateTime? date) {
    state = state.copyWith(startDate: date);
    fetchResponses(1); // Re-fetch data with new filter
  }

  void setEndDate(DateTime? date) {
    state = state.copyWith(endDate: date);
    fetchResponses(1); // Re-fetch data with new filter
  }

  void setRiskLevelFilter(String? riskLevel) {
    state = state.copyWith(selectedRiskLevelFilter: riskLevel);
    fetchResponses(1); // Reset to first page when filter changes
  }

  void nextPage() {
    if (state.responses != null && state.currentPage < state.responses!.lastPage && !state.isLoading) {
      fetchResponses(state.currentPage + 1);
    }
  }

  void previousPage() {
    if (state.responses != null && state.currentPage > 1 && !state.isLoading) {
      fetchResponses(state.currentPage - 1);
    }
  }
}
