@echo off
setlocal enabledelayedexpansion

:: --- [ CONFIGURATION ] ---
set "current_ver=0.2"
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

:: ตรวจสอบเน็ตแบบง่ายก่อน
ping -n 1 google.com >nul 2>&1
if %errorLevel% neq 0 goto admin_ok

:: ดึงค่าเวอร์ชันล่าสุด (ใช้ไฟล์ชั่วคราวเพื่อความชัวร์ ไม่ใช้ for /f ที่ทำให้เด้ง)
powershell -Command "$ProgressPreference = 'SilentlyContinue'; try { $v = (New-Object Net.WebClient).DownloadString('%url_ver%').Trim(); $v | Out-File -FilePath '%temp%\v_check.txt' -Encoding ascii } catch { 'error' | Out-File -FilePath '%temp%\v_check.txt' -Encoding ascii }"

:: อ่านค่าจากไฟล์ชั่วคราว
set /p latest_ver=<%temp%\v_check.txt
del /q %temp%\v_check.txt >nul 2>&1

:: ถ้าค่าที่ได้มาผิดปกติ ให้ข้ามไปเลย
if "%latest_ver%"=="error" goto admin_ok
if "%latest_ver%"=="" goto admin_ok

:: เปรียบเทียบเวอร์ชัน
if NOT "%latest_ver%"=="%current_ver%" (
    echo.
    echo    ==================================================
    echo      [ UPDATE FOUND ] : New Version v%latest_ver%
    echo    ==================================================
    echo.
    set /p choice=    Do you want to update now? (Y/N): 
    if /i "!choice!"=="Y" (
        echo.
        echo    [ UPDATING ] : Downloading...
        powershell -Command "(New-Object Net.WebClient).DownloadFile('%url_script%', 'temp_upd.bat')"
        if exist "temp_upd.bat" (
            move /y "temp_upd.bat" "%~nx0" >nul
            start "" "%~nx0"
            exit
        )
    )
)

:admin_ok
:: --- ส่วนเมนูหลักเดิมของคุณ ---
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
echo [ Cleaning... ]
del /s /f /q %temp%\*.* >nul 2>&1
echo DONE!
pause
goto menu

:disable_def
powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $true"
echo Defender Disabled.
pause
goto menu

:enable_def
powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $false"
echo Defender Enabled.
pause
goto menu

:add_exclude
set /p folderpath= Path: 
powershell -Command "Add-MpPreference -ExclusionPath '%folderpath%'"
echo Added.
pause
goto menu