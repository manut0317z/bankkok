@echo off
setlocal
title FLUKE SUPER TOOLS v0.0.2
mode con cols=60 lines=3

:: [1] ขอกลางสิทธิ์ Administrator
net session >nul 2>&1 || (powershell -Command "Start-Process '%~f0' -Verb RunAs" & exit /b)

echo Loading FLUKE SUPER TOOLS...

:: [2] รัน GUI พร้อมระบบถอดรหัสภาษาไทยแบบ HEX (กันเหนียว 100%)
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$u = [System.Text.Encoding]::GetEncoding(874); " ^
    "$m1 = $u.GetString(@(0x20,0x0E,0x32,0x0E,0x32,0x0E,0x07,0x0E,0x31,0x0E,0x42,0x0E,0x30,0x0E,0x1A,0x0E,0x48,0x0E,0x1A,0x0E,0x1A,0x0E,0x23,0x0E,0x31,0x0E,0x22,0x0E,0x1A,0x0E)); " ^
    "Add-Type -AssemblyName System.Windows.Forms; Add-Type -AssemblyName System.Drawing; " ^
    "$f = New-Object Windows.Forms.Form; $f.Text = 'FLUKE SUPER TOOLS v0.2.6'; $f.Size = '380,500'; " ^
    "$f.StartPosition = 'CenterScreen'; $f.BackColor = '#0F0F0F'; $f.TopMost = $true; $f.FormBorderStyle = 'FixedDialog'; " ^
    "$fontTitle = New-Object Drawing.Font('Impact', 22); $fontBtn = New-Object Drawing.Font('Tahoma', 10, [Drawing.FontStyle]::Bold); " ^
    "$title = New-Object Windows.Forms.Label; $title.Text = 'SYSTEM CONTROL'; $title.ForeColor = 'DeepSkyBlue'; " ^
    "$title.Font = $fontTitle; $title.Size = '380,60'; $title.TextAlign = 'MiddleCenter'; $f.Controls.Add($title); " ^
    "function Btn($t, $y, $c, $s) { " ^
    "  $b = New-Object Windows.Forms.Button; $b.Text = $t; $b.Top = $y; $b.Left = 40; $b.Width = 300; $b.Height = 45; " ^
    "  $b.FlatStyle = 'Flat'; $b.ForeColor = 'White'; $b.BackColor = $c; $b.Font = $fontBtn; $b.Cursor = [Windows.Forms.Cursors]::Hand; " ^
    "  $b.Add_Click($s); $f.Controls.Add($b) " ^
    "} " ^
    "Btn '1. CLEAN SYSTEM' 80 '#2D2D2D' { Remove-Item \"$env:TEMP\*\" -Recurse -Force -EA 0; [Windows.Forms.MessageBox]::Show('Clean Success!', 'Done') }; " ^
    "Btn '2. DISABLE ANTIVIRUS' 145 '#B42828' { Set-MpPreference -DisableRealtimeMonitoring $true; [Windows.Forms.MessageBox]::Show('Disabled!', 'Warning') }; " ^
    "Btn '3. ENABLE ANTIVIRUS' 210 '#289628' { Set-MpPreference -DisableRealtimeMonitoring $false; [Windows.Forms.MessageBox]::Show('Enabled!', 'Safe') }; " ^
    "Btn '4. RESET ANYDESK ID' 275 '#7828A0' { " ^
    "  Stop-Process -Name AnyDesk -Force -EA 0; net stop adservice -EA 0; " ^
    "  $p = @(\"$env:APPDATA\AnyDesk\", \"$env:SystemDrive\ProgramData\AnyDesk\"); " ^
    "  foreach($x in $p){ if(Test-Path $x){ attrib -r -s -h \"$x\*\" /s /d; Remove-Item \"$x\*\" -Recurse -Force -EA 0 } } " ^
    "  [Windows.Forms.MessageBox]::Show('AnyDesk ID Reset!', 'Success') " ^
    "}; " ^
    "Btn '5. ADD EXCLUSION' 340 '#0078D7' { $d = New-Object Windows.Forms.FolderBrowserDialog; if($d.ShowDialog() -eq 'OK'){ Add-MpPreference -ExclusionPath $d.SelectedPath; [Windows.Forms.MessageBox]::Show('Added!') } }; " ^
    "Btn 'EXIT' 410 '#444444' { $f.Close() }; " ^
    "$f.ShowDialog() | Out-Null"
exit
