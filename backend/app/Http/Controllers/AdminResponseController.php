<?php

namespace App\Http\Controllers;

use App\Models\Response;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Gate;
use Illuminate\Support\Facades\DB;

class AdminResponseController extends Controller
{
    public function allResponses()
    {
        $responses = Response::with('user:id,name,first_name,last_name,email,role,department')
            ->whereNotNull('global_score')
            ->orderBy('created_at', 'desc')
            ->get();

        // Manually decode recommendations as a fallback
        $responses->each(function ($response) {
            if (is_string($response->recommendations)) {
                $response->recommendations = json_decode($response->recommendations, true);
            }
        });

        return response()->json($responses);
    }

    public function showResponse($id)
    {
        $response = Response::with('user:id,name,email', 'items.question')->findOrFail($id);

        return response()->json($response);
    }

    public function statistics(Request $request)
    {
        $query = Response::query();

        // Filter by department
        if ($request->has('department') && $request->department !== 'All') {
            $query->whereHas('user', function ($q) use ($request) {
                $q->where('department', $request->department);
            });
        }

        // Filter by date range
        if ($request->has('start_date') && $request->has('end_date')) {
            $query->whereBetween('created_at', [$request->start_date, $request->end_date]);
        }

        $totalResponses = $query->whereNotNull('global_score')->count();
        $averageGlobalScore = $query->whereNotNull('global_score')->avg('global_score');

        $riskDistribution = (clone $query)->whereNotNull('risk')
            ->select('risk', DB::raw('count(*) as count'))
            ->groupBy('risk')
            ->get()
            ->pluck('count', 'risk');

        $categoryAverages = [
            'stress' => (clone $query)->whereNotNull('stress_score')->avg('stress_score'),
            'motivation' => (clone $query)->whereNotNull('motivation_score')->avg('motivation_score'),
            'satisfaction' => (clone $query)->whereNotNull('satisfaction_score')->avg('satisfaction_score'),
        ];

        $globalScoreTrend = (clone $query)->whereNotNull('global_score')
            ->select(DB::raw('DATE(created_at) as date'), DB::raw('avg(global_score) as score'))
            ->groupBy('date')
            ->orderBy('date', 'asc')
            ->get()
            ->map(function ($item) {
                $item->score = (float) $item->score; // Explicitly cast to float
                return $item;
            });

        return response()->json([
            'total_responses' => (int) $totalResponses,
            'average_global_score' => round($averageGlobalScore, 2),
            'risk_distribution' => $riskDistribution,
            'category_averages' => [
                'stress' => round($categoryAverages['stress'], 2),
                'motivation' => round($categoryAverages['motivation'], 2),
                'satisfaction' => round($categoryAverages['satisfaction'], 2),
            ],
            'global_score_trend' => $globalScoreTrend,
        ]);
    }
}
