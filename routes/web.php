<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\VedaController;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
*/

Route::get('/login', [\App\Http\Controllers\AuthController::class, 'showLogin'])->name('login');
Route::post('/login', [\App\Http\Controllers\AuthController::class, 'login']);
Route::post('/logout', [\App\Http\Controllers\AuthController::class, 'logout'])->name('logout');

Route::middleware(['auth'])->group(function () {
    Route::get('/', function () {
        return view('dashboard');
    });

    Route::get('/setup', [\App\Http\Controllers\SetupController::class, 'showWizard'])->middleware('admin');
    Route::post('/setup/complete', [\App\Http\Controllers\SetupController::class, 'completeSetup'])->middleware('admin');

    Route::get('/api/logs', [\App\Http\Controllers\LogController::class, 'getLogs']);
    Route::get('/api/stats', [\App\Http\Controllers\StatsController::class, 'getSystemStats']);
    Route::get('/api/files', [\App\Http\Controllers\FileController::class, 'listFiles']);
    Route::get('/api/file/read', [\App\Http\Controllers\FileController::class, 'readFile']);
    Route::get('/api/activity', [\App\Http\Controllers\LogController::class, 'getActivityLogs']);
    Route::post('/veda/process', [VedaController::class, 'processCommand']);

    Route::get('/marketplace', function () {
        return view('marketplace');
    });
});

require __DIR__ . '/api.php';
