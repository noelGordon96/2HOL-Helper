; Initial settings
#SingleInstance, force
SetWorkingDir %A_ScriptDir%
Menu, Tray, Icon , 2hol_icon.ico

; Prompt user for game location
FileSelectFolder, gameFolderPath,,, Please select your 2HOL game folder (the folder that contains your "OneLife.exe" file.)

; Create shortcut to game file
oneLifePath := gameFolderPath . "\OneLife.exe"
FileCreateShortcut, %oneLifePath%, OneLife.lnk, %gameFolderPath%

; Write changes to Config file
IniWrite, true, Config.ini, Config, installed
IniWrite, %gameFolderPath%, config.ini, Config, gameFolderPath
