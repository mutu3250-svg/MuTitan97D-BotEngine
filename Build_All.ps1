# MU Titan 97D BotEngine v1 build script
# Bu script Windows + Visual Studio Build Tools/Visual Studio ile GameServer.exe ve Main.dll derler.

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
$GameServerProj = Join-Path $Root "Source\MuServer\GameServer\GameServer.vcxproj"
$MainProj = Join-Path $Root "Source\Client\Main\Main.vcxproj"
$OutputDir = Join-Path $Root "_build_output"

function Write-Step($msg) {
    Write-Host ""
    Write-Host "==== $msg ====" -ForegroundColor Cyan
}

function Find-MSBuild {
    $vswhere = Join-Path ${env:ProgramFiles(x86)} "Microsoft Visual Studio\Installer\vswhere.exe"
    if (Test-Path $vswhere) {
        $result = & $vswhere -latest -products * -requires Microsoft.Component.MSBuild -find "MSBuild\**\Bin\MSBuild.exe" | Select-Object -First 1
        if ($result -and (Test-Path $result)) { return $result }
    }

    $candidates = @(
        "${env:ProgramFiles}\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe",
        "${env:ProgramFiles}\Microsoft Visual Studio\2022\Professional\MSBuild\Current\Bin\MSBuild.exe",
        "${env:ProgramFiles}\Microsoft Visual Studio\2022\Enterprise\MSBuild\Current\Bin\MSBuild.exe",
        "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2019\Community\MSBuild\Current\Bin\MSBuild.exe",
        "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2019\Professional\MSBuild\Current\Bin\MSBuild.exe",
        "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2019\Enterprise\MSBuild\Current\Bin\MSBuild.exe",
        "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2017\Community\MSBuild\15.0\Bin\MSBuild.exe",
        "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2017\Professional\MSBuild\15.0\Bin\MSBuild.exe",
        "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2017\Enterprise\MSBuild\15.0\Bin\MSBuild.exe",
        "${env:ProgramFiles(x86)}\MSBuild\14.0\Bin\MSBuild.exe"
    )
    foreach ($c in $candidates) {
        if (Test-Path $c) { return $c }
    }
    throw "MSBuild bulunamadi. Visual Studio 2017/2019/2022 veya Build Tools kurulu olmali. Proje v141 toolset ister; VS Installer'dan 'VC++ 2017 v141 toolset' secili olmali."
}

if (!(Test-Path $GameServerProj)) { throw "GameServer.vcxproj bulunamadi: $GameServerProj. Bu scripti Source klasorunun ust dizininde calistirin." }
if (!(Test-Path $MainProj)) { throw "Main.vcxproj bulunamadi: $MainProj. Full Source paketini kullanin; GameServer-only paketinde client Main.dll derlenmez." }

$MSBuild = Find-MSBuild
New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null

Write-Step "MSBuild bulundu"
Write-Host $MSBuild

Write-Step "GameServer.exe derleniyor"
& $MSBuild $GameServerProj /m /t:Rebuild /p:Configuration=Release /p:Platform=Win32 /p:SolutionDir="$Root\Source\MuServer\\" /v:minimal /fl /flp:logfile="$Root\build_gameserver.log`;verbosity=normal"
if ($LASTEXITCODE -ne 0) { throw "GameServer derleme hatasi. build_gameserver.log dosyasini kontrol edin." }

Write-Step "Main.dll derleniyor"
& $MSBuild $MainProj /m /t:Rebuild /p:Configuration=Release /p:Platform=Win32 /p:SolutionDir="$Root\Source\Client\\" /v:minimal /flp1:logfile="$Root\build_main.log`;verbosity=normal"
if ($LASTEXITCODE -ne 0) { throw "Main.dll derleme hatasi. build_main.log dosyasini kontrol edin." }

$GameServerExe = Join-Path $Root "Source\MuServer\bin\Release\GameServer\GameServer.exe"
$MainDll = Join-Path $Root "Source\Client\bin\Release\Main\Main.dll"

Write-Step "Ciktilar kopyalaniyor"
if (Test-Path $GameServerExe) {
    Copy-Item $GameServerExe (Join-Path $OutputDir "GameServer.exe") -Force
    Write-Host "OK: _build_output\GameServer.exe"
} else {
    Write-Warning "GameServer.exe beklenen yerde bulunamadi: $GameServerExe"
}
if (Test-Path $MainDll) {
    Copy-Item $MainDll (Join-Path $OutputDir "Main.dll") -Force
    Write-Host "OK: _build_output\Main.dll"
} else {
    Write-Warning "Main.dll beklenen yerde bulunamadi: $MainDll"
}

Write-Step "Tamamlandi"
Write-Host "Derlenen dosyalar: $OutputDir"
Write-Host "Canli servera atmadan once eski GameServer.exe ve Main.dll yedegini alin."
