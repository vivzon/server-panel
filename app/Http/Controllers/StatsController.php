<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Process;

class StatsController extends Controller
{
    /**
     * Get system statistics.
     */
    public function getSystemStats()
    {
        $result = Process::run("/var/www/panel/scripts/shm-stats.sh");

        if ($result->successful()) {
            return response()->json([
                'status' => 'success',
                'data' => json_decode($result->output(), true)
            ]);
        }

        return response()->json([
            'status' => 'error',
            'message' => 'Failed to fetch system stats.'
        ]);
    }
}
