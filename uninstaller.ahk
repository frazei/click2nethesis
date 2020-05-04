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

;RunWait, %a_ProgramFiles%\click2nethesis\autorun_remove.reg
RunWait, %a_ProgramFiles%\click2nethesis\service_remove.reg

FileRemoveDir, %a_ProgramFiles%\click2nethesis, 1
FileDelete, %A_AppData%\click2nethesis.ini

MsgBox Click2Nethesis correttamente rimosso!