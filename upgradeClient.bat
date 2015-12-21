@echo off
set /a count=0
taskkill /F /IM fwGUI.exe > NUL

:stopservice
set /a count+=1
if %count% EQU 40 exit /B 2
sc stop FileWaveWinClient
timeout /t 2 /nobreak >NUL
SC query FileWaveWinClient | FIND "STATE" | FIND "STOPPED" >NUL
IF errorlevel 1 GOTO stopservice


:deletingpid
set /a count+=1
if %count% EQU 80 goto exit /B 3
timeout /t 2 /nobreak >NUL
del /f %ProgramData%\FileWave\FWClient\fwcld.pid > NUL
IF exist %ProgramData%\FileWave\FWClient\fwcld.pid GOTO deletingpid


start /wait msiexec /qn /norestart /i C:\temp\FileWaveClient.msi > NUL

del "c:\temp\FileWaveClient.msi" > NUL
del "c:\temp\scheduleRestart.bat" > NUL
del "c:\temp\FileWave Client Upgrade.xml" > NUL
del %0 > NUL