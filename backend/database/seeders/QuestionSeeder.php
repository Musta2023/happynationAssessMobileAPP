<?php

namespace Database\Seeders;

use App\Models\Question;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class QuestionSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $questions = [
            // Stress
            [
                'question_text' => 'How often have you felt overwhelmed by your workload in the past month?',
                'category' => 'stress',
                'type' => 'likert',
            ],
            [
                'question_text' => 'Do you feel you have a healthy work-life balance?',
                'category' => 'stress',
                'type' => 'yes_no',
            ],
            [
                'question_text' => 'Describe a recent situation at work that you found stressful.',
                'category' => 'stress',
                'type' => 'text',
            ],
            // Motivation
            [
                'question_text' => 'How motivated do you feel to contribute to the company\'s goals?',
                'category' => 'motivation',
                'type' => 'likert',
            ],
            [
                'question_text' => 'Do you feel recognized and appreciated for your contributions?',
                'category' => 'motivation',
                'type' => 'yes_no',
            ],
            [
                'question_text' => 'What aspects of your job do you find most engaging?',
                'category' => 'motivation',
                'type' => 'text',
            ],
            // Satisfaction
            [
                'question_text' => 'Overall, how satisfied are you with your current role?',
                'category' => 'satisfaction',
                'type' => 'likert',
            ],
            [
                'question_text' => 'Are you satisfied with your opportunities for professional growth?',
                'category' => 'satisfaction',
                'type' => 'yes_no',
            ],
            [
                'question_text' => 'How satisfied are you with the team collaboration and communication?',
                'category' => 'satisfaction',
                'type' => 'likert',
            ],
            [
                'question_text' => 'What would improve your overall job satisfaction?',
                'category' => 'satisfaction',
                'type' => 'text',
            ],
        ];

        foreach ($questions as $question) {
            Question::create($question);
        }
    }
}
