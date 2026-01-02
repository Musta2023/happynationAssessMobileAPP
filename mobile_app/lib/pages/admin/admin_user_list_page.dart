// lib/screens/admin/admin_user_list_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/controllers/admin_users_controller.dart';
import 'package:mobile_app/widgets/shared/back_and_home_buttons.dart';
import 'package:mobile_app/models/user.dart';
import 'package:mobile_app/widgets/shared/no_data_found_widget.dart';
import 'package:get/get.dart';
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

class AdminUserListPage extends ConsumerStatefulWidget {
  const AdminUserListPage({super.key});

  @override
  ConsumerState<AdminUserListPage> createState() => _AdminUserListPageState();
}

class _AdminUserListPageState extends ConsumerState<AdminUserListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adminUsersProvider.notifier).fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminUsersProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context, state),
      body: _buildBody(context, state),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed('/admin_user_form'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        icon: const Icon(Icons.person_add_outlined),
        label: const Text('Add Employee', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, AdminUsersState state) {
    return AppBar(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 1,
      automaticallyImplyLeading: false,
      actions: const [
        BackAndHomeButtons(),
      ],
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Employee Directory',
            style: TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text(
            '${state.users.length} Active Accounts',
            style: const TextStyle(color: AppColors.textSubtle, fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: AppColors.border, height: 1),
      ),
    );
  }

  Widget _buildBody(BuildContext context, AdminUsersState state) {
    if (state.isLoading && state.users.isEmpty) {
      return _buildShimmerLoading();
    }

    if (state.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.danger),
            const SizedBox(height: 16),
            Text(state.errorMessage!, style: const TextStyle(color: AppColors.textSubtle)),
            TextButton(
              onPressed: () => ref.read(adminUsersProvider.notifier).fetchUsers(),
              child: const Text('Retry Fetch'),
            )
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchAndStats(state),
          const SizedBox(height: 24.0),
          if (state.users.isEmpty)
            const NoDataFoundWidget(message: 'No employee accounts found.')
          else
            _buildUserList(state),
        ],
      ),
    );
  }

  Widget _buildSearchAndStats(AdminUsersState state) {
    return Column(
      children: [
        // Search Mock (Visual Polish)
        TextField(
          decoration: InputDecoration(
            hintText: 'Search by name or email...',
            hintStyle: const TextStyle(color: AppColors.textSubtle, fontSize: 14),
            prefixIcon: const Icon(Icons.search, color: AppColors.textSubtle, size: 20),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserList(AdminUsersState state) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: state.users.length,
        separatorBuilder: (context, index) => const Divider(height: 1, color: AppColors.border, indent: 70),
        itemBuilder: (context, index) {
          final user = state.users[index];
          return _buildUserListItem(user, state);
        },
      ),
    );
  }

  Widget _buildUserListItem(User user, AdminUsersState state) {
    final bool isMasterAdmin = user.email == 'admin@company.com';
    final initials = user.fullName.isNotEmpty ? user.fullName.split(' ').map((e) => e[0]).take(2).join().toUpperCase() : '?';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: ListTile(
        leading: Hero(
          tag: 'user-${user.id}',
          child: CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            child: Text(
              initials,
              style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ),
        title: Text(
          user.fullName,
          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textMain, fontSize: 15),
        ),
        subtitle: Text(
          user.email,
          style: const TextStyle(color: AppColors.textSubtle, fontSize: 13),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _actionButton(
              icon: Icons.edit_outlined,
              color: Colors.blue,
              onPressed: () => Get.toNamed('/admin_user_form', arguments: user),
            ),
            const SizedBox(width: 4),
            _actionButton(
              icon: Icons.delete_outline_rounded,
              color: isMasterAdmin ? Colors.grey[300]! : AppColors.danger,
              onPressed: isMasterAdmin || state.isDeleting ? null : () => _confirmDelete(context, user),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton({required IconData icon, required Color color, VoidCallback? onPressed}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, User user) async {
    final bool? confirm = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (context, anim1, anim2) => const SizedBox(),
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: anim1.value,
          child: Opacity(
            opacity: anim1.value,
            child: AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Text('Remove Employee?', style: TextStyle(fontWeight: FontWeight.bold)),
              content: Text('Are you sure you want to delete ${user.fullName}? This action cannot be undone.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Keep Account', style: TextStyle(color: AppColors.textSubtle)),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.danger,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Delete Account'),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (confirm == true) {
      final bool success = await ref.read(adminUsersProvider.notifier).deleteUser(user.id.toString());
      if (!mounted) return;
      
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? '${user.fullName} removed' : 'Failed to delete user'),
          backgroundColor: success ? AppColors.textMain : AppColors.danger,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: 8,
        itemBuilder: (_, __) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          height: 80,
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }
}
