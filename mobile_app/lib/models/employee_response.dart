import 'dart:convert';// For jsonDecode       
import 'package:mobile_app/models/assessment.dart';

class EmployeeResponse {
  final int id;
  final int userId;
  final int? assessmentId;
  Assessment? assessment; 
  final int stressScore;
  final int motivationScore;
  final int satisfactionScore;
  final int globalScore;
  final String risk;
  final List<String> recommendations;
  final String summary;
  final DateTime createdAt;
  final DateTime updatedAt;

  EmployeeResponse({
    required this.id,
    required this.userId,
    this.assessmentId,
    this.assessment,
    required this.stressScore,
    required this.motivationScore,
    required this.satisfactionScore,
    required this.globalScore,
    required this.risk,
    required this.recommendations,
    required this.summary,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EmployeeResponse.fromJson(Map<String, dynamic> json) {
    // Helper function to handle the recommendations field safely
    List<String> parseRecommendations(dynamic data) {
      if (data == null) return [];
      
      // Case 1: It's already a List (What we expect)
      if (data is List) {
        return data.map((e) => e.toString()).toList();
      }
      
      // Case 2: It's a JSON String that needs decoding (common in PHP/Laravel)
      if (data is String && data.startsWith('[')) {
        try {
          final decoded = jsonDecode(data);
          if (decoded is List) {
            return decoded.map((e) => e.toString()).toList();
          }
        } catch (e) {
          return [];
        }
      }

      // Case 3: It's just a regular string
      if (data is String && data.isNotEmpty) {
        return [data];
      }

      return [];
    }

    return EmployeeResponse(
      id: json['id'],
      userId: json['user_id'],
      assessmentId: json['assessment_id'],
      assessment: json['assessment'] != null 
          ? Assessment.fromJson(json['assessment']) 
          : null,
      stressScore: json['stress_score'] ?? 0,
      motivationScore: json['motivation_score'] ?? 0,
      satisfactionScore: json['satisfaction_score'] ?? 0,
      globalScore: json['global_score'] ?? 0,
      risk: json['risk'] ?? 'low',
      recommendations: parseRecommendations(json['recommendations']), // Safe parsing
      summary: json['summary'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  
}
