# Employee Well-being Diagnostic System - Backend

This project serves as the robust backend API for the Employee Well-being Diagnostic System. It is built using Laravel 11 and provides all the necessary endpoints for user authentication, assessment management, question handling, response storage, and AI-powered analysis.

## Technology Stack

*   **Laravel 11:** The core PHP framework.
*   **PHP 8.2+:** The language runtime.
*   **MySQL (or SQLite):** For database management.
*   **Laravel Passport:** Handles OAuth2 authentication for secure API access.
*   **Google Gemini API:** Integrated for advanced AI analysis of employee responses.
*   **RESTful API:** Provides well-structured endpoints for the mobile application.

## Features

*   **Authentication:** Secure registration and login for both employees and administrators.
*   **User Management:** Admin functionalities to manage employee accounts.
*   **Assessment Management:** Admins can create, update, and manage well-being assessments.
*   **Question Management:** Admins can add, edit, activate/deactivate questions used in assessments.
*   **Response Handling:** Stores employee responses to assessments.
*   **AI Analysis:** Integrates with the Google Gemini API to provide stress, motivation, satisfaction scores, risk levels, summaries, and recommendations based on employee responses.
*   **History & Analytics:** Provides employee assessment history and comprehensive admin dashboards with statistics and response details.

## Setup and Installation

For detailed instructions on setting up and installing this backend, including database configuration, API key setup, and deployment considerations, please refer to the main project's `README.md` located in the root directory of the repository (`../README.md`).

## Contributing

For general Laravel contributing guidelines, refer to the [Laravel documentation](https://laravel.com/docs/contributions). Specific contributions to this project should follow the guidelines outlined in the main project `README.md`.

## License

The Laravel framework is open-sourced software licensed under the [MIT license](https://opensource.org/licenses/MIT).