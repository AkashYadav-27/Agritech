@echo off
setlocal EnableExtensions
title AgriTech - Launcher
cd /d "%~dp0"

if exist "%ProgramFiles%\nodejs\node.exe" set "PATH=%ProgramFiles%\nodejs;%PATH%"
where node >nul 2>&1
if errorlevel 1 goto no_node

if not exist "server\node_modules" goto need_setup
if not exist "client\node_modules" goto need_setup
goto start_app

:need_setup
echo Dependencies are missing. Running setup first...
call 01_SETUP.bat

:start_app
echo.
echo ==================================================
echo   Starting AgriTech
echo ==================================================

rem Start the MongoDB Windows service if it exists (needs admin; ignored otherwise)
net start MongoDB >nul 2>&1

echo Starting backend  (http://localhost:5000) ...
start "AgriTech Server" /D "%~dp0server" cmd /k npm start

echo Starting frontend (http://localhost:5173) ...
start "AgriTech Client" /D "%~dp0client" cmd /k npm run dev

echo.
echo Waiting for the servers to come up...
timeout /t 12 /nobreak >nul
start "" http://localhost:5173

echo.
echo ==================================================
echo   AgriTech is running in two windows:
echo     - AgriTech Server  (wait for: AgriTech API running)
echo     - AgriTech Client
echo   Browser: http://localhost:5173
echo.
echo   Demo logins:
echo     Admin : admin@agritech.com  /  Admin@123
echo     Farmer: farmer@agritech.com /  Farmer@123
echo.
echo   To stop everything, run 03_STOP.bat
echo   If the page shows errors on first launch, wait a few
echo   seconds and refresh. The first run seeds demo data.
echo ==================================================
pause
exit /b 0

:no_node
echo [ERROR] Node.js was not found.
echo         Run 00_INSTALL_PREREQUISITES.bat first, then 01_SETUP.bat.
pause
exit /b 1
