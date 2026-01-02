# Employee Well-being Diagnostic System

This is a full-stack application for an employee well-being diagnostic system, built with Laravel 11 for the backend and Flutter 3.x for the mobile application. It integrates with the Google Gemini API for AI-powered analysis of employee responses.

For a comprehensive technical overview, including detailed architecture, API endpoints, database schema, and in-depth setup/deployment instructions, please refer to the [TECHNICAL_DOCUMENTATION.md](TECHNICAL_DOCUMENTATION.md).

## Technology Stack

**Backend:**
*   Laravel 11
*   PHP 8.2+
*   SQL (MySQL/PostgreSQL)
*   Laravel Passport (OAuth2)
*   RESTful API

**Mobile App:**
*   Flutter 3.x
*   GetX (state management, routing, dependency injection)
*   Riverpod (state management)
*   Dio (HTTP client)
*   flutter_secure_storage
*   intl
*   fl_chart
*   pdf, printing, share_plus, screenshot (for reports & sharing)

**AI:**
*   Google Gemini API

## System Roles

### 1. Employee
*   Register & login
*   Answer well-being questionnaires
*   View AI results
*   View history of assessments

### 2. Admin
*   Login separately
*   Manage questions (add, edit, delete, activate/deactivate)
*   View all employee responses
*   View analytics dashboard
*   Manage users and assessments
*   Monitor employee risk levels

## Setup and Installation

### Prerequisites

Please refer to the [TECHNICAL_DOCUMENTATION.md](TECHNICAL_DOCUMENTATION.md#prerequisites) for a complete list of prerequisites, including specific software versions.

### 1. Backend (Laravel 11)

1.  **Navigate to the `backend` directory:**
    ```bash
    cd backend
    ```

2.  **Install Composer dependencies:**
    ```bash
    composer install
    ```

3.  **Copy `.env.example` to `.env`:**
    ```bash
    cp .env.example .env
    # For Windows
    # copy .env.example .env
    ```

4.  **Generate application key:**
    ```bash
    php artisan key:generate
    ```

5.  **Configure `.env` file:**
    *   Set `DB_CONNECTION` to `mysql` or `pgsql`.
    *   Configure `DB_DATABASE`, `DB_USERNAME`, `DB_PASSWORD`.
    *   Set your Google API Key for AI features:
        ```
        GOOGLE_API_KEY=your_google_api_key_here
        ```
    *   For detailed instructions on `APP_KEY` and Laravel Passport keys for deployment, refer to the [TECHNICAL_DOCUMENTATION.md](TECHNICAL_DOCUMENTATION.md#backend-deployment-steps).

6.  **Install Laravel Passport:**
    ```bash
    php artisan passport:install
    ```
    This will create the necessary encryption keys and client IDs/secrets.

7.  **Run migrations and seed the database:**
    ```bash
    php artisan migrate --seed
    ```
    This will create all tables and populate them with the default admin user (`admin@company.com`, password: `admin123`) and sample questions.

8.  **Start the Laravel development server:**
    ```bash
    php artisan serve
    ```
    The backend will typically run on `http://127.0.0.1:8000`.

### 2. Mobile App (Flutter 3.x)

1.  **Navigate to the `mobile_app` directory:**
    ```bash
    cd mobile_app
    ```

2.  **Install Flutter dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Configure API Base URL:**
    *   Open `lib/api/api_client.dart` (or `lib/api/api_endpoints.dart` if the file name was changed) and ensure `baseUrl` matches your Laravel backend's URL. For Android emulators, `http://10.0.2.2:8000/api` is common. For iOS simulators or physical devices, use your machine's local IP address (e.g., `http://192.168.1.X:8000/api`).

4.  **Run the Flutter application:**
    ```bash
    flutter run
    ```
    Choose your preferred device (emulator or physical device).

## Deployment

For detailed deployment instructions for both the Laravel backend and Flutter mobile application, including production environment notes and platform-specific configurations, please refer to the [TECHNICAL_DOCUMENTATION.md](TECHNICAL_DOCUMENTATION.md#deployment).

## Usage

### Employee Flow
1.  **Register:** Create a new employee account from the mobile app's login screen.
2.  **Login:** Log in with your registered employee credentials.
3.  **Assessments:** View available assessments. Assessments you have already completed will be marked as "Answered" and cannot be resubmitted. Open assessments will be marked "Open".
4.  **Take Assessment:** Start an open well-being assessment, answer the questions, and submit.
5.  **Results:** View the AI-powered analysis, including scores, risk level, summary, and recommendations.
6.  **Navigation:** Use the "Back" and "Home" buttons in the app bar to easily navigate through the application.
7.  **History:** Review your past assessments, with correct assessment titles displayed.

### Admin Flow
1.  **Login:** From the mobile app's login screen, select "Admin Login" and use the default admin credentials:
    *   Email: `admin@company.com`
    *   Password: `admin123`
2.  **Dashboard:** View overall statistics, risk distribution, and category averages.
3.  **Manage Questions:** Add, edit, delete, or activate/deactivate questions.
4.  **View Responses:** Browse all employee responses and their detailed AI analyses.
5.  **Manage Users & Assessments:** Access dedicated admin sections to manage users and assessments.

---
**Note:** Remember to replace `your_google_api_key_here` in the `.env` file of your Laravel backend with your actual Google API key.
