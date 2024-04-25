
;###########################################################
;	INITIAL SCRIPT SETTINGS
;###########################################################


#SingleInstance, force
SetWorkingDir %A_ScriptDir%
Menu, Tray, NoIcon


;###########################################################
;	GLOBAL VARIABLES
;###########################################################


; capture calling script from the first passed in param
callingScriptName = %1%

settingsFile := "settings.ini"
configFile := "config.ini"
; variables here


; Setting INI file identifiers
setting_secA_iniName := "General"
setting_A1_iniKey := "sound_enabled"
setting_A2_iniKey := "sound_file"
setting_A3_iniKey := "sound_volume"

setting_secB_iniName := "Position"
setting_B1_iniKey := "timer_x"
setting_B2_iniKey := "timer_y"



; Set GUI edit variables
; Edit ids are always set to "EditX" where X is the Nth Edit
setting_A1_edit := "Edit1"
setting_A2_edit := "Edit2"
setting_A3_edit := "Edit3"

setting_B1_edit := "Edit4"
setting_B2_edit := "Edit5"


; Window layout spacing variables
col_1_w := 200

col_2_x := 110
col_2_w := 200

btn_refresh_x := 16
btn_refresh_w := 60

btn_apply_x := 130
btn_apply_w := 60

btn_ok_x := 200
btn_ok_w := 90




; ##########################################################
;	MAIN GUI CREATION
; ##########################################################

; Create settings GUI
; ----------------------------------------------------------
Gui, Settings:+AlwaysOnTop

; Settings Header: Section A
Gui, Settings:Font, s11 bold underline, Veranda
Gui, Settings:Add, Text, center x20, Sound

; Settings: Section A
Gui, Settings:Font, s9 normal, Verdana

Gui, Settings:Add, Text, x20 w%col_1_w% section, Sound Enabled:
Gui, Settings:Add, Edit, xs%col_2_x% ys-4 w%col_2_w% vSetting_A1_edit,

Gui, Settings:Add, Text, x20 w%col_1_w% section, Sound File:
Gui, Settings:Add, Edit, xs%col_2_x% ys-4 w%col_2_w% vSetting_A2_edit,

Gui, Settings:Add, Text, x20 w%col_1_w% section, Sound Volume:
Gui, Settings:Add, Edit, xs%col_2_x% ys-4 w%col_2_w% vSetting_A3_edit,

; ----------------------------------------------------------
; Settings Header: Section B
Gui, Settings:Font, s11 bold underline, Veranda
Gui, Settings:Add, Text, center x20, Timer Position

; Settings: Section B
Gui, Settings:Font, s9 normal, Verdana

Gui, Settings:Add, Button, x130 w150 gMoveTimer_btnHandle section, Move Timer Manually

Gui, Settings:Add, Text, x20 w%col_1_w% section, X:
Gui, Settings:Add, Edit, xs%col_2_x% ys-4 w%col_2_w% vSetting_B1_edit,

Gui, Settings:Add, Text, x20 w%col_1_w% section, Y:
Gui, Settings:Add, Edit, xs%col_2_x% ys-4 w%col_2_w% vSetting_B2_edit,

Gui, Settings:Add, Text, x20 w%col_1_w% section,	; BLANK SPACE FOR SPACING

; ----------------------------------------------------------
; Add buttons to GUI and show GUI (and pull setting file values)
Gui, Settings:Add, Button, x%btn_refresh_x% w%btn_refresh_w% gRefresh_btnHandle section, Refresh
Gui, Settings:Add, Button, x%btn_apply_x% ys0 w%btn_apply_w% gApply_btnHandle Default, Apply
Gui, Settings:Add, Button, x%btn_ok_x% ys0 w%btn_ok_w% gOK_btnHandle, OK / Restart
Gui, Settings:Show, xCenter yCenter, Script Settings

WinWait, Script Settings
refreshGuiValues()
createTimerDisplay()



;###########################################################
;	HOTKEYS
;###########################################################


; BLANK HOTKEY (PREVENTS LABELS BELOW FROM EXECUTING)
#IfWinActive, Script Settings
~Enter::
Return
#IfWinActive



;###########################################################
;	BUTTON HANDLER SUBROUTINE LABELS (NEED HOTKEYS ABOVE TO STOP FLOW)
;###########################################################



MoveTimer_btnHandle:
Gui, Settings:+LastFound
Control, Disable,, Button1
toggleTimerWindowBorder()
Return


Refresh_btnHandle:
refreshGuiValues()
Return


Apply_btnHandle:
writeSettingToFile()
updateTimerPosition()
Return



OK_btnHandle:
Gui, Settings:Hide
Gui, Settings:Destroy
Run, %callingScriptName%
ExitApp
Return




;###########################################################
;	MAIN SETTINGS WINDOW MANAGEMENT FUNCTIONS
;###########################################################



; Read in necesary settings from the settings file and write them the GUI fields
refreshGuiValues(){

	global settingsFile
	
	global setting_secA_iniName
	global setting_A1_iniKey
	global setting_A2_iniKey
	global setting_A3_iniKey

	global setting_secB_iniName
	global setting_B1_iniKey
	global setting_B2_iniKey
	
	global setting_A1_edit
	global setting_A2_edit
	global setting_A3_edit
	global setting_B1_edit
	global setting_B2_edit

	; Pull settings from local INI file
	IniRead, setting_A1_value, %settingsFile%, %setting_secA_iniName%, %setting_A1_iniKey%, not_found
	IniRead, setting_A2_value, %settingsFile%, %setting_secA_iniName%, %setting_A2_iniKey%, not_found
	IniRead, setting_A3_value, %settingsFile%, %setting_secA_iniName%, %setting_A3_iniKey%, not_found
	IniRead, setting_B1_value, %settingsFile%, %setting_secB_iniName%, %setting_B1_iniKey%, not_found
	IniRead, setting_B2_value, %settingsFile%, %setting_secB_iniName%, %setting_B2_iniKey%, not_found

	; Set GUI values to match file read in values
	Gui, Settings:+LastFound
	ControlSetText, %setting_A1_edit%, %setting_A1_value%
	ControlSetText, %setting_A2_edit%, %setting_A2_value%
	ControlSetText, %setting_A3_edit%, %setting_A3_value%
	ControlSetText, %setting_B1_edit%, %setting_B1_value%
	ControlSetText, %setting_B2_edit%, %setting_B2_value%
}



