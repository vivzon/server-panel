<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Hash;
use App\Models\User;

class SetupController extends Controller
{
    public function showWizard()
    {
        // If setup is already finished, redirect to dashboard
        if (File::exists(base_path('.setup_completed'))) {
            return redirect('/');
        }
        return view('setup');
    }

    public function completeSetup(Request $request)
    {
        $request->validate([
            'admin_email' => 'required|email',
            'admin_password' => 'required|min:8',
            'hostname' => 'required|string',
        ]);

        // 1. Create Admin User
        // User::create([...]) -> skipping DB logic for this mock implementation

        // 2. Set Hostname via script
        // Process::run("hostnamectl set-hostname " . $request->hostname);

        // 3. Mark setup as completed
        File::put(base_path('.setup_completed'), now());

        return response()->json(['status' => 'success', 'message' => 'Setup completed successfully!']);
    }
}
