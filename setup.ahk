
;###########################################################
;	INITIAL SCRIPT SETTINGS
;###########################################################


#SingleInstance, force
SetWorkingDir %A_ScriptDir%
Menu, Tray, Icon , images\2hol_icon.ico


;###########################################################
;	GLOBAL VARIABLES
;###########################################################


mainFilePath := A_ScriptDir . "\2HOL Helper.exe"
shortcutsFolderPath := A_ScriptDir . "\shortcuts\OneLife.lnk"
gameFolderPath := ""
oneLifePath := ""


;###########################################################
;	CONNECT TO 2HOL FOLDER AND CREATE SHORTCUT
;###########################################################



; Pull 2HOL game location information
FileSelectFolder, gameFolderPath,,, Please select your 2HOL game folder (the folder that contains your "OneLife.exe" file.)
oneLifePath := gameFolderPath . "\OneLife.exe"

; Create shortcut to game file
FileCreateShortcut, %oneLifePath%, %shortcutsFolderPath%, %gameFolderPath%

; Write changes to Config file
IniWrite, true, Config.ini, Config, installed
IniWrite, %gameFolderPath%, config.ini, Config, gameFolderPath



; ##########################################################
;	CREATE SHORTCUTS MAIN GUI CREATION
; ##########################################################



; Prompt user to create desktop and start menu shortcuts

Gui, Shortcuts:Font, s11 bold underline, Veranda
Gui, Shortcuts:Add, Text, center x20, Create Shortcuts
Gui, Shortcuts:Font, s11 normal, Veranda
Gui, Shortcuts:Add, CheckBox, vcheckCreateDesktopShortcut, Desktop shortcut
Gui, Shortcuts:Add, CheckBox, vcheckCreateStartMenuShortcut, Start Menu shortcut


Gui, shortcuts:Add, Button, gFinish_btnHandle, Finish
Gui, shortcuts:Show, xCenter yCenter w200, Setup




;###########################################################
;	HOTKEYS
;###########################################################


; BLANK HOTKEY (PREVENTS LABELS BELOW FROM EXECUTING)
#IfWinActive, Setup
~Enter::
Return
#IfWinActive



;###########################################################
;	BUTTON HANDLER SUBROUTINE LABELS (NEED HOTKEYS ABOVE TO STOP FLOW)
;###########################################################



Finish_btnHandle:
Gui, Shortcuts:Submit, NoHide

if (checkCreateDesktopShortcut == 1){
	createProgramShortcut(A_Desktop)
	IniWrite, true, Config.ini, Config, desktopShortcut
}
if (checkCreateStartMenuShortcut == 1){
	createProgramShortcut(A_Programs)
	IniWrite, true, Config.ini, Config, startMenuShortcut
}
Gui, Shortcuts:Hide
Gui, Shortcuts:Destroy
MsgBox, Setup complete!`n`nWhen you want to play simply open the `"2HOL Helper.exe`" file. Enjoy :)`n`nYou may want to check out the settings to make the sure they work for you (particularly the timer position).
ExitApp
Return


;###########################################################
;	SETUP FUNCTIONS
;###########################################################


createProgramShortcut(locationPath){	
	global mainFilePath
	newShortcutPath := locationPath . "\2HOL Helper.lnk"
	FileCreateShortcut, %mainFilePath%, %newShortcutPath%, %A_ScriptDir%
}

; ##########################################################
; MAIN CLOSING PROCEDURES
; ##########################################################


ShortcutsGuiClose()
{
	ExitApp
}