@echo off
setlocal EnableExtensions EnableDelayedExpansion

rem This script manages the bot on Windows, allowing it to run in the background.
rem You can start, stop, restart, and check the status of the bot without
rem needing to keep a command prompt window open.

rem =========================
rem Configuration
rem
rem This section contains settings you may need to change to run the bot.
rem =========================

rem --- REQUIRED ---
rem You MUST change this to the full path of your bot's folder.
rem To get the path, right-click the folder in Windows Explorer, select "Copy as path", and paste it here (remove the surrounding quotes).
rem Example: set "BOT_DIR=C:\Users\YourName\Documents\FortuneTellerBot"
set "BOT_DIR=C:\path\to\bot"

rem --- ADVANCED (usually no changes needed) ---
set "BOT_SCRIPT=bot.py"
rem This script assumes your Python virtual environment is in a folder named '.venv'
rem inside your bot directory. If you named it something else or put it elsewhere, change VENV_DIR below.
set "VENV_DIR=%BOT_DIR%\.venv"
set "PY=%VENV_DIR%\Scripts\python.exe"
set "LOG_FILE=%BOT_DIR%\bot.log"
set "PID_FILE=%BOT_DIR%\bot.pid"
set "INVITE_FILE=%BOT_DIR%\invite.txt"
set "INVITE_PREFIX=Invite link:"
set "NETWORK_HOST=8.8.8.8"

cd /d "%BOT_DIR%" || exit /b 1

if "%~1"=="" set "CMD=start" & goto :start
if /I "%~1"=="start"   goto :start
if /I "%~1"=="stop"    goto :stop
if /I "%~1"=="restart" goto :restart
if /I "%~1"=="status"  goto :status
if /I "%~1"=="invite"  goto :invite
if /I "%~1"=="viewlog" goto :viewlog

echo Usage: %~nx0 {start|stop|restart|status|invite|viewlog}
exit /b 1

:start
if not exist "%PY%" (
  echo Virtual environment not found: "%PY%"
  exit /b 1
)

call :wait_network

rem If PID file exists, verify if process still alive
if exist "%PID_FILE%" (
  for /f "usebackq tokens=1" %%P in ("%PID_FILE%") do set "PID=%%P"
  if defined PID (
    for /f "tokens=2 delims=," %%A in ('tasklist /FI "PID eq !PID!" /FO CSV /NH') do set "PROC=%%~A"
    if defined PROC (
      echo Bot already running with PID !PID!.
      exit /b 0
    ) else (
      del "%PID_FILE%" >nul 2>&1
    )
  )
)

rem Truncate log
type nul > "%LOG_FILE%"

rem Start hidden so no console sticks around; capture PID
for /f "usebackq delims=" %%P in (`
  powershell -NoProfile -Command ^
    "Start-Process -FilePath '%PY%' -ArgumentList '%BOT_SCRIPT%' -WorkingDirectory '%BOT_DIR%' -WindowStyle Hidden -RedirectStandardOutput '%LOG_FILE%' -RedirectStandardError '%LOG_FILE%' -PassThru | %%{ $_.Id }"
`) do set "PID=%%P"

if not defined PID (
  echo Failed to start bot.
  exit /b 1
)

echo !PID!>"%PID_FILE%"
echo Started bot (PID !PID!). Waiting for invite link (30s max)...
call :wait_invite 30
exit /b 0

:stop
if not exist "%PID_FILE%" (
  echo Not running.
  exit /b 0
)
for /f "usebackq tokens=1" %%P in ("%PID_FILE%") do set "PID=%%P"
if not defined PID (
  echo Not running.
  del "%PID_FILE%" >nul 2>&1
  exit /b 0
)
taskkill /PID %PID% /T /F >nul 2>&1
if %ERRORLEVEL% EQU 0 (
  echo Stopped PID %PID%.
) else (
  echo Process %PID% not found or could not be stopped.
)
del "%PID_FILE%" >nul 2>&1
exit /b 0

:restart
call :stop
timeout /t 1 /nobreak >nul
goto :start

:status
if not exist "%PID_FILE%" (
  echo Bot is not running.
  exit /b 0
)
for /f "usebackq tokens=1" %%P in ("%PID_FILE%") do set "PID=%%P"
for /f "tokens=2 delims=," %%A in ('tasklist /FI "PID eq %PID%" /FO CSV /NH') do set "PROC=%%~A"
if defined PROC (
  echo Bot is running (PID %PID%).
) else (
  echo Bot is not running. Cleaning stale PID file.
  del "%PID_FILE%" >nul 2>&1
)
exit /b 0

:invite
call :wait_invite 30
exit /b 0

:viewlog
start "" notepad.exe "%LOG_FILE%"
exit /b 0

:wait_network
echo Checking network...
:netloop
ping -n 1 -w 1000 %NETWORK_HOST% >nul
if errorlevel 1 (
  echo Waiting for network...
  timeout /t 2 /nobreak >nul
  goto :netloop
)
exit /b 0

:wait_invite
set "SECONDS=%~1"
if not defined SECONDS set "SECONDS=30"
set /a "loops=%SECONDS%/2"
set "found="

for /L %%I in (1,1,%loops%) do (
  if exist "%LOG_FILE%" (
    for /f "usebackq delims=" %%L in (`findstr /C:"%INVITE_PREFIX%" "%LOG_FILE%"`) do (
      set "line=%%L"
      set "found=1"
    )
  )
  if defined found (
    rem Strip "Invite link: " prefix, keep the URL as-is
    set "link=!line:%INVITE_PREFIX% =!"
    echo Invite link: !link!
    >"%INVITE_FILE%" echo !link!
    powershell -NoProfile -Command ^
      "try { Set-Clipboard -Value (Get-Content -Raw -LiteralPath '%INVITE_FILE%') } catch {}" >nul 2>&1
    exit /b 0
  )
  timeout /t 2 /nobreak >nul
)
echo Could not find invite link in the log after %SECONDS% seconds.
exit /b 1