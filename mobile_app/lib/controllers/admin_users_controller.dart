import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:mobile_app/api/api_client.dart';
import 'package:mobile_app/models/user.dart'; // Import the User model

class AdminUsersState {
  final List<User> users;
  final bool isLoading;
  final String? errorMessage;
  final bool isDeleting; // To track if a delete operation is in progress

  AdminUsersState({
    this.users = const [],
    this.isLoading = false,
    this.errorMessage,
    this.isDeleting = false,
  });

  AdminUsersState copyWith({
    List<User>? users,
    bool? isLoading,
    String? errorMessage,
    bool? isDeleting,
  }) {
    return AdminUsersState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isDeleting: isDeleting ?? this.isDeleting,
    );
  }
}

final adminUsersProvider = StateNotifierProvider.autoDispose<AdminUsersNotifier, AdminUsersState>(
  (ref) => AdminUsersNotifier(),
);

class AdminUsersNotifier extends StateNotifier<AdminUsersState> {
  AdminUsersNotifier() : super(AdminUsersState());

  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<void> fetchUsers() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final response = await _apiClient.getAllUsers();
      // Assuming the API returns a List directly for users
      final List<User> users = (response.data as List)
          .map((item) => User.fromJson(item as Map<String, dynamic>))
          .toList();
      state = state.copyWith(users: users, isLoading: false);
    } on DioException catch (e) {
      state = state.copyWith(
          errorMessage: 'Failed to load users: ${e.message}',
          isLoading: false);
    } catch (e) {
      state = state.copyWith(
          errorMessage: 'An unexpected error occurred: $e', isLoading: false);
    }
  }

  Future<bool> deleteUser(String userId) async {
    // Prevent deletion of the master admin
    final User? userToDelete = state.users.firstWhereOrNull((user) => user.id.toString() == userId);
    if (userToDelete != null && userToDelete.email == 'admin@company.com') {
      state = state.copyWith(
        errorMessage: 'Cannot delete the master admin account.',
        isDeleting: false,
      );
      return false;
    }

    state = state.copyWith(isDeleting: true, errorMessage: null);
    try {
      await _apiClient.deleteUser(userId);
      // Remove the user from the local state upon successful deletion
      state = state.copyWith(
        users: state.users.where((user) => user.id.toString() != userId).toList(),
        isDeleting: false,
      );
      return true;
    } on DioException catch (e) {
      state = state.copyWith(
          errorMessage: 'Failed to delete user: ${e.message}',
          isDeleting: false);
      return false;
    } catch (e) {
      state = state.copyWith(
          errorMessage: 'An unexpected error occurred: $e',
          isDeleting: false);
      return false;
    }
  }

  Future<bool> createUser(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true, errorMessage: null); // Using isLoading for now, could add isCreating
    try {
      final response = await _apiClient.createUser(data);
      final User newUser = User.fromJson(response.data);
      state = state.copyWith(
        users: [...state.users, newUser],
        isLoading: false,
      );
      return true;
    } on DioException catch (e) {
      state = state.copyWith(
          errorMessage: 'Failed to create user: ${e.message}',
          isLoading: false);
      return false;
    } catch (e) {
      state = state.copyWith(
          errorMessage: 'An unexpected error occurred: $e',
          isLoading: false);
      return false;
    }
  }
}
