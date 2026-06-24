<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Order;
use App\Models\Tukang;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Routing\Controllers\HasMiddleware;
use Illuminate\Routing\Controllers\Middleware;

class DashboardController extends Controller implements HasMiddleware
{
    public static function middleware(): array
    {
        return [
            new Middleware('auth:api'),
        ];
    }

    public function index(): JsonResponse
    {
        if (!auth()->user()->isAdmin()) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized',
            ], 403);
        }

        $totalTukang = Tukang::count();
        $totalUser = User::where('role', 'user')->count();
        $totalTukangAktif = Tukang::where('status', 'aktif')->count();
        $totalOrder = Order::count();
        $totalOrderSelesai = Order::where('status', 'selesai')->count();
        $totalOrderMenunggu = Order::where('status', 'menunggu')->count();
        $recentOrders = Order::with(['user', 'tukang'])
            ->orderBy('created_at', 'desc')
            ->take(5)
            ->get();
        $recentTukang = Tukang::orderBy('created_at', 'desc')->take(5)->get();

        return response()->json([
            'success' => true,
            'data' => [
                'total_tukang' => $totalTukang,
                'total_user' => $totalUser,
                'total_tukang_aktif' => $totalTukangAktif,
                'total_order' => $totalOrder,
                'total_order_selesai' => $totalOrderSelesai,
                'total_order_menunggu' => $totalOrderMenunggu,
                'recent_orders' => $recentOrders,
                'recent_tukang' => $recentTukang,
            ],
        ]);
    }
}
