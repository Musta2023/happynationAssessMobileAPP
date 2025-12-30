import 'package:get/get.dart'; // Essential GetX imports
import 'package:mobile_app/pages/admin/admin_all_responses_page.dart';
import 'package:mobile_app/pages/admin/admin_home_page.dart';
import 'package:mobile_app/routes/role_middleware.dart'; // For RoleMiddleware
import 'package:mobile_app/pages/questionnaire/questionnaire_page.dart'; // For QuestionnairePage
// For AdminDashboardPage
import 'package:mobile_app/admin/pages/users/user_list_page.dart'; // For AdminUserListPage

// Core user-facing pages
import '../pages/auth/login_screen.dart';
import '../pages/auth/register_screen.dart';
import 'package:mobile_app/pages/results/results_page.dart';

// Employee specific pages
import 'package:mobile_app/pages/employee/employee_main_screen.dart';
import 'package:mobile_app/pages/employee/history_page.dart';
import 'package:mobile_app/pages/employee/profile_page.dart';
import 'package:mobile_app/pages/employee/history_detail_page.dart';

import 'package:mobile_app/admin/pages/questions/question_edit_page.dart';
import 'package:mobile_app/admin/pages/responses/response_detail_page.dart';
import 'package:mobile_app/admin/pages/questions/question_list_page.dart';
import 'package:mobile_app/pages/admin/admin_login_page.dart';
import 'package:mobile_app/pages/admin/admin_assessment_list_page.dart';
import 'auth_middleware.dart';

part 'app_routes.dart';

/// Defines the application's pages and their bindings with routes.
///
/// This class is used by `GetMaterialApp` to configure the app's navigation.
class AppPages {
  /// The initial route to be loaded when the app starts.
  ///
  /// Note: The actual initial route is dynamically determined in `main.dart`
  /// based on the authentication state. This serves as a fallback.
  static const initial = Routes.login;

  /// A list of all pages in the application.
  ///
  /// Each [GetPage] maps a route name to a page widget and can specify
  /// bindings, middlewares, and transitions.
  static final routes = [
    GetPage(
      name: Routes.login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: Routes.register,
      page: () => const RegistrationScreen(),
      // Uses a slide-in transition from the bottom.
      transition: Transition.downToUp,
    ),
    GetPage(
      name: Routes.adminLogin, // New: Admin Login Page
      page: () => AdminLoginPage(),
    ),
    // Removed: GetPage for Routes.home as it's being replaced by employeeMain and adminDashboard
    GetPage(
      name: Routes.employeeMain, // New: Employee Main Screen
      page: () => EmployeeMainScreen(),
      middlewares: [
        AuthMiddleware(), // Should always be protected
        RoleMiddleware('employee'), // Only employees can access this
      ],
    ),
    GetPage(
      name: Routes.questionnaire,
      page: () => QuestionnairePage(),
      middlewares: [
        AuthMiddleware(),
        RoleMiddleware('employee'),
      ],
    ),
    GetPage(
      name: Routes.results,
      page: () => ResultsPage(), // Assuming a ResultsPage exists
      middlewares: [
        AuthMiddleware(), // Results page should also be protected by auth
      ],
    ),
    GetPage(
      name: Routes.history, // New: History Page
      page: () => const HistoryPage(),
      middlewares: [
        AuthMiddleware(),
        RoleMiddleware('employee'),
      ],
    ),
    GetPage(
      name: Routes.historyDetail, // New: History Detail Page
      page: () => HistoryDetailPage(),
      middlewares: [
        AuthMiddleware(),
        RoleMiddleware('employee'),
      ],
    ),
    GetPage(
      name: Routes.profile, // New: Profile Page
      page: () => const ProfilePage(),
      middlewares: [
        AuthMiddleware(),
        RoleMiddleware('employee'),
      ],
    ),
    GetPage(
      name: Routes.adminDashboard,
      page: () => const AdminHomePage(),
      middlewares: [
        AuthMiddleware(),
        RoleMiddleware('admin'),
      ],
    ),
    GetPage(
      name: Routes.adminQuestions,
      page: () => AdminQuestionListPage(),
      middlewares: [
        AuthMiddleware(),
        RoleMiddleware('admin'),
      ],
    ),
    GetPage(
      name: Routes.adminResponses,
      page: () => const AdminAllResponsesPage(),
      middlewares: [
        AuthMiddleware(),
        RoleMiddleware('admin'),
      ],
    ),
    GetPage(
      name: Routes.adminResponseDetail,
      page: () => const AdminResponseDetailPage(),
      middlewares: [
        AuthMiddleware(),
        RoleMiddleware('admin'),
      ],
    ),
    GetPage(
      name: Routes.adminQuestionEdit,
      page: () => QuestionEditPage(question: Get.arguments),
      middlewares: [
        AuthMiddleware(),
        RoleMiddleware('admin'),
      ],
    ),
    GetPage(
      name: Routes.adminUsers,
      page: () => const AdminUserListPage(),
      middlewares: [
        AuthMiddleware(),
        RoleMiddleware('admin'),
      ],
    ),
    GetPage(
      name: Routes.adminAssessments,
      page: () => const AdminAssessmentListPage(),
      middlewares: [
        AuthMiddleware(),
        RoleMiddleware('admin'),
      ],
    ),
  ];
}
