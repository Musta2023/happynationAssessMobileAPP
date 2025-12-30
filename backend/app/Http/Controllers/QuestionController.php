<?php

namespace App\Http\Controllers;

use App\Models\Question;
use App\Models\Assessment;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class QuestionController extends Controller
{
    public function index()
    {
        $questions = Question::where('is_active', true)->get();
        return response()->json($questions);
    }

    public function getAssessmentQuestions(Assessment $assessment)
    {
        return response()->json($assessment->questions);
    }

    public function getAssessments()
    {
        $assessments = Assessment::with('questions')->get();
        return response()->json($assessments);
    }
}