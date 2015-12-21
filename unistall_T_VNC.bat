ECHO OFF
REM Title:      UninstallVNC.cmd
REM Date:       2/29/2012
REM Author:     Gregory Strike
REM URL:        http://www.gregorystrike.com/2012/02/29/script-to-uninstallremove-vnc-passively/
REM
REM Purpose:    Script to remove VNC from a computer without user intervention.
REM
REM             This script should remove the following VNC servers:
REM                 UltraVNC Server
REM                 RealVNC Server
REM                 TightVNC Server
REM                 (Please submit requests for additional VNC Servers to the URL above)
REM
REM License:    This script is free to use given the following restrictions are followed.
REM             1. When used the Author and URL above must remain in place, unaltered.
REM             2. Do not publish the contents of this script anywhere. Instead a link 
REM                must be provided back to the URL listed above.
REM
REM Requires Administrative Privileges

@Title Removing VNC Installations...
CLS

REM Stop Any VNC Services
ECHO Stopping Services.
NET STOP winvnc
NET STOP WinVNC4
NET STOP uvnc_service
NET STOP tvnserver

REM Kill Any Possible Left Over VNC Processes
ECHO Killing any possibly left over VNC processes.
TASKKILL /F /IM winvnc.exe
TASKKILL /F /IM winvnc4.exe
TASKKILL /F /IM tvnserver.exe

REM Delete Any VNC Services
ECHO Deleteing Services.
SC DELETE winvnc
SC DELETE WinVNC4
SC DELETE uvnc_service
SC DELETE tvnserver

REM Removes Any VNC Registry Keys
ECHO Removing HKEY_CLASSES_ROOT VNC Keys.
REG DELETE HKCR\.vnc /F
REG DELETE HKCR\VNC.ConnectionInfo /F
REG DELETE HKCR\VncViewer.Config /F

ECHO Removing HKEY_LOCAL_MACHINE VNC Keys.
REG DELETE HKLM\SOFTWARE\UltraVNC /F
REG DELETE HKLM\SOFTWARE\ORL /F
REG DELETE HKLM\SOFTWARE\RealVNC /F
REG DELETE HKLM\SOFTWARE\TightVNC /F

REG DELETE HKLM\SOFTWARE\Classes\Installer\Products\0CFB0D2C777F7664EB43FDDA06450BC2 /F
REG DELETE HKLM\SOFTWARE\Classes\Installer\Features\0CFB0D2C777F7664EB43FDDA06450BC2 /F

