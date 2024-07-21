#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Version=Beta
#AutoIt3Wrapper_Icon=bin\autoinstaller.ico
#AutoIt3Wrapper_Outfile=autoinstaller.x86.exe
#AutoIt3Wrapper_Outfile_x64=autoinstaller.x64.exe
#AutoIt3Wrapper_Compression=0
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Res_Comment=Software installer tools, created by AutoIt3
#AutoIt3Wrapper_Res_Description=AUTOINSTALLER   v2.0.0.0   Enterprise Edition
#AutoIt3Wrapper_Res_Fileversion=2.4.07.30
#AutoIt3Wrapper_Res_ProductName=AUTOINSTALLER
#AutoIt3Wrapper_Res_ProductVersion=2.4.07.30
#AutoIt3Wrapper_Res_CompanyName=László Kártik - Senior IT System Engineer
#AutoIt3Wrapper_Res_LegalCopyright=Copyright © 2024, László Kártik
#AutoIt3Wrapper_Res_LegalTradeMarks=AUTOINSTALLER ™ SINCE 2019
#AutoIt3Wrapper_Res_Language=1038
#AutoIt3Wrapper_Res_Field=Website|"https://github.com/lacikartik88"
#AutoIt3Wrapper_Res_Field=Comment|"Software installer tools, created by AutoIt3"
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

; Info: http://www.autoitscript.com/autoit3/scite/docs/AutoIt3Wrapper.htm
; Icons added to the resources can be used with TraySetIcon(@ScriptFullPath, -5) etc. and are stored with numbers -5, -6...

#include <Array.au3>
#include <AutoItConstants.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <DateTimeConstants.au3>
#include <File.au3>
#include <FileConstants.au3>
#include <FontConstants.au3>
#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiComboBox.au3>
#include <GUIComboBoxEx.au3>
#include <GUIButton.au3>
#include <GUIImageList.au3>
#include <GUIListView.au3>
#include <GUIMenu.au3>
#include <ListViewConstants.au3>
#include <MsgBoxConstants.au3>
#include <StaticConstants.au3>
#include <WinAPI.au3>
#include <WindowsConstants.au3>

Init()

