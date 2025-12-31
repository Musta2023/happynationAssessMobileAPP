import 'dart:convert'; // Import for jsonDecode
import 'package:mobile_app/models/assessment.dart';

class EmployeeResponse {
  final int id;
  final int userId;
  final int? assessmentId;
  final Assessment? assessment; // Eager loaded assessment
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
      recommendations: (jsonDecode(json['recommendations']) as List<dynamic>?) // Decode JSON string
              ?.map((e) => e.toString())
              .toList() ??
          [],
      summary: json['summary'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'assessment_id': assessmentId,
      'assessment': assessment?.toJson(),
      'stress_score': stressScore,
      'motivation_score': motivationScore,
      'satisfaction_score': satisfactionScore,
      'global_score': globalScore,
      'risk': risk,
      'recommendations': recommendations,
      'summary': summary,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
