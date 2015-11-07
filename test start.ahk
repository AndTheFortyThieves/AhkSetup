#NoEnv

;SYNTAX:
;build [Source] [-li License | -gnu_gpl] [-d Dest] [-lang Language] [-s]

q="
build_source := "Testsuite\Example Program\start.exe"
build_license := "-gnu_gpl"
build_dest := "Testsuite\Destination\ep_setup.exe"
build_lang := "DE"
build_single := ""

build_cmd := "build " . q . build_source . q . " " . ((build_license == "-gnu_gpl") ? "" : "-li ") . q . build_license . q . " " . ((build_dest == "") ? "" : "-d ") . q . build_dest . q . " " . ((build_lang == "") ? "" : "-lang ") . q . build_lang . q . " " . q . build_single . q
RunWait, %comspec% /c " %build_cmd% && pause && exit",,max
FileRead, build_log, log.txt
;MsgBox % build_log
ExitApp