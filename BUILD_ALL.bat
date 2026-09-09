@echo off
chcp 65001 >nul
setlocal
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Build_All.ps1"
echo.
echo Bitti. Pencereyi kapatmak icin bir tusa basin.
pause >nul
