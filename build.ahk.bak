#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SetBatchLines, -1
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

FileInstall, gnu_gpl_EN.txt, % A_Temp . "\gnu_gpl_EN.txt", 1
FileInstall, gnu_gpl_DE.txt, % A_Temp . "\gnu_gpl_DE.txt", 1


If(!DllCall("AttachConsole", "int", -1)){
	ExitApp
}

SplitPath, A_AhkPath,, AhkRoot
next_param := "source"
single := 0
gnu_gpl := 0
destination := ""
language := "EN"

param1=%1%
param2=%2%
param3=%3%
param4=%4%
param5=%5%
param6=%6%
param7=%7%
param8=%8%
Loop, 8
{
	tmp := param%A_Index%
	if(tmp == "")
		break
	if(next_param != ""){
		%next_param% := tmp
		next_param := ""
		continue
	}
	if(tmp == "-li")
	{
		next_param := "license"
		continue
	}
	if(tmp == "-lang")
	{
		next_param := "language"
		continue
	}
	if(tmp == "-gnu_gpl")
	{
		gnu_gpl := 1
		license := 1
		continue
	}
	if(tmp == "-d")
	{
		next_param := "destination"
		continue
	}
	;in case of wrong parameter, show syntax help:
	source := ""
	break
}

if(!source or !license)
{
	FileAppend, % "`n`nSYNTAX:`nbuild [Source] [-li License | -gnu_gpl] [-d Dest] [-lang Language] [-s]`n`n", CONOUT$
	FileAppend, % "    [Source]`n", CONOUT$
	FileAppend, % "       Can be any executable. Source folder must contain appinfo`.ini`n`n", CONOUT$
	FileAppend, % "    [-li License | -gnu_gpl]`n", CONOUT$
	FileAppend, % "       LicenseFile: Can be any txt file holding the license text.`n", CONOUT$
	FileAppend, % "       -gnu_gpl:    Use standard GNU General Public License v3`n`n", CONOUT$
	FileAppend, % "    [-d Dest]            (optional)`n", CONOUT$
	FileAppend, % "       The setup file's destination (defaults to directory of 'Source')`n`n", CONOUT$
	FileAppend, % "    [-lang Language]     (optional)`n", CONOUT$
	FileAppend, % "       The setup language (and gpl language in case of -gnu_gpl)`n", CONOUT$
	FileAppend, % "       Available languages: EN, DE  (defaults to EN)`n`n", CONOUT$
	FileAppend, % "    [-s]                 (optional)`n", CONOUT$
	FileAppend, % "       'single-mode', don't include resources from 'Source' directory", CONOUT$
	gosub, Exit
}

;collecting language specific data
lp_section := 1
Loop, Read, lang_packages/%language%.lp
{
	if (A_LoopReadLine == "`;SECTION END")
	{
		lp_section++
		continue
	}
	if (lp_section == 3) {
		lp_entry := StrSplit(A_LoopReadLine, "="), lp_varname := lp_entry[1], %lp_varname% := lp_entry[2]
	}
}

SplitPath, source, source_exe, source_dir

FileDelete, log.txt

