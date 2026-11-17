@echo off
chcp 65001 >nul
setlocal
cd /d "%~dp0"
echo ============================================================================
echo [S9.9] 正在解除 Windows 封鎖並啟動《廠商請款資料》NAS x 雲端三維同步與 24:00 排程設定...
echo ============================================================================
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '%~dp0*.ps1' | Unblock-File -ErrorAction SilentlyContinue"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0sync_nas_vendor_billing_2400_s98.ps1" -RegisterTask
endlocal
