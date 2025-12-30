<?php

namespace App\Http\Controllers;

use App\Models\Question;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Gate;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Validator;

class AdminQuestionController extends Controller
{
    public function index()
    {
        $questions = Question::all();
        Log::info('AdminQuestionController@index method hit. Returning ' . $questions->count() . ' questions.');
        return response()->json($questions);
    }

    public function store(Request $request)
    {
        Log::info('AdminQuestionController@store method hit.');
        $validator = Validator::make($request->all(), [
            'question_text' => 'required|string',
            'category' => 'required|in:stress,motivation,satisfaction',
            'type' => 'required|in:likert,yes_no,text',
            'is_active' => 'boolean',
        ]);

        if ($validator->fails()) {
            return response()->json($validator->errors(), 422);
        }

        $question = Question::create($request->all());

        return response()->json($question, 201);
    }

    public function update(Request $request, $id)
    {
        Log::info("AdminQuestionController@update method hit for question ID: {$id}.");
        $question = Question::findOrFail($id);

        $validator = Validator::make($request->all(), [
            'question_text' => 'sometimes|required|string',
            'category' => 'sometimes|required|in:stress,motivation,satisfaction',
            'type' => 'sometimes|required|in:likert,yes_no,text',
            'is_active' => 'sometimes|boolean',
        ]);

        if ($validator->fails()) {
            return response()->json($validator->errors(), 422);
        }

        $question->update($request->all());

        return response()->json($question);
    }

    public function destroy($id)
    {
        $question = Question::findOrFail($id);
        $question->delete();

        return response()->json(null, 204);
    }

    public function toggleStatus($id)
    {
        $question = Question::findOrFail($id);
        $question->is_active = !$question->is_active;
        $question->save();

        return response()->json($question);
    }
}