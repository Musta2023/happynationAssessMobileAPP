import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/controllers/assessment_analytics_controller.dart';
import 'package:mobile_app/widgets/global_score_chart.dart';
import 'package:mobile_app/widgets/category_scores_chart.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:mobile_app/utils/pdf_exporter.dart';
import 'package:mobile_app/widgets/shared/back_and_home_buttons.dart';
import 'package:share_plus/share_plus.dart';

class AdminAssessmentAnalyticsPage extends ConsumerWidget {
  final String assessmentId;
  late final ScreenshotController _screenshotController;

  AdminAssessmentAnalyticsPage({super.key, required this.assessmentId}) {
    _screenshotController = ScreenshotController();
  }

  Future<void> _exportAsImage(BuildContext context) async {
    final image = await _screenshotController.capture();
    if (image == null) return;

    final directory = await getTemporaryDirectory();
    final imagePath = await File('${directory.path}/analytics.png').writeAsBytes(image);
    
    if (!context.mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    // ignore: deprecated_member_use
    Share.shareXFiles(
      [XFile(imagePath.path)],
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsState = ref.watch(assessmentAnalyticsProvider(assessmentId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assessment Analytics'),
        automaticallyImplyLeading: false,
        actions: [
          const BackAndHomeButtons(),
          IconButton(
            icon: const Icon(Icons.image),
            onPressed: () => _exportAsImage(context),
            tooltip: 'Export as Image',
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () {
              analyticsState.analytics.whenData((analytics) {
                PdfExporter.exportToPdf(analytics);
              });
            },
            tooltip: 'Export as PDF',
          ),
        ],
      ),
body: analyticsState.analytics.when(
  data: (analytics) {
    return Screenshot(
      controller: _screenshotController,
      child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
            
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      analytics.assessmentTitle,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Analytics as of: ${analytics.date.toLocal()}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: GlobalScoreChart(globalScore: analytics.globalScore),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        'Risk Level: ${analytics.riskLevel}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: _getRiskColor(analytics.riskLevel),
                            ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Category Scores',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    CategoryScoresChart(categoryScores: analytics.categoryScores),
                    const SizedBox(height: 24),
                    Text(
                      'Summary',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      analytics.summary,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Recommendations',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    ...analytics.recommendations.map(
                      (rec) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text('• $rec', style: Theme.of(context).textTheme.bodyLarge),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Failed to load analytics: $error'),
        ),
      ),
    );
  }

  Color _getRiskColor(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
