<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Order;
use App\Models\Rating;
use App\Models\Tukang;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Routing\Controllers\HasMiddleware;
use Illuminate\Routing\Controllers\Middleware;
use Illuminate\Support\Facades\Validator;

class RatingController extends Controller implements HasMiddleware
{
    public static function middleware(): array
    {
        return [
            new Middleware('auth:api'),
        ];
    }

    public function store(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'tukang_id' => 'required|exists:tukang,id',
            'order_id' => 'required|exists:orders,id',
            'rating' => 'required|integer|min:1|max:5',
            'review' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors(),
            ], 422);
        }

        $order = Order::findOrFail($request->order_id);
        if ($order->status !== 'selesai') {
            return response()->json([
                'success' => false,
                'message' => 'Pesanan belum selesai',
            ], 400);
        }

        $rating = Rating::updateOrCreate(
            ['user_id' => auth()->id(), 'order_id' => $request->order_id],
            ['tukang_id' => $request->tukang_id, 'rating' => $request->rating, 'review' => $request->review]
        );

        $avgRating = Rating::where('tukang_id', $request->tukang_id)->avg('rating');
        Tukang::where('id', $request->tukang_id)->update(['rating' => $avgRating]);

        return response()->json([
            'success' => true,
            'message' => 'Rating berhasil dikirim',
            'data' => $rating,
        ], 201);
    }
}
