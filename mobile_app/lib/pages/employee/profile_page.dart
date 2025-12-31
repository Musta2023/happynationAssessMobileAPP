import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/services/auth_service.dart';
import 'package:mobile_app/main.dart'; // To access AppColors

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Get.find<AuthService>();
    final user = authService.user;
    final theme = Theme.of(context);

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('User data not available.')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Professional light background
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. HEADER SECTION (Avatar & Name)
            _buildHeader(user, theme),

            const SizedBox(height: 24),

            // 2. INFORMATION SECTION
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Personal Information",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.dark,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Unified Information Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildInfoTile(
                          icon: Icons.email_outlined,
                          label: 'Email Address',
                          value: user.email,
                          isFirst: true,
                        ),
                        _buildDivider(),
                        _buildInfoTile(
                          icon: Icons.business_outlined,
                          label: 'Department',
                          value: user.department ?? 'Not Assigned',
                        ),
                        _buildDivider(),
                        _buildInfoTile(
                          icon: Icons.badge_outlined,
                          label: 'Role',
                          value: user.role,
                          isLast: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 3. ACCOUNT ACTIONS SECTION
                  const Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.dark,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildActionTile(
                    icon: Icons.lock_outline,
                    title: "Change Password",
                    onTap: () {
                      Get.snackbar("Notice", "Feature coming soon");
                    },
                  ),
                  _buildActionTile(
                    icon: Icons.logout_rounded,
                    title: "Sign Out",
                    isDestructive: true,
                    onTap: () => authService.logout(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Modern Header with Avatar and Gradient Background
  Widget _buildHeader(dynamic user, ThemeData theme) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background decorative shape
        Container(
          height: 220,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [theme.colorScheme.primary, theme.colorScheme.primary.withValues(alpha: 0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
          ),
        ),
        // Content
        Column(
          children: [
            const SizedBox(height: 60),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                radius: 55,
                backgroundColor: Colors.grey[100],
                child: Text(
                  (user.firstName ?? user.fullName)[0].toUpperCase(),
                  style: TextStyle(
                    fontSize: 44, 
                    fontWeight: FontWeight.bold, 
                    color: theme.colorScheme.primary
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user.fullName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              user.role.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Reusable tile for displaying user info
  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F3FF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.primary, size: 22),
      ),
      title: Text(
        label,
        style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.dark),
      ),
    );
  }

  // Action tiles for Settings/Logout
  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? AppColors.danger : AppColors.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        leading: Icon(icon, color: color),
        title: Text(
          title,
          style: TextStyle(color: color, fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, indent: 70, endIndent: 20, color: Colors.grey[100]);
  }
}
