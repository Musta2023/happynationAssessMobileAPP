import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:mobile_app/models/assessment_analytics.dart';

class PdfExporter {
  static Future<void> exportToPdf(AssessmentAnalytics analytics) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          _buildHeader(),
          _buildTitle(analytics),
          _buildInfo(analytics),
          _buildScores(analytics),
          _buildSummary(analytics),
          _buildRecommendations(analytics),
        ],
      ),
    );

    await Printing.sharePdf(bytes: await pdf.save(), filename: 'assessment-analytics.pdf');
  }

  static pw.Widget _buildHeader() {
    return pw.Container(
      alignment: pw.Alignment.center,
      margin: const pw.EdgeInsets.only(bottom: 20),
      child: pw.Text(
        'Happy Nation Assessment Analytics',
        style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  static pw.Widget _buildTitle(AssessmentAnalytics analytics) {
    return pw.Header(
      level: 1,
      child: pw.Text(analytics.assessmentTitle),
    );
  }

  static pw.Widget _buildInfo(AssessmentAnalytics analytics) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Date: ${analytics.date.toLocal()}'),
        pw.SizedBox(height: 10),
      ],
    );
  }

  static pw.Widget _buildScores(AssessmentAnalytics analytics) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Header(level: 2, child: pw.Text('Scores')),
        pw.Text('Global Score: ${analytics.globalScore.toStringAsFixed(2)}%'),
        pw.Text('Risk Level: ${analytics.riskLevel}'),
        pw.SizedBox(height: 10),
        pw.Header(level: 3, child: pw.Text('Category Scores')),
        ...analytics.categoryScores.entries.map(
          (entry) => pw.Text('${entry.key}: ${entry.value.toStringAsFixed(2)}%'),
        ),
        pw.SizedBox(height: 20),
      ],
    );
  }

  static pw.Widget _buildSummary(AssessmentAnalytics analytics) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Header(level: 2, child: pw.Text('Summary')),
        pw.Text(analytics.summary),
        pw.SizedBox(height: 20),
      ],
    );
  }

  static pw.Widget _buildRecommendations(AssessmentAnalytics analytics) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Header(level: 2, child: pw.Text('Recommendations')),
        ...analytics.recommendations.map((rec) => pw.Bullet(text: rec)),
        pw.SizedBox(height: 20),
      ],
    );
  }
}
