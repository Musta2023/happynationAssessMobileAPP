class ApiEndpoints {

  // ------------------------------------------------------------------------- // NEW (Railway Production)
  static const String baseUrl = "https://happynationassessmobileapp-production.up.railway.app/api";

  // -------------------------------------------------------------------------
  // 2. ENDPOINTS
  // -------------------------------------------------------------------------
  
  // Auth (Unified)
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String adminLogin = '/admin/login';
  static const String refresh = '/auth/refresh';

  // Questions
  static const String questions = '/questions';
  static const String employeeAssessments = '/assessments';
  static String assessmentQuestions(String assessmentId) => '/assessments/$assessmentId/questions';
  
  // Responses
  static const String submitResponse = '/responses';
  static const String history = '/responses/history';
  static String responseDetail(int id) => '/responses/$id';

  // Admin
  static const String adminDashboard = '/admin/dashboard';
  static const String adminQuestions = '/admin/questions';
  static String adminQuestionDetail(int id) => '/admin/questions/$id';
  static String adminQuestionToggle(int id) => '/admin/questions/$id/toggle';
  static const String adminResponses = '/admin/responses';
  static String adminResponseDetail(int id) => '/admin/responses/$id';
  static const String adminStatistics = '/admin/statistics';
  static const String adminDepartments = '/admin/departments'; // New endpoint
  static const String adminUsers = '/admin/users'; // New: Admin Users endpoint
  static String adminUserResponses(String id) => '/admin/users/$id/responses';

  // Admin Users Management
  static const String adminUsersList = '/admin/users'; // GET all users
  static String adminUserDelete(String id) => '/admin/users/$id'; // DELETE a user
  static const String adminUserCreate = '/admin/users'; // POST create new user (admin or employee)

  // Admin Questions Management
  static const String adminQuestionsList = '/admin/questions'; // GET all questions, POST create new
  static String adminQuestionCreate = '/admin/questions'; // POST create new question
  static String adminQuestionShow(String id) => '/admin/questions/$id'; // GET specific question
  static String adminQuestionUpdate(String id) => '/admin/questions/$id'; // PUT update specific question
  static String adminQuestionDelete(String id) => '/admin/questions/$id'; // DELETE specific question

  // Admin Assessments Management
  static const String adminAssessmentsList = '/admin/assessments'; // GET all assessments, POST create new
  static String adminAssessmentCreate = '/admin/assessments'; // POST create new assessment
  static String adminAssessmentShow(String id) => '/admin/assessments/$id'; // GET specific assessment
  static String adminAssessmentUpdate(String id) => '/admin/assessments/$id'; // PUT update specific assessment
  static String adminAssessmentDelete(String id) => '/admin/assessments/$id'; // DELETE specific assessment
  static String adminAssessmentAnalytics(String id) => '/admin/assessments/$id/analytics'; // GET analytics for a specific assessment
}
