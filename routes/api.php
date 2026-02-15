<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\DeveloperApiController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
*/

Route::middleware('auth:sanctum')->prefix('v1')->group(function () {
    Route::get('/domains', [DeveloperApiController::class, 'listDomains']);
    Route::post('/domains', [DeveloperApiController::class, 'createDomain']);
    Route::get('/stats', [DeveloperApiController::class, 'systemStats']);
});
