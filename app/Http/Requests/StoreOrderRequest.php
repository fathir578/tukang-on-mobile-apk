<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreOrderRequest extends FormRequest
{
    public function authorize(): bool { return true; }
    public function rules(): array
    {
        return [
            'tukang_id' => 'required|exists:tukang,id',
            'deskripsi' => 'required|string',
            'alamat' => 'required|string',
        ];
    }
}
