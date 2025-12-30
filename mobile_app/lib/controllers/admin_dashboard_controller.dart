
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:mobile_app/api/api_client.dart';
import '../models/admin_dashboard_models.dart';

// Define a state class that holds all dashboard data and status
class AdminDashboardState {
  final DashboardStatistics? statistics;
  final PaginatedResponses? responses;
  final bool isLoading;
  final String? errorMessage;
  final int currentPage;
  final String? selectedRiskLevelFilter;
  final List<String>? availableDepartments; // New: List of all departments
  final String? selectedDepartment; // New: Currently selected department
  final DateTime? startDate; // New: Start date for filter
  final DateTime? endDate; // New: End date for filter

  AdminDashboardState({
    this.statistics,
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

  AdminDashboardState copyWith({
    DashboardStatistics? statistics,
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
    return AdminDashboardState(
      statistics: statistics ?? this.statistics,
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
final adminDashboardProvider = StateNotifierProvider<AdminDashboardNotifier, AdminDashboardState>(
  (ref) => AdminDashboardNotifier(),
);

class AdminDashboardNotifier extends StateNotifier<AdminDashboardState> {
  AdminDashboardNotifier() : super(AdminDashboardState()) {
    fetchDepartments(); // Fetch departments when notifier is created
  }

  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<void> fetchDashboardData() async {
    debugPrint('Fetching dashboard data...');
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await _apiClient.getAdminStatistics(
        startDate: state.startDate?.toIso8601String(),
        endDate: state.endDate?.toIso8601String(),
        department: state.selectedDepartment,
      );
      debugPrint('Response data type: ${response.data.runtimeType}, content: ${response.data}');
      final statistics = DashboardStatistics.fromJson(response.data);
      state = state.copyWith(statistics: statistics, isLoading: false);
      debugPrint('Dashboard data fetched successfully.');
    } on DioException catch (e) {
      state = state.copyWith(errorMessage: 'Failed to load dashboard data: ${e.message}', isLoading: false);
      debugPrint('Error fetching dashboard data: $e');
    } catch (e) {
      state = state.copyWith(errorMessage: 'An unexpected error occurred.', isLoading: false);
      debugPrint('Error fetching dashboard data: $e');
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
    fetchDashboardData(); // Re-fetch data with new filter
  }

  void setStartDate(DateTime? date) {
    state = state.copyWith(startDate: date);
    fetchDashboardData(); // Re-fetch data with new filter
  }

  void setEndDate(DateTime? date) {
    state = state.copyWith(endDate: date);
    fetchDashboardData(); // Re-fetch data with new filter
  }
}
