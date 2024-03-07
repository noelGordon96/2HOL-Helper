﻿;###########################################################
;	INFO HEADER
;###########################################################


; SCRIPT NAME:	2HOL Helper
; DESCRIPTION:	Create hotkeys and other functions for TwoHoursOneLife
; VERSION:		1.8.30.23
; AUTHOR:		Noel Gordon (veggieman1996@gmail.com)


;###########################################################
;	FUTURE TODOS
;###########################################################

; IMPROVEMENT maybe try to solve full-screen limitation

; FEATURE small ding countdown at very end of timer

; FEATURE enable multiple timers to go at once
; FEATURE settings.ini customization multiple timer vertical offset

; BUG FIX make input box cancel button functional
; BUG FIX typing in the main menu spawn seed field can activate hotkeys
; BUG FIX script will not exit until timer is finished (timer can't be canceled after window closed)


;###########################################################
;	INSTALLATION UPDATE NOTES
;###########################################################

; Mandy's version: V1.8.23.23
; V1.8.23.23  ---> VCurrent

; - Added Hotkey to Cancel timer (only changed the *_Main.ahk script file)

; - Added customizable "sound_volume=100" setting to setting.ini

; - Only launches OneLife if OneLife window doesn't already exist


;###########################################################
;	INITIAL SCRIPT SETTINGS
;###########################################################


#SingleInstance, force
SetWorkingDir %A_ScriptDir%
Menu, Tray, Icon , 2hol_icon.ico


;###########################################################
;	SCRIPT SYSTEM TRAY MENU CONTROL
;###########################################################


; add setting item to script's tray menu
Menu, Tray, NoStandard
Menu, Tray, Add, Settings, SettingsWindow_menuHandle
Menu, Tray, Add, Exit, QuitNow


;###########################################################
;	GLOBAL VARIABLES READING IN FILE DATA
;###########################################################

DEBUG := true	; USED FOR TESTING WHEN DEVELOPING
settingsFile := "settings.ini"
helpFile := "help.txt"

chatActive := false
timerActive := false


; ##########################################################
;	LOAD DATA FROM LOCAL STORAGE
; ##########################################################


; General settings
IniRead, sound_enabled, %settingsFile%, General, sound_enabled
IniRead, sound_file, %settingsFile%, General, sound_file
IniRead, sound_volume, %settingsFile%, General, sound_volume
IniRead, flash_enabled, %settingsFile%, General, flash_enabled
IniRead, flash_start_time, %settingsFile%, General, flash_start_time
IniRead, input_default, %settingsFile%, General, input_default
IniRead, input_timeout, %settingsFile%, General, input_timeout

; Position settings
IniRead, timer_x, %settingsFile%, Position, timer_x
IniRead, timer_y, %settingsFile%, Position, timer_y
IniRead, input_x, %settingsFile%, Position, input_x
IniRead, input_y, %settingsFile%, Position, input_y

;Color settings
IniRead, timer_color, %settingsFile%, Color, timer_color
IniRead, timer_alpha, %settingsFile%, Color, timer_alpha
IniRead, timer_back_color, %settingsFile%, Color, timer_back_color
IniRead, flash_color, %settingsFile%, Color, flash_color
IniRead, flash_alpha, %settingsFile%, Color, flash_alpha
IniRead, flash_back_color, %settingsFile%, Color, flash_back_color



; ##########################################################
; LAUNCH TWO_HOURS_ONE_LIFE GAME
; ##########################################################


if Not(WinExist("OneLife")){
	Run, OneLife
	WinWait, OneLife,, 60
}



; ##########################################################
; BACKGROUND SCRIPT
; ##########################################################



; Exit script once OneLife window is closed
while (true){
	if Not(WinExist("OneLife")){
		timerActive := false
		ExitApp
	}
	sleep, 5000
}



; ##########################################################
; GAME HOTKEYS
; ##########################################################

#IfWinActive, OneLife


; Create a timer with a given number of minutes
~T::

; only start timer if chat is not dialog box is not active
if not(chatActive){

	; get limer length from user
	InputBox, timerMins, 2HOL Timer, Timer Minutes,, 200, 120, %input_x%, %input_y%,, %input_timeout%, %input_default%


	; create gui to display timer
	;timer_back_color := "00FF00"  ; Can be any RGB color (it will be made transparent below).
	Gui +LastFound +AlwaysOnTop -Caption +ToolWindow  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
	Gui, Color, %timer_back_color%
	Gui, Font, s28 c%timer_color% bold, Courier New ; Set a large font size (32-point).
	Gui, Add, Text, vTimerText Right, H:MM:SS  ; H:MM:SS serves to auto-size the window.
	; Make all pixels of this color transparent and make the text itself translucent (150):
	WinSet, TransColor, %timer_back_color% %timer_alpha%
	Gui, Show, x%timer_x% y%timer_y% NoActivate  ; NoActivate avoids deactivating the currently active window.


		
	;start timer and update on-screen-display
	timerActive := true
	timer_min := timerMins
	timer_sec := 0
	total_timer_sec := (timer_min * 60) + timer_sec


	while ((total_timer_sec > 0) and (timerActive)){

		; bound second value to 60 and adjust minutes accourdingly
		; needs to be before the display update to avoid writing -1 for seconds
		if (timer_sec < 0){
			timer_sec := timer_sec + 60
			timer_min := timer_min - 1
		}

		; write timer with leading zero on seconds
		if (timer_sec < 10){
			Gui, Font, s28 c%timer_color% bold, Courier New
			GuiControl, Font, TimerText
			GuiControl,, TimerText, %timer_min%:0%timer_sec%
		}
		else{
			Gui, Font, s28 c%timer_color% bold, Courier New
			GuiControl, Font, TimerText
			GuiControl,, TimerText, %timer_min%:%timer_sec%
		}
		

		sleep, 500
		
		; flash timer if needed
		if (total_timer_sec <= flash_start_time){
			Gui, Font, s28 c%flash_color% bold, Courier New
			GuiControl, Font, TimerText
		}
		
		sleep, 500
		
		
		total_timer_sec := total_timer_sec - 1
		timer_sec := timer_sec - 1
	}
	
	Gui, Font, s28 c%timer_color% bold, Courier New
	GuiControl, Font, TimerText
	GuiControl,, TimerText, 0:00
	
	; play sound tones if necesary
	if ((sound_enabled == "true") and (timerActive)){
		SetCurrentProcessVolume(sound_volume)
		SoundPlay, %sound_file%, WAIT
	}
	
	timerActive := false
	Gui, Destroy
}
Return





~C::
if not(chatActive){
	timerActive := false
}
Return






; Manage chat dialog status
~ENTER::
if (chatActive){
	chatActive := false
}
else {
	chatActive := true
}
Return





; Set chat status when pressing / key
~/::
chatActive := true
Return






#IfWinActive







;###########################################################
;	SETTINGS WINDOW SUBROUTINE LABELS (NEED HOTKEYS ABOVE TO STOP FLOW)
;###########################################################


SettingsWindow_menuHandle:





Gui, Settings:Font, s12 bold underline, Veranda
Gui, Settings:Add, Text, center x20 y5, Timer Position

Gui, Settings:Font, s9 normal, Verdana
Gui, Settings:Add, Text, x20 w150 section, X:
Gui, Settings:Add, Edit, xs100 ys-4 w100 vtimerX_edit, %timer_x%

Gui, Settings:Add, Text, x20 w150 section, Y:
Gui, Settings:Add, Edit, xs100 ys-4 w100 vtimerY_edit, %timer_y%






Gui, Settings:Font, s12 bold underline, Veranda
Gui, Settings:Add, Text, center x20, Colors

Gui, Settings:Font, s9 normal, Verdana
Gui, Settings:Add, Text, x20 w150 section, Timer Color:
Gui, Settings:Add, Edit, xs100 ys-4 w100, %timer_color%

Gui, Settings:Add, Text, x20 w150 section, Timer Alpha:
Gui, Settings:Add, Edit, xs100 ys-4 w100, %timer_alpha%

Gui, Settings:Add, Text, x20 w150 section, Back Color:
Gui, Settings:Add, Edit, xs100 ys-4 w100, %timer_back_color%




Gui, Settings:Add, Button, x20 w80 section gSettingsWindowApply_buttonHandle, Apply
Gui, Settings:Add, Button, Default xs100 ys0 w80 gSettingsWindowOK_buttonHandle, OK

Gui, Settings:Show, xCenter yCenter, Script Settings

Return


SettingsGuiClose:
SettingsWindowOK_buttonHandle:
Gui, Settings:Hide
Gui, Settings:Destroy
Return



SettingsWindowApply_buttonHandle:
; Code here to apply window settings to correct variables and save to settings file
Return


;###########################################################
;	OTHER MISC SUBROUTINE LABELS (NEED HOTKEYS ABOVE TO STOP FLOW)
;###########################################################


QuitNow:
ExitApp
Return


; ##########################################################
; MISC FUNCTIONS
; ##########################################################



; Set the volume for the current script works (works with commands like SoundPlay)
; source: https://www.autohotkey.com/boards/viewtopic.php?t=98435
SetCurrentProcessVolume(volume) ; volume can be number 0 — 100 or "mute" or "unmute"
{
   static MMDeviceEnumerator      := "{BCDE0395-E52F-467C-8E3D-C4579291692E}"
        , IID_IMMDeviceEnumerator := "{A95664D2-9614-4F35-A746-DE8DB63617E6}"
        , IID_IAudioClient        := "{1cb9ad4c-dbfa-4c32-b178-c2f568a703b2}"
        , IID_ISimpleAudioVolume  := "{87ce5498-68d6-44e5-9215-6da47ef883d8}"
        , eRender := 0, eMultimedia := 1, CLSCTX_ALL := 0x17
        , _ := OnExit( Func("SetCurrentProcessVolume").Bind(100) )
        
   IMMDeviceEnumerator := ComObjCreate(MMDeviceEnumerator, IID_IMMDeviceEnumerator)
   ; IMMDeviceEnumerator::GetDefaultAudioEndpoint
   DllCall(NumGet(NumGet(IMMDeviceEnumerator + 0) + A_PtrSize*4), "Ptr", IMMDeviceEnumerator, "UInt", eRender, "UInt", eMultimedia, "PtrP", IMMDevice)
   ObjRelease(IMMDeviceEnumerator)

   VarSetCapacity(GUID, 16)
   DllCall("Ole32\CLSIDFromString", "Str", IID_IAudioClient, "Ptr", &GUID)
   ; IMMDevice::Activate
   DllCall(NumGet(NumGet(IMMDevice + 0) + A_PtrSize*3), "Ptr", IMMDevice, "Ptr", &GUID, "UInt", CLSCTX_ALL, "Ptr", 0, "PtrP", IAudioClient)
   ObjRelease(IMMDevice)
   
   ; IAudioClient::GetMixFormat
   DllCall(NumGet(NumGet(IAudioClient + 0) + A_PtrSize*8), "Ptr", IAudioClient, "UIntP", pFormat)
   ; IAudioClient::Initialize
   DllCall(NumGet(NumGet(IAudioClient + 0) + A_PtrSize*3), "Ptr", IAudioClient, "UInt", 0, "UInt", 0, "UInt64", 0, "UInt64", 0, "Ptr", pFormat, "Ptr", 0)
   DllCall("Ole32\CLSIDFromString", "Str", IID_ISimpleAudioVolume, "Ptr", &GUID)
   ; IAudioClient::GetService
   DllCall(NumGet(NumGet(IAudioClient + 0) + A_PtrSize*14), "Ptr", IAudioClient, "Ptr", &GUID, "PtrP", ISimpleAudioVolume)
   ObjRelease(IAudioClient)
   if (volume + 0 != "")
      ; ISimpleAudioVolume::SetMasterVolume
      DllCall(NumGet(NumGet(ISimpleAudioVolume + 0) + A_PtrSize*3), "Ptr", ISimpleAudioVolume, "Float", volume/100, "Ptr", 0)
   else
      ; ISimpleAudioVolume::SetMute
      DllCall(NumGet(NumGet(ISimpleAudioVolume + 0) + A_PtrSize*5), "Ptr", ISimpleAudioVolume, "UInt", volume = "mute" ? true : false, "Ptr", 0)
   ObjRelease(ISimpleAudioVolume)
}



