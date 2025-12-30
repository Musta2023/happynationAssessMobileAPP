// lib/screens/admin/admin_home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:mobile_app/controllers/admin_dashboard_controller.dart';
import 'package:mobile_app/models/admin_dashboard_models.dart';
import 'package:mobile_app/widgets/shared/no_data_found_widget.dart';
import 'package:mobile_app/widgets/admin/risk_distribution_pie_chart.dart';
import 'package:mobile_app/widgets/admin/category_scores_bar_chart.dart';
import 'package:mobile_app/widgets/admin/global_score_line_chart.dart';
import 'package:mobile_app/pages/admin/admin_all_responses_page.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AppColors {
  static const Color primary = Color(0xFF6366F1); // Indigo
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color success = Color(0xFF10B981); // Emerald
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color danger = Color(0xFFEF4444);  // Rose
  static const Color textMain = Color(0xFF0F172A);
  static const Color textSubtle = Color(0xFF64748B);
  static const Color border = Color(0xFFE2E8F0);
}

class AdminHomePage extends ConsumerStatefulWidget {
  const AdminHomePage({super.key});

  @override
  ConsumerState<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends ConsumerState<AdminHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adminDashboardProvider.notifier).fetchDashboardData();
    });
  }

  /// Shows a confirmation dialog before logging out
  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to sign out of the admin panel?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSubtle)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              // 1. Clear your local storage/session here if needed
              // 2. Navigate to login and clear navigation history
              Get.offAllNamed('/login'); 
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(adminDashboardProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context, dashboardState),
      body: _buildBody(context, dashboardState),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, AdminDashboardState state) {
    String dateRange = "All Time";
    if (state.startDate != null && state.endDate != null) {
      dateRange = "${DateFormat('MMM d').format(state.startDate!)} - ${DateFormat('MMM d, y').format(state.endDate!)}";
    }

    return AppBar(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Admin Dashboard',
            style: TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text(
            dateRange,
            style: const TextStyle(color: AppColors.textSubtle, fontSize: 12, fontWeight: FontWeight.normal),
          ),
        ],
      ),
      actions: [
        PopupMenuButton<String>(
          offset: const Offset(0, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          onSelected: (value) {
            if (value == 'logout') _handleLogout();
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              enabled: false,
              child: Text("Signed in as Admin", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'logout',
              child: Row(
                children: [
                  Icon(Icons.logout, size: 18, color: AppColors.danger),
                  SizedBox(width: 8),
                  Text('Logout', style: TextStyle(color: AppColors.danger)),
                ],
              ),
            ),
          ],
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: const Icon(Icons.person_outline, color: AppColors.primary),
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: AppColors.border, height: 1),
      ),
    );
  }

  Widget _buildBody(BuildContext context, AdminDashboardState dashboardState) {
    if (dashboardState.isLoading && dashboardState.statistics == null) {
      return _buildShimmerLoading(context);
    }

    if (dashboardState.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.danger),
            const SizedBox(height: 16),
            Text(dashboardState.errorMessage!, textAlign: TextAlign.center),
            TextButton(
              onPressed: () => ref.read(adminDashboardProvider.notifier).fetchDashboardData(),
              child: const Text("Retry"),
            )
          ],
        ),
      );
    }

    if (dashboardState.statistics == null) {
      return const NoDataFoundWidget(message: 'No dashboard data available.');
    }

    return _buildDashboard(context, dashboardState);
  }

  Widget _buildDashboard(BuildContext context, AdminDashboardState state) {
    final stats = state.statistics!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeHeader(),
          const SizedBox(height: 24.0),
          _buildFiltersSection(context, state),
          const SizedBox(height: 32.0),
          _buildKPICards(context, stats),
          const SizedBox(height: 32.0),
          _buildVisualInsightsSection(context, stats),
          const SizedBox(height: 32.0),
          _buildTrendsSection(context, stats),
          const SizedBox(height: 32.0),
          _buildQuickActions(context),
          const SizedBox(height: 40.0),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back, Admin',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textMain,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Here’s a snapshot of employee wellbeing',
          style: TextStyle(color: AppColors.textSubtle, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildFiltersSection(BuildContext context, AdminDashboardState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        bool isWide = constraints.maxWidth > 600;
        return Column(
          children: [
            if (isWide)
              Row(
                children: [
                  Expanded(child: _buildDeptDropdown(state)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildDateRangeSelector(state)),
                ],
              )
            else ...[
              _buildDeptDropdown(state),
              const SizedBox(height: 12),
              _buildDateRangeSelector(state),
            ]
          ],
        );
      }),
    );
  }

  Widget _buildDeptDropdown(AdminDashboardState state) {
    return DropdownButtonFormField<String>(
      initialValue: state.selectedDepartment,
      decoration: _filterInputDecoration('Department', Icons.business_outlined),
      style: const TextStyle(fontSize: 14, color: AppColors.textMain),
      items: [
        const DropdownMenuItem(value: null, child: Text('All Departments')),
        ...(state.availableDepartments ?? []).map((d) => DropdownMenuItem(value: d, child: Text(d))),
      ],
      onChanged: (val) => ref.read(adminDashboardProvider.notifier).setSelectedDepartment(val),
    );
  }

  Widget _buildDateRangeSelector(AdminDashboardState state) {
    String dateLabel = "Select Date Range";
    if (state.startDate != null && state.endDate != null) {
      dateLabel = "${DateFormat('yMMMd').format(state.startDate!)} - ${DateFormat('yMMMd').format(state.endDate!)}";
    }
    return InkWell(
      onTap: () async {
        final range = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
        );
        if (range != null) {
          ref.read(adminDashboardProvider.notifier).setStartDate(range.start);
          ref.read(adminDashboardProvider.notifier).setEndDate(range.end);
        }
      },
      child: InputDecorator(
        decoration: _filterInputDecoration('Date Range', Icons.calendar_today_outlined),
        child: Text(dateLabel, style: const TextStyle(fontSize: 14)),
      ),
    );
  }

  InputDecoration _filterInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 18, color: AppColors.primary),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
    );
  }

  Widget _buildKPICards(BuildContext context, DashboardStatistics stats) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth < 600 ? 2 : 3;
        return GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: constraints.maxWidth < 600 ? 1.3 : 2.2,
          ),
          children: [
            _buildPremiumStatCard('Total Responses', stats.totalResponses.toString(), Icons.assignment_outlined, AppColors.primary),
            _buildPremiumStatCard('Avg. Global Score', stats.averageGlobalScore.toStringAsFixed(1), Icons.insights_rounded, AppColors.success),
            _buildPremiumStatCard('High-Risk Cases', stats.highRiskCount.toString(), Icons.warning_amber_rounded, AppColors.danger),
          ],
        );
      },
    );
  }

  Widget _buildPremiumStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: color, size: 20),
              ),
              const Icon(Icons.more_horiz, color: AppColors.textSubtle, size: 18),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textMain)),
              Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textSubtle, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVisualInsightsSection(BuildContext context, DashboardStatistics stats) {
    return LayoutBuilder(builder: (context, constraints) {
      bool isWide = constraints.maxWidth > 800;
      return Flex(
        direction: isWide ? Axis.horizontal : Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: isWide ? 2 : 0,
            child: _buildChartContainer('Category Averages', CategoryScoresBarChart(categoryScores: stats.categoryScores)),
          ),
          SizedBox(width: isWide ? 20 : 0, height: isWide ? 0 : 20),
          Expanded(
            flex: isWide ? 1 : 0,
            child: _buildChartContainer('Risk Distribution', RiskDistributionPieChart(
              lowRiskCount: stats.lowRiskCount,
              mediumRiskCount: stats.mediumRiskCount,
              highRiskCount: stats.highRiskCount,
            )),
          ),
        ],
      );
    });
  }

  Widget _buildTrendsSection(BuildContext context, DashboardStatistics stats) {
    return _buildChartContainer(
      'Global Score Over Time',
      GlobalScoreLineChart(trendData: stats.globalScoreTrend),
      height: 300,
    );
  }

  Widget _buildChartContainer(String title, Widget chart, {double height = 280}) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textMain)),
              const Spacer(),
              const Icon(Icons.info_outline, size: 16, color: AppColors.textSubtle),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(child: chart),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textMain)),
        const SizedBox(height: 16),
        LayoutBuilder(builder: (context, constraints) {
          int count = constraints.maxWidth > 600 ? 4 : 2;
          return GridView.count(
            crossAxisCount: count,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _buildActionCard('All Responses', Icons.list_alt, AppColors.primary, () => Get.to(() => const AdminAllResponsesPage())),
              _buildActionCard('Employees', Icons.people_outline, Colors.blue, () => Get.toNamed('/admin_users')),
              _buildActionCard('Questions', Icons.quiz_outlined, Colors.purple, () => Get.toNamed('/admin_questions')),
              _buildActionCard('Assessments', Icons.assignment_turned_in_outlined, Colors.teal, () => Get.toNamed('/admin_assessments')),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildActionCard(String label, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textMain)),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoading(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 30, width: 200, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8))),
            const SizedBox(height: 24),
            Container(height: 100, width: double.infinity, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16))),
            const SizedBox(height: 24),
            Row(
              children: List.generate(3, (i) => Expanded(child: Container(margin: const EdgeInsets.only(right: 8), height: 120, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16))))),
            ),
            const SizedBox(height: 24),
            Container(height: 300, width: double.infinity, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16))),
          ],
        ),
      ),
    );
  }
}
