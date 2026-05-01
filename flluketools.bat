@echo off
setlocal
title FLUKE SUPER TOOLS - LOADER

:: [1] เช็คและขอสิทธิ์ Admin
net session >nul 2>&1 || (powershell -Command "Start-Process '%~f0' -Verb RunAs" & exit /b)

:: [2] สร้างสคริปต์ PowerShell แยกออกมาเป็นไฟล์ (เพื่อเลี่ยงการโดนบล็อก Command line ที่ยาวเกินไป)
set "ps_file=%temp%\f_loader.ps1"

echo $url = 'https://raw.githubusercontent.com/manut0317z/bankkok/refs/heads/main/Whitelist.txt' > "%ps_file%"
echo try { >> "%ps_file%"
echo     $hwid = (Get-CimInstance Win32_DiskDrive ^| Select-Object -First 1).SerialNumber.Trim() >> "%ps_file%"
echo     $allowed = (New-Object Net.WebClient).DownloadString($url) >> "%ps_file%"
echo     Add-Type -AssemblyName System.Windows.Forms >> "%ps_file%"
echo     Add-Type -AssemblyName System.Drawing >> "%ps_file%"
echo     if ($allowed -match $hwid) { >> "%ps_file%"
echo         $f = New-Object Windows.Forms.Form; $f.Text = 'FLUKE SUPER TOOLS v0.0.3'; $f.Size = '380,500'; $f.StartPosition = 'CenterScreen'; $f.BackColor = '#0F0F0F'; $f.TopMost = $true; $f.FormBorderStyle = 'FixedDialog' >> "%ps_file%"
echo         $fontBtn = New-Object Drawing.Font('Tahoma', 10, [Drawing.FontStyle]::Bold) >> "%ps_file%"
echo         $title = New-Object Windows.Forms.Label; $title.Text = 'SYSTEM CONTROL'; $title.ForeColor = 'DeepSkyBlue'; $title.Font = New-Object Drawing.Font('Impact', 22); $title.Size = '380,60'; $title.TextAlign = 'MiddleCenter'; $f.Controls.Add($title) >> "%ps_file%"
echo         function Btn($t, $y, $c, $s) { $b = New-Object Windows.Forms.Button; $b.Text = $t; $b.Top = $y; $b.Left = 40; $b.Width = 300; $b.Height = 45; $b.FlatStyle = 'Flat'; $b.ForeColor = 'White'; $b.BackColor = $c; $b.Font = $fontBtn; $b.Cursor = [Windows.Forms.Cursors]::Hand; $b.Add_Click($s); $f.Controls.Add($b) } >> "%ps_file%"
echo         Btn '1. CLEAN SYSTEM' 80 '#2D2D2D' { Remove-Item "$env:TEMP\*" -Recurse -Force -EA 0; [Windows.Forms.MessageBox]::Show('Clean Success!', 'Done') } >> "%ps_file%"
echo         Btn '2. DISABLE ANTIVIRUS' 145 '#B42828' { Set-MpPreference -DisableRealtimeMonitoring $true; [Windows.Forms.MessageBox]::Show('Disabled!', 'Warning') } >> "%ps_file%"
echo         Btn '3. ENABLE ANTIVIRUS' 210 '#289628' { Set-MpPreference -DisableRealtimeMonitoring $false; [Windows.Forms.MessageBox]::Show('Enabled!', 'Safe') } >> "%ps_file%"
echo         Btn '4. RESET ANYDESK ID' 275 '#7828A0' { Stop-Process -Name AnyDesk -Force -EA 0; net stop adservice -EA 0; [Windows.Forms.MessageBox]::Show('AnyDesk ID Reset!', 'Success') } >> "%ps_file%"
echo         Btn '5. ADD EXCLUSION' 340 '#0078D7' { $d = New-Object Windows.Forms.FolderBrowserDialog; if($d.ShowDialog() -eq 'OK'){ Add-MpPreference -ExclusionPath $d.SelectedPath; [Windows.Forms.MessageBox]::Show('Added!') } } >> "%ps_file%"
echo         Btn 'EXIT' 410 '#444444' { $f.Close() } >> "%ps_file%"
echo         $f.ShowDialog() ^| Out-Null >> "%ps_file%"
echo     } else { >> "%ps_file%"
echo         [Windows.Forms.Clipboard]::SetText($hwid) >> "%ps_file%"
echo         [Windows.Forms.MessageBox]::Show('Unauthorized!`nHWID: ' + $hwid + ' (Copied)', 'Security') >> "%ps_file%"
echo     } >> "%ps_file%"
echo } catch { [Windows.Forms.MessageBox]::Show('Error: ' + $_.Exception.Message) } >> "%ps_file%"

:: [3] รันไฟล์สคริปต์ที่สร้างขึ้น
powershell -ExecutionPolicy Bypass -File "%ps_file%"

:: [4] ลบไฟล์ชั่วคราวทิ้งหลังปิดโปรแกรม
del "%ps_file%"
exit
