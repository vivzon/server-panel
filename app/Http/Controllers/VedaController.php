<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Process;
use Illuminate\Support\Facades\Log;

class VedaController extends Controller
{
    /**
     * Whitelist of safe commands and their regex patterns.
     */
    protected $patterns = [
        'domain_add' => '/(?:domain add karo|add domain) ([\w\.-]+)/i',
        'ssl_install' => '/(?:ssl lagao|install ssl)/i',
        'mysql_restart' => '/(?:mysql restart|restart mysql)/i',
        'db_create' => '/(?:database banao|create database) ([\w_-]+)/i',
        'email_create' => '/(?:email banao|create email) ([\w@\.-]+)/i',
        'backup' => '/(?:backup lelo|take backup|full backup)/i',
        'logs' => '/(?:logs dikhao|show logs) (\w+)/i',
        'firewall_status' => '/(?:firewall status|firewall dikhao)/i',
        'firewall_allow' => '/(?:port allow karo|allow port) (\d+)/i',
        'firewall_deny' => '/(?:port block karo|deny port) (\d+)/i',
        'app_wp' => '/(?:wordpress install karo|install wordpress) ([\w\.-]+)/i',
        'system_health' => '/(?:health check|system health|server status)/i',
        'mail_setup' => '/(?:mail server setup karo|setup mail server)/i',
        'client_add' => '/(?:client banao|add client) ([\w_-]+)/i',
        'security_audit' => '/(?:security audit|check security|jail status)/i',
        'jail_setup' => '/(?:fail2ban setup karo|install jail)/i',
        'list_files' => '/(?:files dikhao|list files) ([\w_-]+)/i',
        'quota_check' => '/(?:quota check|check quota) ([\w_-]+)/i',
        'self_heal' => '/(?:self heal|fix system|auto fix)/i',
        'nodejs_install' => '/(?:nodejs install karo|install nodejs) ([\w\.-]+) (\w+)/i',
        'laravel_deploy' => '/(?:laravel install karo|deploy laravel) ([\w\.-]+)/i',
        'system_audit' => '/(?:system audit|full audit|check system security)/i',
        'cloud_backup' => '/(?:cloud backup|backup to cloud) ([\w_-]+)/i',
        'client_report' => '/(?:client report|resource report) ([\w_-]+)?/i',
    ];

    /**
     * Map intent to bash script.
     */
    public function processCommand(Request $request)
    {
        $input = $request->input('command');
        Log::info("VEDA received command: " . $input);

        // SECURITY GUARD: Prohibit destructive commands
        $destructive = ['rm ', 'rm -rf', 'format ', 'shutdown', 'reboot', 'mkfs', 'dd '];
        foreach ($destructive as $danger) {
            if (stripos($input, $danger) !== false) {
                return response()->json([
                    'status' => 'critical',
                    'message' => 'Action Prohibited: VEDA does not allow destructive system commands like ' . trim($danger) . '.'
                ]);
            }
        }

        foreach ($this->patterns as $intent => $pattern) {
            if (preg_match($pattern, $input, $matches)) {
                return $this->executeIntent($intent, $matches);
            }
        }

        return response()->json([
            'status' => 'error',
            'message' => 'VEDA: Sumajh nahi aaya. Please try again with a safe command.'
        ]);
    }

    protected function executeIntent($intent, $matches)
    {
        switch ($intent) {
            case 'domain_add':
                $domain = $matches[1];
                if (!filter_var($domain, FILTER_VALIDATE_DOMAIN, FILTER_FLAG_HOSTNAME)) {
                    return response()->json(['status' => 'error', 'message' => 'Invalid domain format.']);
                }
                $result = Process::run("/var/www/panel/scripts/shm-domain-add.sh $domain");
                break;

            case 'ssl_install':
                $result = Process::run("certbot --nginx --non-interactive --agree-tos -m admin@shm-panel.local");
                break;

            case 'mysql_restart':
                $result = Process::run("systemctl restart mariadb");
                break;

            case 'db_create':
                $dbname = $matches[1];
                $dbuser = $dbname . "_user";
                $dbpass = bin2hex(random_bytes(8));
                $result = Process::run("/var/www/panel/scripts/shm-db-add.sh $dbname $dbuser $dbpass");
                break;

            case 'email_create':
                $email = $matches[1];
                $password = bin2hex(random_bytes(8));
                $result = Process::run("/var/www/panel/scripts/shm-mail-add.sh $email $password");
                break;

            case 'backup':
                $result = Process::run("/var/www/panel/scripts/shm-backup.sh");
                break;

            case 'logs':
                $type = $matches[1];
                $result = Process::run("tail -n 20 /var/log/$type/access.log");
                break;

            case 'firewall_status':
                $result = Process::run("/var/www/panel/scripts/shm-firewall.sh status");
                break;

            case 'firewall_allow':
                $port = $matches[1];
                $result = Process::run("/var/www/panel/scripts/shm-firewall.sh allow $port");
                break;

            case 'firewall_deny':
                $port = $matches[1];
                $result = Process::run("/var/www/panel/scripts/shm-firewall.sh deny $port");
                break;

            case 'app_wp':
                $domain = $matches[1];
                $result = Process::run("/var/www/panel/scripts/shm-app-wp.sh $domain");
                break;

            case 'system_health':
                $result = Process::run("/var/www/panel/scripts/shm-stats.sh");
                break;

            case 'mail_setup':
                $result = Process::run("/var/www/panel/scripts/shm-mail-setup.sh");
                break;

            case 'client_add':
                $client = $matches[1];
                $result = Process::run("/var/www/panel/scripts/shm-client-add.sh $client");
                break;

            case 'security_audit':
                $result = Process::run("/var/www/panel/scripts/shm-jail.sh status");
                break;

            case 'jail_setup':
                $result = Process::run("/var/www/panel/scripts/shm-jail.sh");
                break;

            case 'list_files':
                $client = $matches[1];
                $result = Process::run("ls -lh /var/www/clients/$client/public_html");
                break;

            case 'quota_check':
                $client = $matches[1];
                $result = Process::run("/var/www/panel/scripts/shm-quota.sh status $client");
                break;

            case 'self_heal':
                $result = Process::run("/var/www/panel/scripts/shm-self-heal.sh");
                break;

            case 'nodejs_install':
                $domain = $matches[1];
                $app = $matches[2];
                $result = Process::run("/var/www/panel/scripts/shm-app-nodejs.sh $domain $app");
                break;

            case 'laravel_deploy':
                $domain = $matches[1];
                $repo = "https://github.com/laravel/laravel.git"; // Default for demo
                $result = Process::run("/var/www/panel/scripts/shm-app-laravel.sh $domain $repo");
                break;

            case 'system_audit':
                $result = Process::run("/var/www/panel/scripts/shm-audit.sh");
                break;

            case 'cloud_backup':
                $remote = $matches[1];
                $result = Process::run("/var/www/panel/scripts/shm-backup-cloud.sh $remote");
                break;

            case 'client_report':
                $client = $matches[1] ?? "";
                $result = Process::run("/var/www/panel/scripts/shm-client-usage.sh $client");
                break;

            default:
                return response()->json(['status' => 'error', 'message' => 'Intent not mapped.']);
        }

        if ($result->successful()) {
            return response()->json([
                'status' => 'success',
                'output' => $result->output(),
                'message' => 'VEDA: Kaam ho gaya!'
            ]);
        }

        return response()->json([
            'status' => 'error',
            'output' => $result->errorOutput(),
            'message' => 'VEDA: Kuch gadbad ho gayi.'
        ]);
    }
}
