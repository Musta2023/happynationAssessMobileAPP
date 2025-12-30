import 'package:get/get.dart';
import 'package:mobile_app/api/api_client.dart';
import 'package:mobile_app/models/user.dart';
import 'package:mobile_app/api/api_endpoints.dart';

class UserService extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<List<User>> getAllUsers() async {
    final response = await _apiClient.dio.get(ApiEndpoints.adminUsers); // Assuming this is the endpoint
    
    if (response.statusCode == 200) {
      final List<dynamic> userJson = response.data;
      return userJson.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users: ${response.statusCode}');
    }
  }

  Future<void> deleteUser(int id) async {
    final response = await _apiClient.dio.delete('${ApiEndpoints.adminUsers}/$id');

    if (response.statusCode == 200) {
      Get.snackbar('Success', 'User deleted successfully', snackPosition: SnackPosition.BOTTOM);
    } else {
      throw Exception('Failed to delete user: ${response.statusCode}');
    }
  }
}
