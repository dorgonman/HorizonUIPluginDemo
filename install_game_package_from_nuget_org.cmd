@ECHO OFF
REM PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& '%~dpn0.ps1'"
PowerShell -NoProfile -Command "& {Start-Process -Wait PowerShell.exe -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%~dpn0.ps1""' -Verb RunAs}"

where sh
sh %~dpn0.sh


pause