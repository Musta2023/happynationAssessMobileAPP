# Troubleshooting Guide for HappyNation Assess Mobile App

This document outlines common issues and their solutions when setting up or running the HappyNation Assess Mobile App and its backend.

## 1. Backend Issues: Database & Deployment

### Issue: `SQLSTATE[HY000]: General error: 1 no such table: assessments` or similar database errors.
**Explanation:** This error means that the necessary database tables for the application (e.g., `assessments`, `questions`, `responses`) have not been created in your database.
**Solution:**
1.  **Navigate to your `backend` directory.**
2.  **Run migrations and seed the database:**
    ```bash
    php artisan migrate:refresh --seed
    ```
    This command will create all the required tables and populate them with initial data (like an admin user and sample questions).
3.  **Ensure your `.env` database configuration is correct.**

### Issue: `The "--show-key" option does not exist.` or `The "--show" option does not exist.` during deployment (e.g., on Railway).
**Explanation:** These errors occur when the deployment platform (like Railway's buildpack) tries to generate or display application keys using outdated command options that are no longer supported by your Laravel version. The key generation might still succeed, but the command to display them fails.
**Solution:** Manually generate your `APP_KEY` and Laravel Passport keys locally, and then set them as environment variables directly in your deployment platform's dashboard.
1.  **Generate `APP_KEY` locally:** In your `backend` directory, run `php artisan key:generate --show`. Copy the output (e.g., `base64:YourAppKeyString...`).
2.  **Generate Laravel Passport keys locally:** In your `backend` directory, run `php artisan passport:keys --force`. This creates `oauth-private.key` and `oauth-public.key` in `backend/storage/`. Copy the entire content of both files.
3.  **Set as Environment Variables:** In your Railway (or similar platform) project's "Variables" section, add:
    *   `APP_KEY`: (value from step 1)
    *   `PASSPORT_PRIVATE_KEY`: (content of `oauth-private.key`)
    *   `PASSPORT_PUBLIC_KEY`: (content of `oauth-public.key`)
    This bypasses the platform's automatic key generation.

### Issue: `assessment_id: null` in history responses or "Unknown Assessment" titles.
**Explanation:** This happens if the `assessment_id` is not correctly saved in the backend's database when an employee submits an assessment. My previous fix for `ResponseController.php` addresses this.
**Solution:**
1.  **Ensure Latest Backend Deployment:** Verify that your very latest backend code (specifically the changes to `backend/app/Http/Controllers/ResponseController.php` to save `assessment_id`) is successfully deployed to Railway.
2.  **Submit New Assessments:** This fix only applies to *newly submitted* assessments. Old history records will still have `assessment_id: null`. After deploying, submit a new assessment to see the correct titles appear in your history.

## 2. Mobile App (Flutter) Issues

### Issue: `403 Unauthorized` when fetching assessments (e.g., on History page).
**Explanation:** This occurs if an employee is trying to access an API endpoint meant only for administrators.
**Solution:** This was addressed in `mobile_app/lib/controllers/history_controller.dart`. Ensure you are using `_apiClient.getEmployeeAssessments()` (which maps to `/api/assessments`) instead of `_apiClient.getAllAssessments()` (which maps to `/api/admin/assessments`) for employee users.

### Issue: Assessment status remains "Open" even after submission.
**Explanation:** This indicates that the mobile app is not correctly identifying submitted assessments from the user's history, often due to a type mismatch in comparison.
**Solution:** This was addressed in `mobile_app/lib/controllers/employee_assessments_controller.dart`. The comparison for `assessment_id` needs to ensure both sides are of the same type (e.g., by converting `response['assessment_id']` to a string: `response['assessment_id']?.toString() == assessment.id`).

### Issue: `There are multiple heroes that share the same tag within a subtree.` (Flutter UI error).
**Explanation:** This is a Flutter UI error related to `Hero` widgets. It means you have two or more `Hero` widgets in the same visible part of the UI that have the exact same `tag` property. `Hero` tags must be unique.
**Solution:** Review your `Hero` widget implementations. Ensure that each `Hero` widget has a unique `tag` within the current navigation stack. Often, this means appending a unique identifier (like an item's ID) to the tag string (e.g., `Hero(tag: 'user-${user.id}', ...)`).

---
*If you encounter any other issues, please provide detailed error messages and context.*