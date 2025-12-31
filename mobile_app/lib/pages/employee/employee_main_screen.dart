import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/controllers/employee_main_controller.dart';
import 'package:mobile_app/pages/employee/history_page.dart';
import 'package:mobile_app/pages/employee/profile_page.dart';
import 'package:mobile_app/pages/employee/employee_assessments_page.dart';
import 'package:mobile_app/services/auth_service.dart';

class EmployeeMainScreen extends StatelessWidget {
  final EmployeeMainController controller = Get.put(EmployeeMainController());

  EmployeeMainScreen({super.key});

  final List<String> _pageTitles = const [
    'Available Assessments',
    'My Progress History',
    'Account Profile',
  ];

  // Modern Logout Confirmation Dialog
  void _showLogoutDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to sign out of your account?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () => Get.find<AuthService>().logout(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() => Scaffold(
          backgroundColor: const Color(0xFFF8F9FA), // Clean light background
          appBar: AppBar(
            elevation: 0,
            backgroundColor: theme.colorScheme.primary,
            centerTitle: true,
            title: Text(
              _pageTitles[controller.selectedIndex.value],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
                color: Colors.white,
              ),
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20), // Modern rounded bottom bar
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 8),
                child: IconButton(
                  icon: const Icon(Icons.logout_rounded, color: Colors.white),
                  onPressed: () => _showLogoutDialog(context),
                ),
              ),
            ],
          ),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: IndexedStack(
              key: ValueKey<int>(controller.selectedIndex.value),
              index: controller.selectedIndex.value,
              children: [
                EmployeeAssessmentsPage(),
                const HistoryPage(),
                const ProfilePage(),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: BottomNavigationBar(
                currentIndex: controller.selectedIndex.value,
                onTap: controller.changePage,
                backgroundColor: Colors.white,
                selectedItemColor: theme.colorScheme.primary,
                unselectedItemColor: Colors.grey[400],
                selectedFontSize: 12,
                unselectedFontSize: 12,
                type: BottomNavigationBarType.fixed,
                showUnselectedLabels: true,
                elevation: 0,
                items: const [
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Icon(Icons.assignment_outlined),
                    ),
                    activeIcon: Icon(Icons.assignment),
                    label: 'Assessments',
                  ),
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Icon(Icons.analytics_outlined),
                    ),
                    activeIcon: Icon(Icons.analytics),
                    label: 'History',
                  ),
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Icon(Icons.person_outline),
                    ),
                    activeIcon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
