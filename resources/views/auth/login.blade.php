<!DOCTYPE html>
<html lang="en" class="dark">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SHM Panel - Login</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
        }

        .glass {
            background: rgba(30, 41, 59, 0.7);
            backdrop-filter: blur(12px);
        }
    </style>
</head>

<body class="bg-gray-900 text-gray-100 min-h-screen flex items-center justify-center p-6">
    <div class="w-full max-w-md glass border border-gray-800 p-8 rounded-3xl shadow-2xl">
        <div class="flex flex-col items-center mb-8">
            <div class="w-16 h-16 bg-indigo-600 rounded-2xl flex items-center justify-center font-bold text-3xl mb-4">S
            </div>
            <h1 class="text-2xl font-bold tracking-tight text-white">SHM <span class="text-indigo-400">PANEL</span></h1>
            <p class="text-gray-400 text-sm mt-2">Pranaam! Login to manage your server.</p>
        </div>

        <form action="/login" method="POST" class="space-y-6">
            @csrf
            <div>
                <label class="block text-xs font-bold text-gray-400 uppercase tracking-widest mb-2">Email
                    Address</label>
                <input type="email" name="email" required
                    class="w-full bg-gray-800 border border-gray-700 rounded-xl px-4 py-3 focus:ring-2 focus:ring-indigo-500 focus:outline-none transition-all">
                @error('email')
                    <p class="text-red-400 text-xs mt-1">{{ $message }}</p>
                @enderror
            </div>

            <div>
                <label class="block text-xs font-bold text-gray-400 uppercase tracking-widest mb-2">Password</label>
                <input type="password" name="password" required
                    class="w-full bg-gray-800 border border-gray-700 rounded-xl px-4 py-3 focus:ring-2 focus:ring-indigo-500 focus:outline-none transition-all">
            </div>

            <button type="submit"
                class="w-full bg-indigo-600 hover:bg-indigo-500 text-white font-bold py-3 rounded-xl transition-all shadow-lg">
                Enter Dashboard
            </button>
        </form>

        <div class="mt-8 pt-6 border-t border-gray-800 text-center">
            <p class="text-gray-500 text-xs tracking-wide">SHM Panel Security Framework v1.0</p>
        </div>
    </div>
</body>

</html>