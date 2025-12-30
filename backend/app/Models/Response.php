<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Response extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'assessment_id',
        'stress_score',
        'motivation_score',
        'satisfaction_score',
        'global_score',
        'risk',
        'recommendations',
        'summary',
    ];

    protected $casts = [
        'recommendations' => 'array',
    ];


    public function assessment()
    {
        return $this->belongsTo(Assessment::class);
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function items()
    {
        return $this->hasMany(ResponseItem::class);
    }
}
