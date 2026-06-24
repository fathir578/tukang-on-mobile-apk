<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreTukangRequest extends FormRequest
{
    public function authorize(): bool { return true; }
    public function rules(): array
    {
        return [
            'name' => 'required|string|max:255',
            'email' => 'nullable|email|unique:tukang',
            'phone' => 'nullable|string|max:20',
            'keahlian' => 'nullable|string|max:255',
            'deskripsi' => 'nullable|string',
        ];
    }
}
