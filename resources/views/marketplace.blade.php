<!DOCTYPE html>
<html lang="en" class="dark">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SHM Panel - Marketplace</title>
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

<body class="bg-gray-900 text-gray-100 min-h-screen flex flex-col">
    <!-- Header -->
    <header class="glass border-b border-gray-800 p-4 flex justify-between items-center sticky top-0 z-50">
        <div class="flex items-center gap-3">
            <div class="w-10 h-10 bg-indigo-600 rounded-lg flex items-center justify-center font-bold text-xl cursor-pointer"
                onclick="location.href='/'">S</div>
            <h1 class="text-xl font-bold tracking-tight">SHM <span class="text-indigo-400">MARKETPLACE</span></h1>
        </div>
        <div class="flex items-center gap-4">
            <span class="text-sm text-gray-400">v1.0 Ready</span>
            <div class="w-2 h-2 bg-green-500 rounded-full animate-pulse"></div>
        </div>
    </header>

    <main class="flex-1 p-8 overflow-y-auto">
        <div class="max-w-7xl mx-auto">
            <div class="mb-10">
                <h2 class="text-3xl font-bold mb-2">One-Click Installations</h2>
                <p class="text-gray-400">Select an application to deploy on your server instantly via VEDA.</p>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                <!-- WordPress -->
                <div
                    class="glass p-6 rounded-3xl border border-gray-800 hover:border-indigo-500 transition-all flex flex-col gap-4">
                    <div class="flex items-center gap-4">
                        <div
                            class="w-12 h-12 bg-blue-500/20 text-blue-500 rounded-xl flex items-center justify-center font-bold text-2xl">
                            W</div>
                        <h3 class="text-xl font-bold">WordPress</h3>
                    </div>
                    <p class="text-gray-400 text-sm">Deploy the world's most popular CMS with full database and Nginx
                        config.</p>
                    <button onclick="installApp('WordPress')"
                        class="mt-auto bg-indigo-600 hover:bg-indigo-500 py-3 rounded-xl font-bold transition-all">Install
                        Ready</button>
                </div>

                <!-- Node.js -->
                <div
                    class="glass p-6 rounded-3xl border border-gray-800 hover:border-green-500 transition-all flex flex-col gap-4">
                    <div class="flex items-center gap-4">
                        <div
                            class="w-12 h-12 bg-green-500/20 text-green-500 rounded-xl flex items-center justify-center font-bold text-2xl">
                            JS</div>
                        <h3 class="text-xl font-bold">Node.js / PM2</h3>
                    </div>
                    <p class="text-gray-400 text-sm">Deploy JavaScript applications with PM2 process management.</p>
                    <button onclick="installApp('Node.js')"
                        class="mt-auto bg-indigo-600 hover:bg-indigo-500 py-3 rounded-xl font-bold transition-all">Install
                        Ready</button>
                </div>

                <!-- Laravel -->
                <div
                    class="glass p-6 rounded-3xl border border-gray-800 hover:border-red-500 transition-all flex flex-col gap-4">
                    <div class="flex items-center gap-4">
                        <div
                            class="w-12 h-12 bg-red-500/20 text-red-500 rounded-xl flex items-center justify-center font-bold text-2xl">
                            L</div>
                        <h3 class="text-xl font-bold">Laravel</h3>
                    </div>
                    <p class="text-gray-400 text-sm">The PHP Framework for Web Artisans. Full deployment including
                        Composer.</p>
                    <button onclick="installApp('Laravel')"
                        class="mt-auto bg-indigo-600 hover:bg-indigo-500 py-3 rounded-xl font-bold transition-all">Install
                        Ready</button>
                </div>
            </div>
        </div>
    </main>

    <script>
        function installApp(app) {
            alert(`Suno VEDA! Please use the following command in the main dashboard: \n\n ${app === 'WordPress' ? 'wordpress install karo example.com' : 'nodejs install karo example.com myapp'}`);
            location.href = '/';
        }
    </script>
</body>

</html>