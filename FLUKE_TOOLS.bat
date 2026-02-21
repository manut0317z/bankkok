@echo off
setlocal enabledelayedexpansion

:: --- [ CONFIGURATION: ตั้งค่าตรงนี้ ] ---
set "current_ver=0.1"
:: วางลิงก์ Raw GitHub ของไฟล์ version.txt และไฟล์ตัวโปรแกรม (.bat)
set "url_ver=https://raw.githubusercontent.com/manut0317z/bankkok/refs/heads/main/version.txt"
set "url_script=https://github.com/manut0317z/bankkok/blob/main/FLUKE_TOOLS.bat"
:: ---------------------------------------

:: --- ส่วนขอสิทธิ์ Administrator อัตโนมัติ ---
net session >nul 2>&1
if %errorLevel% == 0 (
    goto :check_update
) else (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit
)

:check_update
title Checking for updates...
echo Checking for updates, please wait...

:: ใช้ PowerShell ดึงเลขเวอร์ชันล่าสุดมาเทียบ
for /f "delims=" %%a in ('powershell -Command "$ProgressPreference = 'SilentlyContinue'; try { (New-Object Net.WebClient).DownloadString('%url_ver%').Trim() } catch { $null }"') do set "latest_ver=%%a"

:: ถ้าดึงเวอร์ชันได้ และไม่ตรงกับปัจจุบัน
if defined latest_ver (
    if "%latest_ver%" neq "%current_ver%" (
        echo.
        echo ==================================================
        echo   FOUND NEW VERSION: v%latest_ver% (Current: v%current_ver%)
        echo ==================================================
        set /p choice= Do you want to update now? (Y/N): 
        if /i "!choice!"=="Y" (
            echo Updating...
            powershell -Command "(New-Object Net.WebClient).DownloadFile('%url_script%', '%~f0')"
            echo Update Complete! Restarting...
            timeout /t 2 >nul
            start "" "%~f0"
            exit
        )
    )
)
goto :admin_ok

:admin_ok
:: --- ตั้งค่าภาษาและสี (ระบบเดิมของคุณ) ---
chcp 874 >nul
title FLUKE SUPER TOOLS v%current_ver%
color 9

:menu
cls
echo.
echo    ==================================================
echo             FLUKE SYSTEM TOOLS (PROGRESS)
echo             VERSION: %current_ver%
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
echo    [ กำลังเริ่มกระบวนการล้างขยะ... ]
echo    --------------------------------------------------
echo.
powershell -Command "for($i=0; $i -le 100; $i+=10) { Write-Progress -Activity 'กำลังทำความสะอาดระบบ' -Status \"$i%% เสร็จสิ้น\" -PercentComplete $i; Start-Sleep -Milliseconds 200 }"

del /s /f /q %temp%\*.* >nul 2>&1
for /d %%p in ("%temp%\*") do rd /s /q "%%p" >nul 2>&1
del /s /f /q C:\Windows\Temp\*.* >nul 2>&1
for /d %%p in ("C:\Windows\Temp\*") do rd /s /q "%%p" >nul 2>&1
powershell -Command "Clear-RecycleBin -Confirm:$false" >nul 2>&1

echo.
echo    ? [100%%] ล้างไฟล์ขยะและถังขยะเรียบร้อยแล้ว!
echo    --------------------------------------------------
pause
goto menu

:disable_def
cls
echo.
echo    [ กำลังปิดการป้องกัน... ]
powershell -Command "Write-Progress -Activity 'Changing Status' -Status 'Disabling...' -PercentComplete 50"
powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $true"
echo.
echo    DONE: ปิดการสแกนไวรัสชั่วคราวแล้ว
pause
goto menu

:enable_def
cls
echo.
echo    [ กำลังเปิดการป้องกัน... ]
powershell -Command "Write-Progress -Activity 'Changing Status' -Status 'Enabling...' -PercentComplete 50"
powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $false"
echo.
echo    DONE: ระบบป้องกันกลับมาทำงานปกติ
pause
goto menu

:add_exclude
cls
echo.
echo    [ ADD EXCLUSION PATH ]
echo    --------------------------------------------------
set /p folderpath=    PATH: 
powershell -Command "Write-Progress -Activity 'Adding Path' -Status 'Processing...' -PercentComplete 50"
powershell -Command "Add-MpPreference -ExclusionPath '%folderpath%'"
echo.
echo    SUCCESS: เพิ่มการยกเว้นเรียบร้อย!
echo    --------------------------------------------------
pause
goto menu