writeSettingToFile(){

	; assume-global mode
	global

	; submit GUI values to variables
	Gui, Settings:Submit, NoHide

	; write variables to settings file
	IniWrite, %setting_A1_edit%, %settingsFile%, %setting_secA_iniName%, %setting_A1_iniKey%
	IniWrite, %setting_A2_edit%, %settingsFile%, %setting_secA_iniName%, %setting_A2_iniKey%
	IniWrite, %setting_A3_edit%, %settingsFile%, %setting_secA_iniName%, %setting_A3_iniKey%
	IniWrite, %setting_B1_edit%, %settingsFile%, %setting_secB_iniName%, %setting_B1_iniKey%
	IniWrite, %setting_B2_edit%, %settingsFile%, %setting_secB_iniName%, %setting_B2_iniKey%
}



;###########################################################
;	TIMER WINDOW MANAGEMENT FUNCTIONS
;###########################################################



; Draws the timer display
createTimerDisplay(){
	
	global settingsFile
	global timerBorder := false
	
	; Pull nesesary parameters to draw timer
	IniRead, timer_x, %settingsFile%, Position, timer_x
	IniRead, timer_y, %settingsFile%, Position, timer_y
	IniRead, timer_color, %settingsFile%, Color, timer_color
	IniRead, timer_back_color, %settingsFile%, Color, timer_back_color
	IniRead, timer_alpha, %settingsFile%, Color, timer_alpha

	; create gui window to display timer
	;timer_back_color := "00FF00"  ; Can be any RGB color (it will be made transparent below).
	Gui, Timer:+LastFound +AlwaysOnTop -Caption +ToolWindow  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
	Gui, Timer:Color, %timer_back_color%
	Gui, Timer:Font, s28 c%timer_color% bold, Courier New ; Set a large font size (32-point).
	Gui, Timer:Add, Text, Right, H:MM:SS  ; H:MM:SS serves to auto-size the window.
	; Make all pixels of this color transparent and make the text itself translucent (150):
	WinSet, TransColor, %timer_back_color% %timer_alpha%
	Gui, Timer:Show, x%timer_x% y%timer_y% NoActivate, Timer Window ; NoActivate avoids deactivating the currently active window.
	
	; Enable move timer window button
	Gui, Settings:+LastFound
	Control, Enable,, Button1
}



; Save the timer windows current position to settings file
; (Assumes the timer window has border and accounts for this in the position saved)
saveTimerPosition(){

	global settingsFile
	global configFile

	;Read in caption (window titlebar and border) offset values from config file
	IniRead, caption_offset_top, %configFile%, Position, caption_offset_top
	IniRead, caption_offset_left, %configFile%, Position, caption_offset_left

	; calculate normal (captionless) position of window
	Gui, Timer:+LastFound
	WinGetPos, win_x, win_y
	timer_x := win_x + caption_offset_left
	timer_y := win_y + caption_offset_top

	; write values to storage and refresh gui
	IniWrite, %timer_x%, %settingsFile%, Position, timer_x
	IniWrite, %timer_y%, %settingsFile%, Position, timer_y
}


; Move the timer to the location it should be based on what is saved in the settings file
updateTimerPosition(){
	
	global timerBorder
	global settingsFile
	
	; Ensure the timer is displaying as it would in-game
	if (!timerBorder){
		
		IniRead, timer_x, %settingsFile%, Position, timer_x
		IniRead, timer_y, %settingsFile%, Position, timer_y

		WinMove, Timer Window,, %timer_x%, %timer_y%
	}
}



toggleTimerWindowBorder(){
	
	global timerBorder
	global settingsFile
	global configFile
	
	if (!timerBorder){
		
		;Read in caption (window titlebar and border) offset values from config file
		IniRead, caption_offset_top, %configFile%, Position, caption_offset_top
		IniRead, caption_offset_left, %configFile%, Position, caption_offset_left
		IniRead, timer_x, %settingsFile%, Position, timer_x
		IniRead, timer_y, %settingsFile%, Position, timer_y
		
		;Get position of window with caption offset
		offset_pos_x := timer_x - caption_offset_left
		offset_pos_y := timer_y - caption_offset_top
		
		;Set window to visible and correct position
		Gui, Timer:+LastFound +Caption
		WinMove, Timer Window,, %offset_pos_x%, %offset_pos_y%
		WinSet, TransColor, Off
		WinActivate, Timer Window
		timerBorder := true
	}
	else {

		Gui, Timer:+LastFound -Caption
		WinSet, TransColor, %timer_back_color% %timer_alpha%
		WinMove, Timer Window,, %timer_x%, %timer_y%
		timerBorder := false
	}
}



; ##########################################################
; MAIN CLOSING PROCEDURES
; ##########################################################


TimerGuiClose()
{
	saveTimerPosition()
	Gui, Timer:Destroy
	refreshGuiValues()
	createTimerDisplay()
}

SettingsGuiClose()
{
	ExitApp
}
