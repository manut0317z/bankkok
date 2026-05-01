@echo off
setlocal
title FLUKE SUPER TOOLS v0.0.3

:: [1] ขอสิทธิ์ Admin (ถ้ายังไม่มี)
net session >nul 2>&1 || (powershell -Command "Start-Process '%~f0' -Verb RunAs" & exit /b)

:: [2] เรียก PowerShell แบบหลบการตรวจจับ (ใช้การรันแบบ NoLogo และ NonInteractive)
powershell -NoLogo -NonInteractive -NoProfile -ExecutionPolicy Bypass -Command ^
    "$u = 'https://raw.githubusercontent.com/manut0317z/bankkok/main/Whitelist.txt'; " ^
    "$h = (Get-CimInstance Win32_DiskDrive | Select-Object -First 1).SerialNumber.Trim(); " ^
    "try { " ^
    "    $a = (New-Object Net.WebClient).DownloadString($u); " ^
    "    if ($a -match $h) { " ^
    "        Add-Type -AssemblyName System.Windows.Forms; Add-Type -AssemblyName System.Drawing; " ^
    "        $f = New-Object Windows.Forms.Form; $f.Text = 'FLUKE SUPER TOOLS'; $f.Size = '380,500'; " ^
    "        $f.StartPosition = 'CenterScreen'; $f.BackColor = '#0F0F0F'; $f.TopMost = $true; " ^
    "        $t = New-Object Windows.Forms.Label; $t.Text = 'SYSTEM CONTROL'; $t.ForeColor = 'DeepSkyBlue'; " ^
    "        $t.Font = New-Object Drawing.Font('Impact', 22); $t.Size = '380,60'; $t.TextAlign = 'MiddleCenter'; $f.Controls.Add($t); " ^
    "        $font = New-Object Drawing.Font('Tahoma', 10, [Drawing.FontStyle]::Bold); " ^
    "        function Btn($txt, $y, $clr, $script) { " ^
    "            $b = New-Object Windows.Forms.Button; $b.Text = $txt; $b.Top = $y; $b.Left = 40; $b.Width = 300; $b.Height = 45; " ^
    "            $b.FlatStyle = 'Flat'; $b.ForeColor = 'White'; $b.BackColor = $clr; $b.Font = $font; $b.Add_Click($script); $f.Controls.Add($b) " ^
    "        } " ^
    "        Btn '1. CLEAN SYSTEM' 80 '#2D2D2D' { Remove-Item \"$env:TEMP\*\" -Recurse -Force -EA 0; [Windows.Forms.MessageBox]::Show('Done!') }; " ^
    "        Btn '2. DISABLE ANTIVIRUS' 145 '#B42828' { Set-MpPreference -DisableRealtimeMonitoring $true; [Windows.Forms.MessageBox]::Show('Disabled!') }; " ^
    "        Btn '3. ENABLE ANTIVIRUS' 210 '#289628' { Set-MpPreference -DisableRealtimeMonitoring $false; [Windows.Forms.MessageBox]::Show('Enabled!') }; " ^
    "        Btn '4. RESET ANYDESK ID' 275 '#7828A0' { Stop-Process -Name AnyDesk -Force -EA 0; net stop adservice -EA 0; [Windows.Forms.MessageBox]::Show('Reset!') }; " ^
    "        Btn '5. ADD EXCLUSION' 340 '#0078D7' { $d = New-Object Windows.Forms.FolderBrowserDialog; if($d.ShowDialog() -eq 'OK'){ Add-MpPreference -ExclusionPath $d.SelectedPath; [Windows.Forms.MessageBox]::Show('Added!') } }; " ^
    "        Btn 'EXIT' 410 '#444444' { $f.Close() }; " ^
    "        $f.ShowDialog() | Out-Null " ^
    "    } else { " ^
    "        Add-Type -AssemblyName System.Windows.Forms; [Windows.Forms.Clipboard]::SetText($h); " ^
    "        [Windows.Forms.MessageBox]::Show('Unauthorized!`nHWID: ' + $h + ' (Copied)') " ^
    "    } " ^
    "} catch { " ^
    "    Add-Type -AssemblyName System.Windows.Forms; [Windows.Forms.MessageBox]::Show('Error: ' + $_.Exception.Message) " ^
    "}"
exit
