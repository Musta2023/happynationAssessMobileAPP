// lib/models/admin_dashboard_models.dart

// Data structure for /api/admin/statistics
class DashboardStatistics {
  final int totalEmployees; // New KPI for Home Page
  final int totalResponses;
  final double averageGlobalScore;
  final int lowRiskCount;
  final int mediumRiskCount;
  final int highRiskCount;
  final int highRiskEmployeesCount; // New KPI for Home Page
  final Map<String, double> categoryScores; // e.g., {'Stress': 3.5, 'Motivation': 4.2}
  final List<GlobalScoreTrend> globalScoreTrend; // List of date-score pairs

  DashboardStatistics({
    required this.totalEmployees,
    required this.totalResponses,
    required this.averageGlobalScore,
    required this.lowRiskCount,
    required this.mediumRiskCount,
    required this.highRiskCount,
    required this.highRiskEmployeesCount,
    required this.categoryScores,
    required this.globalScoreTrend,
  });

  factory DashboardStatistics.fromJson(Map<String, dynamic> json) {
    final riskDistribution = json['risk_distribution'] as Map<String, dynamic>? ?? {};
    final categoryAverages = json['category_averages'] as Map<String, dynamic>? ?? {};

    return DashboardStatistics(
      totalEmployees: json['total_employees'] as int? ?? 0, // Assuming this might be added later
      totalResponses: json['total_responses'] as int? ?? 0,
      averageGlobalScore: (json['average_global_score'] as num? ?? 0.0).toDouble(),
      lowRiskCount: riskDistribution['low'] as int? ?? 0,
      mediumRiskCount: riskDistribution['medium'] as int? ?? 0,
      highRiskCount: riskDistribution['high'] as int? ?? 0, // Assuming 'high' might be in distribution
      highRiskEmployeesCount: json['high_risk_employees_count'] as int? ?? 0, // Assuming this might be added
      categoryScores: Map<String, double>.from(categoryAverages.map(
        (key, value) => MapEntry(key, (value as num).toDouble()),
      )),
      globalScoreTrend: (json['global_score_trend'] as List?)
              ?.map((item) => GlobalScoreTrend.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class GlobalScoreTrend {
  final DateTime date;
  final double score;

  GlobalScoreTrend({required this.date, required this.score});

  factory GlobalScoreTrend.fromJson(Map<String, dynamic> json) {
    return GlobalScoreTrend(
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      score: (json['score'] as num? ?? 0.0).toDouble(),
    );
  }
}

// Data structure for /api/admin/responses (paginated list)
class EmployeeResponse {
  final String id;
  final String? firstName;
  final String? lastName;
  final String employeeEmail;
  final double globalScore;
  final String riskLevel;
  final DateTime submissionDate;
  final int? stressScore;
  final int? motivationScore;
  final int? satisfactionScore;
  final String? summary;
  final List<String>? recommendations;

  EmployeeResponse({
    required this.id,
    this.firstName,
    this.lastName,
    required this.employeeEmail,
    required this.globalScore,
    required this.riskLevel,
    required this.submissionDate,
    this.stressScore,
    this.motivationScore,
    this.satisfactionScore,
    this.summary,
    this.recommendations,
  });

  String get safeEmployeeName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    }
    if (firstName != null) {
      return firstName!;
    }
    if (lastName != null) {
      return lastName!;
    }
    return 'Unknown User';
  }

  factory EmployeeResponse.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;
    return EmployeeResponse(
      id: json['id']?.toString() ?? 'N/A',
      firstName: user?['first_name']?.toString(),
      lastName: user?['last_name']?.toString(),
      employeeEmail: user?['email']?.toString() ?? 'N/A',
      globalScore: (json['global_score'] as num? ?? 0.0).toDouble(),
      riskLevel: json['risk']?.toString() ?? 'Unknown', // Corrected from risk_level
      submissionDate: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(), // Corrected from submission_date
      stressScore: json['stress_score'] as int?,
      motivationScore: json['motivation_score'] as int?,
      satisfactionScore: json['satisfaction_score'] as int?,
      summary: json['summary'] as String?,
      recommendations: (json['recommendations'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
    );
  }
}

class PaginatedResponses {
  final List<EmployeeResponse> data;
  final int currentPage;
  final int lastPage;
  final int total;

  PaginatedResponses({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  factory PaginatedResponses.fromJson(Map<String, dynamic> json) {
    return PaginatedResponses(
      data: (json['data'] as List?)
          ?.map((item) => EmployeeResponse.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      currentPage: json['current_page'] as int? ?? 1,
      lastPage: json['last_page'] as int? ?? 1,
      total: json['total'] as int? ?? 0,
    );
  }
}
