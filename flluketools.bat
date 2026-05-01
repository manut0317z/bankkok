@echo off
setlocal
title FLUKE SUPER TOOLS v0.0.3

:: [1] เช็คสิทธิ์ Admin แบบตรงไปตรงมา (ไม่ใช้ไฟล์ Temp)
net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: [2] รัน GUI และระบบ Logic ทั้งหมดผ่าน PowerShell Session เดียว
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "Add-Type -AssemblyName System.Windows.Forms; Add-Type -AssemblyName System.Drawing; " ^
    "$fontBtn = New-Object Drawing.Font('Tahoma', 10, [Drawing.FontStyle]::Bold); " ^
    "$url = 'https://raw.githubusercontent.com/manut0317z/bankkok/main/Whitelist.txt'; " ^
    " " ^
    "/* ดึง HWID เครื่อง */ " ^
    "$hwid = (Get-CimInstance Win32_DiskDrive | Select-Object -First 1).SerialNumber.Trim(); " ^
    " " ^
    "/* ตรวจสอบสิทธิ์ Online */ " ^
    "try { " ^
    "    $allowed = (Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 10).Content; " ^
    "} catch { " ^
    "    [Windows.Forms.MessageBox]::Show('กรุณาเชื่อมต่ออินเทอร์เน็ต!', 'Connection Error'); exit; " ^
    "} " ^
    " " ^
    "function Main-Interface { " ^
    "    $f = New-Object Windows.Forms.Form; $f.Text = 'FLUKE SUPER TOOLS v0.0.3'; $f.Size = '380,500'; " ^
    "    $f.StartPosition = 'CenterScreen'; $f.BackColor = '#0F0F0F'; $f.TopMost = $true; $f.FormBorderStyle = 'FixedDialog'; " ^
    "    $title = New-Object Windows.Forms.Label; $title.Text = 'SYSTEM CONTROL'; $title.ForeColor = 'DeepSkyBlue'; " ^
    "    $title.Font = New-Object Drawing.Font('Impact', 22); $title.Size = '380,60'; $title.TextAlign = 'MiddleCenter'; $f.Controls.Add($title); " ^
    "    function Btn($t, $y, $c, $s) { " ^
    "        $b = New-Object Windows.Forms.Button; $b.Text = $t; $b.Top = $y; $b.Left = 40; $b.Width = 300; $b.Height = 45; " ^
    "        $b.FlatStyle = 'Flat'; $b.ForeColor = 'White'; $b.BackColor = $c; $b.Font = $fontBtn; $b.Cursor = [Windows.Forms.Cursors]::Hand; " ^
    "        $b.Add_Click($s); $f.Controls.Add($b) " ^
    "    } " ^
    "    Btn '1. CLEAN SYSTEM' 80 '#2D2D2D' { Remove-Item \"$env:TEMP\*\" -Recurse -Force -EA 0; [Windows.Forms.MessageBox]::Show('Clean Success!', 'Done') }; " ^
    "    Btn '2. DISABLE ANTIVIRUS' 145 '#B42828' { Set-MpPreference -DisableRealtimeMonitoring $true; [Windows.Forms.MessageBox]::Show('Disabled!', 'Warning') }; " ^
    "    Btn '3. ENABLE ANTIVIRUS' 210 '#289628' { Set-MpPreference -DisableRealtimeMonitoring $false; [Windows.Forms.MessageBox]::Show('Enabled!', 'Safe') }; " ^
    "    Btn '4. RESET ANYDESK ID' 275 '#7828A0' { Stop-Process -Name AnyDesk -Force -EA 0; net stop adservice -EA 0; [Windows.Forms.MessageBox]::Show('AnyDesk ID Reset!', 'Success') }; " ^
    "    Btn '5. ADD EXCLUSION' 340 '#0078D7' { $d = New-Object Windows.Forms.FolderBrowserDialog; if($d.ShowDialog() -eq 'OK'){ Add-MpPreference -ExclusionPath $d.SelectedPath; [Windows.Forms.MessageBox]::Show('Added!') } }; " ^
    "    Btn 'EXIT' 410 '#444444' { $f.Close() }; " ^
    "    $f.ShowDialog() | Out-Null; " ^
    "} " ^
    " " ^
    "if ($allowed -match $hwid) { " ^
    "    Main-Interface " ^
    "} else { " ^
    "    [Windows.Forms.Clipboard]::SetText($hwid); " ^
    "    [Windows.Forms.MessageBox]::Show('เครื่องนี้ไม่ได้รับอนุญาต!`n`nHWID: ' + $hwid + '`n(คัดลอกลง Clipboard แล้ว)', 'Security'); " ^
    "}"
exit
