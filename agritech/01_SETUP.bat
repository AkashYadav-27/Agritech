@echo off
setlocal EnableExtensions
title AgriTech - Setup
cd /d "%~dp0"

echo ==================================================
echo   AgriTech - Installing project dependencies
echo ==================================================
echo.

if exist "%ProgramFiles%\nodejs\node.exe" set "PATH=%ProgramFiles%\nodejs;%PATH%"
where node >nul 2>&1
if errorlevel 1 goto no_node
where npm >nul 2>&1
if errorlevel 1 goto no_node

echo Node.js version:
node -v
echo.

echo [1/3] Installing backend packages...
pushd server
call npm install --no-audit --no-fund
if errorlevel 1 goto fail
popd
echo.

echo [2/3] Installing frontend packages...
pushd client
call npm install --no-audit --no-fund
if errorlevel 1 goto fail
popd
echo.

echo [3/3] Preparing the database engine...
sc query MongoDB >nul 2>&1
if not errorlevel 1 goto db_ok
echo No local MongoDB service found. Downloading embedded MongoDB (one time, about 100 MB)...
pushd server
call node -e "require('mongodb-memory-server').MongoMemoryServer.create().then(m=>m.stop()).then(()=>console.log('Embedded MongoDB is ready')).catch(e=>console.log('Skipped:',e.message))"
popd
goto done

:db_ok
echo Local MongoDB service found.

:done
echo.
echo ==================================================
echo   Setup complete. Now double-click 02_RUN.bat
echo ==================================================
pause
exit /b 0

:no_node
echo [ERROR] Node.js was not found.
echo         Run 00_INSTALL_PREREQUISITES.bat first, then try again.
pause
exit /b 1

:fail
echo.
echo [ERROR] npm install failed. Check your internet connection and try again.
pause
exit /b 1