FOR /F "skip=2 tokens=*" %%X IN ('REG QUERY HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\') DO (
	REG DELETE "%%X\Components\57C6E5345D210A44998842E79B5BAD50" /F
	REG DELETE "%%X\Components\60FC611B29478454B9CCC507AE31AB91" /F
	REG DELETE "%%X\Components\8760511C47B4A704098BDBBF6FABBA1E" /F
	REG DELETE "%%X\Components\C41D6780D95C7F941859343ED8BC9241" /F
	REG DELETE "%%X\Components\DED58383173414A4091F8D2048078A4C" /F
	REG DELETE "%%X\Components\E6202AA71864F884C81B002320BB0549" /F
	REG DELETE "%%X\Components\FC5DB5C3632BA7541A9675A1C82083A8" /F
	REG DELETE "%%X\Components\16D1756551A3EDC6E8F5B6FFA037594A" /F
	REG DELETE "%%X\Components\2145043942A6E4124023181E6B7FDBF6" /F
	REG DELETE "%%X\Components\231519E4B428507098D8223B3A0A8F96" /F	
	REG DELETE "%%X\Components\302B4E81CD72DE0B4F30CA2A3D6A4402" /F
	REG DELETE "%%X\Components\3D1E935A0099847E0B58B52CE24B589A" /F
	REG DELETE "%%X\Components\4BB1967F0DBB41EFAF7F4E9B5E5C5A24" /F
	REG DELETE "%%X\Components\4F9ECC71841010D31CAC655987A70628" /F
	REG DELETE "%%X\Components\531F2FBD7ECECDC7F6D67A9FCC8B942A" /F
	REG DELETE "%%X\Components\56FD6A56C21F936F424F73AE1B2E2B36" /F
	REG DELETE "%%X\Components\5878C68AAFC9FA10F0B4C6E8CA069047" /F
	REG DELETE "%%X\Components\5FD29712D83702BA4FCE0C96154D92C4" /F
	REG DELETE "%%X\Components\6B01529E7D5A5472649F01D30BC95E3A" /F
	REG DELETE "%%X\Components\7B6D9BB76DCB452B711C73C5A46F1B1B" /F
	REG DELETE "%%X\Components\7D296B2F4EB98AE91A0130F483557D6F" /F
	REG DELETE "%%X\Components\8F6AFAF4B2D541472FE33BCA458A141F" /F
	REG DELETE "%%X\Components\A318DADA61784AC25EC877CFFAECF3A4" /F
	REG DELETE "%%X\Components\AF07FC3002281089E82C09958495E1A4" /F
	REG DELETE "%%X\Components\C8948541143719FB0A313615829CF5A0" /F
	REG DELETE "%%X\Components\D439878C7F1352183C793E3D31D4A45D" /F
	REG DELETE "%%X\Components\E0AC44FD57660AA234EA024A277CAE3C" /F
	REG DELETE "%%X\Components\E2F011E639D0E9C6021B56BC9096CBD6" /F
	REG DELETE "%%X\Components\F77AC6157D51D1E3BD6343EA0E164BFA" /F
	
	REG DELETE "%%X\Products\0CFB0D2C777F7664EB43FDDA06450BC2" /F
	REG DELETE "%%X\Products\A133C5C86D79ED64FB4F4842DB608A88" /F
)

REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Management\ARPCache\RealVNC_is1" /F
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Management\ARPCache\TightVNC_is1" /F
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Management\ARPCache\Ultravnc2_is1" /F
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Management\ARPCache\WinVNC_is1" /F

REG DELETE HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{8C5C331A-97D6-46DE-BFF4-8424BD06A888} /F
REG DELETE HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{A8AD990E-355A-4413-8647-A9B168978423}_is1 /F
REG DELETE HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{C2D0BFC0-F777-4667-BE34-DFAD6054B02C} /F
REG DELETE HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Ultravnc2_is1 /F
REG DELETE HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\WinVNC_is1 /F
REG DELETE HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\RealVNC_is1 /F
REG DELETE HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\TightVNC_is1 /F
REG DELETE HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\TightVNC /F

REG DELETE HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v WinVNC /F
REG DELETE HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v tvncontrol /F

