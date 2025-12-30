class AnalysisResult {
  final int stressScore;
  final int motivationScore;
  final int satisfactionScore;
  final int globalScore;
  final String riskLevel;
  final List<String> recommendations;
  final String summary;
  final DateTime? createdAt; // Made createdAt nullable

  AnalysisResult({
    required this.stressScore,
    required this.motivationScore,
    required this.satisfactionScore,
    required this.globalScore,
    required this.riskLevel,
    required this.recommendations,
    required this.summary,
    this.createdAt, // Made createdAt optional
  });

  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    return AnalysisResult(
      stressScore: json['stress_score'],
      motivationScore: json['motivation_score'],
      satisfactionScore: json['satisfaction_score'],
      globalScore: json['global_score'],
      riskLevel: json['risk_level'],
      recommendations: List<String>.from(json['recommendations']),
      summary: json['summary'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null, // Handle nullable createdAt
    );
  }
}
