<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;

class Assessment extends Model
{
    use HasFactory;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'title',
        'description',
    ];

    /**
     * The accessors to append to the model's array form.
     *
     * @var array
     */
    protected $appends = ['question_ids'];

    /**
     * The questions that belong to the assessment.
     */
    public function questions(): BelongsToMany
    {
        return $this->belongsToMany(Question::class, 'assessment_question', 'assessment_id', 'question_id');
    }

    /**
     * The responses for the assessment.
     */
    public function responses()
    {
        return $this->hasMany(Response::class);
    }

    /**
     * Get the question IDs for the assessment.
     *
     * @return array
     */
    public function getQuestionIdsAttribute(): array
    {
        if (!$this->relationLoaded('questions')) {
            return [];
        }
        return $this->questions->pluck('id')->map(fn($id) => (string) $id)->toArray();
    }
}
