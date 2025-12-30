import 'package:get/get.dart';
import 'package:mobile_app/api/api_client.dart';
import 'package:mobile_app/api/api_endpoints.dart';
import 'package:mobile_app/models/response_history.dart'; // Contains ResponseDetail

class AdminResponseService extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<ResponseDetail> getResponseDetail(int id) async {
    final response = await _apiClient.dio.get('${ApiEndpoints.adminResponses}/$id');

    if (response.statusCode == 200 && response.data != null) {
      return ResponseDetail.fromJson(response.data);
    } else {
      throw Exception('Failed to load response detail: ${response.statusCode}');
    }
  }
}
