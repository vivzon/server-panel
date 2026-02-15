<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Domain;
use App\Models\Client;
use Illuminate\Support\Facades\Process;
use App\Services\WebhookService;

class DeveloperApiController extends Controller
{
    /**
     * List all domains.
     */
    public function listDomains()
    {
        return response()->json([
            'status' => 'success',
            'data' => Domain::all()
        ]);
    }

    /**
     * Create a new domain via API.
     */
    public function createDomain(Request $request)
    {
        $request->validate([
            'domain' => 'required|string',
        ]);

        $domain = $request->input('domain');

        // Execute the same script VEDA uses
        $result = Process::run("/var/www/panel/scripts/shm-domain-add.sh $domain");

        if ($result->successful()) {
            Domain::create(['name' => $domain, 'status' => 'active']);

            WebhookService::dispatch('domain.created', [
                'domain' => $domain,
                'status' => 'success',
                'timestamp' => now()
            ]);

            return response()->json([
                'status' => 'success',
                'message' => "Domain $domain created successfully."
            ]);
        }

        return response()->json([
            'status' => 'error',
            'message' => "Failed to create domain."
        ], 500);
    }

    /**
     * Get system health stats via API.
     */
    public function systemStats()
    {
        $result = Process::run("/var/www/panel/scripts/shm-stats.sh");
        return response()->json([
            'status' => 'success',
            'data' => json_decode($result->output()) ?: $result->output()
        ]);
    }
}
