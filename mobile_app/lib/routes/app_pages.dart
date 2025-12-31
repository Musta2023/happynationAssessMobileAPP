import 'package:get/get.dart';
// Core Auth Pages
import '../pages/auth/login_screen.dart';
import '../pages/auth/register_screen.dart';

// Employee / User Facing Pages
import 'package:mobile_app/pages/employee/employee_main_screen.dart';
import 'package:mobile_app/pages/employee/history_page.dart';
import 'package:mobile_app/pages/employee/profile_page.dart';
import 'package:mobile_app/pages/employee/history_detail_page.dart';
import 'package:mobile_app/pages/questionnaire/questionnaire_page.dart';
import 'package:mobile_app/pages/results/results_page.dart';

// Admin Pages
import 'package:mobile_app/pages/admin/admin_login_page.dart';
import 'package:mobile_app/pages/admin/admin_home_page.dart';
import 'package:mobile_app/pages/admin/admin_all_responses_page.dart';
import 'package:mobile_app/pages/admin/admin_response_detail_page.dart';
import 'package:mobile_app/pages/admin/admin_user_list_page.dart';
import 'package:mobile_app/pages/admin/admin_question_list_page.dart';
import 'package:mobile_app/pages/admin/admin_assessment_list_page.dart';
import 'package:mobile_app/admin/pages/questions/question_edit_page.dart';

// Middlewares
import 'auth_middleware.dart';
import 'package:mobile_app/routes/role_middleware.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = Routes.login;

  static final routes = [
    // --- AUTHENTICATION ---
    GetPage(
      name: Routes.login,
      page: () => const LoginScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.register,
      page: () => const RegistrationScreen(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: Routes.adminLogin,
      page: () => AdminLoginPage(),
      transition: Transition.cupertino,
    ),

    // --- EMPLOYEE SECTION ---
    GetPage(
      name: Routes.employeeMain,
      page: () => EmployeeMainScreen(),
      binding: BindingsBuilder(() {
        // You can add controllers here if you don't want to Put them in the UI
      }),
      middlewares: [
        AuthMiddleware(),
        RoleMiddleware('employee'),
      ],
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.questionnaire,
      // We pass the assessmentId via Get.arguments inside the Page/Controller
      page: () => QuestionnairePage(assessmentId: Get.arguments), 
      middlewares: [
        AuthMiddleware(),
        RoleMiddleware('employee'),
      ],
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.results,
      page: () => const ResultsPage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.history,
      page: () => HistoryPage(),
      middlewares: [AuthMiddleware(), RoleMiddleware('employee')],
    ),
    GetPage(
      name: Routes.historyDetail,
      page: () => HistoryDetailPage(),
      middlewares: [AuthMiddleware(), RoleMiddleware('employee')],
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: Routes.profile,
      page: () => const ProfilePage(),
      middlewares: [AuthMiddleware(), RoleMiddleware('employee')],
    ),

    // --- ADMIN SECTION ---
    GetPage(
      name: Routes.adminDashboard,
      page: () => const AdminHomePage(),
      middlewares: [AuthMiddleware(), RoleMiddleware('admin')],
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.adminQuestions,
      page: () => const AdminQuestionListPage(),
      middlewares: [AuthMiddleware(), RoleMiddleware('admin')],
    ),
    GetPage(
      name: Routes.adminResponses,
      page: () => const AdminAllResponsesPage(),
      middlewares: [AuthMiddleware(), RoleMiddleware('admin')],
    ),
    GetPage(
      name: Routes.adminResponseDetail,
      page: () => AdminResponseDetailPage(),
      middlewares: [AuthMiddleware(), RoleMiddleware('admin')],
    ),
    GetPage(
      name: Routes.adminQuestionEdit,
      page: () => QuestionEditPage(question: Get.arguments),
      middlewares: [AuthMiddleware(), RoleMiddleware('admin')],
    ),
    GetPage(
      name: Routes.adminUsers,
      page: () => const AdminUserListPage(),
      middlewares: [AuthMiddleware(), RoleMiddleware('admin')],
    ),
    GetPage(
      name: Routes.adminAssessments,
      page: () => const AdminAssessmentListPage(),
      middlewares: [AuthMiddleware(), RoleMiddleware('admin')],
    ),
  ];
}
