<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\AdminAuthController;
use App\Http\Controllers\AdminDashboardController;
use App\Http\Controllers\QuestionController;
use App\Http\Controllers\AdminQuestionController;
use App\Http\Controllers\ResponseController;
use App\Http\Controllers\AdminResponseController;
use App\Http\Controllers\AdminUserController; // Added AdminUserController
use App\Http\Controllers\AssessmentController; // Added AssessmentController
use App\Http\Controllers\AnalyticsController;

// Auth Routes
Route::post('/auth/register', [AuthController::class, 'register']);
Route::post('/auth/login', [AuthController::class, 'login']);
Route::post('/auth/refresh', [AuthController::class, 'refresh'])->middleware('auth:api');

// Admin Auth
Route::post('/admin/login', [AdminAuthController::class, 'login']);

// Employee Routes
Route::middleware('auth:api')->group(function () {
    // Questions
    Route::get('/questions', [QuestionController::class, 'index']);

    // Assessments
    Route::get('/assessments', [QuestionController::class, 'getAssessments']);
    Route::get('/assessments/{assessment}/questions', [QuestionController::class, 'getAssessmentQuestions']);

    // Responses
    Route::post('/responses', [ResponseController::class, 'store']);
    Route::post('/responses/analyze', [ResponseController::class, 'analyze']);
    Route::get('/responses/history', [ResponseController::class, 'history']);
    Route::get('/responses/{id}', [ResponseController::class, 'show']);
});


// Admin Routes
Route::middleware(['auth:api', 'role:admin'])->prefix('admin')->group(function () {
    // Dashboard
    Route::get('/dashboard', [AdminDashboardController::class, 'index']);
    
    // Questions
    Route::get('/questions', [AdminQuestionController::class, 'index']);
    Route::post('/questions', [AdminQuestionController::class, 'store']);
    Route::put('/questions/{id}', [AdminQuestionController::class, 'update']);
    Route::delete('/questions/{id}', [AdminQuestionController::class, 'destroy']);
    Route::patch('/questions/{id}/toggle', [AdminQuestionController::class, 'toggleStatus']);

    // Responses
    Route::get('/responses', [AdminResponseController::class, 'allResponses']);
    Route::get('/responses/{id}', [AdminResponseController::class, 'showResponse']);
    
    // Users
    Route::get('/users', [AdminUserController::class, 'index']);
    Route::post('/users', [AdminUserController::class, 'store']); // Store new user
    Route::put('/users/{id}', [AdminUserController::class, 'update']); // Update user
    Route::delete('/users/{id}', [AdminUserController::class, 'destroy']);
    Route::get('/users/{id}/responses', [AdminUserController::class, 'userResponses']);
    Route::get('/departments', [AdminUserController::class, 'getDepartments']);

    // Assessments
    Route::apiResource('assessments', AssessmentController::class);
    Route::get('/assessments/{assessment}/analytics', [AnalyticsController::class, 'getAssessmentAnalytics']);

    // Statistics
    Route::get('/statistics', [AdminResponseController::class, 'statistics']);
});
