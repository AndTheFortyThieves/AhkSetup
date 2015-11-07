#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

MsgBox This script will run the file 'Update.exe' with the AutoUpdate option.`nUpdate.exe can be any setup executable, that has been downloaded previously by the application/update checker...
FileCopy, Update.exe, %A_Temp%/Update.exe, 1
Run, %A_Temp%/Update.exe "AutoUpdate", %A_ScriptDir%/..
ExitApp