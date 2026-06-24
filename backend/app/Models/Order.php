<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Order extends Model
{
    protected $fillable = [
        'user_id', 'tukang_id', 'deskripsi', 'alamat',
        'status', 'diproses_at', 'selesai_at',
    ];

    protected function casts(): array
    {
        return [
            'diproses_at' => 'datetime',
            'selesai_at' => 'datetime',
        ];
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function tukang()
    {
        return $this->belongsTo(Tukang::class);
    }

    public function rating()
    {
        return $this->hasOne(Rating::class);
    }
}
