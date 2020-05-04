; click2nethesis ver. 2.1 - service
; sviluppato per AutoHotkey v1.1.32.00 (Unicode 64-bit)

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#include %A_ScriptDir%/JSON.ahk
ini=%A_AppData%\click2nethesis.ini ; C:\Users\...\AppData\Roaming

if FileExist(ini) {
    IniRead, mode, %ini%, settings, mode
    IniRead, hotkey, %ini%, settings, hotkey
    IniRead, username, %ini%, settings, username
    IniRead, password, %ini%, settings, password
    IniRead, url, %ini%, settings, url
    IniRead, extension, %ini%, settings, extension
    IniRead, yuser, %ini%, yealink, yuser
    IniRead, ypass, %ini%, yealink, ypass
} else {
    MsgBox Errore lettura %ini%
}

if !A_Args[1] {
	MsgBox Errore: numero di telefono mancante
} else {
	param := A_Args[1] ;Fetch the contents of the command line argument
	appurl := "sip://" ; This should be the URL Protocol that you registered in the Windows Registry
	IfInString, param, %appurl%
	{
		arglen := StrLen(param) ;Length of entire argument
		applen := StrLen(appurl) ;Length of appurl
		len := arglen - applen ;Length of argument less appurl
		StringRight, param, param, len ; Remove appurl portion from the beginning of parameter
	}
    
	param := StrReplace(param, "sip", "")
	param := StrReplace(param, ".", "")
	param := StrReplace(param, ":", "")
	param := StrReplace(param, "-", "")
	param := StrReplace(param, "/", "")
	param := StrReplace(param, "+39", "")
	
	if param is integer
	{
		MsgBox, 4, , Vuoi chiamare %param%?
		IfMsgBox, Yes
            if username && password && url
                Switch mode {
                    Case "2": ;NethCTI
                        Token := MakeLogin(username, password, url)
                        if(Token) {
                            MakeCall(param, username, Token, url)
                        } else {
                            TrayTip, click2nethesis, Erorre login impossibile ottenere il token, 10, 1
                        }
                        return
                    Case "3": ;Yealink
                        if extension {
                            Token := MakeLogin(username, password, url)
                            if(Token) {
                                ip := GetExtension(extension, username, Token, url)
                                if(ip) {                                
                                    Outgoing(yuser, ypass, ip, param, extension, url)
                                } else {
                                    TrayTip, click2nethesis, Errore CTI impossibile ottenere IP del telefono, 10, 1
                                }
                            } else {
                                TrayTip, click2nethesis, Erorre login impossibile ottenere il token, 10, 1
                            }
                        } else
                            TrayTip, click2nethesis, Extension non specificato, 10, 1
                        return
                    Default:
                        TrayTip, click2nethesis, Mode non supportato, 10, 1
                }
            else
                MsgBox Parametri mancanti
		IfMsgBox, No
			TrayTip, click2nethesis, Operazione annullata, 10, 1
	} else {
		TrayTip, click2nethesis, %param% non è un numero valido, 10, 2
	}
}

;; Funzioni
MakeLogin(username, password, url) {
    Output := Esegui("curl.exe --insecure -i -X POST -d username=" . Username . " -d password=" . Password . " https://" . Url . "/webrest/authentication/login")
    if(Output) {
        FoundPos := InStr(Output, "Digest")
        if(FoundPos) {
            FoundPos += 7
            Digest := StrReplace(SubStr(Output, FoundPos , 40), "`n")
            Token := Esegui("echo|set /p=""" . username . ":" . password . ":" . Digest . """ | openssl dgst -sha1 -hmac """ . password . """")
            Token := StrReplace(SubStr(Token,-40), "`n")
            Return Token
        } else {
            return false
        }
    } else {
        Return false
    }
}

MakeCall(number, username, token, url) {
	Command := "curl.exe --insecure --request POST --url https://" . Url . "/webrest/astproxy/call --header ""Authorization: " . Username . ":" . Token . """ --header ""content-type: multipart/form-data;"" --form number=" . number . ""
	RunWait, %ComSpec% /c %Command%,, Hide
}

GetExtension(extension, username, token, url) {
    Output := Esegui("curl.exe --insecure --url https://" . Url . "/webrest/astproxy/extension/" . Extension . " --header ""Authorization: " . Username . ":" . Token . """")
    if(Output) {
       MyJsonInstance := new JSON()
        JsonObject := MyJsonInstance.Load(Output)
        Return JsonObject["ip"]
    } else {
        Return false
    }
}

Outgoing(yuser, ypass, ip, number, extension, url) {
    Command := "curl.exe --insecure --url ""http://" . yuser . ":" . ypass . "@" . ip . "/servlet?key=number=" . number . "&outgoing_uri=" . Extension . "@" . Url . """"
    RunWait, %ComSpec% /c %Command%,, Hide
}

Esegui(params) {
	tmpFile := A_Temp . "\click2nethesis" . A_Index
	command := params . " > " . tmpFile
	RunWait, %ComSpec% /c %command%,, Hide

	if(FileExist(tmpFile)) {
		FileRead, response, % tmpFile
		if(response) {
			return %response%
		} else {
			return false
		}
	} else {
		return false
	}
}