console_log("`n")
console_log("starting...`n")
if !FileExist(source_dir . "\appinfo.ini"){
	console_log("ERROR: Couldn't find " . source_dir . "\appinfo.ini")
	gosub, Exit
}
IniRead, AppName, % source_dir . "\appinfo.ini", AppInfo, AppName, % A_Space
IniRead, AppID, % source_dir . "\appinfo.ini", AppInfo, AppID, % AppName
IniRead, AppVersion, % source_dir . "\appinfo.ini", AppInfo, AppVersion, % A_Space
IniRead, AppUpdateVersion, % source_dir . "\appinfo.ini", AppInfo, AppUpdateVersion, % A_Space
IniRead, AppAuthorName, % source_dir . "\appinfo.ini", AppInfo, AppAuthorName, % A_Space
IniRead, AppAuthorEmail, % source_dir . "\appinfo.ini", AppInfo, AppAuthorEmail, % A_Space
IniRead, AppChangelog, % source_dir . "\appinfo.ini", AppInfo, AppChangelog, % A_Space
IniRead, AppStdInstall, % source_dir . "\appinfo.ini", AppInfo, AppStdInstall, % AppName
IniRead, AppStartMenu, % source_dir . "\appinfo.ini", AppInfo, AppStartMenu, % AppName
IniRead, AppWebsite, % source_dir . "\appinfo.ini", AppInfo, AppWebsite, % A_Space
IniRead, AppFileTypes, % source_dir . "\appinfo.ini", AppInfo, AppFileTypes, % A_Space
IniRead, AppIcon, % source_dir . "\appinfo.ini", AppInfo, AppIcon, %A_WorkingDir%\setupicon.ico
IniRead, AppUninstFiles, % source_dir . "\appinfo.ini", AppInfo, AppUninstFiles, % A_Space
IniRead, AppUninstReg, % source_dir . "\appinfo.ini", AppInfo, AppUninstReg, % A_Space
IniRead, AppPortability, % source_dir . "\appinfo.ini", AppInfo, AppPortability, 0
IniRead, AppExtraInit, % source_dir . "\appinfo.ini", AppInfo, AppExtraInit, % A_Space
IniRead, AppUpdateRemove, % source_dir . "\appinfo.ini", AppInfo, AppUpdateRemove, % A_Space
AppInfoIncomplete := (!AppName or !AppVersion or !AppUpdateVersion or !AppAuthorName)
if AppInfoIncomplete {
	console_log("ERROR: Incomplete appinfo.ini!")
	gosub, Exit
}
AppChangelogAvailable := !(!AppChangelog)
AppWebsiteAvailable := !(!AppWebsite)
AppAuthorEmailAvailable := !(!AppAuthorEmail)
AppUsesFileTypes := !(!AppFileTypes)

