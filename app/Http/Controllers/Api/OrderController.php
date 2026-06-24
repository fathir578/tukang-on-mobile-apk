<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Order;
use App\Models\Tukang;
use App\Services\WhatsAppService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Routing\Controllers\HasMiddleware;
use Illuminate\Routing\Controllers\Middleware;
use Illuminate\Support\Facades\Validator;

class OrderController extends Controller implements HasMiddleware
{
    protected WhatsAppService $waService;

    public static function middleware(): array
    {
        return [
            new Middleware('auth:api'),
        ];
    }

    public function __construct(WhatsAppService $waService)
    {
        $this->waService = $waService;
    }

    public function index(Request $request): JsonResponse
    {
        $user = auth()->user();
        $query = Order::with(['tukang', 'user', 'rating']);

        if ($user->isAdmin()) {
            // admin liat semua
        } elseif ($user->isTukang()) {
            $tukang = Tukang::where('user_id', $user->id)->first();
            if ($tukang) {
                $query->where('tukang_id', $tukang->id);
            }
        } else {
            $query->where('user_id', $user->id);
        }

        $orders = $query->orderBy('created_at', 'desc')
            ->paginate($request->per_page ?? 15);

        return response()->json([
            'success' => true,
            'data' => $orders->items(),
            'pagination' => [
                'current_page' => $orders->currentPage(),
                'last_page' => $orders->lastPage(),
                'per_page' => $orders->perPage(),
                'total' => $orders->total(),
            ],
        ]);
    }

    public function store(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'tukang_id' => 'required|exists:tukang,id',
            'deskripsi' => 'required|string',
            'alamat' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors(),
            ], 422);
        }

        $order = Order::create([
            'user_id' => auth()->id(),
            'tukang_id' => $request->tukang_id,
            'deskripsi' => $request->deskripsi,
            'alamat' => $request->alamat,
            'status' => 'menunggu',
        ]);

        $order->load(['user', 'tukang']);

        $this->sendOrderNotification($order);

        return response()->json([
            'success' => true,
            'message' => 'Pesanan berhasil dibuat',
            'data' => $order,
        ], 201);
    }

    public function show(int $id): JsonResponse
    {
        $order = Order::with(['tukang', 'user', 'rating'])->findOrFail($id);
        return response()->json([
            'success' => true,
            'data' => $order,
        ]);
    }

    public function process(int $id): JsonResponse
    {
        $order = Order::findOrFail($id);
        $order->update([
            'status' => 'diproses',
            'diproses_at' => now(),
        ]);

        $order->load(['user', 'tukang']);
        $this->sendStatusNotification($order, 'diproses');

        return response()->json([
            'success' => true,
            'message' => 'Pesanan sedang diproses',
            'data' => $order,
        ]);
    }

    public function complete(int $id): JsonResponse
    {
        $order = Order::findOrFail($id);
        $order->update([
            'status' => 'selesai',
            'selesai_at' => now(),
        ]);

        $order->load(['user', 'tukang']);
        $this->sendStatusNotification($order, 'selesai');

        return response()->json([
            'success' => true,
            'message' => 'Pesanan selesai',
            'data' => $order,
        ]);
    }

    public function cancel(int $id): JsonResponse
    {
        $order = Order::findOrFail($id);
        $order->update(['status' => 'dibatalkan']);

        return response()->json([
            'success' => true,
            'message' => 'Pesanan dibatalkan',
            'data' => $order,
        ]);
    }

    protected function sendOrderNotification(Order $order): void
    {
        $noWa = $order->tukang->phone;
        if (!$noWa) return;

        $pesan = "🔔 *Pesanan Baru!*\n\n"
            . "Nama: {$order->user->name}\n"
            . "Alamat: {$order->alamat}\n"
            . "Deskripsi: {$order->deskripsi}\n\n"
            . "Silakan cek aplikasi untuk detail.";

        $this->waService->send($noWa, $pesan);
    }

    protected function sendStatusNotification(Order $order, string $status): void
    {
        $noWa = $order->user->phone;
        if (!$noWa) return;

        $label = $status === 'diproses' ? 'Sedang Diproses' : 'Selesai';
        $pesan = "✅ *Pesanan {$label}!*\n\n"
            . "Tukang: {$order->tukang->name}\n"
            . "Status: {$label}\n\n"
            . "Terima kasih telah menggunakan tukang-on.";

        $this->waService->send($noWa, $pesan);
    }
}
