import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/api/api_client.dart';
import 'package:mobile_app/routes/app_pages.dart';
import 'package:mobile_app/services/auth_service.dart';
import 'package:mobile_app/services/secure_storage_service.dart';
import 'package:mobile_app/admin/services/user_service.dart';
// import 'package:mobile_app/admin/services/admin_response_service.dart'; // Import AdminResponseService

// New imports for Riverpod
import 'package:flutter_riverpod/flutter_riverpod.dart';

// New imports for Provider and Admin Dashboard pages
// import 'package:provider/provider.dart';
import 'package:mobile_app/pages/admin/admin_home_page.dart'; // Import AdminHomePage
import 'package:mobile_app/pages/admin/admin_all_responses_page.dart'; // Import AdminAllResponsesPage
import 'package:mobile_app/pages/admin/employee_profile_page.dart'; // Import EmployeeProfilePage
import 'package:mobile_app/pages/admin/admin_user_list_page.dart'; // Import AdminUserListPage
import 'package:mobile_app/pages/admin/admin_question_list_page.dart'; // Import AdminQuestionListPage
import 'package:mobile_app/pages/admin/admin_question_form_page.dart'; // Import AdminQuestionFormPage
import 'package:mobile_app/pages/admin/admin_assessment_list_page.dart'; // Import AdminAssessmentListPage
import 'package:mobile_app/pages/admin/admin_assessment_form_page.dart'; // Import AdminAssessmentFormPage
import 'package:mobile_app/pages/admin/admin_response_detail_page.dart';

/// Define custom application colors for consistent theming and status indication.
class AppColors {
  static const Color primary = Color(0xFF6366F1); // Indigo
  static const Color secondary = Color(0xFF6C757D); // Subtle gray (retained for accents)
  static const Color tertiary = Color(0xFF8B008B); // Retained, or use a shade of indigo for charts
  static const Color success = Color(0xFF22C55E); // Emerald
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color danger = Color(0XFFEF4444); // Rose
  static const Color info = Color(0xFF17A2B8);   // General info blue (retained)
  static const Color light = Color(0xFFF8F9FA);  // Light background (retained)
  static const Color dark = Color(0xFF1A202C);   // Deeper dark for text/elements, akin to "Deep Navy" or "Professional Slate"

  // Specific status colors requested by the user, updated to new palette
  static const Color statusHigh = success;  // Emerald
  static const Color statusMedium = warning; // Amber
  static const Color statusLow = danger;   // Rose
}

/// The main entry point for the application.
///
/// FIXED: Completely rewritten to correctly initialize services with GetX
/// and determine the initial route based on the unified AuthService.
Future<void> main() async {
  // Ensure Flutter engine is initialized.
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize and register all services for global access.
  // The order matters if services depend on each other.
  await Get.putAsync(() async => SecureStorageService());
  // AuthService needs SecureStorageService, so put it after
  await Get.putAsync(() async => AuthService().init());
  // ApiClient needs AuthService, but AuthService's constructor (before .init()) doesn't directly use ApiClient
  // ApiClient's _authService is Get.find<AuthService>() which requires AuthService to be available.
  // So, ApiClient must be registered *after* AuthService.
  // Using Get.lazyPut for ApiClient means it's only instantiated when first 'find'ed.
  Get.lazyPut(() => ApiClient()); 
  await Get.putAsync(() async => UserService());

  // Removed AdminResponseService as its functions are now integrated into AdminDashboardController
  // await Get.putAsync(() async => AdminResponseService());

  // Determine the initial route after services are initialized.
  final authService = Get.find<AuthService>();
  final initialRoute = authService.getInitialRoute();

  runApp(
    ProviderScope( // Wrap with ProviderScope for Riverpod
      child: MyApp(initialRoute: initialRoute),
    ),
  );
}

/// The root widget of the application.
class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Well-being Assessment',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true, // Enable Material 3
        brightness: Brightness.light,
        // scaffoldBackgroundColor is implicitly handled by ColorScheme.surface,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
          primary: AppColors.primary,
          onPrimary: Colors.white,
          secondary: AppColors.secondary,
          onSecondary: Colors.white,
          tertiary: AppColors.tertiary, // Assign tertiary color
          error: AppColors.danger,
          onError: Colors.white,
          surface: AppColors.light, // Default background surface color for scaffold (replaces deprecated 'background')
          onSurface: AppColors.dark, // Text on surface/background (replaces deprecated 'onBackground')
          surfaceContainerHighest: AppColors.light, // Replaces deprecated 'surfaceVariant' for some backgrounds
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false, // Left align title for modern look
          titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith( // Use theme's titleLarge
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.secondary,
          type: BottomNavigationBarType.fixed,
        ),
        cardTheme: CardThemeData( // Updated CardThemeData to CardTheme
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Larger radius for Material 3 look
          ),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0), // Increased vertical margin
        ),
        textTheme: TextTheme( // Ensure text theme aligns with Material 3 and custom colors
          headlineLarge: const TextStyle(color: AppColors.dark, fontWeight: FontWeight.bold),
          headlineMedium: const TextStyle(color: AppColors.dark, fontWeight: FontWeight.bold),
          headlineSmall: const TextStyle(color: AppColors.dark, fontWeight: FontWeight.bold),
          titleLarge: const TextStyle(color: AppColors.dark, fontWeight: FontWeight.bold),
          titleMedium: const TextStyle(color: AppColors.dark, fontWeight: FontWeight.bold),
          titleSmall: const TextStyle(color: AppColors.dark, fontWeight: FontWeight.bold),
          bodyLarge: const TextStyle(color: AppColors.dark),
          bodyMedium: const TextStyle(color: AppColors.dark),
          labelLarge: const TextStyle(color: AppColors.dark),
          labelMedium: TextStyle(color: AppColors.secondary.withAlpha(179)), // Hint style
          labelSmall: const TextStyle(color: AppColors.dark),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData( // Added OutlinedButtonTheme for consistency
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.danger, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.danger, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          hintStyle: TextStyle(color: AppColors.secondary.withAlpha(179)),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Use Get.toNamed() or Get.offNamed() for navigation
      // For demonstration, let's assume if the initial route is '/' (default for non-admin)
      // and we want to show AdminHomePage, we can redirect or set home directly.
      // A more robust solution would involve GetX middleware or route guards.
      home: initialRoute == '/admin_home' ? const AdminHomePage() : null,
      initialRoute: initialRoute != '/admin_home' ? initialRoute : null, // If not admin home, use initialRoute
      getPages: [
        ...AppPages.routes,
        GetPage(name: '/admin_home', page: () => const AdminHomePage()),
        GetPage(name: '/admin_all_responses', page: () => const AdminAllResponsesPage()),
        GetPage(name: '/employee_profile', page: () => EmployeeProfilePage(employee: Get.arguments)),
        GetPage(name: '/admin_response_detail', page: () => AdminResponseDetailPage()),
        GetPage(name: '/admin_users', page: () => const AdminUserListPage()),
        GetPage(name: '/admin_questions', page: () => const AdminQuestionListPage()),
        GetPage(name: '/admin_question_form', page: () => AdminQuestionFormPage(question: Get.arguments)),
        GetPage(name: '/admin_assessments', page: () => const AdminAssessmentListPage()),
        GetPage(name: '/admin_assessment_form', page: () => AdminAssessmentFormPage(assessment: Get.arguments)),
      ],
    );
  }
}
