<?php

namespace App\Http\Controllers;

use App\Models\Assessment;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class AssessmentController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $assessments = Assessment::with('questions:id,question_text,category')->get();
        return response()->json($assessments);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validatedData = $request->validate([
            'title' => 'required|string|max:255',
            'description' => 'nullable|string',
            'question_ids' => 'array',
            'question_ids.*' => 'exists:questions,id',
        ]);

        $assessment = Assessment::create([
            'title' => $validatedData['title'],
            'description' => $validatedData['description'] ?? null,
        ]);

        if (isset($validatedData['question_ids'])) {
            $assessment->questions()->attach($validatedData['question_ids']);
        }

        return response()->json($assessment->load('questions:id,question_text,category'), 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(Assessment $assessment)
    {
        return response()->json($assessment->load('questions:id,question_text,category'));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Assessment $assessment)
    {
        $validatedData = $request->validate([
            'title' => 'required|string|max:255',
            'description' => 'nullable|string',
            'question_ids' => 'array',
            'question_ids.*' => 'exists:questions,id',
        ]);

        $assessment->update([
            'title' => $validatedData['title'],
            'description' => $validatedData['description'] ?? null,
        ]);

        if (isset($validatedData['question_ids'])) {
            $assessment->questions()->sync($validatedData['question_ids']);
        } else {
            $assessment->questions()->detach(); // Detach all if no IDs are provided
        }

        return response()->json($assessment->load('questions:id,question_text,category'));
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Assessment $assessment)
    {
        $assessment->delete();
        return response()->json(['message' => 'Assessment deleted successfully']);
    }
}