REM Removes entries from all control sets
ECHO Removing ControlSet VNC keys.
FOR /F "tokens=*" %%X IN ('REG QUERY HKLM\SYSTEM ^| FIND "ControlSet"') DO (
	ECHO %%X
	REG DELETE "%%X\Enum\Root\LEGACY_WINVNC" /F
	REG DELETE "%%X\Hardware Profiles\Current\System\CurrentControlSet\Services\vncdrv" /F
	REG DELETE "%%X\Services\winvnc" /F
	REG DELETE "%%X\Services\Eventlog\Application\WinVNC4" /F
	REG DELETE "%%X\Services\Eventlog\Application\UltraVnc" /F
	
	REG DELETE "%%X\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile\AuthorizedApplications\List" /V "C:\Program Files\TightVNC\tvnserver.exe" /F
	REG DELETE "%%X\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile\AuthorizedApplications\List" /V "C:\Program Files\TightVNC\vncviewer.exe" /F
	REG DELETE "%%X\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile\AuthorizedApplications\List" /V "C:\Program Files\UltraVNC\vncviewer.exe" /F
	REG DELETE "%%X\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile\AuthorizedApplications\List" /V "C:\Program Files\UltraVNC\winvnc.exe" /F
			
	REG DELETE "%%X\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile\AuthorizedApplications\List" /V "C:\Program Files\TightVNC\tvnserver.exe" /F
	REG DELETE "%%X\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile\AuthorizedApplications\List" /V "C:\Program Files\TightVNC\vncviewer.exe" /F
	REG DELETE "%%X\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile\AuthorizedApplications\List" /V "C:\Program Files\UltraVNC\vncviewer.exe" /F
	REG DELETE "%%X\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile\AuthorizedApplications\List" /V "C:\Program Files\UltraVNC\winvnc.exe" /F
		
	REG DELETE "%%X\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /V "{1F47EFAA-DD28-47CB-91B0-69E711BF1539}" /F
	REG DELETE "%%X\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /V "{29C8E0DE-9408-4E24-AA51-B8A258135D0A}" /F
	REG DELETE "%%X\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /V "{60AA5B63-27C2-4B88-BF81-9FED65C8E8C9}" /F
	REG DELETE "%%X\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /V "{68A8E22B-6189-413A-8509-9F08B8651FB9}" /F
	REG DELETE "%%X\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /V "{861F1EA6-034F-41E5-812B-EDED398FEBFC}" /F
	REG DELETE "%%X\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /V "{CF337EB1-940B-46C1-8FD7-1A76CBE9E63B}" /F
	
	REG DELETE "%%X\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile\GloballyOpenPorts\List" /V "5800:TCP" /F
	REG DELETE "%%X\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile\GloballyOpenPorts\List" /V "5900:TCP" /F
	
	REG DELETE "%%X\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile\GloballyOpenPorts\List" /V "5800:TCP" /F
	REG DELETE "%%X\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile\GloballyOpenPorts\List" /V "5900:TCP" /F	
)

REM Removes registry keys for any currently mounted user hives
ECHO Removing VNC keys from mounted user hives.
FOR /F "skip=2 tokens=*" %%X IN ('REG QUERY HKU') DO (
	REG DELETE "%%X\Software\Microsoft\Installer\Products\A133C5C86D79ED64FB4F4842DB608A88" /F
	REG DELETE "%%X\Software\ORL" /F
	
	REG DELETE "%%X\AppEvents\EventLabels\VNCviewerBell" /F
	REG DELETE "%%X\AppEvents\Schemes\Apps\VNCviewer" /F
)

REM For Pre Windows Vista
ECHO Deleteing VNC files from Pre-Vista profiles.
FOR /F "tokens=*" %%X IN ('DIR /B /AD "C:\Documents and Settings\"') DO (
	DEL /F /Q "C:\Documents and Settings\%%X\Desktop\UltraVNC Viewer.lnk"
	DEL /F /Q "C:\Documents and Settings\%%X\Desktop\UltraVNC Server.lnk"
	DEL /F /Q "C:\Documents and Settings\%%X\Desktop\UltraVNC Settings.lnk"
	DEL /F /Q "C:\Documents and Settings\%%X\Desktop\VNC Viewer.lnk"
	DEL /F /Q "C:\Documents and Settings\%%X\Start Menu\Programs\UltraVNC.lnk"
	DEL /F /Q "C:\Documents and Settings\%%X\Start Menu\Programs\UltraVNC Server.lnk"
	DEL /F /Q "C:\Documents and Settings\%%X\Start Menu\Programs\UltraVNC Viewer.lnk"
	DEL /F /Q "C:\Documents and Settings\%%X\Start Menu\Programs\UltraVNC Settings.lnk"
	
	RD /S /Q "C:\Documents and Settings\%%X\Start Menu\Programs\TightVNC" 
	RD /S /Q "C:\Documents and Settings\%%X\Start Menu\Programs\RealVNC" 
	RD /S /Q "C:\Documents and Settings\%%X\Start Menu\Programs\UltraVNC" 
)

