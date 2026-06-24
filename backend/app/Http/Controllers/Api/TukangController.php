<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Tukang;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Routing\Controllers\HasMiddleware;
use Illuminate\Routing\Controllers\Middleware;
use Illuminate\Support\Facades\Validator;

class TukangController extends Controller implements HasMiddleware
{
    public static function middleware(): array
    {
        return [
            new Middleware('auth:api', except: ['index', 'show']),
        ];
    }

    public function index(Request $request): JsonResponse
    {
        $query = Tukang::query();

        if ($request->search) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('name', 'like', "%{$search}%")
                  ->orWhere('keahlian', 'like', "%{$search}%")
                  ->orWhere('alamat', 'like', "%{$search}%");
            });
        }

        if ($request->keahlian) {
            $query->where('keahlian', 'like', "%{$request->keahlian}%");
        }

        $tukang = $query->where('status', 'aktif')
            ->orderBy('rating', 'desc')
            ->paginate($request->per_page ?? 15);

        return response()->json([
            'success' => true,
            'data' => $tukang->items(),
            'pagination' => [
                'current_page' => $tukang->currentPage(),
                'last_page' => $tukang->lastPage(),
                'per_page' => $tukang->perPage(),
                'total' => $tukang->total(),
            ],
        ]);
    }

    public function show(int $id): JsonResponse
    {
        $tukang = Tukang::with('ratings')->findOrFail($id);
        return response()->json([
            'success' => true,
            'data' => $tukang,
        ]);
    }

    public function store(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'email' => 'nullable|email|unique:tukang',
            'phone' => 'nullable|string|max:20',
            'alamat' => 'nullable|string',
            'keahlian' => 'nullable|string|max:255',
            'foto' => 'nullable|string',
            'deskripsi' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors(),
            ], 422);
        }

        $data = $validator->validated();
        $data['user_id'] = auth()->id();
        $tukang = Tukang::create($data);

        return response()->json([
            'success' => true,
            'message' => 'Tukang berhasil ditambahkan',
            'data' => $tukang,
        ], 201);
    }

    public function update(Request $request, int $id): JsonResponse
    {
        $tukang = Tukang::findOrFail($id);

        $validator = Validator::make($request->all(), [
            'name' => 'sometimes|string|max:255',
            'email' => 'nullable|email|unique:tukang,email,' . $id,
            'phone' => 'nullable|string|max:20',
            'alamat' => 'nullable|string',
            'keahlian' => 'nullable|string|max:255',
            'foto' => 'nullable|string',
            'deskripsi' => 'nullable|string',
            'status' => 'sometimes|in:aktif,nonaktif',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors(),
            ], 422);
        }

        $tukang->update($validator->validated());

        return response()->json([
            'success' => true,
            'message' => 'Tukang berhasil diperbarui',
            'data' => $tukang,
        ]);
    }

    public function destroy(int $id): JsonResponse
    {
        $tukang = Tukang::findOrFail($id);
        $tukang->delete();

        return response()->json([
            'success' => true,
            'message' => 'Tukang berhasil dihapus',
        ]);
    }
}
