<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Process;

class LogController extends Controller
{
    /**
     * Safely fetch the last N lines of a system log.
     */
    public function getLogs(Request $request)
    {
        $logType = $request->query('type', 'nginx');
        $lines = $request->query('lines', 50);

        $logPaths = [
            'nginx' => '/var/log/nginx/access.log',
            'mysql' => '/var/log/mysql/error.log',
            'panel' => storage_path('logs/laravel.log'),
            'auth' => '/var/log/auth.log',
        ];

        if (!isset($logPaths[$logType])) {
            return response()->json(['status' => 'error', 'message' => 'Lota! Log type invalid hai.']);
        }

        $path = $logPaths[$logType];

        // Execute tail safely
        $result = Process::run("tail -n $lines $path");

        return response()->json([
            'status' => 'success',
            'data' => $result->output() ?: "No logs found or permission denied.",
        ]);
    }
}
