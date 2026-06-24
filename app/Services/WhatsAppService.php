<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class WhatsAppService
{
    protected string $apiKey;
    protected string $baseUrl;

    public function __construct()
    {
        $this->apiKey = config('services.fonnte.api_key');
        $this->baseUrl = 'https://api.fonnte.com';
    }

    public function send(string $target, string $message): bool
    {
        if (empty($this->apiKey)) {
            Log::warning('FONNTE_API_KEY belum diatur. WA tidak terkirim.', ['target' => $target]);
            return false;
        }

        try {
            $response = Http::withHeaders([
                'Authorization' => $this->apiKey,
            ])->post("{$this->baseUrl}/send", [
                'target' => $target,
                'message' => $message,
                'countryCode' => '62',
            ]);

            if ($response->successful()) {
                Log::info('WA berhasil dikirim', ['target' => $target]);
                return true;
            }

            Log::error('Gagal kirim WA', ['response' => $response->body()]);
            return false;
        } catch (\Exception $e) {
            Log::error('Exception kirim WA: ' . $e->getMessage());
            return false;
        }
    }
}
