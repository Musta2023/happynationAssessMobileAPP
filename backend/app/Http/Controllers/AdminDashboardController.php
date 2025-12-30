<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\Question;
use App\Models\Response;
use Illuminate\Http\Request;

class AdminDashboardController extends Controller
{
    /**
     * Provide statistics for the admin dashboard.
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function index()
    {
        $stats = [
            'total_users' => User::where('role', 'employee')->count(),
            'total_questions' => Question::count(),
            'total_responses' => Response::count(),
            'average_score' => Response::avg('global_score'),
        ];

        return response()->json($stats);
    }
}