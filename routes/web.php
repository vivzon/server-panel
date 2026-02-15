<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\VedaController;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
*/

Route::get('/', function () {
    return view('dashboard');
});

Route::get('/setup', [\App\Http\Controllers\SetupController::class, 'showWizard']);
Route::post('/setup/complete', [\App\Http\Controllers\SetupController::class, 'completeSetup']);

Route::get('/api/logs', [\App\Http\Controllers\LogController::class, 'getLogs']);
Route::get('/api/stats', [\App\Http\Controllers\StatsController::class, 'getSystemStats']);
Route::get('/api/files', [\App\Http\Controllers\FileController::class, 'listFiles']);
Route::get('/api/file/read', [\App\Http\Controllers\FileController::class, 'readFile']);
Route::post('/veda/process', [VedaController::class, 'processCommand']);
