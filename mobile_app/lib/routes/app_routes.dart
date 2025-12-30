
part of 'app_pages.dart';

/// An abstract class that holds all route constants for the application.
abstract class Routes {
  // Core user-facing routes
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const questionnaire = '/questionnaire';
  static const results = '/results';
  static const history = '/history';
  static const profile = '/profile'; // New: Profile page
  static const employeeMain = '/employee_main'; // New: Employee main screen with bottom nav
  static const historyDetail = '/history-detail';

  // Admin routes
  static const adminLogin = '/admin/login';
  static const adminDashboard = '/admin/dashboard';
  static const adminQuestions = '/admin/questions';
  static const adminQuestionEdit = '/admin/question-edit';
  static const adminResponses = '/admin/responses';
  static const adminResponseDetail = '/admin/response-detail';
  static const adminUsers = '/admin/users'; // New: Admin Users page
  static const adminAssessments = '/admin/assessments';
}
