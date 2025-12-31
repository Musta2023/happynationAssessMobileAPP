import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/models/analysis_result.dart';
import 'package:mobile_app/main.dart'; // Import AppColors

class HistoryDetailPage extends StatelessWidget {
  final AnalysisResult result;

  HistoryDetailPage({super.key}) : result = Get.arguments as AnalysisResult;

  // Mapping risk to the specific AppColors defined in your main.dart
  Color _getRiskColor(String risk) {
    switch (risk.toLowerCase()) {
      case 'high':
        return AppColors.danger; // Rose
      case 'medium':
        return AppColors.warning; // Amber
      case 'low':
        return AppColors.success; // Emerald
      default:
        return AppColors.secondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Assessment Report'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. TOP SCORE CARD
            _buildScoreOverview(context),
            const SizedBox(height: 24),

            // 2. CATEGORY BREAKDOWN
            _buildSectionHeader('Detailed Metrics'),
            const SizedBox(height: 12),
            _buildCategoryCard(),
            const SizedBox(height: 24),

            // 3. AI SUMMARY
            _buildSectionHeader('AI Insights Summary'),
            const SizedBox(height: 12),
            _buildAISummaryCard(theme),
            const SizedBox(height: 24),

            // 4. RECOMMENDATIONS
            _buildSectionHeader('Actionable Recommendations'),
            const SizedBox(height: 12),
            ...result.recommendations.map((rec) => _buildRecommendationItem(rec)),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Header for Global Score and Risk Level
  Widget _buildScoreOverview(BuildContext context) {
    final riskColor = _getRiskColor(result.riskLevel);
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 5))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Global Score", style: TextStyle(color: Colors.grey[500], fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text(
                "${result.globalScore}%",
                style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: AppColors.dark),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: riskColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: riskColor.withValues(alpha: 0.2)),
            ),
            child: Column(
              children: [
                Text("RISK LEVEL", style: TextStyle(color: riskColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                Text(
                  result.riskLevel.toUpperCase(),
                  style: TextStyle(color: riskColor, fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // Category Scores with Linear Progress Bars
  Widget _buildCategoryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _buildProgressRow('Stress Management', result.stressScore.toDouble() / 100, Colors.orange),
          const Divider(height: 32),
          _buildProgressRow('Work Motivation', result.motivationScore.toDouble() / 100, Colors.blue),
          const Divider(height: 32),
          _buildProgressRow('Job Satisfaction', result.satisfactionScore.toDouble() / 100, Colors.purple),
        ],
      ),
    );
  }

  Widget _buildProgressRow(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.dark)),
            Text("${(value * 100).toInt()}%", style: TextStyle(fontWeight: FontWeight.bold, color: color)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: color.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  // AI Summary with a "Robot" or "Insight" feel
  Widget _buildAISummaryCard(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary.withValues(alpha: 0.05), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, color: theme.colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text("AI Analysis", style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          SelectableText(
            result.summary,
            style: const TextStyle(fontSize: 15, height: 1.5, color: AppColors.dark),
          ),
        ],
      ),
    );
  }

  // Recommendations as "Action Cards"
  Widget _buildRecommendationItem(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: const Border(left: BorderSide(width: 4, color: AppColors.success)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, color: AppColors.success, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: SelectableText(
              text,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.dark),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.dark),
    );
  }
}
