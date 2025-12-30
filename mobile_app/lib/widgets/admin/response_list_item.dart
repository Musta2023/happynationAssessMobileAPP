// lib/widgets/admin/response_list_item.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/styles/dashboard_styles.dart';
import 'package:mobile_app/models/admin_dashboard_models.dart';
import 'package:get/get.dart'; // Import GetX for navigation

class ResponseListItem extends StatelessWidget {
  final EmployeeResponse response;
  // final VoidCallback onTap; // We will handle navigation internally

  const ResponseListItem({
    super.key,
    required this.response,
    // required this.onTap,
  });

  Color _getRiskColor() {
    switch (response.riskLevel) {
      case 'Low':
        return Colors.green.shade600;
      case 'Medium':
        return Colors.orange.shade600;
      case 'High':
        return Colors.red.shade600;
      default:
        return Colors.grey;
    }
  }

  Color _getRiskBadgeColor() {
    switch (response.riskLevel) {
      case 'Low':
        return Colors.green.shade100;
      case 'Medium':
        return Colors.orange.shade100;
      case 'High':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  Color _getRiskBadgeTextColor() {
    switch (response.riskLevel) {
      case 'Low':
        return Colors.green.shade800;
      case 'Medium':
        return Colors.orange.shade800;
      case 'High':
        return Colors.red.shade800;
      default:
        return Colors.grey.shade800;
    }
  }

  String _getInitials(String name, String email) {
    if (name.isNotEmpty && name != 'Unknown User') {
      final parts = name.split(' ');
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      } else if (parts.isNotEmpty) {
        return parts[0][0].toUpperCase();
      }
    }
    return email[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String displayDate = DateFormat('MMM dd, yyyy').format(response.submissionDate);
    final String displayName = response.safeEmployeeName;
    _getInitials(displayName, response.employeeEmail);
    final Color riskColor = _getRiskColor();

    return GestureDetector( // Using GestureDetector for onTap
      onTap: () {
        Get.toNamed('/admin_response_detail', arguments: response);
      },
      child: Container( // Using Container with BoxDecoration
        margin: const EdgeInsets.symmetric(vertical: 8.0), // Margin between items
        padding: const EdgeInsets.all(16.0),
        decoration: DashboardStyles.cardDecoration(), // Consistent card decoration
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Avatar/Initials with status ring
                Hero(
                  tag: 'response-${response.id}', // Unique tag for Hero animation
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: riskColor, width: 2), // Status ring
                    ),
                    child: CircleAvatar(
                      backgroundColor: theme.colorScheme.primaryContainer,
                      child: Text(
                        response.id, // Display the unique ID
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        response.employeeEmail,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8.0),
                      // Sentiment Sparkline Placeholder
                      Container(
                        height: 20, // Height for sparkline
                        width: 80, // Width for sparkline
                        color: Colors.grey.shade100, // Placeholder color
                        alignment: Alignment.center,
                        child: Text('Sparkline', style: theme.textTheme.bodySmall),
                        // Actual fl_chart LineChart implementation would go here:
                        // child: LineChart(
                        //   LineChartData(
                        //     gridData: const FlGridData(show: false),
                        //     titlesData: const FlTitlesData(show: false),
                        //     borderData: FlBorderData(show: false),
                        //     lineBarsData: [
                        //       LineChartBarData(
                        //         spots: sentimentData.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
                        //         isCurved: true,
                        //         barWidth: 2,
                        //         dotData: const FlDotData(show: false),
                        //         belowBarData: BarAreaData(show: false),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Risk Badge (soft-tonal colors)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: _getRiskBadgeColor(),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text(
                        response.riskLevel,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: _getRiskBadgeTextColor(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Score: ${response.globalScore.toStringAsFixed(1)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: riskColor, // Use risk color for score
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      displayDate,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // No Divider, rely on Container margin for separation
          ],
        ),
      ),
    );
  }
}
