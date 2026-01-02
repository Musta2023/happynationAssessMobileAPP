# Technical Documentation: Well-being Assessment Mobile Application

This document provides a comprehensive technical overview of the Well-being Assessment Mobile Application, which consists of a Laravel (PHP) backend and a Flutter (Dart) mobile frontend. It is intended for developers joining the project to quickly understand its architecture, functionality, and development practices.

## Table of Contents

1.  [Project Overview](#1-project-overview)
    *   [Application Purpose](#application-purpose)
    *   [Main Features](#main-features)
    *   [User Roles and Permissions](#user-roles-and-permissions)
2.  [Architecture](#2-architecture)
    *   [High-Level System Architecture](#high-level-system-architecture)
    *   [Backend–Frontend Communication Flow](#backendfrontend-communication-flow)
    *   [Folder Structure Explanation](#folder-structure-explanation)
        *   [Laravel Backend (`backend/`)](#laravel-backend-backend)
        *   [Flutter Mobile App (`mobile_app/`)](#flutter-mobile-app-mobile_app)
3.  [Backend (Laravel)](#3-backend-laravel)
    *   [Framework Version & Requirements](#framework-version--requirements)
    *   [Database Schema and Models](#database-schema-and-models)
    *   [API Endpoints (grouped by feature)](#api-endpoints-grouped-by-feature)
    *   [Authentication & Authorization](#authentication--authorization)
    *   [Business Logic and Services](#business-logic-and-services)
    *   [Error Handling and Validation](#error-handling-and-validation)
4.  [Mobile App (Flutter)](#4-mobile-app-flutter)
    *   [Flutter Version & Dependencies](#flutter-version--dependencies)
    *   [App Structure and Main Widgets](#app-structure-and-main-widgets)
    *   [State Management Approach](#state-management-approach)
    *   [Screens and Navigation Flow](#screens-and-navigation-flow)
    *   [API Integration](#api-integration)
    *   [Charts, Analytics, and Exports](#charts-analytics-and-exports)
5.  [Setup & Installation](#5-setup--installation)
    *   [Prerequisites](#prerequisites)
    *   [Backend Installation Steps](#backend-installation-steps)
    *   [Mobile App Installation Steps](#mobile-app-installation-steps)
    *   [Running the Project Locally](#running-the-project-locally)
6.  [Deployment](#6-deployment)
    *   [Backend Deployment Steps](#backend-deployment-steps)
    *   [Mobile Build (Android / iOS)](#mobile-build-android--ios)
    *   [Production Environment Notes](#production-environment-notes)
7.  [Maintenance & Best Practices](#7-maintenance--best-practices)
    *   [How to Add New Features](#how-to-add-new-features)
    *   [Code Organization Guidelines](#code-organization-guidelines)
    *   [Security Considerations](#security-considerations)

---

## 1. Project Overview

This project comprises a mobile application designed to facilitate well-being assessments, providing insights into various aspects such as stress, motivation, and satisfaction. It is built with a robust backend powered by Laravel (PHP) and a dynamic cross-platform mobile frontend developed using Flutter (Dart).

### Application Purpose

The primary purpose of this application is to:
*   Enable users (employees) to take various well-being assessments.
*   Provide immediate feedback and analysis of their assessment responses, including scores, risk levels, and recommendations.
*   Offer administrators a comprehensive dashboard to manage assessments, questions, users, and review aggregated analytics and individual responses.
*   Support data visualization through charts and export features (e.g., PDF reports) for detailed analysis and record-keeping.

### Main Features

*   **User Authentication & Authorization**: Secure login and registration for employees and administrators, with role-based access control.
*   **Assessment Management (Admin)**: Administrators can create, update, and delete assessments, associating them with a curated set of questions.
*   **Question Management (Admin)**: Administrators can add, modify, delete, and activate/deactivate individual questions, categorizing them by domain (stress, motivation, satisfaction) and type (Likert, Yes/No, Text).
*   **Employee Assessments**: Employees can browse available assessments and submit their responses.
*   **Personalized Response Analysis**: After submitting an assessment, employees receive a personalized analysis, including scores across different categories, an overall risk assessment (low, medium, high), recommendations, and a summary.
*   **Response History**: Employees can view their past assessment responses and detailed analyses.
*   **Admin Dashboard**: Provides a high-level overview of application usage, user activity, and aggregated assessment statistics.
*   **User Management (Admin)**: Administrators can view, create, update, and delete user accounts, assigning roles (admin/employee) and departments.
*   **Comprehensive Reporting & Analytics (Admin)**: Administrators can view all user responses, filter data by assessment or user, and access detailed analytics for specific assessments, often presented with charts.
*   **Data Export**: Functionality to export data, potentially including individual responses or aggregate reports, as PDF documents.

### User Roles and Permissions

The application defines two distinct user roles:

*   **Employee**:
    *   Can register and log in to the mobile application.
    *   Can view available assessments and answer questions.
    *   Can submit assessment responses.
    *   Can view their own response history and detailed analysis, including scores, risks, and recommendations.
    *   Cannot access administrative features.

*   **Admin**:
    *   Has all capabilities of an Employee.
    *   Can log in via a dedicated admin interface (or role-based access within the mobile app).
    *   Manages users (create, edit, delete, assign roles/departments).
    *   Manages questions (create, edit, delete, toggle status).
    *   Manages assessments (create, edit, delete, link questions).
    *   Accesses comprehensive analytics and reports for all assessments and users.
    *   Can view all submitted responses in detail.

---

## 2. Architecture

The application adopts a client-server architecture, comprising a Laravel-based backend serving as the API and business logic layer, and a Flutter-based mobile application acting as the frontend client.

### High-Level System Architecture

```
+-------------------+           +-------------------+           +-------------------+
|                   |           |                   |           |                   |
|   Mobile Client   | <-------> |    Laravel API    | <-------> |     Database      |
|  (Flutter/Dart)   |   HTTP    |       (PHP)       |   SQL/ORM |   (MySQL/Postgres |
|                   |   (JSON)  |                   |           |     etc.)         |
+-------------------+           +-------------------+           +-------------------+
        ^                                 ^
        |                                 |
        |                             (Optional)
        |                             Google API (AI/Analytics)
        |                             Pusher (Realtime)
        |                             AWS S3 (Storage)
        |
        +-------------------------------------------------------------+
                                       Internet
```

1.  **Mobile Client (Flutter/Dart):** The user-facing application built with Flutter, providing a cross-platform experience (Android, iOS). It handles UI rendering, user interaction, local state management, and communicates with the backend API.
2.  **Laravel API (PHP):** The core backend service developed with the Laravel framework. It exposes RESTful APIs, manages business logic, handles data persistence, authentication, and authorization. It interacts with the database and integrates with external services.
3.  **Database:** Stores all application data, including user profiles, assessments, questions, and responses. The current setup implies a relational database (e.g., MySQL, PostgreSQL).
4.  **External Services (Optional/Integrated):** The backend can integrate with various third-party services for enhanced functionality:
    *   **Google API:** Potentially for AI-driven analysis, machine learning capabilities, or other advanced data processing for assessment responses.
    *   **Pusher:** For real-time communication, broadcasting events or notifications to connected clients.
    *   **AWS S3:** For scalable cloud storage of files, reports, or other assets.

### Backend–Frontend Communication Flow

Communication between the Flutter mobile client and the Laravel API occurs over HTTP/HTTPS using RESTful principles, with data exchanged primarily in JSON format.

1.  **Authentication:**
    *   The Flutter client sends user credentials (email/password) to the Laravel API's authentication endpoints (`/auth/login`, `/admin/login`).
    *   Upon successful authentication, the Laravel API returns an OAuth2 access token (via Laravel Passport).
    *   The Flutter client securely stores this access token using `flutter_secure_storage`.
    *   For subsequent authenticated requests, the Flutter client includes the access token in the `Authorization` header (`Bearer <token>`).
2.  **Data Exchange:**
    *   The Flutter client makes requests (GET, POST, PUT, DELETE) to various API endpoints (e.g., `/questions`, `/responses`, `/admin/users`).
    *   The Laravel API processes these requests, interacts with the database (via Eloquent ORM), applies business logic, and returns JSON responses.
    *   The Flutter client parses these JSON responses and updates its UI or local state accordingly.
3.  **Error Handling:**
    *   Both client and server are expected to handle errors gracefully. The API returns appropriate HTTP status codes (e.g., 401 Unauthorized, 403 Forbidden, 422 Unprocessable Entity, 500 Internal Server Error) and descriptive JSON error messages. The Flutter client interprets these to provide user feedback.

### Folder Structure Explanation

#### Laravel Backend (`backend/`)

The backend follows a standard Laravel project structure, organized to separate concerns:

*   **`app/`**: Contains the core logic of the application.
    *   `Http/Controllers/`: Houses controllers responsible for handling incoming HTTP requests and returning responses.
    *   `Http/Middleware/`: Middleware for request filtering (e.g., authentication, role-based access).
    *   `Models/`: Eloquent ORM models that represent database tables and encapsulate business logic related to data.
    *   `Providers/`: Service providers for bootstrapping services, registering bindings, and event handling.
*   **`bootstrap/`**: Contains the `app.php` file that bootstraps the framework.
*   **`config/`**: Configuration files for various aspects of the application (e.g., `auth.php`, `database.php`, `passport.php`).
*   **`database/`**: Database-related files.
    *   `migrations/`: Defines the database schema and modifications over time.
    *   `factories/`: Generates fake data for testing and seeding.
    *   `seeders/`: Populates the database with initial data.
*   **`public/`**: The web server's document root, containing `index.php` and static assets.
*   **`routes/`**: Defines all application routes.
    *   `api.php`: API routes consumed by the mobile application.
    *   `web.php`: Web routes (if any, though not the primary frontend).
*   **`storage/`**: Stores compiled templates, file-based sessions, caches, and other files generated by the framework.
*   **`tests/`**: Contains unit and feature tests.
*   **`vendor/`**: Composer-managed PHP dependencies.

#### Flutter Mobile App (`mobile_app/`)

The mobile application follows a modular structure, enhancing maintainability and scalability:

*   **`lib/`**: Contains all the Dart source code for the application.
    *   `admin/`: Specific features and UI components for the admin section.
    *   `api/`: Defines API clients, network request logic, and data transfer objects (DTOs) for communication with the Laravel backend.
    *   `controllers/`: Contains logic for managing application flow and state, often integrated with GetX.
    *   `helpers/`: General-purpose helper functions and classes.
    *   `models/`: Dart classes representing the data models fetched from the backend.
    *   `pages/`: Defines individual screens/views of the application.
    *   `routes/`: Manages the application's navigation paths and `GetPage` configurations.
    *   `services/`: Core application services, such as `AuthService` (authentication logic), `SecureStorageService` (secure local storage), `UserService` (user-related operations).
    *   `styles/`: Centralized definitions for application themes, colors, and typography.
    *   `utils/`: Miscellaneous utility classes and extensions.
    *   `widgets/`: Reusable UI components.
*   **`android/`**, **`ios/`**: Platform-specific code and configuration files for Android and iOS builds.
*   **`pubspec.yaml`**: Defines project metadata, dependencies, assets, and other Flutter-specific configurations.

---

## 3. Backend (Laravel)

The backend of the application is built using the Laravel framework, providing a robust and scalable foundation for API services, business logic, and data management.

### Framework Version & Requirements

*   **Laravel Version:** `^11.0`
*   **PHP Version:** `^8.2`
*   **Composer:** Used for managing PHP dependencies.

Key dependencies include `laravel/passport` for API authentication, `fakerphp/faker` for development data generation, and `phpunit/phpunit` for testing.

### Database Schema and Models

The application's data layer is structured around the following Eloquent models and their corresponding database tables. Relationships are defined to maintain data integrity and facilitate querying.

1.  **`User` (Table: `users`)**
    *   **Purpose:** Stores user authentication details and profile information.
    *   **Fields:** `id`, `name` (nullable), `first_name`, `last_name`, `email` (unique), `email_verified_at`, `password`, `role` (enum: `'admin'`, `'employee'`), `department`, `remember_token`, `created_at`, `updated_at`.
    *   **Relationships:** `hasMany(Response::class)` - A user can submit multiple responses.
2.  **`Assessment` (Table: `assessments`)**
    *   **Purpose:** Represents a collection of questions grouped as a single assessment.
    *   **Fields:** `id`, `title`, `description` (nullable), `created_at`, `updated_at`.
    *   **Relationships:**
        *   `belongsToMany(Question::class)` - Many-to-many relationship with questions via `assessment_question` pivot table.
        *   `hasMany(Response::class)` - An assessment can have many user responses.
3.  **`Question` (Table: `questions`)**
    *   **Purpose:** Stores individual assessment questions.
    *   **Fields:** `id`, `question_text`, `category` (enum: `'stress'`, `'motivation'`, `'satisfaction'`), `type` (enum: `'likert'`, `'yes_no'`, `'text'`), `is_active` (boolean, default `true`), `created_at`, `updated_at`.
    *   **Relationships:**
        *   `belongsToMany(Assessment::class)` - Many-to-many relationship with assessments.
        *   `hasMany(ResponseItem::class)` - A question can be answered in multiple response items.
4.  **`Response` (Table: `responses`)**
    *   **Purpose:** Records a user's completed assessment, including calculated scores and recommendations.
    *   **Fields:** `id`, `user_id` (FK to `users`), `assessment_id` (FK to `assessments`, nullable), `stress_score`, `motivation_score`, `satisfaction_score`, `global_score`, `risk` (enum: `'low'`, `'medium'`, `'high'`, nullable), `recommendations` (JSON array), `summary`, `created_at`, `updated_at`.
    *   **Relationships:**
        *   `belongsTo(User::class)` - Belongs to one user.
        *   `belongsTo(Assessment::class)` - Belongs to one assessment.
        *   `hasMany(ResponseItem::class)` - Comprises multiple individual question answers.
5.  **`ResponseItem` (Table: `response_items`)**
    *   **Purpose:** Stores an individual answer to a specific question within a `Response`.
    *   **Fields:** `id`, `response_id` (FK to `responses`), `question_id` (FK to `questions`), `answer_value`, `created_at`, `updated_at`.
    *   **Relationships:**
        *   `belongsTo(Response::class)` - Belongs to one overall response.
        *   `belongsTo(Question::class)` - Relates to one question.

**Pivot Table:**
*   **`assessment_question`**: Links `assessments` and `questions` tables for their many-to-many relationship. It contains `assessment_id` and `question_id` as foreign keys forming a composite primary key.

### API Endpoints (grouped by feature)

All API endpoints are defined in `backend/routes/api.php` and primarily return JSON responses. Authentication with Laravel Passport (`auth:api` middleware) is required for most endpoints. Admin-specific endpoints also enforce a `role:admin` middleware check.

*   **Authentication & User Management**
    *   `POST /auth/register`: Register a new user.
    *   `POST /auth/login`: Authenticate a user and receive an access token.
    *   `POST /auth/refresh`: Refresh an expired access token.
    *   `POST /auth/logout`: Invalidate the current access token.
    *   `POST /admin/login`: Authenticate an administrator.
*   **Employee Features (Authenticated)**
    *   `GET /questions`: Retrieve a list of active questions.
    *   `GET /assessments`: Retrieve a list of available assessments.
    *   `GET /assessments/{assessment_id}/questions`: Get questions for a specific assessment.
    *   `POST /responses`: Submit a new assessment response.
    *   `POST /responses/analyze`: Analyze a submitted response to generate scores and recommendations.
    *   `GET /responses/history`: View the authenticated user's past responses.
    *   `GET /responses/{response_id}`: Get details of a specific response.
*   **Admin Features (Authenticated, Role: Admin)**
    *   `GET /admin/dashboard`: Overview statistics for administrators.
    *   **Questions:**
        *   `GET /admin/questions`: List all questions.
        *   `POST /admin/questions`: Create a new question.
        *   `PUT /admin/questions/{id}`: Update an existing question.
        *   `DELETE /admin/questions/{id}`: Delete a question.
        *   `PATCH /admin/questions/{id}/toggle`: Toggle a question's active status.
    *   **Responses:**
        *   `GET /admin/responses`: List all user responses.
        *   `GET /admin/responses/{id}`: Get details of any specific response.
        *   `GET /admin/statistics`: Retrieve application-wide response statistics.
    *   **Users:**
        *   `GET /admin/users`: List all registered users.
        *   `POST /admin/users`: Create a new user (admin can specify role).
        *   `PUT /admin/users/{id}`: Update a user's details.
        *   `DELETE /admin/users/{id}`: Delete a user.
        *   `GET /admin/users/{id}/responses`: View responses submitted by a specific user.
        *   `GET /admin/departments`: Get a list of all unique departments.
    *   **Assessments (`apiResource` endpoints):**
        *   `GET /admin/assessments`: List all assessments.
        *   `POST /admin/assessments`: Create a new assessment.
        *   `GET /admin/assessments/{assessment}`: Retrieve a specific assessment.
        *   `PUT /admin/assessments/{assessment}`: Update an assessment.
        *   `DELETE /admin/assessments/{assessment}`: Delete an assessment.
    *   **Analytics:**
        *   `GET /admin/assessments/{assessment_id}/analytics`: Get detailed analytics for a specific assessment.

### Authentication & Authorization

The backend utilizes **Laravel Passport** for API authentication, implementing an OAuth2 token-based system.

*   **Authentication:** Users obtain an access token upon successful login. This token must be sent with subsequent requests in the `Authorization` header as a Bearer token. `AuthToken` refresh and invalidation (logout) endpoints are provided.
*   **Authorization:**
    *   **Middleware (`auth:api`):** Ensures that only authenticated users can access protected routes.
    *   **Role-Based Access Control (`role:admin` middleware):** Restricts certain routes to users with the `admin` role, leveraging the `role` column in the `users` table. This provides a granular level of access control for administrative functions.

### Business Logic and Services

The business logic is primarily housed within the Laravel Controllers and, implicitly, within the Eloquent Models.
*   **Controllers (`app/Http/Controllers/`):** Orchestrate the flow of data, handle requests, interact with models, and prepare responses.
*   **Models (`app/Models/`):** Encapsulate data access and business rules directly related to each entity (e.g., `User` model handles user-specific logic, `Assessment` model manages assessment-related operations).
*   **Service Classes (Implied):** While not explicitly located in a dedicated `app/Services` directory in the initial scan, complex business operations (like response analysis) are likely delegated to dedicated service classes or methods within controllers to maintain separation of concerns. The presence of `GOOGLE_API_KEY` hints that the `analyze` endpoint in `ResponseController` will delegate to an AI service or similar.

### Error Handling and Validation

Laravel provides robust mechanisms for error handling and validation:
*   **Validation:** Input validation is performed at the controller level using Laravel's powerful validation rules, ensuring data integrity before processing. Invalid input typically results in a `422 Unprocessable Entity` HTTP status code with detailed error messages.
*   **Exception Handling:** Global exception handling catches unhandled exceptions, returning appropriate JSON error responses for API consumers. Custom exceptions can be defined for specific error scenarios.
*   **HTTP Status Codes:** The API consistently returns standard HTTP status codes to indicate the outcome of an operation (e.g., 200 OK, 201 Created, 401 Unauthorized, 403 Forbidden, 404 Not Found, 500 Internal Server Error).

---

## 4. Mobile App (Flutter)

The mobile application provides the user interface for interacting with the backend services. Developed using Flutter, it offers a consistent experience across Android and iOS platforms.

### Flutter Version & Dependencies

*   **Flutter SDK:** `>=3.0.0 <4.0.0`
*   **Dart SDK:** `>=3.0.0 <4.0.0`

**Key Dependencies:**

*   **`dio`**: A powerful HTTP client for making API requests to the Laravel backend. It provides features like interceptors, global configuration, and error handling.
*   **`flutter_secure_storage`**: Used for securely storing sensitive data such as authentication tokens on the device's keychain/keystore.
*   **`shared_preferences`**: Provides a simple mechanism for storing persistent key-value data locally for less sensitive information (e.g., user preferences, flags).
*   **`get`**: A comprehensive solution for state management, dependency injection, and routing. In this project, it's primarily used for dependency injection (service locator pattern) and navigation.
*   **`flutter_riverpod`**: A reactive caching and data-binding framework, used for managing and exposing application state to UI components in a testable and maintainable way.
*   **`provider`**: While `flutter_riverpod` is the primary state management solution, `provider` is also present and might be used in specific contexts or as a transitive dependency.
*   **`fl_chart`**: A versatile library for drawing various types of charts and graphs, essential for visualizing assessment results and analytics.
*   **`pdf`**: Enables the generation of PDF documents directly within the application, useful for reports and export features.
*   **`printing`**: Provides functionality for printing documents generated within the app.
*   **`path_provider`**: A Flutter plugin for finding commonly used locations on the filesystem, necessary for saving files (like generated PDFs).
*   **`share_plus`**: Allows sharing content (text, images, files) from the application to other apps on the device.
*   **`screenshot`**: A utility for capturing screenshots of Flutter widgets, which can then be saved or shared.
*   **`intl`**: Internationalization and localization for handling date/time formatting, number formatting, and message translation.
*   **`shimmer`**: A package to easily add shimmering effect to the UI, commonly used for loading states.

### App Structure and Main Widgets

The application's source code (`mobile_app/lib`) is organized modularly to enhance maintainability and separation of concerns:

*   **`main.dart`**: The application's entry point. It handles the initial setup including:
    *   Ensuring Flutter engine initialization.
    *   Registering core services (`SecureStorageService`, `AuthService`, `ApiClient`, `UserService`) using `GetX`'s dependency injection.
    *   Determining the initial navigation route based on authentication status and user role.
    *   Setting up the main `GetMaterialApp` widget, which defines the application's theme (`AppColors`, `ThemeData`) and global routes.
    *   Wrapping the app in `ProviderScope` to enable Riverpod for state management.
*   **`admin/`**: Contains components, pages, and services exclusively for the administrator interface.
*   **`api/`**: Houses API client configurations, data models for API responses, and methods for interacting with the Laravel backend. This includes `ApiClient` for making HTTP requests.
*   **`controllers/`**: Contains business logic and state management logic, often leveraging GetX or Riverpod.
*   **`helpers/`**: General-purpose helper functions and utilities used across the application.
*   **`models/`**: Dart classes representing the data structures (e.g., `User`, `Assessment`, `Question`, `Response`) that mirror the backend's data models.
*   **`pages/`**: Contains the main screen widgets for both employee and admin functionalities (e.g., `AdminHomePage`, `AdminAllResponsesPage`, `EmployeeProfilePage`, `AdminUserListPage`, etc.).
*   **`routes/`**: Defines the application's navigation paths and `GetX` route configurations (`AppPages.routes`).
*   **`services/`**: Core application services that encapsulate specific functionalities like authentication (`AuthService`), secure local data storage (`SecureStorageService`), and user-related operations (`UserService`).
*   **`styles/`**: Centralized definitions for the application's visual style, including color palettes (`AppColors`) and text themes.
*   **`utils/`**: Miscellaneous utility classes and extensions.
*   **`widgets/`**: Reusable UI components (e.g., custom buttons, input fields, cards) used to build the application's user interface.

### State Management Approach

The application utilizes a combination of `GetX` and `Riverpod` for state management and dependency injection:

*   **GetX (`get`)**: Primarily used as a service locator for managing dependencies and for handling application-wide routing. Services are instantiated once (`Get.putAsync`) and can be accessed anywhere using `Get.find()`.
*   **Riverpod (`flutter_riverpod`)**: Serves as the main state management solution for UI-specific state. It offers a robust and testable way to manage application data that changes over time and needs to be reflected in the UI. By wrapping the entire app in `ProviderScope`, all widgets can safely consume providers to access state and services.

### Screens and Navigation Flow

Navigation is handled globally via `GetX`'s routing system, configured through `GetMaterialApp` and `AppPages.routes`.

*   **Initial Route:** The `AuthService` dynamically determines the starting screen for the user based on their authentication status and role (e.g., login screen for unauthenticated users, employee dashboard for employees, admin dashboard for administrators).
*   **Named Routes:** All major screens are accessible via named routes (e.g., `/admin_home`, `/admin_users`, `/responses/history`).
*   **Authentication Guards:** The `AuthService` likely plays a role in guarding routes, preventing unauthorized access to certain parts of the application.
*   **Admin-Specific Pages:** A rich set of admin pages are defined, allowing full management of questions, users, assessments, and viewing of all responses and analytics.
    *   `/admin_home`
    *   `/admin_all_responses`
    *   `/employee_profile`
    *   `/admin_response_detail`
    *   `/admin_users`
    *   `/admin_questions`
    *   `/admin_question_form`
    *   `/admin_assessments`
    *   `/admin_assessment_form`

### API Integration

The `api/` directory and `ApiClient` (`lib/api/api_client.dart`) are central to integrating with the Laravel backend.

*   `ApiClient` (based on `dio`) is configured to send requests with the necessary authentication tokens, which are retrieved from the `AuthService` and `SecureStorageService`.
*   It handles request serialization (converting Dart objects to JSON) and response deserialization (parsing JSON to Dart objects/models).
*   Error handling for network requests (e.g., displaying error messages for failed API calls, handling token expiration) is managed within `ApiClient` and `AuthService`.

### Charts, Analytics, and Exports

The mobile app provides rich features for data visualization and export:

*   **Charts:** Utilizes the `fl_chart` library to render various types of charts (e.g., bar charts, pie charts, line charts) to visually represent assessment scores, trends, and aggregated analytics for both employees and administrators.
*   **Analytics:** For employees, this involves displaying personalized score breakdowns and risk assessments. For administrators, it means viewing aggregated data, department-wise statistics, and assessment-specific performance.
*   **Exports:**
    *   **PDF Generation:** The `pdf` and `printing` packages allow the application to generate and print detailed PDF reports, which can include assessment results, recommendations, or administrative summaries.
    *   **Screenshot & Sharing:** The `screenshot` and `share_plus` packages enable users to capture parts of the UI (e.g., a chart or a summary) and share them with other applications or contacts.

---

## 5. Setup & Installation

This section details the steps required to set up and run both the Laravel backend and the Flutter mobile application locally.

### Prerequisites

Before proceeding, ensure you have the following installed on your development machine:

*   **PHP:** Version `8.2` or higher.
*   **Composer:** PHP dependency manager.
*   **Node.js & npm/yarn:** For Laravel's frontend asset compilation (if any) and general project tooling.
*   **MySQL or PostgreSQL:** A relational database server.
*   **Git:** Version control system.
*   **Flutter SDK:** Version `3.0.0` or higher.
    *   Ensure your Flutter environment is correctly set up by running `flutter doctor`.
*   **Android Studio / Xcode:** For mobile app development and running on emulators/simulators or physical devices.
*   **IDE:** Visual Studio Code (recommended) or PhpStorm/Android Studio with relevant extensions.

### Backend Installation Steps

1.  **Clone the Repository:**
    ```bash
    git clone <repository_url>
    cd myFirstAPP/backend
    ```
    *Assumption: The backend code is within the `backend/` subdirectory of the cloned repository.*

2.  **Install PHP Dependencies:**
    ```bash
    composer install
    ```

3.  **Environment Configuration:**
    *   Create a `.env` file by copying the example file:
        ```bash
        cp .env.example .env
        ```
    *   Edit the `.env` file and configure your database connection and other environment variables:
        ```ini
        # Example .env settings
        APP_NAME="Well-being App Backend"
        APP_ENV=local
        APP_KEY= # This will be generated in the next step
        APP_DEBUG=true
        APP_URL=http://localhost:8000 # Or your preferred local URL

        DB_CONNECTION=mysql # or pgsql for PostgreSQL
        DB_HOST=127.0.0.1
        DB_PORT=3306 # or 5432 for PostgreSQL
        DB_DATABASE=your_database_name
        DB_USERNAME=your_db_user
        DB_PASSWORD=your_db_password

        # Google API Key (if required for local development)
        GOOGLE_API_KEY=your_google_api_key

        # Laravel Passport Keys (will be generated)
        PASSPORT_PRIVATE_KEY=
        PASSPORT_PUBLIC_KEY=
        ```

4.  **Generate Application Key:**
    ```bash
    php artisan key:generate
    ```

5.  **Database Migration & Seeding:**
    *   Create the database specified in `DB_DATABASE` in your `.env` file.
    *   Run migrations to create tables:
        ```bash
        php artisan migrate
        ```
    *   (Optional) Seed the database with test data:
        ```bash
        php artisan db:seed
        ```

6.  **Laravel Passport Setup:**
    *   Install Passport's client keys (required for OAuth2 authentication):
        ```bash
        php artisan passport:install
        ```
        This command will generate encryption keys and create default API clients. Note down the `Client ID` and `Client Secret` for the `Personal Access Client` and `Password Grant Client` as they might be needed for testing or configuring the mobile app if it uses these directly (though usually the Flutter app uses a password grant client which is implicitly configured with the `passport:install` command).

7.  **Run Laravel Development Server:**
    ```bash
    php artisan serve
    ```
    The backend should now be running on `http://localhost:8000` (or another port if specified).

### Mobile App Installation Steps

1.  **Navigate to Mobile App Directory:**
    ```bash
    cd ../mobile_app # From the backend directory
    # or if starting from project root:
    # cd mobile_app
    ```

2.  **Get Flutter Dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Environment Configuration (Flutter):**
    *   Flutter applications typically manage environment variables differently. You might need to configure a `config.dart` file or use a package like `flutter_dotenv` to handle API base URLs and other sensitive configurations.
    *   **Assumption:** The `ApiClient` in `mobile_app/lib/api/api_client.dart` will have a configurable base URL for the backend. Ensure this points to your local Laravel backend (e.g., `http://10.0.2.2:8000` for Android emulator, `http://localhost:8000` for iOS simulator or web).
        *If the mobile app has a `.env` file or similar, you will need to create and configure it.*

4.  **Run the Flutter App:**
    *   Connect a physical device, start an Android emulator, or an iOS simulator.
    *   Run the app:
        ```bash
        flutter run
        ```
    *   Alternatively, run for web:
        ```bash
        flutter run -d chrome
        ```

### Running the Project Locally

1.  Ensure your database server is running.
2.  Start the Laravel backend: Navigate to `myFirstAPP/backend` and run `php artisan serve`.
3.  Start the Flutter mobile app: Navigate to `myFirstAPP/mobile_app` and run `flutter run` (or `flutter run -d <device_id>`).
4.  The mobile application should now connect to your local Laravel backend.

---

## 6. Deployment

This section outlines the general steps for deploying the Laravel backend and building the Flutter mobile application for production environments.

### Backend Deployment Steps

The Laravel backend is designed for server-side deployment. The presence of a `Procfile` and `start.sh` strongly suggests deployment to a Platform-as-a-Service (PaaS) like **Railway** or Heroku.

**General Deployment Workflow (e.g., Railway/Heroku):**

1.  **Version Control:** Ensure your backend code is pushed to a Git repository (e.g., GitHub, GitLab).
2.  **Platform Configuration:**
    *   Create a new project/application on your chosen PaaS.
    *   Connect your Git repository.
    *   Configure environment variables:
        *   Copy the values from your local `.env` file (excluding `APP_KEY`, `PASSPORT_PRIVATE_KEY`, `PASSPORT_PUBLIC_KEY` if they are handled by the platform or generated on first deploy) to the platform's environment variable settings.
        *   Ensure `APP_ENV=production` is set.
        *   Update `APP_URL` to your production domain.
        *   Configure production database credentials (DB\_HOST, DB\_DATABASE, DB\_USERNAME, DB\_PASSWORD).
        *   Set any third-party API keys (`GOOGLE_API_KEY`, Pusher, AWS S3) as required.
        *   **Crucially, generate and securely store `APP_KEY`, `PASSPORT_PRIVATE_KEY`, `PASSPORT_PUBLIC_KEY` directly on the platform if not handled by your `start.sh` script.** The `start.sh` script in this project *does not* generate these, so they must be provided.
3.  **Build and Start Commands:**
    *   The `Procfile` (e.g., `web: php artisan serve --host 0.0.0.0 --port $PORT`) will define how the web server starts.
    *   The `start.sh` script acts as a pre-build/pre-start hook. It will:
        *   Install Composer dependencies (`composer install --no-dev --optimize-autoloader`).
        *   Run database migrations (`php artisan migrate --force`).
        *   Cache configuration (`php artisan config:cache`).
        *   Start the Laravel server.
    *   Ensure your chosen platform correctly executes `start.sh` or configure its build/deploy hooks to do so.
4.  **Database Provisioning:**
    *   Provision a production-grade database instance (e.g., managed MySQL, PostgreSQL service) and link it to your application.
    *   Ensure proper database credentials are set in the environment variables.
5.  **SSL/TLS:** Configure SSL certificates for secure HTTPS communication (usually handled by the PaaS).
6.  **Domain Setup:** Point your custom domain to the deployed application.

### Mobile Build (Android / iOS)

Building the Flutter mobile application for production involves generating platform-specific release builds.

**Android Build:**

1.  **Navigate to Mobile App Directory:**
    ```bash
    cd mobile_app
    ```
2.  **Update `pubspec.yaml` version:** Ensure the `version` field in `pubspec.yaml` is incremented appropriately (e.g., `1.0.0+1` to `1.0.1+2`).
3.  **Keystore Setup:** Generate a signing key (if you don't have one) and configure your Android project to sign your app. This is crucial for releasing to the Google Play Store.
    *   Refer to the [official Flutter documentation for Android signing](https://docs.flutter.dev/deployment/android).
4.  **Build App Bundle (Recommended for Play Store):**
    ```bash
    flutter build appbundle
    ```
    This generates an `app-release.aab` file in `build/app/outputs/bundle/release/`.
5.  **Build APK (for testing or specific distribution):**
    ```bash
    flutter build apk --release
    ```
    This generates an `app-release.apk` file in `build/app/outputs/flutter-apk/`.
6.  **Upload to Google Play Console:** Use the generated App Bundle or APK to publish your app to the Google Play Store.

**iOS Build:**

1.  **Navigate to Mobile App Directory:**
    ```bash
    cd mobile_app
    ```
2.  **Update `pubspec.yaml` version:** Ensure the `version` field in `pubspec.yaml` is incremented.
3.  **Xcode Setup:**
    *   Open the iOS project in Xcode:
        ```bash
        open ios/Runner.xcworkspace
        ```
    *   Configure signing and team settings in Xcode (Runner target -> Signing & Capabilities). You'll need an Apple Developer account and appropriate provisioning profiles.
4.  **Build for Archiving:**
    *   Select a generic iOS Device as the target.
    *   Go to `Product > Archive`. This will build and archive your application.
5.  **Distribute via App Store Connect:**
    *   Once archived, use Xcode's Organizer window or `xcrun altool` to upload your app to App Store Connect.
    *   Refer to the [official Flutter documentation for iOS deployment](https://docs.flutter.dev/deployment/ios).

### Production Environment Notes

*   **API Base URL:** Ensure the Flutter app's `ApiClient` is configured with the correct production base URL of your deployed Laravel backend. This might involve using different `.env` files for build types or build-time constants.
*   **Database Backups:** Implement regular database backups for your production backend.
*   **Monitoring & Logging:** Set up application performance monitoring (APM) and centralized logging for both backend and frontend to quickly identify and resolve issues.
*   **Security:** Regularly review security practices, keep dependencies updated, and ensure all sensitive environment variables are handled securely.
*   **Rate Limiting:** Implement rate limiting on critical API endpoints (e.g., login, registration) to mitigate brute-force attacks.
*   **API Key Protection:** If the Flutter app uses any API keys directly, ensure they are stored securely (e.g., through environment configurations during build) and not exposed in public repositories.

---

## 7. Maintenance & Best Practices

This section provides guidelines for maintaining the application, adding new features, organizing code, and ensuring security.

### How to Add New Features

When adding new features, follow a structured approach to ensure consistency, maintainability, and scalability.

**Backend (Laravel):**

1.  **Define API Endpoints:** Add new routes to `backend/routes/api.php`, ensuring they are grouped logically and protected by appropriate middleware (e.g., `auth:api`, `role:admin`).
2.  **Create Controllers/Actions:** Implement the logic in new or existing controllers within `backend/app/Http/Controllers/`. Focus on single responsibility and clean code.
3.  **Update/Create Models & Migrations:** If the feature requires new data or changes to existing data structures, create new migrations (`php artisan make:migration`) and update/create Eloquent models (`backend/app/Models/`).
4.  **Implement Business Logic:** Encapsulate complex business rules within models, dedicated service classes, or use form requests for validation.
5.  **Write Tests:** Create unit and feature tests (`backend/tests/`) to cover the new functionality.
6.  **Update Documentation:** Ensure any new endpoints, models, or significant logic changes are reflected in the project documentation.

**Mobile App (Flutter):**

1.  **Define UI/UX:** Design the user interface and experience for the new feature.
2.  **Update API Service:** If the new feature interacts with the backend, update `mobile_app/lib/api/api_client.dart` or create new API service methods. Define corresponding data models in `mobile_app/lib/models/`.
3.  **Implement UI Components:** Create new pages/screens in `mobile_app/lib/pages/` and reusable widgets in `mobile_app/lib/widgets/`.
4.  **Manage State:** Utilize Riverpod for managing UI-specific state and GetX for dependency injection as per existing patterns.
5.  **Define Navigation:** Add new routes to `mobile_app/lib/routes/app_pages.dart` and implement navigation logic.
6.  **Write Tests:** Implement widget and unit tests for new UI components and logic.

### Code Organization Guidelines

Adhering to established code organization principles is crucial for large projects.

**Backend (Laravel):**

*   **MVC Pattern:** Strictly follow Laravel's Model-View-Controller pattern. Keep controllers lean and delegate business logic to models or service classes.
*   **Single Responsibility:** Each class, method, and function should have one clear responsibility.
*   **Naming Conventions:** Use clear, descriptive names for variables, functions, and classes (e.g., PascalCase for classes, camelCase for methods/variables, snake_case for database columns).
*   **PSR Standards:** Adhere to PHP's PSR coding standards (PSR-1, PSR-2, PSR-4, etc.) as enforced by tools like Laravel Pint.
*   **Configuration vs. Code:** Keep environment-specific settings in `.env` files, not hardcoded in the codebase.

**Mobile App (Flutter):**

*   **Modular Structure:** Maintain the existing modular structure in `lib/` (e.g., `api`, `models`, `pages`, `services`, `widgets`).
*   **Separation of Concerns:** Separate UI (`widgets`, `pages`) from business logic (`controllers`, `services`) and data handling (`api`, `models`).
*   **State Management Consistency:** Use Riverpod consistently for UI state and GetX for dependency injection and routing.
*   **Naming Conventions:** Follow Dart's naming conventions (camelCase for variables/functions, PascalCase for classes/types).
*   **Linting:** Adhere to `flutter_lints` rules as defined in `analysis_options.yaml`.

### Security Considerations

Security is paramount for any application, especially one handling user data.

*   **Input Validation:** Always validate all incoming data on the backend to prevent common vulnerabilities like SQL injection, XSS, and mass assignment.
*   **Authentication & Authorization:** Ensure all endpoints are appropriately protected. Implement robust access control checks (e.g., role-based authorization) at the backend.
*   **Secure Storage:** Use `flutter_secure_storage` in the mobile app for sensitive data (tokens, user IDs) and avoid storing credentials in plaintext.
*   **HTTPS Only:** All communication between the mobile app and backend must occur over HTTPS to encrypt data in transit.
*   **Dependency Updates:** Regularly update all project dependencies (Composer for PHP, `pubspec.yaml` for Flutter) to patch known vulnerabilities.
*   **Error Handling:** Avoid exposing sensitive error details (e.g., stack traces) in production environments.
*   **Environment Variables:** Never hardcode sensitive information (API keys, database credentials) directly into the codebase. Use environment variables.
*   **Rate Limiting:** Implement rate limiting on critical API endpoints (e.g., login, registration) to mitigate brute-force attacks.
*   **API Key Protection:** If the Flutter app uses any API keys directly, ensure they are stored securely (e.g., through environment configurations during build) and not exposed in public repositories.
