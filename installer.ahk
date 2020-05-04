; click2nethesis ver. 2.1 - service
; sviluppato per AutoHotkey v1.1.32.00 (Unicode 64-bit)

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

if not (A_IsAdmin) {
	MsgBox Questo programma deve essere eseguito come amministratore
	ExitApp
}

FileCreateDir, %a_ProgramFiles%\click2nethesis
FileInstall, click2nethesis.exe, %a_ProgramFiles%\click2nethesis\click2nethesis.exe, 1
FileInstall, service.exe, %a_ProgramFiles%\click2nethesis\service.exe, 1
FileInstall, service.reg, %a_ProgramFiles%\click2nethesis\service.reg, 1
FileInstall, service_remove.reg, %a_ProgramFiles%\click2nethesis\service_remove.reg, 1
;FileInstall, autorun.reg, %a_ProgramFiles%\click2nethesis\autorun.reg, 1
;FileInstall, autorun_remove.reg, %a_ProgramFiles%\click2nethesis\autorun_remove.reg, 1
FileInstall, curl.exe, %a_ProgramFiles%\click2nethesis\curl.exe, 1
FileInstall, openssl.exe, %a_ProgramFiles%\click2nethesis\openssl.exe, 1
FileInstall, libeay32.dll, %a_ProgramFiles%\click2nethesis\libeay32.dll, 1
FileInstall, ssleay32.dll, %a_ProgramFiles%\click2nethesis\ssleay32.dll, 1
FileInstall, click2nethesis.ico, %a_ProgramFiles%\click2nethesis\click2nethesis.ico, 1
FileInstall, uninstaller.exe, %a_ProgramFiles%\click2nethesis\uninstaller.exe, 1
FileCreateShortcut, %a_ProgramFiles%\click2nethesis\click2nethesis.exe, %A_ProgramsCommon%\click2nethesis.lnk
IniWrite, %A_Now%, %A_AppData%\click2nethesis.ini, installed

RunWait, %a_ProgramFiles%\click2nethesis\service.reg

MsgBox Click2Nethesis correttamente installato!

Run, %a_ProgramFiles%\click2nethesis\click2nethesis.exe