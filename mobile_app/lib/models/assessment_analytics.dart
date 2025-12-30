class AssessmentAnalytics {
  final int assessmentId;
  final String assessmentTitle;
  final DateTime date;
  final double globalScore;
  final Map<String, double> categoryScores;
  final String riskLevel;
  final String summary;
  final List<String> recommendations;

  AssessmentAnalytics({
    required this.assessmentId,
    required this.assessmentTitle,
    required this.date,
    required this.globalScore,
    required this.categoryScores,
    required this.riskLevel,
    required this.summary,
    required this.recommendations,
  });

  factory AssessmentAnalytics.fromJson(Map<String, dynamic> json) {
    return AssessmentAnalytics(
      assessmentId: json['assessment_id'],
      assessmentTitle: json['assessment_title'],
      date: DateTime.parse(json['date']),
      globalScore: (json['global_score'] as num).toDouble(),
      categoryScores: (json['category_scores'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, (value as num).toDouble()),
      ),
      riskLevel: json['risk_level'],
      summary: json['summary'],
      recommendations: List<String>.from(json['recommendations']),
    );
  }
}
