@echo off

REG DELETE HKCR\Installer\Features\D2346819BA0363D4892E26D4E8EE2447 /f

REG DELETE HKCR\Installer\Products\D2346819BA0363D4892E26D4E8EE2447 /f

REG DELETE HKLM\SOFTWARE\Classes\Installer\Features\D2346819BA0363D4892E26D4E8EE2447 /f

REG DELETE HKLM\SOFTWARE\Classes\Installer\Products\D2346819BA0363D4892E26D4E8EE2447 /f