if AppUsesFileTypes {
	if !FileExist(source_dir . "\" . AppFileTypes){
		console_log("ERROR: Couldn't find " . source_dir . "\" . AppFileTypes)
		gosub, Exit
	}
	IniRead, AppAssociatedFileTypes, % source_dir . "\" . AppFileTypes
}
if AppExtraInit {
	if !FileExist(source_dir . "\" . AppExtraInit){
		console_log("ERROR: Couldn't find " . source_dir . "\" . AppExtraInit)
		gosub, Exit
	}
}
if AppChangelogAvailable {
	if !FileExist(source_dir . "\" . AppChangelog){
		console_log("ERROR: Couldn't find " . source_dir . "\" . AppChangelog)
		gosub, Exit
	}
}
	
console_log("Application Info:`n")
console_log("AppName=" . AppName . "`n")
console_log("AppID=" . AppID . "`n")
console_log("AppVersion=" . AppVersion . "`n")
console_log("AppUpdateVersion=" . AppUpdateVersion . "`n")
console_log("AppAuthorName=" . AppAuthorName . "`n")
console_log("AppAuthorEmailAvailable=" . AppAuthorEmailAvailable . "`n")
if AppAuthorEmailAvailable
	console_log("AppAuthorEmail=" . AppAuthorEmail . "`n")
else
	AppAuthorEmail := BUILD_LANG_UNAIVAILABLE
console_log("AppStdInstall=" . AppStdInstall . "`n")
console_log("AppStartMenu=" . AppStartMenu . "`n")
console_log("AppPortability=" . AppPortability . "`n")
console_log("AppChangelogAvailable=" . AppChangelogAvailable . "`n")
if AppChangelogAvailable
	console_log("AppChangelog=" . AppChangelog . "`n")
console_log("AppWebsiteAvailable=" . AppWebsiteAvailable . "`n")
if AppWebsiteAvailable
	console_log("AppWebsite=" . AppWebsite . "`n")
console_log("AppUsesFileTypes=" . AppUsesFileTypes . "`n")
if AppUsesFileTypes
	console_log("--- AppAssociatedFileTypes:`n" . AppAssociatedFileTypes . "`n---`n")
if(gnu_gpl){
	console_log("license: GNU General Public License v3`n")
	console_log("         language: " . language . "`n")
	if(!FileExist(A_Temp . "\gnu_gpl_" . language . ".txt")){
		console_log("WARNING: GNU GPL not available in language " . language . "`n")
		console_log("         (check www.gnu.org/licenses/translations.html and download manually)`n")
		console_log("         GNU GPL language set to default (EN)`n")
		language := "EN"
	}
	license := A_Temp . "\gnu_gpl_" . language . "`.txt"
}
if(!FileExist(source)){
	console_log("ERROR: source file does not exist!`n")
	gosub, Exit
}
if(!FileExist(license)){
	console_log("ERROR: license file does not exist!`n")
	gosub, Exit
}
FileRead, license_content, %license%
if(!FileExist(AppIcon) or (AppIcon == "setupicon.ico")){
	AppIcon := source_dir . "\" . AppIcon
	if(!FileExist(AppIcon)){
		console_log("ERROR: specified icon file does not exist!`n")
		gosub, Exit
	}
}
if(SubStr(AppIcon, -3) == ".exe"){
	console_log("Using icon from executable.`n")
}
if(destination == ""){
	destination := source_dir . "\" . AppName . " Setup.exe"
	console_log("Using standard destination.`n")
}
console_log("creating environment:`ncopying files...`n")
FileRemoveDir, build, 1
FileCreateDir, build
FileCopyDir, % source_dir, build, 1
IniWrite, %AppID%, build/appinfo.ini, AppInfo, AppID
if !AppUninstFiles
{
	uniquename := "uninstf" . A_TickCount
	while (FileExist("build\" . uniquename)){
		uniquename .= 0
	}
	AppUninstFiles := uniquename
	console_log("creating AppUninstFiles: '" . AppUninstFiles . "'`n")
}
if !AppUninstReg
{
	uniquename := "uninstr" . A_TickCount
	while (FileExist("build\" . uniquename)){
		uniquename .= 0
	}
	AppUninstReg := uniquename
	console_log("creating AppUninstReg: '" . AppUninstReg . "'`n")
}
IniWrite, %AppUninstFiles%, build/appinfo.ini, AppInfo, AppUninstFiles
IniWrite, %AppUninstReg%, build/appinfo.ini, AppInfo, AppUninstReg
console_log("writing instruction file 1/2...`n")
instructions := "Gui`,Submit`,NoHide`n"
instr_amount_counter := 0
qm="
FileDelete, instructions
FileDelete, license.txt
FileDelete, changelog.txt
rel_pos := StrLen(source_dir) + 2
instructions .= "log(" . qm . "Preparing..."  . qm . ")`n"
if AppUpdateRemove {
	console_log("generating update file-removing instructions`n")
	Loop, Read, % "build\" . AppUpdateRemove
	{
		type := SubStr(A_LoopReadLine, 1, 1)
		path := SubStr(A_LoopReadLine, 3)
		if (type == "F")
			instructions .= "FileDelete`, `%label11`%\" . path . "`n"
		if (type == "D")
			instructions .= "FileRemoveDir`, `%label11`%\" . path . "`, 1`n"
	}
}
console_log("generating instructions from directory structure of " . source_dir . ":`n")
Loop, Files, %source_dir%\*.*, DR
{
	rel_path := SubStr(A_LoopFileFullPath, rel_pos)
	console_log(instr_amount_counter . ": " . rel_path . "`n")
	instructions .= "log(label11 `. " . qm . "\" . rel_path  . qm . ")`nFileCreateDir`, `% label11 `. " . qm . "\" . rel_path  . qm . "`ninstr_count++`, progress := floor(100*(instr_count/instr_amount))`nprog(progress)`nGuiControl,, label15, `%progress`% ```%`n"
	instr_amount_counter ++
}
console_log("generating instructions from files inside " . source_dir . ":`n")
Loop, Files, %source_dir%\*.*, FR
{
	rel_path := SubStr(A_LoopFileFullPath, rel_pos)
	if((rel_path == AppExtraInit) or (rel_path == AppUpdateRemove))
		continue
	if(A_LoopFileSize){
		console_log(instr_amount_counter . ": " . rel_path . "`n")
		instructions .= "log(label11 `. " . qm . "\" . rel_path  . qm . ")`nFileInstall`," . auto_escape(rel_path) . "`, `% label11 `. " . qm . "\" . rel_path  . qm . ",1`ninstr_count++`, progress := floor(100*(instr_count/instr_amount))`nprog(progress)`nGuiControl,, label15, `%progress`% ```%`n"
	} else {
		console_log(instr_amount_counter . ": " . rel_path . " (empty!)`n")
		instructions .= "log(label11 `. " . qm . "\" . rel_path  . qm . ")`nFileAppend`, `% " qm . qm . "`, `% label11 `. " . qm . "\" . rel_path  . qm . "`ninstr_count++`, progress := floor(100*(instr_count/instr_amount))`nprog(progress)`nGuiControl,, label15, `%progress`% ```%`n"
	}
	instr_amount_counter ++
}
rel_path := "Uninstall.exe"
console_log(instr_amount_counter . ": " . rel_path . " (obligatory)`n")
instructions .= "log(label11 `. " . qm . "\" . rel_path  . qm . ")`nFileInstall`," . rel_path . "`, `% label11 `. " . qm . "\" . rel_path  . qm . ",1`ninstr_count++`, progress := floor(100*(instr_count/instr_amount))`nprog(progress)`nGuiControl,, label15, `%progress`% ```%`n"
instr_amount_counter ++

console_log("writing instruction file 2/2...`n")

instr_amount_counter ++
instructions .= "if (SetupTypeNormal) {`n"
instructions .= "log(" . qm . "Registry..." . qm . ")`n"
instructions .= "AppKey := " . qm . "SOFTWARE\" . AppID . qm . "`n"
instructions .= "UninstallKey := " . qm . "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\" . AppID . qm . "`n"
instructions .= "AppPathKey := " . qm . "SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\" . source_exe . qm . "`n"
instructions .= "SetRegView `% (A_Is64bitOS ? 64 : 32)`n"
instructions .= "RegWrite REG_SZ, HKLM, `%AppKey`%, InstallDir, `%label11`%`n"
instructions .= "RegWrite REG_SZ, HKLM, `%AppKey`%, Version, `%CONST_SETUP_APPVERSION`%`n"
instructions .= "RegWrite REG_SZ, HKLM, `%UninstallKey`%, DisplayName, `%CONST_SETUP_TITLE`%`n"
instructions .= "RegWrite REG_SZ, HKLM, `%UninstallKey`%, UninstallString, " . qm . "`%label11`%\Uninstall.exe" . qm . "`n"
instructions .= "RegWrite REG_SZ, HKLM, `%UninstallKey`%, DisplayIcon, " . qm . "`%label11`%\" . source_exe . qm . "`n"
instructions .= "RegWrite REG_SZ, HKLM, `%UninstallKey`%, DisplayVersion, `%CONST_SETUP_APPVERSION`%`n"
instructions .= "RegWrite REG_SZ, HKLM, `%UninstallKey`%, URLInfoAbout, `%CONST_SETUP_APPWEBSITE`%`n"
instructions .= "RegWrite REG_SZ, HKLM, `%UninstallKey`%, Publisher, `%CONST_SETUP_APPAUTHORNAME`%`n"
instructions .= "RegWrite REG_DWORD, HKLM, `%UninstallKey`%, NoModify, 1`n"
instructions .= "RegWrite REG_SZ, HKLM, `%AppPathKey`%,, `%label11`%\" . source_exe . "`n"
if AppUsesFileTypes {
	AppFileTypesIni := source_dir . "\" . AppFileTypes
	Loop, Parse, AppAssociatedFileTypes, `n
	{
		filetype := A_LoopField
		IniRead, Type_Name, % AppFileTypesIni, % filetype, Type_Name, % filetype
		IniRead, Type_Extension, % AppFileTypesIni, % filetype, Type_Extension, % A_Space
		IniRead, Type_Icon, % AppFileTypesIni, % filetype, Type_Icon, % A_Space
		IniRead, Type_NewFile, % AppFileTypesIni, % filetype, Type_NewFile, % A_Space
		IniRead, MenuDefault, % AppFileTypesIni, % filetype, Default, % A_Space
		if !Type_Extension {
			console_log("ERROR: no extension specified for AppFileType '" . filetype . "'! Skipping...`n")
			continue
		}
		instructions .= "RegRead, null, HKCR, ." . Type_Extension . "`nExtensionIsAppProperty := ErrorLevel`nRegRead, null, HKCR, " . filetype . "`nTypeIsAppProperty := (ErrorLevel && ExtensionIsAppProperty)`nif !TypeIsAppProperty`n{`nRegRead, TypeOwner, HKCR, " . filetype . ",Owner`nTypeIsAppProperty := (TypeOwner == CONST_SETUP_APPID)`n}`nif TypeIsAppProperty`n{`nRegWrite, REG_SZ, HKCR, " . filetype . ",Owner,`%CONST_SETUP_APPID`%`n}`nif TypeIsAppProperty`n{`n"
		instructions .= "RegWrite REG_SZ, HKCR, ." . Type_Extension . ",, " . filetype . "`n"
		instructions .= "FileAppend, ``nHKCR\." . Type_Extension . ", `%label11`%\" . AppUninstReg . "`n"
		instructions .= "FileAppend, ``nHKCR\" . filetype . ", `%label11`%\" . AppUninstReg . "`n"
		if Type_NewFile {
			SplitPath, Type_NewFile,,, Type_NewFileExtension
			if !FileExist(source_dir . "\" . Type_NewFile){
				console_log("ERROR: Couldn't find " . source_dir . "\" . Type_NewFile . " (File template for AppFileType '" . filetype . "')`n")
			} else if (Type_NewFileExtension != Type_Extension) {
				console_log("ERROR: " . Type_NewFile . " (File template for AppFileType '" . filetype . "') is not of type '." . Type_Extension . "'`n")
			} else {
				instructions .= "FileAppend, ``n`%A_WinDir`%\ShellNew\" . Type_NewFile . ", `%label11`%\" . AppUninstFiles . "`n"
				instructions .= "FileInstall, " . Type_NewFile . ", `%A_WinDir`%\ShellNew\" . Type_NewFile . ", 1`n"
				instructions .= "RegWrite, REG_SZ, HKCR, ." . Type_Extension . "\ShellNew, FileName, " . Type_NewFile . "`n"
			}
		}
		instructions .= "RegWrite REG_SZ, HKCR, " . filetype . ",, " . Type_Name . "`n"
		if Type_Icon
			instructions .= "RegWrite REG_SZ, HKCR, " . filetype . "\DefaultIcon,, `%label11`%\" . Type_Icon . "`n"
		instructions .= "RegWrite REG_SZ, HKCR, " . filetype . "\Shell\,," . MenuDefault . "`n"
		instructions .= "}`n"
		IniRead, FileTypeAttributes, % AppFileTypesIni, % filetype
		Loop, Parse, FileTypeAttributes, `n
		{
			if ((SubStr(AttrTitle := (StrSplit(A_LoopField, "="))[1], 1, 5) == "Menu_") ? (MenuEntry := SubStr(AttrTitle, 6)) : 0)
			{
				IniRead, MenuEntryDescription, % AppFileTypesIni, % filetype, % "Menu_" . MenuEntry
				MenuEntryDisplayName := (StrSplit(MenuEntryDescription, ","))[1]
				MenuEntryCommand := SubStr(MenuEntryDescription, StrLen(MenuEntryDisplayName) + 2)
				;MsgBox %MenuEntry%`n%MenuEntryDisplayName%`n%MenuEntryCommand%
				instructions .= "FileAppend, ``nHKCR\" . filetype . "\Shell\" . MenuEntry . ", `%label11`%\" . AppUninstReg . "`n"
				instructions .= "RegWrite REG_SZ, HKCR, " . filetype . "\Shell\" . MenuEntry . ",," . MenuEntryDisplayName . "`n"
				instructions .= "MenuCommand=" . auto_escape(MenuEntryCommand) . "`n"
				instructions .= "RegWrite REG_SZ, HKCR, " . filetype . "\Shell\" . MenuEntry . "\Command,,`%MenuCommand`%`n"
			}
		}
	}
}
instructions .= "}`n"
if AppExtraInit
{
	instructions .= "instr_count++`nprogress := 99`nprog(progress)`nGuiControl,, label15, `%progress`% ```%`n"
	instructions .= "log(" . qm . "Completing..." . qm . ")`n"
	instructions .= "#Include, " . AppExtraInit . "`n"
}
instructions .= "instr_count++`nprogress := 100`nprog(progress)`nGuiControl,, label15, `%progress`% ```%`n"
instructions := "instr_count := 0`ninstr_amount := " instr_amount_counter . "`n" . instructions


console_log("----- instruction output -----`n" . instructions . "------------------------------`n")
console_log("processing:`n")
console_log("adding setup_template...`n")
uniquename := A_TickCount
while (FileExist("build\" . uniquename . "`.ahk")){
	uniquename .= 0
}
template_file := "build\" . uniquename . "`.ahk"

FileAppend, RunAsAdmin()`n, % template_file
FileAppend, #Include ../lang_packages/%language%.lp`n, % template_file
FileAppend, CONST_SETUP_TITLE := "%AppName% %AppVersion%"`n, % template_file
FileAppend, CONST_SETUP_APPNAME := "%AppName%"`n, % template_file
FileAppend, CONST_SETUP_APPID := "%AppID%"`n, % template_file
FileAppend, CONST_SETUP_APPEXE := "%source_exe%"`n, % template_file
FileAppend, CONST_SETUP_APPVERSION := "%AppVersion%"`n, % template_file
FileAppend, CONST_SETUP_APPUPDATEVERSION := "%AppUpdateVersion%"`n, % template_file
FileAppend, CONST_SETUP_STD_FOLDER := "%AppStdInstall%"`n, % template_file
FileAppend, CONST_SETUP_APPSTARTMENU := "%AppStartMenu%"`n, % template_file
FileAppend, CONST_SETUP_APPWEBSITE := "%AppWebsite%"`n, % template_file
FileAppend, CONST_SETUP_APPAUTHORNAME := "%AppAuthorName%"`n, % template_file
FileAppend, CONST_SETUP_APPWEBSITEAVAILABLE := %AppWebsiteAvailable%`n, % template_file
FileAppend, CONST_SETUP_APPCHANGELOGAVAILABLE := %AppChangelogAvailable%`n, % template_file
FileAppend, CONST_SETUP_APPPORTABILITY := %AppPortability%`n, % template_file
FileRead, template_content, setup_template.ahk
FileAppend, % template_content, % template_file

console_log("instructions to file...`n")
FileAppend, % instructions, instructions
console_log("license to file...`n")

keywords := "AppName|AppVersion|AppUpdateVersion|AppAuthorName|AppAuthorEmail"
Loop, Parse, keywords, |
StringReplace, license_content, license_content, % "%" . A_LoopField . "%", % %A_LoopField%, 1
FileAppend, % license_content, license.txt

console_log("changelog to file...`n")
if AppChangelogAvailable
	FileRead, changelog_content, build\%AppChangelog%
else
	changelog_content := "none"
FileAppend, % changelog_content, changelog.txt

console_log("adding uninstaller:`n")
console_log("generating Uninstall.exe from template...`n")

uniqueuninst := A_TickCount
while (FileExist("build\" . uniqueuninst . "`.ahk") or FileExist("build\" . uniqueuninst . "`.exe")){
	uniqueuninst .= 0
}
template_file := "build\" . uniqueuninst . "`.ahk"
FileAppend, RunAsAdmin()`n, % template_file
FileAppend, #Include ../lang_packages/%language%.lp`n, % template_file
FileAppend, CONST_SETUP_TITLE := "%AppName% %AppVersion%"`n, % template_file
FileAppend, CONST_SETUP_APPNAME := "%AppName%"`n, % template_file
FileAppend, CONST_SETUP_APPID := "%AppID%"`n, % template_file
FileAppend, CONST_SETUP_APPEXE := "%source_exe%"`n, % template_file
FileAppend, CONST_SETUP_APPSTARTMENU := "%AppStartMenu%"`n, % template_file
FileAppend, CONST_SETUP_APPUNINSTFILES := "%AppUninstFiles%"`n, % template_file
FileAppend, CONST_SETUP_APPUNINSTREG := "%AppUninstReg%"`n, % template_file
FileRead, template_content, uninstall_template.ahk
FileAppend, % template_content, % template_file

console_log("compiling uninstaller...`n")
RunWait, %AhkRoot%\Compiler\Ahk2Exe.exe /in "%A_WorkingDir%\build\%uniqueuninst%.ahk" /out "%A_WorkingDir%\build\%uniqueuninst%.exe" /icon "%AppIcon%"

console_log("adding uninstall starter...`n")
FileRead, template_content, uninst_start.ahk
StringReplace, template_content, template_content, #uninstaller#, %uniqueuninst%.exe
FileAppend, % template_content, build/Uninstall.ahk
RunWait, %AhkRoot%\Compiler\Ahk2Exe.exe /in "%A_WorkingDir%\build\Uninstall.ahk" /out "%A_WorkingDir%\build\Uninstall.exe" /icon "%AppIcon%"

console_log("compiling setup... ")

RunWait, %AhkRoot%\Compiler\Ahk2Exe.exe /in "%A_WorkingDir%\build\%uniquename%.ahk" /out "%destination%" /icon "%AppIcon%"

console_log("(" . errorlevel . ")`n")
CompilingError := (errorlevel != 0)
if (CompilingError) {
	console_log("ERROR occured while compiling. See error message for further information.")
	gosub, Exit
}

console_log("build completed! Setup file saved as: " . destination)

Exit:
console_log("`nremoving temporary files...")
FileDelete, instructions
FileDelete, license.txt
FileDelete, changelog.txt
FileRemoveDir, build, 1
console_log("`n---`nbuild.exe is terminated`n")
ExitApp


console_log(text){
	FileAppend, % text, CONOUT$
	FileAppend, % text, log.txt
}

auto_escape(path) {
	StringReplace, path, path, ``, ````, 1
	StringReplace, path, path, `,, ```,, 1
	StringReplace, path, path, `%, ```%, 1
	return path
}