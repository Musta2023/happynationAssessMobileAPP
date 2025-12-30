class AdminStats {
  final int totalResponses;
  final double averageGlobalScore;
  final Map<String, int> riskDistribution;
  final Map<String, double> categoryAverages;

  AdminStats({
    required this.totalResponses,
    required this.averageGlobalScore,
    required this.riskDistribution,
    required this.categoryAverages,
  });

  factory AdminStats.fromJson(Map<String, dynamic> json) {
    return AdminStats(
      totalResponses: json['total_responses'],
      averageGlobalScore: (json['average_global_score'] as num).toDouble(),
      riskDistribution: Map<String, int>.from(json['risk_distribution']),
      categoryAverages: Map<String, double>.from(
        (json['category_averages'] as Map).map(
          (k, v) => MapEntry(k, (v as num).toDouble()),
        ),
      ),
    );
  }
}
