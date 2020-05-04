; click2nethesis ver. 2.1
; sviluppato per AutoHotkey v1.1.32.00 (Unicode 64-bit)

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance
#Persistent

#include %A_ScriptDir%/JSON.ahk
ini=%A_AppData%\click2nethesis.ini ; C:\Users\...\AppData\Roaming

if FileExist(ini) {
    IniRead, mode, %ini%, settings, mode, %A_Space%
    IniRead, hotkey, %ini%, settings, hotkey, F11
    ;IniRead, service, %ini%, settings, service, %A_Space%
    ;IniRead, autorun, %ini%, settings, autorun, %A_Space%
    IniRead, softphone, %ini%, settings, softphone, %A_Space%
    IniRead, username, %ini%, settings, username, %A_Space%
    IniRead, password, %ini%, settings, password, %A_Space%
    IniRead, url, %ini%, settings, url, %A_Space%
    IniRead, extension, %ini%, settings, extension, %A_Space%
    IniRead, yuser, %ini%, yealink, yuser, %A_Space%
    IniRead, ypass, %ini%, yealink, ypass, %A_Space%
} else {
    ;MsgBox, 48,, Errore lettura %ini%
    TrayTip,,click2nethesis: no config to load,2,1
}

;Menu, Tray, Icon, %a_ProgramFiles%\click2nethesis\click2nethesis.ico
Menu, Tray, NoStandard
Menu, Tray, Add, Open, Open
Menu, Tray, Add, Exit, Exit
Gosub, setHotkey
TrayTip,,click2nethesis is active,2,1

return

Open:
    Gui +LastFoundExist
    ;; Settings
    Gui Add, GroupBox, x10 y8 w458 h115, Settings ;y+8
    Gui Add, Text, x25 y28 w80, Mode ;y+20
    Gui Add, DropDownList, x115 y25 w330 vMode Choose%Mode% AltSubmit gModeChange, Softphone|NethCTI|Yealink ;y-3
    Gui Add, Text, x25 y53 w80, Hotkey ;y+25
    Gui Add, Hotkey, x115 y50 w330 h20 vHotkey, %hotkey% ;y-3
    Gui Add, Text, x25 y78 w80, Softphone ;y+25
    Gui Add, Button, x115 y75 w70 h20 vSelectSoftphone gSelectSoftphone, Select...
    Gui Add, Edit, x195 y75 w250 h20 vSoftphone, %softphone%
    ;Gui Add, Text, x25 y78 w80, Options ;y+25
    ;Gui Add, CheckBox, x115 y75 w330 h20 vService %service%, Associa al protocollo sip:// ;y-3
    ;Gui Add, CheckBox, x115 y95 w330 h20 vAutorun %autorun%, Avvio automatico ;y+20
    ;; NethCTI
    Gui Add, GroupBox, x10 y128 w458 h78, NethCTI ;y=+33
    Gui Add, Text, x25 y148 w80, Username ;y+20
    Gui Add, Edit, x115 y145 w330 h20 r1 vUsername, %username% ;y-3
    Gui Add, Text, x25 y178 w80, Password ;y+25
    Gui Add, Edit, x115 y175 w330 h20 r1 vPassword, %password% ;y-3
    ;; Asterisk
    Gui Add, GroupBox, x10 y210 w458 h75, Asterisk ;y+38
    Gui Add, Text, x25 y233 w80, Url ;y+20
    Gui Add, Text, x115 y233 w40, https://
    Gui Add, Edit, x155 y230 w290 h20 r1 vUrl, %url% ;y-3
    Gui Add, Text, x25 y258 w80, Extension ;y+25
    Gui Add, Edit, x115 y255 w330 h20 r1 vExtension, %extension% ;y-3
    ;; Yealink
    Gui Add, GroupBox, x10 y290 w458 h100, Yealink ;y+38
    Gui Add, Text, x25 y313 w80, User ;y+20
    Gui Add, Edit, x115 y310 w330 h20 r1 vYuser, %yuser% ;y-3
    Gui Add, Text, x25 y338 w80, Password ;y+25
    Gui Add, Edit, x115 y335 w330 h20 r1 vYpass, %ypass% ;y-3
    Gui Add, Text, x25 y363 w80, IP ;y+25
    Gui Add, Edit, x115 y360 w330 h20 r1 +Disabled vYIP, 0.0.0.0 ;y-3
    ;; Button
    Gui Add, Button, x140 y400 w100 h30 vSalva gSalva, Save
    Gui Add, Button, x240 y400 w100 h30 vProva gProva, Test
    ;; Debug
    Gui, Add, Edit, x10 y440 w460 h140 vDebug, Debug

    Gui Add, StatusBar,, click2nethesis ver. 2.0 by RXW
    Gui Show, h620 w480, click2nethesis
    GoSub, ModeChange
