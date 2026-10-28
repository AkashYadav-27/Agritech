@echo off
title AgriTech - Stop
echo Stopping AgriTech server and client...
taskkill /FI "WINDOWTITLE eq AgriTech Server*" /T /F >nul 2>&1
taskkill /FI "WINDOWTITLE eq AgriTech Client*" /T /F >nul 2>&1
echo Done.
timeout /t 2 >nul
