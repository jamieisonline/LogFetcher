REM filepath: logfetcher/LogFetch.bat
@echo off
setlocal
:: LogFetch.bat
:: This script fetches system information and critical event logs, saves them to a file on the user's desktop.

:: Get current user's desktop path
for /f "tokens=2,*" %%a in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v Desktop 2^>nul') do set "desktopPath=%%b"

:: Set output file path to Desktop
set "outputFile=%desktopPath%\system_errors.txt"

echo.
echo.
echo.
echo -----------------------------------------
echo              System Info
echo -----------------------------------------
systeminfo | findstr /B /C:"Host Name" /C:"OS Name" /C:"OS Version" /C:"System Type" /C:"Total Physical Memory" /C:"Available Physical Memory" /C:"Processor(s)"
echo.
echo.
echo.
echo ========================================
echo       Error/Critical Events Log
echo ========================================
echo Exporting to: %outputFile%
echo.

:: Export System log errors and critical events to file
wevtutil qe System /q:"*[System[(Level=1 or Level=2)]]" /f:text > "%outputFile%"

:: Ask user if they want to display contents
set /p showLog=Do you want to display critical logs in this terminal? (Y/N): 
if /I "%showLog%"=="Y" (
    findstr /C:"Level: Critical" "%outputFile%" >nul
    if %errorlevel%==0 (
        echo --- Displaying Critical Events ---
        findstr /C:"Level: Critical" "%outputFile%"
    ) else (
        echo No critical events 
    )
) else (
    echo skipped log display 
)

echo.
echo Full log saved to: %outputFile%
pause