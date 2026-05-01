@echo off
setlocal
title FLUKE SUPER TOOLS v0.0.3

:: [1] บังคับสิทธิ์ Admin
net session >nul 2>&1 || (powershell -Command "Start-Process '%~f0' -Verb RunAs" & exit /b)

:: [2] สร้างไฟล์สคริปต์ชั่วคราว (เพื่อหลบการตรวจจับแบบ Command-Line)
set "ps_script=%temp%\fluke_logic.ps1"

echo $url = 'https://raw.githubusercontent.com/manut0317z/bankkok/main/Whitelist.txt' > "%ps_script%"
echo Add-Type -AssemblyName System.Windows.Forms >> "%ps_script%"
echo Add-Type -AssemblyName System.Drawing >> "%ps_script%"
echo try { >> "%ps_script%"
echo     $h = (Get-CimInstance Win32_DiskDrive ^| Select-Object -First 1).SerialNumber.Trim() >> "%ps_script%"
echo     $a = (New-Object Net.WebClient).DownloadString($url) >> "%ps_script%"
echo     if ($a -match $h) { >> "%ps_script%"
echo         $f = New-Object Windows.Forms.Form; $f.Text = 'FLUKE SUPER TOOLS'; $f.Size = '380,500'; $f.StartPosition = 'CenterScreen'; $f.BackColor = '#0F0F0F'; $f.TopMost = $true; $f.FormBorderStyle = 'FixedDialog' >> "%ps_script%"
echo         $t = New-Object Windows.Forms.Label; $t.Text = 'SYSTEM CONTROL'; $t.ForeColor = 'DeepSkyBlue'; $t.Font = New-Object Drawing.Font('Impact', 22); $t.Size = '380,60'; $t.TextAlign = 'MiddleCenter'; $f.Controls.Add($t) >> "%ps_script%"
echo         $font = New-Object Drawing.Font('Tahoma', 10, [Drawing.FontStyle]::Bold) >> "%ps_script%"
echo         function Btn($txt, $y, $clr, $script) { $b = New-Object Windows.Forms.Button; $b.Text = $txt; $b.Top = $y; $b.Left = 40; $b.Width = 300; $b.Height = 45; $b.FlatStyle = 'Flat'; $b.ForeColor = 'White'; $b.BackColor = $clr; $b.Font = $font; $b.Add_Click($script); $f.Controls.Add($b) } >> "%ps_script%"
echo         Btn '1. CLEAN SYSTEM' 80 '#2D2D2D' { Remove-Item "$env:TEMP\*" -Recurse -Force -EA 0; [Windows.Forms.MessageBox]::Show('Done!') } >> "%ps_script%"
echo         Btn '2. DISABLE ANTIVIRUS' 145 '#B42828' { Set-MpPreference -DisableRealtimeMonitoring $true; [Windows.Forms.MessageBox]::Show('Disabled!') } >> "%ps_script%"
echo         Btn '3. ENABLE ANTIVIRUS' 210 '#289628' { Set-MpPreference -DisableRealtimeMonitoring $false; [Windows.Forms.MessageBox]::Show('Enabled!') } >> "%ps_script%"
echo         Btn '4. RESET ANYDESK ID' 275 '#7828A0' { Stop-Process -Name AnyDesk -Force -EA 0; net stop adservice -EA 0; [Windows.Forms.MessageBox]::Show('Reset!') } >> "%ps_script%"
echo         Btn '5. ADD EXCLUSION' 340 '#0078D7' { $d = New-Object Windows.Forms.FolderBrowserDialog; if($d.ShowDialog() -eq 'OK'){ Add-MpPreference -ExclusionPath $d.SelectedPath; [Windows.Forms.MessageBox]::Show('Added!') } } >> "%ps_script%"
echo         Btn 'EXIT' 410 '#444444' { $f.Close() } >> "%ps_script%"
echo         $f.ShowDialog() ^| Out-Null >> "%ps_script%"
echo     } else { [Windows.Forms.Clipboard]::SetText($h); [Windows.Forms.MessageBox]::Show('Unauthorized!`nHWID: ' + $h + ' (Copied)') } >> "%ps_script%"
echo } catch { [Windows.Forms.MessageBox]::Show('Error: ' + $_.Exception.Message) } >> "%ps_script%"

:: [3] รันสคริปต์ด้วยโหมด Bypass
powershell -ExecutionPolicy Bypass -File "%ps_script%"

:: [4] ล้างไฟล์ขยะ
del "%ps_script%"
exit
