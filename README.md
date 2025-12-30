# Employee Well-being Diagnostic System

This is a full-stack application for an employee well-being diagnostic system, built with Laravel 11 for the backend and Flutter 3.x for the mobile application. It integrates with the OpenAI Chat Completions API for AI-powered analysis of employee responses.

## Technology Stack

**Backend:**
*   Laravel 11
*   PHP 8.2+
*   MySQL (or SQLite for local development)
*   Laravel Passport (OAuth2)
*   RESTful API

**Mobile App:**
*   Flutter 3.x
*   GetX (state management)
*   Dio (HTTP client)
*   flutter_secure_storage
*   intl
*   fl_chart

**AI:**
*   OpenAI Chat Completions API

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
*   Monitor employee risk levels

## Setup and Installation

### 1. Backend (Laravel 11)

#### Prerequisites
*   PHP 8.2+
*   Composer
*   MySQL or SQLite (for local development)
*   OpenSSL PHP Extension
*   PDO PHP Extension
*   Mbstring PHP Extension
*   Tokenizer PHP Extension
*   XML PHP Extension
*   Ctype PHP Extension
*   JSON PHP Extension

#### Steps

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
    copy .env.example .env
    ```

4.  **Generate application key:**
    ```bash
    php artisan key:generate
    ```

5.  **Configure `.env` file:**
    *   Set `DB_CONNECTION` to `mysql` or `sqlite`. If using SQLite, create an empty `database.sqlite` file in the `database` directory.
    *   `DB_DATABASE`, `DB_USERNAME`, `DB_PASSWORD` for MySQL.
    *   Set your OpenAI API Key:
        ```
        OPENAI_API_KEY=your_openai_api_key_here
        ```

6.  **Install Laravel Passport:**
    ```bash
    php artisan passport:install --force
    ```
    This will create the necessary encryption keys and client IDs/secrets.

7.  **Run migrations and seed the database:**
    ```bash
    php artisan migrate:refresh --seed
    ```
    This will create all tables and populate them with the default admin user (`admin@company.com`, password: `admin123`) and 10 sample questions.

8.  **Start the Laravel development server:**
    ```bash
    php artisan serve
    ```
    The backend will typically run on `http://127.0.0.1:8000`.

### 2. Mobile App (Flutter 3.x)

#### Prerequisites
*   Flutter SDK (version 3.x) installed and configured.
*   Android Studio / VS Code with Flutter and Dart plugins.

#### Steps

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
        ```dart
        static const String baseUrl = 'http://10.0.2.2:8000/api'; // Adjust as needed
        ```

4.  **Run the Flutter application:**
    ```bash
    flutter run
    ```
    Choose your preferred device (emulator or physical device).

## Usage

### Employee Flow
1.  **Register:** Create a new employee account from the mobile app's login screen.
2.  **Login:** Log in with your registered employee credentials.
3.  **Assessment:** Start a new well-being assessment, answer the questions, and submit.
4.  **Results:** View the AI-powered analysis, including scores, risk level, summary, and recommendations.
5.  **History:** Review past assessments.

### Admin Flow
1.  **Login:** From the mobile app's login screen, select "Admin Login" and use the default admin credentials:
    *   Email: `admin@company.com`
    *   Password: `admin123`
2.  **Dashboard:** View overall statistics, risk distribution, and category averages.
3.  **Manage Questions:** Add, edit, delete, or activate/deactivate questions.
4.  **View Responses:** Browse all employee responses and their detailed AI analyses.

---
**Note:** Remember to replace `your_openai_api_key_here` in the `.env` file of your Laravel backend with your actual OpenAI API key.
