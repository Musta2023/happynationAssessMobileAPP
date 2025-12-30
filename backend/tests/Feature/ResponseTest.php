<?php

namespace Tests\Feature;

use App\Models\Question;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;
use Tests\TestCase;
use Laravel\Passport\Client;

class ResponseTest extends TestCase
{
    use RefreshDatabase;

    protected $employee;
    protected $employeeToken;
    protected $admin;
    protected $adminToken;
    protected $questions;

    protected function setUp(): void
    {
        parent::setUp();

        // 1. Génération des clés de chiffrement Passport
        Artisan::call('passport:keys', ['--force' => true]);

        // 2. Création du Client Passport (Correction du bug Array vs String et Import Str)
        Client::factory()->create([
            'name' => 'Personal Access Client',
            'secret' => \Illuminate\Support\Str::random(40), // Solution 1: Chemin complet (plus sûr)
            'provider' => 'users',
            'redirect_uris' => ['http://localhost'],
            'grant_types' => ['personal_access'], // Correction: Doit être un tableau
            'revoked' => false,
        ]);
        
        // 3. Peuplement de la base de données
        Artisan::call('db:seed');

        // 4. Configuration de l'employé
        $this->employee = User::factory()->create([
            'email' => 'employee@example.com',
            'password' => bcrypt('password'),
            'role' => 'employee',
        ]);
        $this->employeeToken = $this->employee->createToken('EmployeeToken')->accessToken;

        // 5. Configuration de l'admin
        $this->admin = User::where('email', 'admin@company.com')->first();
        if (!$this->admin) {
             $this->admin = User::factory()->create(['email' => 'admin@company.com', 'role' => 'admin']);
        }
        $this->adminToken = $this->admin->createToken('AdminToken')->accessToken;

        $this->questions = Question::all();
    }

    /**
     * Helper privé pour créer une réponse analysée.
     * Cela permet de simuler Gemini et de préparer les données pour les autres tests.
     */
    private function createAndAnalyzeResponse()
    {
        // Simulation de l'API Google (Mock) pour éviter les erreurs 503 et gagner du temps
        Http::fake([
            'generativelanguage.googleapis.com/*' => Http::response([
                "candidates" => [
                    [
                        "content" => [
                            "parts" => [
                                [
                                    "text" => json_encode([
                                        "stress_score" => 50,
                                        "motivation_score" => 75,
                                        "satisfaction_score" => 60,
                                        "global_score" => 65,
                                        "risk_level" => "medium",
                                        "recommendations" => ["Prendre une pause", "Parler au manager"],
                                        "summary" => "Analyse simulée pour le test."
                                    ])
                                ]
                            ]
                        ]
                    ]
                ]
            ], 200)
        ]);

        // Préparation des réponses aux questions
        $answers = $this->questions->map(function ($question) {
            return ['question_id' => $question->id, 'answer_value' => 'valeur test'];
        })->toArray();

        // Étape 1 : Soumission
        $response = $this->actingAs($this->employee, 'api')->postJson('/api/responses', [
            'answers' => $answers,
        ]);
        
        $data = $response->json();
        
        // Étape 2 : Analyse (C'est ici que Http::fake est utilisé par le backend)
        return $this->actingAs($this->employee, 'api')->postJson('/api/responses/analyze', [
            'response_id' => $data['response_id'],
            'prepared_answers' => $data['prepared_answers'],
        ]);
    }

    /**
     * Test 1 : L'employé peut soumettre et obtenir une analyse
     */
    public function test_employee_can_submit_responses_and_analyze_them_with_google_gemini(): void
    {
        $analysisResponse = $this->createAndAnalyzeResponse();

        $analysisResponse->assertStatus(200)
                         ->assertJsonStructure([
                             'stress_score',
                             'motivation_score',
                             'satisfaction_score',
                             'global_score',
                             'risk_level',
                             'recommendations',
                             'summary',
                         ]);
        
        // Vérifications supplémentaires
        $this->assertIsInt($analysisResponse->json('global_score'));
        $this->assertEquals('medium', $analysisResponse->json('risk_level'));
    }

    /**
     * Test 2 : L'admin ne doit pas pouvoir soumettre de réponses
     */
    public function test_admin_cannot_submit_responses(): void
    {
        $answers = $this->questions->map(fn($q) => ['question_id' => $q->id, 'answer_value' => 'test'])->toArray();

        $response = $this->actingAs($this->admin, 'api')->postJson('/api/responses', [
            'answers' => $answers,
        ]);

        $response->assertStatus(403);
    }

    /**
     * Test 3 : Un utilisateur non connecté ne peut rien soumettre
     */
    public function test_unauthenticated_user_cannot_submit_responses(): void
    {
        $answers = $this->questions->map(fn($q) => ['question_id' => $q->id, 'answer_value' => 'test'])->toArray();
        
        $response = $this->postJson('/api/responses', [
            'answers' => $answers,
        ]);

        $response->assertStatus(401);
    }

    /**
     * Test 4 : L'employé peut voir son historique
     */
    public function test_employee_can_view_their_response_history(): void
    {
        // On crée une donnée d'abord
        $this->createAndAnalyzeResponse();

        $response = $this->actingAs($this->employee, 'api')->getJson('/api/responses/history');

        $response->assertStatus(200)
                 ->assertJsonStructure([
                     '*' => ['id', 'global_score', 'risk', 'created_at']
                 ]);
        
        $this->assertCount(1, $response->json());
    }

    /**
     * Test 5 : L'employé peut voir le détail d'une réponse
     */
    public function test_employee_can_view_a_specific_response_detail(): void
    {
        $this->createAndAnalyzeResponse();
        $createdResponseId = $this->employee->responses()->first()->id;

        $response = $this->actingAs($this->employee, 'api')->getJson("/api/responses/{$createdResponseId}");

        $response->assertStatus(200)
                 ->assertJsonStructure(['id', 'stress_score', 'recommendations', 'response_items']);
    }

    /**
     * Test 6 : Sécurité - Non authentifié sur l'historique
     */
    public function test_unauthenticated_user_cannot_view_response_history(): void
    {
        $response = $this->getJson('/api/responses/history');
        $response->assertStatus(401);
    }

    /**
     * Test 7 : Sécurité - Non authentifié sur le détail
     */
    public function test_unauthenticated_user_cannot_view_a_specific_response_detail(): void
    {
        $response = $this->getJson("/api/responses/999");
        $response->assertStatus(401);
    }

    /**
     * Test 8 : Confidentialité - Un employé ne voit pas les réponses d'un autre
     */
    public function test_employee_cannot_view_another_employees_response_detail(): void
    {
        // 1. L'employé principal crée une réponse
        $this->createAndAnalyzeResponse();
        $firstEmployeeResponseId = $this->employee->responses()->first()->id;

        // 2. On crée un DEUXIÈME employé (intrus)
        $anotherEmployee = User::factory()->create([
            'email' => 'intruder@example.com',
            'role' => 'employee'
        ]);
        
        // 3. Le deuxième essaie de voir la réponse du premier
        $response = $this->actingAs($anotherEmployee, 'api')->getJson("/api/responses/{$firstEmployeeResponseId}");

        $response->assertStatus(403);
    }
}
