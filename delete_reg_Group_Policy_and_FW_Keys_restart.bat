


@echo off

REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy" /f
REG DELETE HKCR\Installer\Features\FA8C8A48802DD634280D9C6679D4A7AE /f

REG DELETE HKCR\Installer\Products\FA8C8A48802DD634280D9C6679D4A7AE /f

REG DELETE HKLM\SOFTWARE\Classes\Installer\Features\FA8C8A48802DD634280D9C6679D4A7AE /f

REG DELETE HKLM\SOFTWARE\Classes\Installer\Products\FA8C8A48802DD634280D9C6679D4A7AE /f
shutdown.exe /r /t 00                                                                               AE /f

REG DELETE HKLM\SOFTWARE\Classes\Installer\Products\FA8C8A48802DD634280D9C6679D4A7AE /f
shutdown.exe /r /t 00