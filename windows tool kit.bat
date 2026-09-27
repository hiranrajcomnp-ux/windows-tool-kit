@echo off
setlocal EnableExtensions EnableDelayedExpansion
title Windows Repair ^& Maintenance Toolbox
color 0A

:: ============================================================
:: WINDOWS REPAIR & MAINTENANCE TOOLBOX
:: WMIC-FREE - Uses PowerShell Get-CimInstance / modern commands
:: Designed for Windows 10/11
:: ============================================================

:: --- Request Administrator privileges ---
net session >nul 2>&1
if not "%errorlevel%"=="0" (
    echo.
    echo [!] Administrator privileges are required.
    echo [*] Relaunching as Administrator...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

set "REPORTDIR=%USERPROFILE%\Desktop\Windows_Toolbox_Reports"
if not exist "%REPORTDIR%" mkdir "%REPORTDIR%" >nul 2>&1

:MENU
cls
echo.
echo ============================================================
echo              WINDOWS REPAIR ^& MAINTENANCE TOOLBOX
echo ============================================================
echo                 WMIC-FREE / Windows 10/11
echo ============================================================
echo.
echo  [ 1] System Info
echo  [ 2] SFC Scan
echo  [ 3] SFC Verify Only
echo  [ 4] DISM Scan
echo  [ 5] DISM Repair
echo  [ 6] Component Cleanup
echo  [ 7] Drive Health ^(SMART/CIM^)
echo  [ 8] Reset TCP/IP
echo  [ 9] Reset Winsock
echo  [10] Performance Report
echo  [11] Battery Report
echo  [12] Flush DNS
echo  [13] WinRE Info
echo  [14] System Restore
echo  [15] Memory Diagnostic
echo  [16] Advanced Startup
echo  [17] Windows Update
echo  [18] Full Report
echo.
echo  ==================== ESSENTIAL TWEAKS ====================
echo  [19] Disable Transparency Effects
echo  [20] Check Windows Activation Status
echo  [21] Create System Restore Point
echo  [22] Show File Extensions
echo  [23] Show Hidden Files
echo  [24] Explorer Open to "This PC"
echo  [25] Set Visual Effects for Best Performance
echo  [26] Enable Dark Mode
echo.
echo  ======================== DEBLOAT =========================
echo  [27] List Installed Store ^(UWP^) Apps
echo  [28] Remove Common Bloatware Apps
echo  [29] Disable Cortana ^(Legacy Policy^)
echo  [30] Disable Windows Tips ^& Suggestions
echo.
echo  =================== ESSENTIAL SOFTWARE ===================
echo  [31] Install 7-Zip
echo  [32] Install Google Chrome
echo  [33] Install VLC Media Player
echo  [34] Install Notepad++
echo  [35] Custom Winget Install ^(Package ID^)
echo  [36] Update All Installed Apps
echo.
echo  ==================== SECURITY BASELINE ===================
echo  [37] Check BitLocker Status
echo  [38] Windows Firewall Status
echo  [39] Windows Defender Status
echo  [40] Check Windows Version
echo.
echo  [41] Open Reports Folder
echo  [42] Restart Windows Explorer
echo  [43] Open Command Prompt
echo  [44] Open PowerShell
echo.
echo  [Q] Exit
echo.
set /p "choice=Select an option: "

if /I "%choice%"=="1"  goto SYSTEMINFO
if /I "%choice%"=="2"  goto SFCSCAN
if /I "%choice%"=="3"  goto SFCVERIFY
if /I "%choice%"=="4"  goto DISMSCAN
if /I "%choice%"=="5"  goto DISMREPAIR
if /I "%choice%"=="6"  goto CLEANUP
if /I "%choice%"=="7"  goto DRIVEHEALTH
if /I "%choice%"=="8"  goto TCPIP
if /I "%choice%"=="9"  goto WINSOCK
if /I "%choice%"=="10" goto PERFORMANCE
if /I "%choice%"=="11" goto BATTERY
if /I "%choice%"=="12" goto FLUSHDNS
if /I "%choice%"=="13" goto WINRE
if /I "%choice%"=="14" goto SYSTEMRESTORE
if /I "%choice%"=="15" goto MEMORY
if /I "%choice%"=="16" goto ADVSTART
if /I "%choice%"=="17" goto UPDATE
if /I "%choice%"=="18" goto FULLREPORT
if /I "%choice%"=="19" goto TRANSPARENCY
if /I "%choice%"=="20" goto ACTIVATION
if /I "%choice%"=="21" goto CREATEPOINT
if /I "%choice%"=="22" goto EXTENSIONS
if /I "%choice%"=="23" goto HIDDENFILES
if /I "%choice%"=="24" goto THISTPC
if /I "%choice%"=="25" goto BESTPERFORMANCE
if /I "%choice%"=="26" goto DARKMODE
if /I "%choice%"=="27" goto LISTUWP
if /I "%choice%"=="28" goto DEBLOAT
if /I "%choice%"=="29" goto CORTANA
if /I "%choice%"=="30" goto TIPS
if /I "%choice%"=="31" goto INSTALL7ZIP
if /I "%choice%"=="32" goto INSTALLCHROME
if /I "%choice%"=="33" goto INSTALLVLC
if /I "%choice%"=="34" goto INSTALLNOTEPAD
if /I "%choice%"=="35" goto CUSTOMWINGET
if /I "%choice%"=="36" goto WINGETUPDATE
if /I "%choice%"=="37" goto BITLOCKER
if /I "%choice%"=="38" goto FIREWALL
if /I "%choice%"=="39" goto DEFENDER
if /I "%choice%"=="40" goto WINVERSION
if /I "%choice%"=="41" goto REPORTSFOLDER
if /I "%choice%"=="42" goto RESTARTEXPLORER
if /I "%choice%"=="43" goto OPENCMD
if /I "%choice%"=="44" goto OPENPOWERSHELL
if /I "%choice%"=="Q" goto EXIT

echo.
echo Invalid selection.
pause
goto MENU


:SYSTEMINFO
cls
echo ============================================================
echo SYSTEM INFORMATION
echo ============================================================
powershell -NoProfile -Command "$os=Get-CimInstance Win32_OperatingSystem; $cs=Get-CimInstance Win32_ComputerSystem; $cpu=Get-CimInstance Win32_Processor | Select-Object -First 1; Write-Host ('Computer Name : ' + $env:COMPUTERNAME); Write-Host ('Manufacturer  : ' + $cs.Manufacturer); Write-Host ('Model         : ' + $cs.Model); Write-Host ('CPU           : ' + $cpu.Name); Write-Host ('RAM           : ' + [math]::Round($cs.TotalPhysicalMemory/1GB,2) + ' GB'); Write-Host ('Windows       : ' + $os.Caption + ' ' + $os.Version); Write-Host ('Architecture  : ' + $os.OSArchitecture); Write-Host ('Install Date  : ' + $os.InstallDate); Write-Host ('Last Boot     : ' + $os.LastBootUpTime)"
pause
goto MENU


:SFCSCAN
cls
echo Running SFC /scannow...
sfc /scannow
pause
goto MENU

:SFCVERIFY
cls
echo Running SFC /verifyonly...
sfc /verifyonly
pause
goto MENU

:DISMSCAN
cls
echo Running DISM /ScanHealth...
DISM /Online /Cleanup-Image /ScanHealth
pause
goto MENU

:DISMREPAIR
cls
echo Running DISM /RestoreHealth...
DISM /Online /Cleanup-Image /RestoreHealth
echo.
echo Running SFC after DISM repair...
sfc /scannow
pause
goto MENU

:CLEANUP
cls
echo Cleaning the Windows component store...
DISM /Online /Cleanup-Image /StartComponentCleanup
pause
goto MENU

:DRIVEHEALTH
cls
echo ============================================================
echo DRIVE HEALTH - WMIC REPLACEMENT
echo ============================================================
echo.
echo Physical disk health:
powershell -NoProfile -Command "Get-PhysicalDisk | Select-Object FriendlyName,MediaType,BusType,HealthStatus,OperationalStatus,Size | Format-Table -AutoSize"
echo.
echo Disk drive information:
powershell -NoProfile -Command "Get-CimInstance Win32_DiskDrive | Select-Object Model,SerialNumber,InterfaceType,Status,@{N='SizeGB';E={[math]::Round($_.Size/1GB,2)}} | Format-Table -AutoSize"
echo.
echo Storage reliability counters ^(if supported by the drive^):
powershell -NoProfile -Command "Get-PhysicalDisk | ForEach-Object { try { Get-StorageReliabilityCounter -PhysicalDisk $_ -ErrorAction Stop | Select-Object DeviceId,Temperature,TemperatureMax,ReadErrorsTotal,WriteErrorsTotal,Wear,PowerOnHours | Format-Table -AutoSize } catch { Write-Host 'Reliability counters are not available for one or more drives.' } }"
pause
goto MENU

:TCPIP
cls
echo Resetting TCP/IP...
netsh int ip reset "%REPORTDIR%\tcpip_reset.txt"
echo.
echo TCP/IP reset completed. Restart Windows if prompted.
pause
goto MENU

:WINSOCK
cls
echo Resetting Winsock...
netsh winsock reset
pause
goto MENU

:PERFORMANCE
cls
echo ============================================================
echo PERFORMANCE REPORT
echo ============================================================
echo Creating power/energy report...
powercfg /energy /duration 60 /output "%REPORTDIR%\energy-report.html"
echo.
echo Creating system information report...
systeminfo > "%REPORTDIR%\systeminfo.txt"
echo.
echo Reports created in:
echo %REPORTDIR%
start "" "%REPORTDIR%"
pause
goto MENU

:BATTERY
cls
echo Creating battery report...
powercfg /batteryreport /output "%REPORTDIR%\battery-report.html"
echo.
echo Battery report:
echo %REPORTDIR%\battery-report.html
start "" "%REPORTDIR%\battery-report.html"
pause
goto MENU

:FLUSHDNS
cls
echo Flushing DNS cache...
ipconfig /flushdns
echo.
echo Current DNS cache has been flushed.
pause
goto MENU

:WINRE
cls
echo Windows Recovery Environment information:
reagentc /info
pause
goto MENU

:SYSTEMRESTORE
cls
echo ============================================================
echo SYSTEM RESTORE
echo ============================================================
echo Current restore-point configuration:
powershell -NoProfile -Command "Get-ComputerRestorePoint -ErrorAction SilentlyContinue | Select-Object SequenceNumber,Description,CreationTime | Format-Table -AutoSize"
echo.
echo Opening System Restore...
start "" rstrui.exe
pause
goto MENU

:MEMORY
cls
echo Opening Windows Memory Diagnostic...
start "" mdsched.exe
pause
goto MENU

:ADVSTART
cls
echo Windows will restart into Advanced Startup.
choice /C YN /M "Restart now"
if errorlevel 2 goto MENU
shutdown /r /o /t 0
goto EXIT

:UPDATE
cls
echo Opening Windows Update...
start "" ms-settings:windowsupdate
pause
goto MENU

:FULLREPORT
cls
echo ============================================================
echo CREATING FULL SYSTEM REPORT
echo ============================================================
echo Please wait...
systeminfo > "%REPORTDIR%\systeminfo.txt"
ipconfig /all > "%REPORTDIR%\ipconfig.txt"
driverquery /v > "%REPORTDIR%\drivers.txt"
netsh advfirewall show allprofiles > "%REPORTDIR%\firewall.txt"
reagentc /info > "%REPORTDIR%\winre.txt"
manage-bde -status > "%REPORTDIR%\bitlocker.txt" 2>&1
powershell -NoProfile -Command "Get-CimInstance Win32_Processor | Format-List *" > "%REPORTDIR%\cpu-cim.txt"
powershell -NoProfile -Command "Get-CimInstance Win32_ComputerSystem | Format-List *" > "%REPORTDIR%\computer-cim.txt"
powershell -NoProfile -Command "Get-CimInstance Win32_OperatingSystem | Format-List *" > "%REPORTDIR%\os-cim.txt"
powershell -NoProfile -Command "Get-CimInstance Win32_DiskDrive | Format-List *" > "%REPORTDIR%\disk-cim.txt"
powershell -NoProfile -Command "Get-PhysicalDisk | Format-List *" > "%REPORTDIR%\physical-disks.txt"
powercfg /batteryreport /output "%REPORTDIR%\battery-report.html" >nul
echo.
echo Full report created:
echo %REPORTDIR%
start "" "%REPORTDIR%"
pause
goto MENU

:TRANSPARENCY
cls
echo Disabling Windows transparency effects...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v EnableTransparency /t REG_DWORD /d 0 /f
echo Done. A sign-out or Explorer restart may be required.
pause
goto MENU

:ACTIVATION
cls
echo ============================================================
echo WINDOWS ACTIVATION STATUS
echo ============================================================
cscript //nologo "%SystemRoot%\System32\slmgr.vbs" /xpr
echo.
echo Detailed license information:
cscript //nologo "%SystemRoot%\System32\slmgr.vbs" /dlv
pause
goto MENU

:CREATEPOINT
cls
echo Creating System Restore Point...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Enable-ComputerRestore -Drive $env:SystemDrive -ErrorAction SilentlyContinue; Checkpoint-Computer -Description 'Windows Toolbox Restore Point' -RestorePointType 'MODIFY_SETTINGS'"
echo.
echo If successful, the restore point has been created.
pause
goto MENU

:EXTENSIONS
cls
echo Showing file extensions...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideFileExt /t REG_DWORD /d 0 /f
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe
pause
goto MENU

:HIDDENFILES
cls
echo Showing hidden files...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Hidden /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowSuperHidden /t REG_DWORD /d 1 /f
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe
pause
goto MENU

:THISTPC
cls
echo Setting File Explorer to open to This PC...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v LaunchTo /t REG_DWORD /d 1 /f
echo Done.
pause
goto MENU

:BESTPERFORMANCE
cls
echo Setting common Windows visual effects to Best Performance...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f
reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9012038010000000 /f
echo.
echo Applying the setting. Sign out/restart may be required.
pause
goto MENU

:DARKMODE
cls
echo Enabling Windows dark mode...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v AppsUseLightTheme /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v SystemUsesLightTheme /t REG_DWORD /d 0 /f
echo Done.
pause
goto MENU

:LISTUWP
cls
echo ============================================================
echo INSTALLED STORE/UWP APPS
echo ============================================================
powershell -NoProfile -Command "Get-AppxPackage | Sort-Object Name | Select-Object Name,Version | Format-Table -AutoSize"
pause
goto MENU

:DEBLOAT
cls
echo ============================================================
echo COMMON BLOATWARE REMOVAL
echo ============================================================
echo This removes selected apps for the CURRENT USER only.
echo Apps not installed are simply skipped.
echo.
choice /C YN /M "Continue"
if errorlevel 2 goto MENU
powershell -NoProfile -ExecutionPolicy Bypass -Command "$apps=@('Microsoft.3DBuilder','Microsoft.3DViewer','Microsoft.BingNews','Microsoft.BingWeather','Microsoft.GetHelp','Microsoft.Getstarted','Microsoft.MicrosoftOfficeHub','Microsoft.MicrosoftSolitaireCollection','Microsoft.People','Microsoft.SkypeApp','Microsoft.WindowsAlarms','Microsoft.WindowsCommunicationsApps','Microsoft.WindowsFeedbackHub','Microsoft.WindowsMaps','Microsoft.XboxApp','Microsoft.XboxGamingOverlay','Microsoft.XboxIdentityProvider','Microsoft.XboxSpeechToTextOverlay','Microsoft.ZuneMusic','Microsoft.ZuneVideo'); foreach($a in $apps){ Get-AppxPackage -Name $a -ErrorAction SilentlyContinue | Remove-AppxPackage -ErrorAction SilentlyContinue; Write-Host ('Processed: '+$a) }"
echo.
echo Note: Microsoft Store, Edge and core Windows components were not targeted.
pause
goto MENU

:CORTANA
cls
echo ============================================================
echo CORTANA LEGACY POLICY
echo ============================================================
echo On current Windows 11 builds, Cortana has been retired.
echo This policy is retained only for older Windows versions.
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f
echo Policy applied where supported.
pause
goto MENU

:TIPS
cls
echo Disabling Windows tips and suggestions...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338388Enabled /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338389Enabled /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-353694Enabled /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v ScoobeSystemSettingEnabled /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SoftLandingEnabled /t REG_DWORD /d 0 /f
echo Done.
pause
goto MENU

:INSTALL7ZIP
cls
echo Installing 7-Zip with Winget...
winget install --id 7zip.7zip -e --accept-source-agreements --accept-package-agreements
pause
goto MENU

:INSTALLCHROME
cls
echo Installing Google Chrome with Winget...
winget install --id Google.Chrome -e --accept-source-agreements --accept-package-agreements
pause
goto MENU

:INSTALLVLC
cls
echo Installing VLC Media Player with Winget...
winget install --id VideoLAN.VLC -e --accept-source-agreements --accept-package-agreements
pause
goto MENU

:INSTALLNOTEPAD
cls
echo Installing Notepad++ with Winget...
winget install --id Notepad++.Notepad++ -e --accept-source-agreements --accept-package-agreements
pause
goto MENU

:CUSTOMWINGET
cls
echo ============================================================
echo CUSTOM WINGET INSTALL
echo ============================================================
set "PKGID="
set /p "PKGID=Enter Winget Package ID: "
if not defined PKGID goto MENU
echo.
echo Installing: %PKGID%
winget install --id "%PKGID%" -e --accept-source-agreements --accept-package-agreements
pause
goto MENU

:WINGETUPDATE
cls
echo Updating all installed Winget packages...
winget upgrade --all --accept-source-agreements --accept-package-agreements
pause
goto MENU

:BITLOCKER
cls
echo ============================================================
echo BITLOCKER STATUS
echo ============================================================
manage-bde -status
echo.
echo PowerShell BitLocker information:
powershell -NoProfile -Command "Get-BitLockerVolume | Select-Object MountPoint,VolumeStatus,ProtectionStatus,EncryptionPercentage,EncryptionMethod | Format-Table -AutoSize"
pause
goto MENU

:FIREWALL
cls
echo ============================================================
echo WINDOWS FIREWALL STATUS
echo ============================================================
netsh advfirewall show allprofiles
pause
goto MENU

:DEFENDER
cls
echo ============================================================
echo MICROSOFT DEFENDER STATUS
echo ============================================================
powershell -NoProfile -Command "Get-MpComputerStatus | Select-Object AMServiceEnabled,AntivirusEnabled,AntispywareEnabled,RealTimeProtectionEnabled,BehaviorMonitorEnabled,IoavProtectionEnabled,NISEnabled | Format-List"
pause
goto MENU

:WINVERSION
cls
echo ============================================================
echo WINDOWS VERSION
echo ============================================================
powershell -NoProfile -Command "$o=Get-CimInstance Win32_OperatingSystem; $b=Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'; [PSCustomObject]@{Edition=$o.Caption;Version=$o.Version;Build=$o.BuildNumber;DisplayVersion=$b.DisplayVersion;UBR=$b.UBR;Architecture=$o.OSArchitecture} | Format-List"
pause
goto MENU

:REPORTSFOLDER
if not exist "%REPORTDIR%" mkdir "%REPORTDIR%" >nul 2>&1
start "" "%REPORTDIR%"
goto MENU

:RESTARTEXPLORER
cls
echo Restarting Windows Explorer...
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe
echo Done.
pause
goto MENU

:OPENCMD
start "" cmd.exe
goto MENU

:OPENPOWERSHELL
start "" powershell.exe
goto MENU

:EXIT
cls
echo.
echo Windows Toolbox closed.
echo.
endlocal
exit /b
