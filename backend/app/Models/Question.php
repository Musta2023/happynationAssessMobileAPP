<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Question extends Model
{
    use HasFactory;

    protected $fillable = [
        'question_text',
        'category',
        'type',
        'is_active',
    ];

    public function responseItems()
    {
        return $this->hasMany(ResponseItem::class);
    }

    public function assessments()
    {
        return $this->belongsToMany(Assessment::class);
    }
}
