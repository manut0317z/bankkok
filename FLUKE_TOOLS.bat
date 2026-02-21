@echo off
setlocal enabledelayedexpansion

:: --- [ CONFIGURATION ] ---
set "current_ver=0.2"
:: ลิงก์ที่ถูกต้อง (ตรวจสอบแล้ว)
set "url_ver=https://raw.githubusercontent.com/manut0317z/bankkok/main/version.txt"
set "url_script=https://raw.githubusercontent.com/manut0317z/bankkok/main/FLUKE_TOOLS.bat"
:: -------------------------

:: --- ส่วนขอสิทธิ์ Administrator ---
net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit
)

:check_update
cls
title FLUKE SUPER TOOLS - Checking Update...
echo  [ STATUS ] : Connecting to Server...

:: 1. เช็คว่าเชื่อมต่ออินเทอร์เน็ตได้ไหม
ping -n 1 google.com >nul 2>&1
if %errorLevel% neq 0 (
    echo  [ WARN   ] : No Internet Connection.
    timeout /t 2 >nul
    goto admin_ok
)

:: 2. ดึงค่าเวอร์ชัน (เพิ่มการจัดการค่าว่าง)
for /f "delims=" %%a in ('powershell -Command "$ProgressPreference = 'SilentlyContinue'; try { $v = (New-Object Net.WebClient).DownloadString('%url_ver%').Trim(); if($v) { echo $v } else { echo 'error' } } catch { echo 'error' }"') do set "latest_ver=%%a"

:: 3. ตรวจสอบเงื่อนไข
if "%latest_ver%"=="error" (
    echo  [ ERROR  ] : GitHub Link is invalid or 404.
    timeout /t 2 >nul
    goto admin_ok
)

if "%latest_ver%" neq "%current_ver%" (
    echo.
    echo    ==================================================
    echo      [ UPDATE FOUND ] : New Version v%latest_ver%
    echo    ==================================================
    echo.
    set /p choice=    Do you want to update now? (Y/N): 
    if /i "!choice!"=="Y" (
        echo.
        echo    [ UPDATING ] : Downloading...
        powershell -Command "(New-Object Net.WebClient).DownloadFile('%url_script%', '%~f0')"
        echo    [ SUCCESS  ] : File Updated.
        timeout /t 1 >nul
        start "" "%~f0"
        exit
    )
)

:admin_ok
:: --- ส่วนเมนูหลัก (ระบบเดิมของคุณ) ---
chcp 874 >nul
title FLUKE SUPER TOOLS v%current_ver%
color 9

:menu
cls
echo.
echo    ==================================================
echo             FLUKE SYSTEM TOOLS (PROGRESS)
echo             Current Version: %current_ver%
echo    ==================================================
echo.
echo     [1] CLEAN  : ล้างขยะเครื่อง (%%temp%%)
echo     [2] OFF    : ปิดสแกนไวรัส (ชั่วคราว)
echo     [3] ON     : เปิดสแกนไวรัส (ปกติ)
echo     [4] ADD    : เพิ่มโฟลเดอร์ยกเว้น (Exclusion)
echo     [5] EXIT   : ออกจากโปรแกรม
echo.
echo    ==================================================
echo.
set /p select=    SELECT (1-5): 

if "%select%"=="1" goto clean
if "%select%"=="2" goto disable_def
if "%select%"=="3" goto enable_def
if "%select%"=="4" goto add_exclude
if "%select%"=="5" exit
goto menu

:clean
cls
echo.
echo    [ กำลังล้างขยะ... ]
powershell -Command "for($i=0; $i -le 100; $i+=20) { Write-Progress -Activity 'Cleaning' -Status \"$i%%\" -PercentComplete $i; Start-Sleep -Milliseconds 100 }"
del /s /f /q %temp%\*.* >nul 2>&1
for /d %%p in ("%temp%\*") do rd /s /q "%%p" >nul 2>&1
powershell -Command "Clear-RecycleBin -Confirm:$false" >nul 2>&1
echo DONE!
pause
goto menu

:disable_def
cls
powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $true"
echo Defender Disabled.
pause
goto menu

:enable_def
cls
powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $false"
echo Defender Enabled.
pause
goto menu

:add_exclude
cls
set /p folderpath= Enter Path: 
powershell -Command "Add-MpPreference -ExclusionPath '%folderpath%'"
echo Added Exclusion.
pause
goto menu