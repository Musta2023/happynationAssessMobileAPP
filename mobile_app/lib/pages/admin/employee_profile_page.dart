// lib/screens/admin/employee_profile_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/controllers/employee_profile_controller.dart';
import 'package:mobile_app/widgets/shared/back_and_home_buttons.dart';
import 'package:mobile_app/models/admin_dashboard_models.dart';
import 'package:mobile_app/widgets/admin/response_list_item.dart';
import 'package:mobile_app/widgets/shared/no_data_found_widget.dart';
import 'package:shimmer/shimmer.dart';

class AppColors {
  static const Color primary = Color(0xFF6366F1); // Indigo
  static const Color background = Color(0xFFF8FAFC); // Slate 50
  static const Color surface = Colors.white;
  static const Color textMain = Color(0xFF0F172A); // Slate 900
  static const Color textSubtle = Color(0xFF64748B); // Slate 500
  static const Color border = Color(0xFFE2E8F0); // Slate 200
  static const Color danger = Color(0xFFF43F5E); // Rose
}

class EmployeeProfilePage extends ConsumerStatefulWidget {
  final EmployeeResponse employee;

  const EmployeeProfilePage({super.key, required this.employee});

  @override
  ConsumerState<EmployeeProfilePage> createState() => _EmployeeProfilePageState();
}

class _EmployeeProfilePageState extends ConsumerState<EmployeeProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(employeeProfileProvider(widget.employee.id).notifier).fetchEmployeeResponses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(employeeProfileProvider(widget.employee.id));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: _buildBody(context, state),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 1,
      automaticallyImplyLeading: false,
      title: const Text(
        'Employee Profile',
        style: TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold, fontSize: 18),
      ),
      actions: [
        const BackAndHomeButtons(),
        IconButton(
          onPressed: () {}, // Optional: Export or Edit actions
          icon: const Icon(Icons.more_horiz, color: AppColors.textSubtle),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: AppColors.border, height: 1),
      ),
    );
  }

  Widget _buildBody(BuildContext context, EmployeeProfileState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 24.0),
          _buildQuickStats(state),
          const SizedBox(height: 32.0),
          _buildHistorySection(context, state),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    final initials = widget.employee.safeEmployeeName.isNotEmpty
        ? widget.employee.safeEmployeeName.split(' ').map((e) => e[0]).take(2).join().toUpperCase()
        : '?';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            child: Text(
              initials,
              style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.employee.safeEmployeeName,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textMain, letterSpacing: -0.5),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.email_outlined, size: 14, color: AppColors.textSubtle),
                    const SizedBox(width: 6),
                    Text(
                      widget.employee.employeeEmail,
                      style: const TextStyle(color: AppColors.textSubtle, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Full-time Employee', // Replace with dynamic role/dept if available
                    style: TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(EmployeeProfileState state) {
    final totalResponses = state.responses?.length ?? 0;
    
    return Row(
      children: [
        Expanded(child: _buildMiniStat('Total Assessments', totalResponses.toString(), Icons.assignment_outlined)),
        const SizedBox(width: 16),
        Expanded(child: _buildMiniStat('Risk Status', 'Monitoring', Icons.shield_outlined)),
      ],
    );
  }

  Widget _buildMiniStat(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textMain)),
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSubtle, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildHistorySection(BuildContext context, EmployeeProfileState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4.0),
          child: Text(
            'Response History',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textMain),
          ),
        ),
        const SizedBox(height: 16.0),
        if (state.isLoading)
          _buildShimmerList()
        else if (state.errorMessage != null)
          _buildErrorState(state.errorMessage!)
        else if (state.responses != null && state.responses!.isNotEmpty)
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.responses!.length,
              separatorBuilder: (context, index) => const Divider(height: 1, color: AppColors.border, indent: 16, endIndent: 16),
              itemBuilder: (context, index) {
                return ResponseListItem(response: state.responses![index]);
              },
            ),
          )
        else
          const NoDataFoundWidget(message: 'No responses recorded yet.'),
      ],
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            const Icon(Icons.cloud_off_outlined, size: 48, color: AppColors.danger),
            const SizedBox(height: 16),
            Text(error, style: const TextStyle(color: AppColors.textSubtle)),
            TextButton(
              onPressed: () => ref.read(employeeProfileProvider(widget.employee.id).notifier).fetchEmployeeResponses(),
              child: const Text('Retry Fetch'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: List.generate(3, (index) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        )),
      ),
    );
  }
}
