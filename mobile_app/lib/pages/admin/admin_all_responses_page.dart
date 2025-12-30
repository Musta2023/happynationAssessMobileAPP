// lib/screens/admin/admin_all_responses_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/controllers/admin_all_responses_controller.dart';
import 'package:mobile_app/models/admin_dashboard_models.dart';
import 'package:mobile_app/widgets/admin/response_list_item.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';

class AppColors {
  static const Color primary = Color(0xFF6366F1);
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color textMain = Color(0xFF0F172A);
  static const Color textSubtle = Color(0xFF64748B);
  static const Color border = Color(0xFFE2E8F0);
  
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);
}

class AdminAllResponsesPage extends ConsumerStatefulWidget {
  const AdminAllResponsesPage({super.key});

  @override
  ConsumerState<AdminAllResponsesPage> createState() => _AdminAllResponsesPageState();
}

class _AdminAllResponsesPageState extends ConsumerState<AdminAllResponsesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adminAllResponsesProvider.notifier).fetchResponses(
        ref.read(adminAllResponsesProvider).currentPage
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminAllResponsesProvider);
    final notifier = ref.read(adminAllResponsesProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context, state),
      body: _buildBody(context, state, notifier),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, AdminAllResponsesState state) {
    return AppBar(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 1,
      title: const Text(
        'Response Analytics',
        style: TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold, fontSize: 18),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.textMain),
        onPressed: () => Navigator.pop(context),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: AppColors.border, height: 1),
      ),
    );
  }

  Widget _buildBody(BuildContext context, AdminAllResponsesState state, AdminAllResponsesNotifier notifier) {
    if (state.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.danger),
            const SizedBox(height: 16),
            Text(state.errorMessage!, style: const TextStyle(color: AppColors.textSubtle)),
            TextButton(
              onPressed: () => notifier.fetchResponses(state.currentPage),
              child: const Text("Retry Connection"),
            )
          ],
        ),
      );
    }

    if (state.isLoading && state.responses == null) {
      return _buildShimmerLoading(context);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderSection(state),
          const SizedBox(height: 24.0),
          _buildFilterCard(context, state, notifier),
          const SizedBox(height: 32.0),
          _buildResponseListSection(context, state, notifier),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(AdminAllResponsesState state) {
    final count = state.responses?.total ?? 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Detailed Overview',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textMain, letterSpacing: -0.5),
        ),
        const SizedBox(height: 4),
        Text(
          'Showing $count total recorded employee assessments',
          style: const TextStyle(color: AppColors.textSubtle, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildFilterCard(BuildContext context, AdminAllResponsesState state, AdminAllResponsesNotifier notifier) {
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
          const Row(
            children: [
              Icon(Icons.filter_list, size: 18, color: AppColors.primary),
              SizedBox(width: 8),
              Text('Filter Results', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textMain)),
            ],
          ),
          const SizedBox(height: 16),
          _buildDeptDropdown(state, notifier),
          const SizedBox(height: 12),
          _buildDateRangeRow(context, state, notifier),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 16),
          _buildRiskFilterChips(context, state, notifier),
        ],
      ),
    );
  }

  Widget _buildDeptDropdown(AdminAllResponsesState state, AdminAllResponsesNotifier notifier) {
    return DropdownButtonFormField<String>(
      initialValue: state.selectedDepartment,
      decoration: _filterInputDecoration('Department', Icons.business_outlined),
      style: const TextStyle(fontSize: 14, color: AppColors.textMain, fontWeight: FontWeight.w500),
      items: [
        const DropdownMenuItem(value: null, child: Text('All Departments')),
        ...(state.availableDepartments ?? []).map((d) => DropdownMenuItem(value: d, child: Text(d))),
      ],
      onChanged: (val) => notifier.setSelectedDepartment(val),
    );
  }

  Widget _buildDateRangeRow(BuildContext context, AdminAllResponsesState state, AdminAllResponsesNotifier notifier) {
    return Row(
      children: [
        Expanded(child: _buildDateButton(context, 'Start Date', state.startDate, true, notifier)),
        const SizedBox(width: 12),
        Expanded(child: _buildDateButton(context, 'End Date', state.endDate, false, notifier)),
      ],
    );
  }

  Widget _buildDateButton(BuildContext context, String label, DateTime? date, bool isStart, AdminAllResponsesNotifier notifier) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2022),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          isStart ? notifier.setStartDate(picked) : notifier.setEndDate(picked);
        }
      },
      child: InputDecorator(
        decoration: _filterInputDecoration(label, Icons.calendar_today_outlined),
        child: Text(
          date != null ? DateFormat('MMM d, y').format(date) : 'Select',
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildRiskFilterChips(BuildContext context, AdminAllResponsesState state, AdminAllResponsesNotifier notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Risk Sensitivity', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSubtle)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          children: [
            _riskChip('All', null, Colors.grey, state, notifier),
            _riskChip('Low', 'Low', AppColors.success, state, notifier),
            _riskChip('Medium', 'Medium', AppColors.warning, state, notifier),
            _riskChip('High', 'High', AppColors.danger, state, notifier),
          ],
        ),
      ],
    );
  }

  Widget _riskChip(String label, String? value, Color color, AdminAllResponsesState state, AdminAllResponsesNotifier notifier) {
    final isSelected = state.selectedRiskLevelFilter == (value ?? 'All');
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) => selected ? notifier.setRiskLevelFilter(value ?? 'All') : null,
      selectedColor: color.withValues(alpha: 0.15),
      backgroundColor: AppColors.background,
      labelStyle: TextStyle(
        color: isSelected ? color : AppColors.textSubtle,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 13,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: isSelected ? color : AppColors.border),
      ),
      showCheckmark: false,
    );
  }

  Widget _buildResponseListSection(BuildContext context, AdminAllResponsesState state, AdminAllResponsesNotifier notifier) {
    final responses = state.responses;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Individual Responses',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textMain),
        ),
        const SizedBox(height: 16.0),
        if (responses != null && responses.data.isNotEmpty)
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: responses.data.length,
                  separatorBuilder: (context, index) => const Divider(height: 1, color: AppColors.border),
                  itemBuilder: (context, index) => ResponseListItem(response: responses.data[index]),
                ),
                _buildPaginationControls(context, responses, state.isLoading, notifier),
              ],
            ),
          )
        else if (state.isLoading)
          const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator()))
        else
          _buildEmptyState(),
      ],
    );
  }

  Widget _buildPaginationControls(BuildContext context, PaginatedResponses responses, bool isLoading, AdminAllResponsesNotifier notifier) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _paginationButton(Icons.chevron_left, responses.currentPage > 1 && !isLoading ? () => notifier.previousPage() : null),
          Text(
            'Page ${responses.currentPage} of ${responses.lastPage}',
            style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textMain, fontSize: 13),
          ),
          _paginationButton(Icons.chevron_right, responses.currentPage < responses.lastPage && !isLoading ? () => notifier.nextPage() : null),
        ],
      ),
    );
  }

  Widget _paginationButton(IconData icon, VoidCallback? onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(8),
            color: onTap == null ? Colors.transparent : AppColors.surface,
          ),
          child: Icon(icon, size: 20, color: onTap == null ? Colors.grey[300] : AppColors.textMain),
        ),
      ),
    );
  }

  InputDecoration _filterInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.textSubtle, fontSize: 12),
      prefixIcon: Icon(icon, size: 18, color: AppColors.primary),
      filled: true,
      fillColor: AppColors.background.withValues(alpha: 0.5),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          children: [
            Icon(Icons.inbox_outlined, size: 48, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text('No responses match your filters', style: TextStyle(color: AppColors.textSubtle, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoading(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(height: 40, width: double.infinity, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12))),
            const SizedBox(height: 20),
            Container(height: 200, width: double.infinity, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16))),
            const SizedBox(height: 32),
            ...List.generate(5, (i) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            )),
          ],
        ),
      ),
    );
  }
}