REM For Vista and beyond
ECHO Deleteing VNC files from Post Vista profiles.
FOR /F "tokens=*" %%X IN ('DIR /B /AD "C:\Users\"') DO (
	DEL /F /Q "C:\Users\%%X\Desktop\UltraVNC Viewer.lnk"
	DEL /F /Q "C:\Users\%%X\Desktop\UltraVNC Server.lnk"
	DEL /F /Q "C:\Users\%%X\Desktop\UltraVNC Settings.lnk"
	DEL /F /Q "C:\Users\%%X\Desktop\VNC Viewer.lnk"
	DEL /F /Q "C:\Users\%%X\Start Menu\Programs\UltraVNC.lnk"
	DEL /F /Q "C:\Users\%%X\Start Menu\Programs\UltraVNC Server.lnk"
	DEL /F /Q "C:\Users\%%X\Start Menu\Programs\UltraVNC Viewer.lnk"
	DEL /F /Q "C:\Users\%%X\Start Menu\Programs\UltraVNC Settings.lnk"

	RD /S /Q "C:\Users\%%X\Start Menu\Programs\TightVNC" 
	RD /S /Q "C:\Users\%%X\Start Menu\Programs\RealVNC" 
	RD /S /Q "C:\Users\%%X\Start Menu\Programs\UltraVNC" 
)

REM 'All Users' of Vista and Beyond
ECHO Deleteing VNC files from ProgramData.
DEL /F /Q "C:\ProgramData\Desktop\UltraVNC Viewer.lnk"
DEL /F /Q "C:\ProgramData\Desktop\UltraVNC Server.lnk"
DEL /F /Q "C:\ProgramData\Desktop\UltraVNC Settings.lnk"
DEL /F /Q "C:\ProgramData\Desktop\VNC Viewer.lnk"
DEL /F /Q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\UltraVNC.lnk"
DEL /F /Q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\UltraVNC Server.lnk"
DEL /F /Q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\UltraVNC Viewer.lnk"
DEL /F /Q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\UltraVNC Settings.lnk"

RD /S /Q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\TightVNC" 
RD /S /Q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\RealVNC" 
RD /S /Q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\UltraVNC"

REM If running as a user with folder redirection
REM THIS WORKS IN MY ENVIRONMENT.  You may have to modify the locations.
ECHO Deleting VNC files from redirected folders.
DEL /F /Q "%HOMESHARE%\Desktop\UltraVNC Viewer.lnk"
DEL /F /Q "%HOMESHARE%\Desktop\UltraVNC Server.lnk"
DEL /F /Q "%HOMESHARE%\Desktop\UltraVNC Settings.lnk"
DEL /F /Q "%HOMESHARE%\Desktop\VNC Viewer.lnk"
DEL /F /Q "%HOMESHARE%\Start Menu\Programs\UltraVNC.lnk"
DEL /F /Q "%HOMESHARE%\Start Menu\Programs\UltraVNC Server.lnk"
DEL /F /Q "%HOMESHARE%\Start Menu\Programs\UltraVNC Viewer.lnk"
DEL /F /Q "%HOMESHARE%\Start Menu\Programs\UltraVNC Settings.lnk"

RD /S /Q "%HOMESHARE%\Start Menu\Programs\TightVNC" 
RD /S /Q "%HOMESHARE%\Start Menu\Programs\RealVNC" 
RD /S /Q "%HOMESHARE%\Start Menu\Programs\UltraVNC"

REM Removes VNC Files
ECHO Deleteing Program Files.
RD /S /Q "%ProgramFiles%\UltraVNC"
RD /S /Q "%ProgramFiles%\uvnc bvba"
RD /S /Q "%ProgramFiles%\RealVNC"
RD /S /Q "%ProgramFiles%\TightVNC"

RD /S /Q "%ProgramFiles% (x86)\UltraVNC"
RD /S /Q "%ProgramFiles% (x86)\uvnc bvba"
RD /S /Q "%ProgramFiles% (x86)\RealVNC"
RD /S /Q "%ProgramFiles% (x86)\TightVNC"