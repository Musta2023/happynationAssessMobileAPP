# Employee Well-being Diagnostic Mobile App

This Flutter project serves as the mobile client for the Employee Well-being Diagnostic System. It allows employees to take assessments, view their results and history, and provides an admin interface for managing questions, assessments, and viewing analytics.

## Features

*   **Employee Interface:**
    *   User registration and login.
    *   View and take well-being assessments.
    *   Receive AI-powered analysis of assessment results (scores, risk level, summary, recommendations).
    *   Review past assessment history.
    *   Easy navigation with "Back" and "Home" buttons on most screens.
*   **Admin Interface:**
    *   Separate admin login.
    *   Manage questions and assessments.
    *   View employee responses and analytics.

## Getting Started

To set up and run this mobile application, please refer to the main project's `README.md` located in the root directory of the repository (`../README.md`) for complete setup instructions, including backend API configuration and detailed usage guides.

### Development Setup

1.  **Navigate to the `mobile_app` directory:**
    ```bash
    cd mobile_app
    ```

2.  **Install Flutter dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Configure API Base URL:**
    *   Open `lib/api/api_endpoints.dart`.
    *   Ensure `baseUrl` matches your Laravel backend's URL. For Android emulators, `http://10.0.2.2:8000/api` is common. For iOS simulators or physical devices, use your machine's local IP address (e.g., `http://192.168.1.X:8000/api`).

4.  **Run the Flutter application:**
    ```bash
    flutter run
    ```
    Choose your preferred device (emulator or physical device).

For help getting started with Flutter development, view the [online documentation](https://docs.flutter.dev/), which offers tutorials, samples, guidance on mobile development, and a full API reference.