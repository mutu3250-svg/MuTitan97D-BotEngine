$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
$GameServerProj = Join-Path $Root "Source\MuServer\GameServer\GameServer.vcxproj"
$OutputDir = Join-Path $Root "_build_output"

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
        "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2017\Enterprise\MSBuild\15.0\Bin\MSBuild.exe"
    )
    foreach ($c in $candidates) { if (Test-Path $c) { return $c } }
    throw "MSBuild bulunamadi. Visual Studio/Build Tools ve VC++ v141 toolset gerekli."
}

if (!(Test-Path $GameServerProj)) { throw "GameServer.vcxproj bulunamadi. Bu scripti Source klasorunun ust dizininde calistirin." }
$MSBuild = Find-MSBuild
New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null

Write-Host "GameServer.exe derleniyor..."
& $MSBuild $GameServerProj /m /t:Rebuild /p:Configuration=Release /p:Platform=Win32 /p:SolutionDir="$Root\Source\MuServer\\" /v:minimal /fl /flp:logfile="$Root\build_gameserver.log`;verbosity=normal"
if ($LASTEXITCODE -ne 0) { throw "GameServer derleme hatasi. build_gameserver.log dosyasini gonder." }

$GameServerExe = Join-Path $Root "Source\MuServer\bin\Release\GameServer\GameServer.exe"
if (Test-Path $GameServerExe) {
    Copy-Item $GameServerExe (Join-Path $OutputDir "GameServer.exe") -Force
    Write-Host "OK: _build_output\GameServer.exe"
} else {
    Write-Warning "GameServer.exe beklenen yerde bulunamadi: $GameServerExe"
}
