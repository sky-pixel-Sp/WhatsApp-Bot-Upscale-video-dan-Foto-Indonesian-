@echo off
title Bot Downloader
cd /d "%~dp0"

echo =================================================
echo   Bot Downloader - starting...
echo =================================================
echo.

node index.js

echo.
if errorlevel 1 (
    echo Bot berhenti dengan error. Cek pesan di atas buat detailnya.
) else (
    echo Bot berhenti.
)
echo.
pause
