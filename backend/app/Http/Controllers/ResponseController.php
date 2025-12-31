<?php

namespace App\Http\Controllers;

use App\Models\Response;
use App\Models\ResponseItem;
use App\Models\Question;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Log;

class ResponseController extends Controller
{
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'answers' => 'required|array',
            'answers.*.question_id' => 'required|exists:questions,id',
            'answers.*.answer_value' => 'required',
        ]);

        if ($validator->fails()) {
            Log::warning('Response store validation failed', ['errors' => $validator->errors(), 'request' => $request->all()]);
            return response()->json($validator->errors(), 422);
        }

        try {
            $user = Auth::user();
            if ($user->role !== 'employee') {
                return response()->json(['error' => 'Unauthorized', 'message' => 'Only employees can submit responses.'], 403);
            }
            $response = $user->responses()->create([]);

            $answers = [];
            foreach ($request->answers as $answerData) {
                $response->items()->create([
                    'question_id' => $answerData['question_id'],
                    'answer_value' => $answerData['answer_value'],
                ]);
                $question = Question::find($answerData['question_id']);
                if ($question) {
                    $answers[] = "Q: {$question->question_text} (Category: {$question->category}, Type: {$question->type})\nA: {$answerData['answer_value']}";
                } else {
                    Log::warning('Question not found for ID', ['question_id' => $answerData['question_id']]);
                    $answers[] = "Q: Unknown Question (ID: {$answerData['question_id']})\nA: {$answerData['answer_value']}";
                }
            }
            Log::info('Response stored successfully', ['response_id' => $response->id, 'user_id' => $user->id]);

            // Perform analysis after storing
            $analysisData = $this->performAnalysis($response, $answers);

            // Return the analysis data as the store method's response
            return response()->json($analysisData, 201);

        } catch (\Exception $e) {
            Log::error('Exception in ResponseController@store', ['message' => $e->getMessage(), 'trace' => $e->getTraceAsString(), 'request' => $request->all()]);
            return response()->json(['error' => 'An unexpected error occurred during response storage.'], 500);
        }
    }

    public function analyze(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'response_id' => 'required|exists:responses,id',
            'prepared_answers' => 'required|array',
        ]);

        if ($validator->fails()) {
            Log::warning('Response analyze validation failed', ['errors' => $validator->errors(), 'request' => $request->all()]);
            return response()->json($validator->errors(), 422);
        }

        try {
            $response = Response::findOrFail($request->response_id);

            if ($response->user_id !== Auth::id()) {
                Log::warning('Unauthorized attempt to analyze response', ['response_id' => $request->response_id, 'user_id' => Auth::id()]);
                return response()->json(['error' => 'Unauthorized'], 403);
            }

            // Call the private method
            $analysisData = $this->performAnalysis($response, $request->prepared_answers);
            return response()->json($analysisData);

        } catch (\Exception $e) {
            Log::error('Exception in ResponseController@analyze', ['message' => $e->getMessage(), 'trace' => $e->getTraceAsString(), 'request' => $request->all()]);
            return response()->json(['error' => 'An unexpected error occurred.'], 500);
        }
    }

    // Private method to encapsulate the core analysis logic
    private function performAnalysis(Response $response, array $preparedAnswers)
    {
        $prompt = "Analyze the following answers and return ONLY valid JSON with the specified structure. Do not add any introductory text or explanations. The scores should be integers between 0 and 100.\n\nJSON structure:\n{\n \"stress_score\": 0,\n \"motivation_score\": 0,\n \"satisfaction_score\": 0,\n \"global_score\": 0,\n \"risk_level\": \"low|medium|high\",\n \"recommendations\": [\"string\"],\n \"summary\": \"string\"\n}\n\nAnswers:\n" . implode("\n", $preparedAnswers);

        try {
            $googleApiKey = env('GOOGLE_API_KEY');
            if (empty($googleApiKey)) {
                Log::error('GOOGLE_API_KEY not set in .env');
                throw new \Exception('Google API Key is not configured.');
            }

            $apiResponse = Http::withHeaders([
                'Content-Type' => 'application/json',
                'x-goog-api-key' => $googleApiKey,
            ])
                ->retry(3, 1000)
                ->timeout(120)
                ->post('https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent', [
                    'contents' => [
                        [
                            'parts' => [
                                ['text' => $prompt]
                            ]
                        ]
                    ],
                    'generationConfig' => [
                        'response_mime_type' => 'application/json',
                        'temperature' => 0.5,
                    ],
                ]);

            if ($apiResponse->failed()) {
                Log::error('Google Gemini API request failed', ['response_body' => $apiResponse->body(), 'status' => $apiResponse->status()]);
                throw new \Exception('Failed to get analysis from AI service.');
            }

            $analysis = $apiResponse->json('candidates.0.content.parts.0.text');
            
            if (is_string($analysis)) {
                $analysis = str_replace('```json', '', $analysis);
                $analysis = str_replace('```', '', $analysis);
            }

            $analysisData = json_decode($analysis, true);

            if (json_last_error() !== JSON_ERROR_NONE) {
                Log::error('Failed to decode JSON from Google Gemini', ['raw_response' => $apiResponse->body(), 'parsed_text' => $analysis, 'json_error' => json_last_error_msg()]);
                throw new \Exception('Invalid JSON format from AI service.');
            }
            
            $response->update([
                'stress_score' => $analysisData['stress_score'],
                'motivation_score' => $analysisData['motivation_score'],
                'satisfaction_score' => $analysisData['satisfaction_score'],
                'global_score' => $analysisData['global_score'],
                'risk' => $analysisData['risk_level'],
                'recommendations' => json_encode($analysisData['recommendations']),
                'summary' => $analysisData['summary'],
            ]);
            Log::info('Response analyzed successfully by Google Gemini', ['response_id' => $response->id, 'analysis_data' => $analysisData]);
            return $analysisData;

        } catch (\Exception $e) {
            Log::error('Exception during Google Gemini API call', ['message' => $e->getMessage(), 'trace' => $e->getTraceAsString()]);
            throw $e; // Re-throw to be caught by the calling method
        }
    }

    public function history()
    {
        $user = Auth::user();
        return Response::where('user_id', $user->id)
            ->with('assessment') // Eager load the associated assessment
            ->orderBy('created_at', 'desc')
            ->get();
    }
}