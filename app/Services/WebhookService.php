<?php

namespace App\Services;

use App\Models\Webhook;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class WebhookService
{
    /**
     * Dispatch a webhook event.
     */
    public static function dispatch(string $event, array $data)
    {
        $webhooks = Webhook::where('event', $event)
            ->where('is_active', true)
            ->get();

        foreach ($webhooks as $webhook) {
            try {
                Http::withHeaders([
                    'X-SHM-Event' => $event,
                    'X-SHM-Signature' => self::generateSignature($webhook->secret, $data),
                ])->post($webhook->url, $data);

                Log::info("Webhook sent to {$webhook->url} for event {$event}");
            } catch (\Exception $e) {
                Log::error("Webhook failed for {$webhook->url}: " . $e->getMessage());
            }
        }
    }

    /**
     * Generate HMAC signature for payload.
     */
    protected static function generateSignature($secret, $data)
    {
        if (!$secret)
            return '';
        return hash_hmac('sha256', json_encode($data), $secret);
    }
}
