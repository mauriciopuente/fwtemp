@echo off

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v AutoConfigURL /t REG_SZ /d "http://pac.zscaler.net/stjschools.org/sslproxysettings.pac" /f



