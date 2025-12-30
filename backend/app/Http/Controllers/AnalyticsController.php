<?php

namespace App\Http\Controllers;

use App\Models\Assessment;
use Illuminate\Http\Request;

class AnalyticsController extends Controller
{
    /**
     * Get analytics for a specific assessment.
     *
     * @param  \App\Models\Assessment  $assessment
     * @return \Illuminate\Http\JsonResponse
     */
    public function getAssessmentAnalytics(Assessment $assessment)
    {
        // In a real application, you would calculate these values based on the responses
        // for this assessment. For now, we'll return a dummy response.

        $categoryScores = [
            'stress' => rand(30, 90),
            'motivation' => rand(40, 95),
            'satisfaction' => rand(20, 85),
        ];

        $globalScore = collect($categoryScores)->average();
        
        $riskLevel = 'low';
        if ($globalScore < 40) {
            $riskLevel = 'high';
        } elseif ($globalScore < 60) {
            $riskLevel = 'medium';
        }

        return response()->json([
            'assessment_id' => $assessment->id,
            'assessment_title' => $assessment->title,
            'date' => now()->toIso8601String(),
            'global_score' => round($globalScore, 2),
            'category_scores' => $categoryScores,
            'risk_level' => $riskLevel,
            'summary' => 'This is a summary of the assessment analytics. Based on the scores, the overall risk level is ' . $riskLevel . '.',
            'recommendations' => [
                'Based on the stress score, consider implementing stress management workshops.',
                'Motivation seems to be good, but can be improved with more recognition.',
                'Satisfaction scores are a bit low. A survey to gather more feedback is recommended.',
            ],
        ]);
    }
}