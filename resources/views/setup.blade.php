<!DOCTYPE html>
<html lang="en" class="dark">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SHM Panel - Setup Wizard</title>
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

        .gradient-bg {
            background: radial-gradient(circle at top left, #4f46e5, transparent), radial-gradient(circle at bottom right, #7c3aed, transparent);
        }
    </style>
</head>

<body class="bg-gray-950 text-gray-100 min-h-screen flex items-center justify-center p-6 gradient-bg">

    <div class="glass w-full max-w-lg rounded-3xl border border-gray-800 shadow-2xl overflow-hidden">
        <div class="p-8 text-center border-b border-gray-800">
            <div
                class="w-16 h-16 bg-indigo-600 rounded-2xl mx-auto flex items-center justify-center font-bold text-3xl mb-4">
                S</div>
            <h1 class="text-2xl font-bold tracking-tight">Welcome to SHM PANEL</h1>
            <p class="text-gray-400 mt-2">Let's configure your server for the first time.</p>
        </div>

        <div class="p-8 space-y-6">
            <div class="space-y-4">
                <div>
                    <label class="block text-sm font-medium text-gray-400 mb-2">Admin Email</label>
                    <input type="email" id="email"
                        class="w-full bg-gray-900 border border-gray-800 rounded-xl px-4 py-3 focus:ring-2 focus:ring-indigo-500 focus:outline-none transition-all">
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-400 mb-2">Admin Password</label>
                    <input type="password" id="password"
                        class="w-full bg-gray-900 border border-gray-800 rounded-xl px-4 py-3 focus:ring-2 focus:ring-indigo-500 focus:outline-none transition-all">
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-400 mb-2">Server Hostname</label>
                    <input type="text" id="hostname" placeholder="hvps.shm-panel.local"
                        class="w-full bg-gray-900 border border-gray-800 rounded-xl px-4 py-3 focus:ring-2 focus:ring-indigo-500 focus:outline-none transition-all">
                </div>
            </div>

            <button onclick="finishSetup()"
                class="w-full bg-indigo-600 hover:bg-indigo-500 py-3 rounded-xl font-bold text-lg transition-all shadow-lg hover:shadow-indigo-500/20 active:scale-[0.98]">
                Finish Installation
            </button>
        </div>

        <div class="px-8 py-4 bg-gray-900/50 flex justify-between items-center text-xs text-gray-500">
            <span>Powered by VEDA AI</span>
            <span>v1.0.0 Stable</span>
        </div>
    </div>

    <script>
        async function finishSetup() {
            const data = {
                admin_email: document.getElementById('email').value,
                admin_password: document.getElementById('password').value,
                hostname: document.getElementById('hostname').value
            };

            if (!data.admin_email || !data.admin_password || !data.hostname) {
                alert('Oye! Saare fields bharo.');
                return;
            }

            try {
                const response = await fetch('/setup/complete', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(data)
                });
                const resData = await response.json();
                if (resData.status === 'success') {
                    window.location.href = '/';
                }
            } catch (e) {
                alert('Setup failed. Check server logs.');
            }
        }
    </script>
</body>

</html>