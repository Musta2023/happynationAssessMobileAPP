part of 'app_pages.dart';

/// An abstract class that holds all route constants for the application.
abstract class Routes {
  // --- Core Authentication ---
  static const login = '/login';
  static const register = '/register';
  static const adminLogin = '/admin/login';

  // --- Employee / User Facing ---
  // Note: 'home' is deprecated in favor of 'employeeMain'
  static const home = '/home'; 
  static const employeeMain = '/employee_main'; 
  
  static const questionnaire = '/questionnaire';
  static const results = '/results';
  static const history = '/history';
  static const historyDetail = '/history-detail';
  static const profile = '/profile';

  // --- Admin Management ---
  static const adminDashboard = '/admin/dashboard';
  static const adminQuestions = '/admin/questions';
  static const adminQuestionEdit = '/admin/question-edit';
  static const adminResponses = '/admin/responses';
  static const adminResponseDetail = '/admin/response-detail';
  static const adminUsers = '/admin/users';
  static const adminAssessments = '/admin/assessments';
}
