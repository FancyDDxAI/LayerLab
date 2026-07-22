# Assembles the runnable LayerLab desktop app from source.
# Downloads the Electron runtime, ONNX Runtime Web and the AI models, then wires
# them together with src/LayerLab.html. No Node.js or npm required.
#
#   powershell -ExecutionPolicy Bypass -File scripts\build-app.ps1
#
# Result: .\LayerLab-App\LayerLab.exe

$ErrorActionPreference = 'Stop'
$ProgressPreference    = 'SilentlyContinue'

$root     = Split-Path -Parent $PSScriptRoot
$out      = Join-Path $root 'LayerLab-App'
$appDir   = Join-Path $out 'resources\app'
$electron = '43.0.0'

Write-Host "LayerLab build" -ForegroundColor Cyan
Write-Host "  output: $out"

# ---------------------------------------------------------------- Electron
$tmp = Join-Path $env:TEMP 'layerlab-build'
New-Item -ItemType Directory -Force -Path $tmp | Out-Null
$zip = Join-Path $tmp "electron-v$electron-win32-x64.zip"

if (-not (Test-Path $zip)) {
    Write-Host "`n[1/4] Downloading Electron v$electron (~145 MB)..." -ForegroundColor Yellow
    Invoke-WebRequest -Uri "https://github.com/electron/electron/releases/download/v$electron/electron-v$electron-win32-x64.zip" -OutFile $zip -TimeoutSec 600
} else { Write-Host "`n[1/4] Electron already downloaded." -ForegroundColor Green }

if (Test-Path $out) { Remove-Item $out -Recurse -Force }
New-Item -ItemType Directory -Force -Path $out | Out-Null
Expand-Archive -Path $zip -DestinationPath $out -Force

# strip Electron's default app so ours is used instead
Remove-Item (Join-Path $out 'resources\default_app.asar') -Force -ErrorAction SilentlyContinue
Rename-Item (Join-Path $out 'electron.exe') 'LayerLab.exe'

# ---------------------------------------------------------------- App files
Write-Host "[2/4] Copying app source..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path $appDir | Out-Null
Copy-Item (Join-Path $root 'src\LayerLab.html')      (Join-Path $appDir 'index.html') -Force
Copy-Item (Join-Path $root 'electron\main.js')       $appDir -Force
Copy-Item (Join-Path $root 'electron\package.json')  $appDir -Force
Copy-Item (Join-Path $root 'assets\icon.ico')        $appDir -Force

# ---------------------------------------------------------------- ONNX Runtime
Write-Host "[3/4] Downloading ONNX Runtime Web (~22 MB)..." -ForegroundColor Yellow
$ortDir = Join-Path $appDir 'ort'
New-Item -ItemType Directory -Force -Path $ortDir | Out-Null
$ortBase = 'https://cdn.jsdelivr.net/npm/onnxruntime-web@1.20.1/dist'
foreach ($f in @('ort.webgpu.min.js','ort-wasm-simd-threaded.jsep.wasm','ort-wasm-simd-threaded.jsep.mjs')) {
    Invoke-WebRequest -Uri "$ortBase/$f" -OutFile (Join-Path $ortDir $f) -TimeoutSec 600
}

# ---------------------------------------------------------------- AI models
Write-Host "[4/4] Downloading AI models (~340 MB)..." -ForegroundColor Yellow
$mDir = Join-Path $appDir 'models'
New-Item -ItemType Directory -Force -Path $mDir | Out-Null
$models = @{
    'isnet-general-use.onnx' = 'https://huggingface.co/tomjackson2023/rembg/resolve/main/isnet-general-use.onnx'
    'anime-isnetis.onnx'     = 'https://huggingface.co/skytnt/anime-seg/resolve/main/isnetis.onnx'
}
foreach ($name in $models.Keys) {
    $dest = Join-Path $mDir $name
    if (Test-Path $dest) { Write-Host "      $name already present"; continue }
    Write-Host "      $name"
    Invoke-WebRequest -Uri $models[$name] -OutFile $dest -TimeoutSec 900
}

# ---------------------------------------------------------------- exe icon (optional)
$rcedit = Join-Path $tmp 'rcedit-x64.exe'
try {
    if (-not (Test-Path $rcedit)) {
        $rel = Invoke-RestMethod -Uri 'https://api.github.com/repos/electron/rcedit/releases/latest' -Headers @{'User-Agent'='layerlab'} -TimeoutSec 60
        $url = ($rel.assets | Where-Object { $_.name -eq 'rcedit-x64.exe' }).browser_download_url
        Invoke-WebRequest -Uri $url -OutFile $rcedit -TimeoutSec 300
    }
    & $rcedit (Join-Path $out 'LayerLab.exe') --set-icon (Join-Path $root 'assets\icon.ico')
    & $rcedit (Join-Path $out 'LayerLab.exe') --set-version-string 'ProductName' 'LayerLab'
    & $rcedit (Join-Path $out 'LayerLab.exe') --set-version-string 'CompanyName' 'FDDX'
    & $rcedit (Join-Path $out 'LayerLab.exe') --set-file-version '1.0.0'
} catch { Write-Host "      (skipped exe icon: $($_.Exception.Message))" -ForegroundColor DarkGray }

$size = [math]::Round((Get-ChildItem $out -Recurse -File | Measure-Object Length -Sum).Sum / 1MB, 0)
Write-Host "`nDone. $size MB" -ForegroundColor Green
Write-Host "Run: $out\LayerLab.exe" -ForegroundColor Cyan