return

;; Subrutines (identificate dalla "g" prima del nome)
ModeChange:
    GuiControlGet, Mode
    Switch mode {
        Case "1": ;Softphone
            GuiControl Enable, Hotkey
            GuiControl Enable, SelectSoftphone
            GuiControl Enable, Softphone
            ;service = 0
            ;GuiControl, , Service, %service%
            GuiControl Disable, Username
            GuiControl Disable, Password
            GuiControl Disable, Url
            GuiControl Disable, Extension
            GuiControl Disable, YUser
            GuiControl Disable, YPass
            GuiControl Enable, Salva
            GuiControl Disable, Prova
        Case "2": ;NethCTI
            GuiControl Enable, Hotkey
            GuiControl Disable, SelectSoftphone
            GuiControl Disable, Softphone
            GuiControl Enable, Username
            GuiControl Enable, Password
            GuiControl Enable, Url
            GuiControl Enable, Extension
            GuiControl Disable, YUser
            GuiControl Disable, YPass
            GuiControl Enable, Salva
            GuiControl Enable, Prova
        Case "3": ;Yealink
            GuiControl Enable, Hotkey
            GuiControl Disable, SelectSoftphone
            GuiControl Disable, Softphone
            GuiControl Enable, Username
            GuiControl Enable, Password
            GuiControl Enable, Url
            GuiControl Enable, Extension
            GuiControl Enable, YUser
            GuiControl Enable, YPass
            GuiControl Enable, Salva
            GuiControl Enable, Prova
        Default:
            GuiControl Disable, Hotkey
            GuiControl Disable, SelectSoftphone
            GuiControl Disable, Softphone
            GuiControl Disable, Username
            GuiControl Disable, Password
            GuiControl Disable, Url
            GuiControl Disable, Extension
            GuiControl Disable, YUser
            GuiControl Disable, YPass
            GuiControl Disable, Salva
            GuiControl Disable, Prova
    }
return

SelectSoftphone:
    FileSelectFile, SelectedFile, 3, , Open a file, Text Executable (*.exe; *.bat)
    ;if (SelectedFile = "")
    ;    MsgBox, The user didn't select anything.
    ;else
    ;    MsgBox, The user selected the following:`n%SelectedFile%
    GuiControl, , Softphone, %SelectedFile%
return

Salva:
    ;mode
    GuiControlGet, Mode
    IniWrite, %Mode%, %A_AppData%\click2nethesis.ini, settings, mode
    ;hotkey
    GuiControlGet, Hotkey
    IniWrite, %Hotkey%, %A_AppData%\click2nethesis.ini, settings, hotkey
    ;softphone
    GuiControlGet, Softphone
    IniWrite, %Softphone%, %A_AppData%\click2nethesis.ini, settings, softphone
    ;username
    GuiControlGet, Username
	IniWrite, %Username%, %A_AppData%\click2nethesis.ini, settings, username
	;password
    GuiControlGet, Password
	IniWrite, %Password%, %A_AppData%\click2nethesis.ini, settings, password
	;url
    GuiControlGet, Url
	IniWrite, %Url%, %A_AppData%\click2nethesis.ini, settings, url
    ;extension
    GuiControlGet, Extension
    IniWrite, %Extension%, %A_AppData%\click2nethesis.ini, settings, extension
    ;yealink user
    GuiControlGet, Yuser
    IniWrite, %Yuser%, %A_AppData%\click2nethesis.ini, yealink, yuser
    ;yealink password
    GuiControlGet, Ypass
    IniWrite, %Ypass%, %A_AppData%\click2nethesis.ini, yealink, ypass
    
    MsgBox, 64,, Salvato in %A_AppData%\click2nethesis.ini
return

Prova:
    GuiControlGet, Mode
    GuiControlGet, Hotkey
    GuiControlGet, Username
    GuiControlGet, Password
    GuiControlGet, Url
    GuiControlGet, Extension
    GuiControlGet, Yuser
    GuiControlGet, Ypass
    
    if username && password && url
        Switch mode {
            Case "2": ;NethCTI
                Token := MakeLogin(username, password, url)
                if(Token) {
                    MakeCall("*43", username, Token, url)
                } else {
                    MsgBox, 48,, Errore login impossibile ottenere il token
                }
                return
            Case "3": ;Yealink
                if extension {
                    Token := MakeLogin(username, password, url)
                    if(Token) {
                        ip := GetExtension(extension, username, Token, url)
                        GuiControl,, YIP, %ip%
                        if(ip) {                                
                            Outgoing(yuser, ypass, ip, "*43", extension, url)
                        } else {
                            MsgBox, 48,, Errore CTI impossibile ottenere IP del telefono
                        }
                    } else {
                        MsgBox, 48,, Errore login impossibile ottenere il token
                    }
                } else
                    MsgBox, 48,, Extension non specificato
                return
            Default:
                MsgBox, 48,, Mode non supportato
        }
    else
        MsgBox, 48,, Parametri mancanti
return

;; Funzioni
MakeLogin(username, password, url) {
    Output := Esegui("curl.exe --insecure -i -X POST -d username=" . Username . " -d password=" . Password . " https://" . Url . "/webrest/authentication/login")
    if(Output) {
        LogDebug(Output)
        FoundPos := InStr(Output, "Digest")
        if(FoundPos) {
            FoundPos += 7
            Digest := StrReplace(SubStr(Output, FoundPos , 40), "`n")
            LogDebug("Digest = " . Digest)
            Token := Esegui("echo|set /p=""" . username . ":" . password . ":" . Digest . """ | openssl dgst -sha1 -hmac """ . password . """")
            Token := StrReplace(SubStr(Token,-40), "`n")
            LogDebug("Token = " . Token)
            return Token
        } else {
            return false
        }
    } else {
        return false
    }
}

MakeCall(number, username, token, url) {
	Command := "curl.exe --insecure --request POST --url https://" . Url . "/webrest/astproxy/call --header ""Authorization: " . Username . ":" . Token . """ --header ""content-type: multipart/form-data;"" --form number=" . number . ""
	LogDebug(Command)
	RunWait, %ComSpec% /c %Command%,, Hide
    return
}