Func Init()
	; define laod screen gui
	Global $iGUI
	$iGUI = GUICreate("", 320, 55, -1, -1, $WS_POPUP, -1)
	GUISetFont(8, $FW_MEDIUM, "", "Comic Sans Ms", $iGUI, $CLEARTYPE_QUALITY)
	;WinSetTrans($iGUI, "", 250)
	GUISetBkColor(0x2D2D2D)
	GUICtrlSetDefColor(0xFFFFFF, $iGUI)
	GUICtrlSetDefBkColor(0x2D2D2D, $iGUI)

	; show gui, define progress
	GUISetState(@SW_SHOW, $iGUI)
	$iProgress = GUICtrlCreateProgress(10, 10, 300, 25, -1, -1)

	; *** step 1: define variables
	GUICtrlCreateLabel("Define variables...                               ", 10, 33, -1, -1)
	GUICtrlSetData($iProgress, "20")
	Sleep(10)

	; define main vars
	Global $mGUI, $SNAME, $SVER, $Btn[2], $icon, $back, $bExit ; gui objects
	Global $1LD[1024], $2LD[64], $3LD[64], $F[2048] ; read directories, files and write data to $cfg, create menu system
	Global $list, $a, $1 = "", $2 = 1, $ext = "*.exe" ; define extension for the files

	; *** step 2: set dirs
	GUICtrlCreateLabel("Scanning config file...                           ", 10, 33, -1, -1)
	GUICtrlSetData($iProgress, "40")
	Sleep(10)

	; set directories
	Global $instD = @ScriptDir & "\install" ; applications directory
	Global $binD = @ScriptDir & "\bin" ; language files directory

	; define cfg file
	Global $cfg = @ScriptDir & "\bin\config.ini" ; main config file

	; create cfg if not exist
	If FileExists($cfg) = False Then
		DirCreate($binD)
		IniWrite($cfg, "Main", "SNAME", "AutoInstaller")
		IniWrite($cfg, "Main", "SVER", "2.4.07.30 Ultimate Edition")
	EndIf

	; *** step 3: setting up themes
	GUICtrlCreateLabel("Setting up themes...                              ", 10, 33, -1, -1)
	GUICtrlSetData($iProgress, "60")
	Sleep(10)

	; define theme variables
	Global $icon = $binD & "\autoinstaller.ico"
	Global $back = $binD & "\back.bmp" ; 1000x400
	Global $bExit = $binD & "\exit.ico"

	; *** step 4: create head
	GUICtrlCreateLabel("Createing head...                                 ", 10, 33, -1, -1)
	GUICtrlSetData($iProgress, "70")
	Sleep(10)

	; define head
	Global $SNAME = IniRead($cfg, "Main", "SNAME", "")
	Global $SVER = IniRead($cfg, "Main", "SVER", "")

	; *** step 5: creating menu structure
	GUICtrlCreateLabel("Creating menu structure...                        ", 10, 33, -1, -1)
	GUICtrlSetData($iProgress, "90")
	Sleep(10)

	; delete old menu system
	IniDelete($cfg, "Menu")
	IniDelete($cfg, "ShellExecute")

	; generate data
	$F = _FileListToArrayRec($instD, $ext, $FLTA_FILES, $FLTAR_RECUR, $FLTAR_SORT, True)
	$list = IniWrite($cfg, "Menu", "$F[0]", "GUICtrlCreateList(" & '"' & '"' & ", 10, 10, 880, 400)")
	For $1 In $F
		If IsString($1) Then
			IniWrite($cfg, "Menu", "$F[" & $2 & "]", "GUICtrlSetData($F[0]," & '"' & $1 & '"' & ")")
			IniWrite($cfg, "ShellExecute", $2, $instD & "\" & $1)
			$2 += 1
		Else
		EndIf
	Next

	; *** step 6: done
	GUICtrlCreateLabel("Done...                                           ", 10, 33, -1, -1)
	GUICtrlSetData($iProgress, "100")
	; wait 0.50s
	Sleep(10)

	; delete gui and run main gui
	GUIDelete($iGUI)
	mGUI()
EndFunc		;==>Init

Func mGUI()
	; delete old guis
	GUIDelete($iGUI)
	GUIDelete($mGUI)

	; define gui
	Global $mGUI = GUICreate($SNAME & "   " & $SVER, 1000, 400, -1, -1, -1, -1)
	GUISetIcon($icon, 0)
	GUISetFont(8, $FW_MEDIUM, "", "Comic Sans Ms", $mGUI, $CLEARTYPE_QUALITY)
	;WinSetTrans($mGUI, "", 250)
	GUICtrlCreatePic($back, 0, 0, 1000, 400, $BS_BITMAP)
	GUICtrlSetDefColor(0xFFFFFF, $mGUI)
	GUICtrlSetDefBkColor(0x2D2D2D, $mGUI)

	; generating data
	Global $F[2048] ; reset variables for create menu system
	Global $1 = 1 ; sequence variables

	; reading menu program path data from $cfg - menuitem level 2
	For $1 = 0 To 2048 Step 1
		If IniRead($cfg, "Menu", "$F[" & $1 & "]", "") <> "" Then
			$F[$1] = IniRead($cfg, "Menu", "$F[" & $1 & "]", "")
			$F[$1] = $F[$1]
			; create menuitems
			If $F[$1] <> "" Then $F[$1] = Execute($F[$1])
		Else
		EndIf
	Next

	; install button [1]
	$Btn[1] = GUICtrlCreateButton("  Install", 895, 10, 100, 50, $BS_ICON)
	GUICtrlSetImage($Btn[1], $icon, "", 2)
	GUICtrlSetCursor($Btn[1], 0)
	GUICtrlSetStyle($Btn[1], $BS_LEFT)

	; exit button [0]
	$Btn[0] = GUICtrlCreateButton("  Exit", 895, 343, 100, 50, $BS_ICON)
	GUICtrlSetImage($Btn[0], $bExit, "", 2)
	GUICtrlSetCursor($Btn[0], 0)
	GUICtrlSetStyle($Btn[0], $BS_LEFT)

	; show gui
	GUISetState(@SW_SHOW, $mGUI)
EndFunc		;==>mGUI

Func Installing()
		$a = GUICtrlRead($F[0])
		Shellexecute($instD & "\" & $a)
EndFunc		;==>Installing

; *** SYSTEM CORE ***
While - 1
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE , $Btn[0] ; exit
			GUIDelete($mGUI)
			ExitLoop
		Case $Btn[1] ; install
			Installing()
	EndSwitch
WEnd