<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Log;

class FileController extends Controller
{
    /**
     * List files in a specific client's web root.
     */
    public function listFiles(Request $request)
    {
        $client = $request->input('client');
        $path = $request->input('path', 'public_html');

        $basePath = "/var/www/clients/" . $client . "/" . $path;

        if (!File::isDirectory($basePath)) {
            return response()->json(['status' => 'error', 'message' => 'Invalid path.']);
        }

        $files = File::files($basePath);
        $directories = File::directories($basePath);

        $result = [];
        foreach ($directories as $dir) {
            $result[] = [
                'name' => basename($dir),
                'type' => 'directory',
                'size' => '--'
            ];
        }
        foreach ($files as $file) {
            $result[] = [
                'name' => basename($file),
                'type' => 'file',
                'size' => $file->getSize()
            ];
        }

        return response()->json(['status' => 'success', 'files' => $result]);
    }

    /**
     * Read a file content.
     */
    public function readFile(Request $request)
    {
        $client = $request->input('client');
        $filePath = $request->input('file');

        $fullPath = "/var/www/clients/" . $client . "/public_html/" . $filePath;

        if (!File::exists($fullPath)) {
            return response()->json(['status' => 'error', 'message' => 'File not found.']);
        }

        return response()->json([
            'status' => 'success',
            'content' => File::get($fullPath)
        ]);
    }
}