GetExtension(extension, username, token, url) {
    Output := Esegui("curl.exe --insecure --url https://" . Url . "/webrest/astproxy/extension/" . Extension . " --header ""Authorization: " . Username . ":" . Token . """")
    if(Output) {
       MyJsonInstance := new JSON()
        JsonObject := MyJsonInstance.Load(Output)
        return JsonObject["ip"]
    } else {
        return false
    }
}

Outgoing(yuser, ypass, ip, number, extension, url) {
    Command := "curl.exe --insecure --url ""http://" . yuser . ":" . ypass . "@" . ip . "/servlet?key=number=" . number . "&outgoing_uri=" . Extension . "@" . Url . """"
    LogDebug(Command)
    RunWait, %ComSpec% /c %Command%,, Hide
    return
}

LogDebug(text) {
	GuiControlGet, Debug
	GuiControl,, Debug, %Debug%`r`n%text%
    return
}

RunWaitOne(command) {
    ; WshShell object: http://msdn.microsoft.com/en-us/library/aew9yb99
    shell := ComObjCreate("WScript.Shell")
    ; Execute a single command via cmd.exe
    exec := shell.Exec(ComSpec " /C " command)
    ; Read and return the command's output
    return exec.StdOut.ReadAll()
}

Esegui(params) {
	tmpFile := A_Temp . "\click2nethesis" . A_Index
	command := params . " > " . tmpFile
	LogDebug(command)
	RunWait, %ComSpec% /c %command%,, Hide

	if(FileExist(tmpFile)) {
		FileRead, response, % tmpFile
		if(response) {
			;MsgBox %response%
			return %response%
		} else {
			;MsgBox no response
			return false
		}
	} else {
		MsgBox, 48,, file not exist
		return false
	}
}

click2call:
    WinActive("A") ; sets last found window
    ControlGetFocus, ctrl

    ;;;;;; salvo il contenuto della clipboard
    clipboardTmp := Clipboard
    ;;;;; prendo il testo selezionato
    Send, ^c

    ;;;;; se sono connesso con citrix aspetto un po'
    if WinActive("ahk_exe CDViewer.exe")
        sleep, 500
    selected := Clipboard
    ;;;;;; ripristino il contenuto della clipboard
    Clipboard := clipboardTmp

    ;;;;;; rimuovo gli spazi
    StringReplace, number, selected, %A_SPACE%, , All

    if number is integer
    {
        Switch mode {
            Case "1": ;Softphone
                Run, %Softphone% sip://%number%
            Default:
                Run, %a_ProgramFiles%\click2nethesis\service.exe %number%
        }
    } else {
        TrayTip, Click2Call, La selezione "%selected%" non e' numero valido, 10, 2
    }
return

setHotkey:
    if hotkey {
        Hotkey, %hotkey%, click2call
    } else {
        MsgBox, 48,, Hotkey non impostato
    }
return

Exit:
  ExitApp
return

GuiClose:
    Gui, Destroy
    Gosub, setHotkey
    TrayTip,,click2nethesis is active,2,1
return

;!r::Reload ; ALT+R Reload for debugging