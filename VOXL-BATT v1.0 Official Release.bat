@echo off
net session >nul 2>&1
if %errorLevel% neq 0 (
    PowerShell Start -Verb RunAs '%0' -ArgumentList '"%CD%"'
    exit /b
)


title VOXL-BATT 1.0
color 2F
echo Yb    dP  dP"Yb  Yb  dP 88              88""Yb    db    888888 888888 
echo  Yb  dP  dP   Yb  YbdP  88     ________ 88__dP   dPYb     88     88   
echo   YbdP   Yb   dP  dPYb  88  .o """""""" 88""Yb  dP__Yb    88     88   
echo    YP     YbodP  dP  Yb 88ood8          88oodP dP""""Yb   88     88                                            
echo ---------------------------------------------------------------------
echo Thanks for using VOXL-BATT 1.0! - (c) 2025 Voxelapp Software
echo Link: https://github.com/Voxelapp-Software/voxl-batt
echo.
setlocal EnableDelayedExpansion


for /f "delims=" %%I in ('powershell -Command "Get-CimInstance -ClassName Win32_Battery | Select-Object -ExpandProperty BatteryStatus"') do (
    set BatteryStatus=%%I
)


if "!BatteryStatus!" equ "2" (
    set BatteryStatus=Charging
) else if "!BatteryStatus!" equ "1" (
    set BatteryStatus=Discharging
) else (
    set BatteryStatus=Unknown
)


for /f "delims=" %%I in ('powershell -Command "Get-CimInstance -ClassName Win32_Battery | Select-Object -ExpandProperty EstimatedChargeRemaining"') do (
    set BatteryLevel=%%I
)

echo ooooooooooooooooooooooooooooooooooo
echo o Battery Status: !BatteryStatus! 
echo o Battery Level: !BatteryLevel!%% 
echo ooooooooooooooooooooooooooooooooooo
echo.

set /p Confirm=Do you want to proceed with generating a battery report? (Y/N): 
if /i "!Confirm!" neq "Y" goto :eof


set /p SaveDir=Enter the directory to save the report (leave blank for C:): 
if "!SaveDir!"=="" set SaveDir=C:
if not exist "!SaveDir!\" (
    echo Invalid directory. Defaulting to C:\
    set SaveDir=C:
)


powercfg /batteryreport /output "!SaveDir!\battery_report.html"
echo ooooooo
echo Done. o
echo ooooooo


set /p ConfirmLocation=Do you want to open the directory of the saved report? (Y/N): 
if /i "!ConfirmLocation!" equ "Y" (
    start explorer "!SaveDir!"
)

pause