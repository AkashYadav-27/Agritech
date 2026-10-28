@echo off
setlocal EnableExtensions
title AgriTech - Install Prerequisites
cd /d "%~dp0"

echo ==================================================
echo   AgriTech - Prerequisites Installer
echo   Installs: Node.js LTS and MongoDB Community
echo   Run this ONCE before 01_SETUP.bat
echo ==================================================
echo.

rem ---- Installers need administrator rights: relaunch elevated if needed ----
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator permission...
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

set "NODE_MSI_URL=https://nodejs.org/dist/v22.11.0/node-v22.11.0-x64.msi"

rem ================= Node.js =================
if exist "%ProgramFiles%\nodejs\node.exe" set "PATH=%ProgramFiles%\nodejs;%PATH%"
where node >nul 2>&1
if errorlevel 1 goto install_node
for /f "tokens=1 delims=." %%a in ('node -v') do set "NV=%%a"
set "NV=%NV:v=%"
if %NV% LSS 18 goto install_node
echo [OK] Node.js is already installed:
node -v
goto check_mongo

:install_node
echo [..] Installing Node.js LTS ...
where winget >nul 2>&1
if errorlevel 1 goto node_direct
winget install -e --id OpenJS.NodeJS.LTS --silent --accept-package-agreements --accept-source-agreements
if not errorlevel 1 goto node_done

:node_direct
echo [..] Downloading the Node.js installer directly...
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%NODE_MSI_URL%' -OutFile '%TEMP%\node-setup.msi' -UseBasicParsing; exit 0 } catch { Write-Host $_; exit 1 }"
if errorlevel 1 goto node_fail
msiexec /i "%TEMP%\node-setup.msi" /qn /norestart
if errorlevel 1 goto node_fail

:node_done
if exist "%ProgramFiles%\nodejs\node.exe" set "PATH=%ProgramFiles%\nodejs;%PATH%"
echo [OK] Node.js installed.
goto check_mongo

:node_fail
echo.
echo [ERROR] Could not install Node.js automatically.
echo         Please install the LTS version from https://nodejs.org and run this file again.
pause
exit /b 1

rem ================= MongoDB =================
:check_mongo
echo.
sc query MongoDB >nul 2>&1
if errorlevel 1 goto install_mongo
echo [OK] MongoDB service is already installed.
goto finish

:install_mongo
where winget >nul 2>&1
if errorlevel 1 goto mongo_skip
echo [..] Installing MongoDB Community Server. This can take a few minutes...
winget install -e --id MongoDB.Server --silent --accept-package-agreements --accept-source-agreements
sc query MongoDB >nul 2>&1
if errorlevel 1 goto mongo_skip
echo [OK] MongoDB installed and running as a Windows service.
goto finish

:mongo_skip
echo.
echo [!] MongoDB could not be installed automatically.
echo     That is fine. AgriTech falls back to a built-in embedded MongoDB.
echo     A one-time download of about 100 MB happens during 01_SETUP.bat.

:finish
echo.
echo ==================================================
echo   Prerequisites are ready. Next:
echo     1^) Double-click 01_SETUP.bat
echo     2^) Double-click 02_RUN.bat
echo ==================================================
pause
exit /b 0
