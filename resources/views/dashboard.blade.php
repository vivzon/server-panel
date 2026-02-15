<!DOCTYPE html>
<html lang="en" class="dark">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SHM Panel - Dashboard</title>
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
            <div class="w-10 h-10 bg-indigo-600 rounded-lg flex items-center justify-center font-bold text-xl">S</div>
            <h1 class="text-xl font-bold tracking-tight">SHM <span class="text-indigo-400">PANEL</span></h1>
        </div>
        <div class="flex items-center gap-4">
            <span class="text-sm text-gray-400">Ubuntu 22.04 LTS</span>
            <div class="w-2 h-2 bg-green-500 rounded-full animate-pulse"></div>
        </div>
    </header>

    <main class="flex-1 flex overflow-hidden">
        <!-- Sidebar -->
        <aside class="w-64 glass border-r border-gray-800 hidden md:flex flex-col p-4 gap-2">
            <a href="/" class="p-3 bg-indigo-600/20 text-indigo-400 rounded-lg font-medium transition-all">Dashboard</a>
            <a href="/marketplace" class="p-3 hover:bg-gray-800 rounded-lg transition-all flex items-center gap-2">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z" />
                </svg>
                Marketplace
            </a>
            <a href="#" class="p-3 hover:bg-gray-800 rounded-lg transition-all">Domains</a>
            <a href="#" class="p-3 hover:bg-gray-800 rounded-lg transition-all">Databases</a>
            <a href="#" class="p-3 hover:bg-gray-800 rounded-lg transition-all">Email Accounts</a>

            <div class="mt-auto border-t border-gray-800 pt-4">
                <form action="/logout" method="POST" id="logout-form">
                    @csrf
                    <button type="submit"
                        class="w-full text-left p-3 text-red-400 hover:bg-red-400/10 rounded-lg transition-all flex items-center gap-2">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path
                                d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
                        </svg>
                        Logout
                    </button>
                </form>
            </div>
        </aside>

        <!-- Main Content -->
        <section class="flex-1 overflow-y-auto p-6 md:p-8">
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
                <!-- Stats -->
                <div class="glass p-6 rounded-2xl border border-gray-800 shadow-xl">
                    <p class="text-sm text-gray-400 uppercase tracking-widest mb-1">CPU Usage</p>
                    <h3 id="cpu-val" class="text-3xl font-bold">--%</h3>
                    <div class="w-full bg-gray-800 h-1.5 mt-3 rounded-full overflow-hidden">
                        <div id="cpu-bar" class="bg-indigo-500 h-full w-0 transition-all duration-500"></div>
                    </div>
                </div>
                <div class="glass p-6 rounded-2xl border border-gray-800 shadow-xl">
                    <p class="text-sm text-gray-400 uppercase tracking-widest mb-1">RAM</p>
                    <h3 id="mem-val" class="text-3xl font-bold">-- GB <span class="text-lg font-normal text-gray-500">/
                            -- GB</span>
                    </h3>
                    <div class="w-full bg-gray-800 h-1.5 mt-3 rounded-full overflow-hidden">
                        <div id="mem-bar" class="bg-indigo-500 h-full w-0 transition-all duration-500"></div>
                    </div>
                </div>
                <div class="glass p-6 rounded-2xl border border-gray-800 shadow-xl">
                    <p class="text-sm text-gray-400 uppercase tracking-widest mb-1">Disk</p>
                    <h3 id="disk-val" class="text-3xl font-bold">--%</h3>
                    <div class="w-full bg-gray-800 h-1.5 mt-3 rounded-full overflow-hidden">
                        <div id="disk-bar" class="bg-indigo-500 h-full w-0 transition-all duration-500"></div>
                    </div>
                </div>
            </div>

            <!-- Console & Activity -->
            <div class="grid grid-cols-1 lg:grid-cols-4 gap-8">
                <div class="lg:col-span-3">
                    <!-- VEDA Console -->
                    <div class="glass rounded-2xl border border-gray-800 shadow-2xl flex flex-col h-[600px]">
                        <div class="p-4 border-b border-gray-800 flex items-center justify-between">
                            <div class="flex items-center gap-3">
                                <div
                                    class="w-8 h-8 bg-indigo-500/20 text-indigo-400 rounded-full flex items-center justify-center">
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path d="M13 10V3L4 14h7v7l9-11h-7z" />
                                    </svg>
                                </div>
                                <h2 class="font-bold">VEDA AI <span
                                        class="text-xs font-normal text-gray-500 ml-2">v1.1</span>
                                    <span id="uptime-display" class="ml-4 text-xs font-normal text-gray-400"></span>
                                </h2>
                            </div>
                            <div class="flex gap-2">
                                <span
                                    class="px-2 py-1 bg-green-500/10 text-green-500 text-[10px] uppercase font-bold rounded">Audit
                                    Logging Enabled</span>
                            </div>
                        </div>

                        <div id="veda-chat" class="flex-1 p-6 overflow-y-auto space-y-4 font-mono text-sm">
                            <div class="flex flex-col gap-1">
                                <span class="text-indigo-400 font-bold">VEDA:</span>
                                <p class="text-gray-300">Namaste! Main VEDA hoon. Aaj Kya audit karein?</p>
                            </div>
                        </div>

                        <div class="p-4 bg-gray-900/50 border-t border-gray-800">
                            <div class="relative">
                                <input type="text" id="veda-input" placeholder="Type a command..."
                                    class="w-full bg-gray-800 border border-gray-700 rounded-xl px-4 py-3 pr-24 focus:ring-2 focus:ring-indigo-500 focus:outline-none transition-all">
                                <button onclick="sendCommand()"
                                    class="absolute right-2 top-2 bottom-2 px-4 bg-indigo-600 hover:bg-indigo-500 rounded-lg font-medium transition-all text-sm">Suno
                                    VEDA</button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="lg:col-span-1">
                    <!-- Activity Timeline -->
                    <div class="glass rounded-2xl border border-gray-800 shadow-2xl flex flex-col h-[600px]">
                        <div class="p-4 border-b border-gray-800">
                            <h2 class="font-bold flex items-center gap-2">
                                <svg class="w-4 h-4 text-gray-400" fill="none" stroke="currentColor"
                                    viewBox="0 0 24 24">
                                    <path d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                                </svg>
                                Recent Activity
                            </h2>
                        </div>
                        <div id="activity-timeline" class="flex-1 p-4 overflow-y-auto space-y-6 scrollbar-hide">
                            <p class="text-xs text-gray-500 text-center py-10 italic">No recent activity tracked.</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <script>
        async function updateActivity() {
            try {
                const response = await fetch('/api/activity');
                const result = await response.json();
                if (result.status === 'success') {
                    const timeline = document.getElementById('activity-timeline');
                    if (result.data.length === 0) return;

                    timeline.innerHTML = result.data.map(log => `
                        <div class="relative pl-6 border-l border-gray-800">
                            <div class="absolute -left-1.5 top-1 w-3 h-3 rounded-full ${log.status === 'success' ? 'bg-green-500' : 'bg-red-500'} border-2 border-gray-900"></div>
                            <div class="flex flex-col">
                                <span class="text-[10px] text-gray-500 font-bold uppercase tracking-wider">${new Date(log.created_at).toLocaleTimeString()}</span>
                                <p class="text-sm font-medium ${log.status === 'success' ? 'text-gray-200' : 'text-red-400'}">${log.intent || 'Command'}</p>
                                <p class="text-xs text-gray-500 line-clamp-1 italic">${log.command}</p>
                            </div>
                        </div>
                    `).join('');
                }
            } catch (e) { console.error("Activity fetch failed"); }
        }

        async function updateStats() {
            try {
                const response = await fetch('/api/stats');
                const result = await response.json();
                if (result.status === 'success') {
                    const stats = result.data;
                    document.getElementById('cpu-val').innerText = stats.cpu + '%';
                    document.getElementById('cpu-bar').style.width = stats.cpu + '%';

                    document.getElementById('mem-val').innerHTML = Math.round(stats.mem_used / 1024 * 10) / 10 + ' GB <span class="text-lg font-normal text-gray-500"> / ' + Math.round(stats.mem_total / 1024) + ' GB</span>';
                    document.getElementById('mem-bar').style.width = stats.mem + '%';

                    document.getElementById('disk-val').innerText = stats.disk + '%';
                    document.getElementById('disk-bar').style.width = stats.disk + '%';

                    document.getElementById('uptime-display').innerText = 'Uptime: ' + stats.uptime;
                }
            } catch (e) { console.error("Stats fetch failed"); }
        }

        setInterval(updateStats, 5000);
        setInterval(updateActivity, 8000);
        updateStats();
        updateActivity();

        async function sendCommand() {
            const input = document.getElementById('veda-input');
            const chat = document.getElementById('veda-chat');
            const command = input.value;
            if (!command) return;

            // Add user message
            chat.innerHTML += `<div class="flex flex-col gap-1 text-right"><span class="text-gray-500 font-bold">Aap:</span><p>${command}</p></div>`;
            input.value = '';

            try {
                const response = await fetch('/veda/process', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json', 'X-CSRF-TOKEN': 'mock-token' },
                    body: JSON.stringify({ command })
                });
                const data = await response.json();

                chat.innerHTML += `<div class="flex flex-col gap-1"><span class="text-indigo-400 font-bold">VEDA:</span><p class="${data.status === 'success' ? 'text-green-400' : 'text-red-400'}">${data.message}</p></div>`;
                if (data.output) {
                    chat.innerHTML += `<div class="bg-black/40 p-3 rounded-lg text-xs text-gray-500 whitespace-pre-wrap">${data.output}</div>`;
                }
            } catch (e) {
                chat.innerHTML += `<div class="flex flex-col gap-1"><span class="text-indigo-400 font-bold">VEDA:</span><p class="text-red-400">Network error. Is the panel running?</p></div>`;
            }
            chat.scrollTop = chat.scrollHeight;
        }
    </script>
</body>

</html>