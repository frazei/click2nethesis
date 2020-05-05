# click2nethesis

click2nethesis is an application created to manage click2call functionality in Windows from user's extension using a Nethvoice (asterisk based) PBX, a softphone application or by dialing the number to a Yealink phone.

*Read this in other languages: [Italian](README.it.md), [English](README.md)*.

## Description
click2nethesis is designed to simplify the handling of an outgoing call from web applications or any program on your PC. It can be invoked using a URL "sip:" or "sip://" and also implements the ability to use a key (a "hotkey") to call the selected text directly (if it is a valid number).

The software, once installed, is executed at Windows start and always remains running.

To view the configuration GUI, you can right-click the icon in the taskbar and select "Open".

![la gui di click2nethesis](extra/screenshots/gui.PNG)

The software is designed to handle 3 separate cases:
* extension registered on a softphone (e.g. jitsi) installed on your PC
* NethCTI managed extension (inside browser)
* extension managed directly on a Yealink physical phone

## Installation
The software can be installed using the executable in the [Releases](https://github.com/frazei/click2nethesis/releases) section.

It must be installed with administrator rights (right-click on the installer and then "Run as Administrator").

Click "yes" when prompted to change to the Windows register.

![registro di sistema](extra/screenshots/registro.PNG)

This registry change simply inserts the program into autorun and associates it with the "sip:" urls. If another software is handling these urls (e.g. a softphone) that change will overwrite the previous assignment. Similarly, if an application that manages this protocol will be installed after click2nethesis, the allocation will be overwritten and you will have to re-assign it (see troubleshooting section).

## How to use it
Depending on the entry chosen by the select "Mode" there are 3 way to use this software. In all three cases, you can specify a "Hotkey", which is a key that can be pressed to dial the selected text (the phone number to call).

### Softphone
![softphone configuration](extra/screenshots/softphone.PNG)

In this case, you must specify the softphone executable (jitsi in the screenshot) to use to make the call.

In this case the system works as a "passthrough" allowing, compared to the use of jitsi alone, to use the hotkey function as well.

### NethCTI
In this case, you must specify the username and password used to access the CTI, the URL of the CTI itself, and the user's extension.

The call can then be handled in two ways:
* If the web CTI is open (in any browser and with the same user) the call will be taken from there;
* If the web CTI is closed the call will be forwarded to the first active device (for that user) in "predictive" mode.

### Yealink
![yealink configuration](extra/screenshots/yealink.PNG)

In this case, you must specify, in addition to the same parameters as the **NethCTI** section, the user and password must also be specified to access the Yealink phone (by default they are admin/admin).

Note that the IP address is greyed because it will be directly detected by the application if it's correctly registered on the PBX.

**Important: The phone must be on the same network as your PC.** The system does not work if the phone is on a different subnet or has a different netmask. It must also be configured to accept the "action URI" from the IP address of the PC or more generically from the network where the PC is located, as specified in these Yealink support pages:
* http://support.yealink.com/faq/faqInfo?id=173
* http://support.yealink.com/faq/faqInfo?id=565

## Saving and testing the configuration
The "SAVE" key saves the configuration to an .ini file while the "Test" key makes a test call and can be used to test the configurations "NethCTI" or "Yealink" while it does not work for "softphone" mode.

## Troubleshooting
The application saves its configurations in an ini file that can be inspected in case of problems with the save.
The file is located in: `C:\Users\...\AppData\Roaming\click2nethesis.ini`
If there are problems with the Windows registry configuration (which deals with the application's autorun and the association with the URL "sip:") you can manually write inside the Windows register using the following files: `C:\Program Files\click2nethesis\service.reg` and `C:\Program Files\click2nethesis\service_remove.reg`

## Uninstall
To uninstall the application use the executable `uninstaller.exe` which is located in the program installation folder `C:\Program Files\click2nethesis`.
When you're done, you can delete the folder.
