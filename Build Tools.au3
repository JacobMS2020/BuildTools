#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile_x64=Build Tools 6.1.0.1.exe
#AutoIt3Wrapper_Res_Comment=This program helps IT professionals automate your work.
#AutoIt3Wrapper_Res_Description=Automation Software By Jacob Stewart
#AutoIt3Wrapper_Res_Fileversion=5.1.0.2
#AutoIt3Wrapper_Res_ProductName=Build Tools5.1.0.2
#AutoIt3Wrapper_Res_ProductVersion=5.1.0.2
#AutoIt3Wrapper_Res_CompanyName=jTech Computers
#AutoIt3Wrapper_Res_LegalCopyright=NA
#AutoIt3Wrapper_Res_LegalTradeMarks=NA
#AutoIt3Wrapper_Res_SaveSource=y
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
Global $version="6.1.0.1"
Global $version_name='Build Tools 6 - Crunchy Packet'
;VERSION 4 AND ABOVE IS NOW HOSTED ON GITHUB.COM
Global $admin=0
If FileExists(@ScriptDir&"\admin") Then $admin=1

ProgressOn("Starting...","Starting...","Loading varables...")
ProgressSet(20,"Setting up Varables...")
#Region ==================================================================================================================== Var

;=== Include ===
#include <File.au3>
#include <GUIComboBoxEx.au3>

;=== Error ===
$ErrorMissingFiles=0

;=== Links ===
Global $LinkWebsiteHelp="https://github.com/kingjacob280/BuildTools/wiki/Help"
Global $LinkWebsite="https://github.com/kingjacob280/BuildTools"
Global $LinkCurrentVersion="https://raw.githubusercontent.com/kingjacob280/BuildTools/main/current%20version.txt"
Global $LinkGrabify="https://grabify.link/WUCHEN" ; Tracking link for stats

;=== Dir ===
Global $DirBin=@ScriptDir&"\Build Tools"
If Not FileExists($DirBin) Then DirCreate($DirBin)
Global $DirOther=$DirBin&"\Other"
Global $dirLocalRoamCache=@LocalAppDataDir&"\Microsoft\Outlook\RoamCache"

;=== File ===
Global $FileLog=$DirBin&"\Log.log"
Global $FileClipHistory=$DirBin&"\ClipBoardHistory.txt"
Global $FileInstallers=$DirBin&"\installers.txt"
_log("---running---") ;Start the log file

;SetDefaultBrowser.exe
Global $FileDefaultBrowserEXE=$DirOther&"\SetDefaultBrowser.exe"
If Not FileExists($FileDefaultBrowserEXE) Then $ErrorMissingFiles+=1

;anydesk.exe
Global $FileAnyDesk=$DirOther&"\anydesk.exe"
If Not FileExists($FileAnyDesk) Then $ErrorMissingFiles+=1

Global $FileStartUp=@ScriptDir&"\Startup=true"
Global $FileStartUpLink=@StartupCommonDir&"\buildtools.lnk"
Global $fileKnownDirectories=$DirBin&"\Known Directories.txt"
If Not FileExists($fileKnownDirectories) Then FileWrite($fileKnownDirectories,"\AppData\Roaming\Thunderbird\Profiles")

;=== User Folder Dir ===
Global $DirFromFolder="unknow"
Global $DirToFolder=@UserProfileDir
_log("File Check Done")

;=== Version ===
Global $CurrentVersion=BinaryToString(InetRead($LinkCurrentVersion))
$CurrentVersion=StringStripWS($CurrentVersion,8)
If $CurrentVersion="" Then
	_log("ERROR: Could not get current version")
	$CurrentVersion="unknown"
Else
	_log("Current Version Read: "&$CurrentVersion)
EndIf

;=== COLOR ===
Global $colorOrange=0xF89123
Global $colorRED_dark=0x990000
Global $colorRed=0xff0000
Global $colorGreen=0x478a00
Global $colorBlue=0x000fb0
Global $colorBlueLight=0x027dc4
Global $colorBlack=0x000000
Global $colorPink=0xff54cf
Global $colorGray=0xd1d1d1
Global $colorGrayLight=0xededed

Global $ColorInput=$colorGrayLight

;=== GUI Button ===
$FontButtons=10
$WeightButtons=700
$AttButtons=""
$FontNameButtons=""
$SpacingButtons=25

;=== Server ===
Global $ServerActive=0
Global $ClientActive=0
Global $ServerIP=@IPAddress1
Global $CycleNumber=1
Global $ServerPort=3000

;=== REG ===
Global $regSearch[3] = ["HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Search","SearchboxTaskbarMode","REG_DWORD"]
Global $regTask[3] = ["HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced","ShowTaskViewButton","REG_DWORD"]
Global $regCortana[3]=["HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced","ShowCortanaButton","REG_DWORD"]
Global $regHibernateEnabled[3]=["HKEY_LOCAL_MACHINE\System\ControlSet001\Control\Power","HibernateEnabled","REG_DWORD"]
;DATA = ChromeHTML
Global $regBrowser1[3]=["HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.htm\UserChoice","ProgId","REG_SZ"]

;=== GLOBAL ===
Global $CheckSoftware[99]
Global $StatusSearch, $StatusTask, $StatusCortana
Global $ButtonAbout, $ButtonInstall, $ButtonLog, $ButtonSearchIcon, $ButtonTaskIcon, $ButtonCopyAll
Global $ComboFromDrive, $ComboUsersFrom, $LableUserFromDir
Global $Socket, $SocketListen
Global $FontButtons,$WeightButtons,$AttButtons,$FontNameButtons, $SpacingButtons

;=== stopping decloration error ===
Global $ButtonSearchIcon="error"
Global $ButtonTaskIcon="error"
Global $ButtonGoogleChromeDefault="error"
Global $ButtonCortanaIcon="error"
Global $ButtonHibernateEnabled="error"

_log("Vars loaded")
;----Running live
#EndRegion ==================================================================================================================== Var
ProgressSet(60,"More setup...")

#Region ==================================================================================================================== Startup


If FileExists($FileStartUp) Then ;--------------------------- Remove startup files (if existes)
	$temp=FileDelete($FileStartUp)
	$temp2=FileDelete($FileStartUpLink)
	_log("startup files deleted, code: "&$temp&$temp2)
EndIf

If $admin=0 Then InetRead($LinkGrabify,3) ; Tracking for stats

If $ErrorMissingFiles>0 Then
	ProgressOff()
	MsgBox(48,"Warning!","Warning! There are "&$ErrorMissingFiles&" missing files, please re-download the 'Build Tools' folder!"&@CRLF&"The program will not run correctly if this is not done. (Note: "& _
	"The program cannot be run from within the .zip file, please extract the program first.)")
	_log("WARNING: Files are missing!")
	ProgressOn("Starting...","Starting...","More setup...")
	ProgressSet(60,"More setup...")
EndIf

_log("Version: "&$version)

#EndRegion==================================================================================================================== Startup

#Region ==================================================================================================================== Var/Status Setup

Func _StatusGoogleChromeDefault()
	$regBrowser1Read=RegRead($regBrowser1[0],$regBrowser1[1])
	If $regBrowser1Read="ChromeHTML" Then
		$StatusGoogleChrome="Is Default"
	Else
		$StatusGoogleChrome="Not Default"
	EndIf
	GUICtrlSetData($ButtonGoogleChromeDefault,"Chrome ("&$StatusGoogleChrome&")")
EndFunc

Func _StatusHibernateEnabled()
	$regHibernateEnabledRead=RegRead($regHibernateEnabled[0],$regHibernateEnabled[1])
	If $regHibernateEnabledRead=1 Then
		$StatusHibernateEnabled="Is On"
	ElseIf $regHibernateEnabledRead=0 Then
		$StatusHibernateEnabled="Is Off"
	Else
		$StatusHibernateEnabled="Unknown"
	EndIf
	GUICtrlSetData($ButtonHibernateEnabled,"Fast Boot ("&$StatusHibernateEnabled&")")
EndFunc

#EndRegion ==================================================================================================================== Var/Status Setup
ProgressSet(80,"Building GUI...")

#Region ==================================================================================================================== GUI setup
Global $guiH, $guiW
$guiH=695
$guiW=450
$guiName="Build Tools (v"&$version&")"
If $admin=1 Then $guiName="Build Tools (v"&$Version&") - admin"
GUICreate($guiName,$guiW,$guiH)
	GUISetBkColor(0xffffff)

; --------------------------------------------------------------------------------------- Bottom

$ButtonAbout=GUICtrlCreateButton("about",$guiW-82,$guiH-22,80,20)
	GUICtrlSetFont(01,7)
	GUICtrlSetColor(-1,$colorBlue)

$ButtonHelp=GUICtrlCreateButton("help",$guiW-164,$guiH-22,80,20)
	GUICtrlSetFont(01,7)
	GUICtrlSetColor(-1,$colorBlue)

$ButtonWebsite=GUICtrlCreateButton("GitHub Page",5,$guiH-22,135,20)
	GUICtrlSetFont(01,7)
	GUICtrlSetColor(-1,$colorBlue)
$ButtonUpdate=GUICtrlCreateButton("Update ("&$CurrentVersion&")",140,$guiH-22,135,20)
	GUICtrlSetFont(01,7)
	If $CurrentVersion>$version Then
		GUICtrlSetColor(-1,$colorOrange)
	Else
		GUICtrlSetColor(-1,$colorBlue)
	EndIf

$LableCurrentClip=GUICtrlCreateLabel("Current Clipboard: "&ClipGet(),5,$guiH-215,$guiW-10,15)
	GUICtrlSetColor(-1,$colorGreen)
$ButtonClear=GUICtrlCreateButton("Clear",5,$guiH-200,75)
GUICtrlCreateLabel("Clipboard History - (This will be keeped even after program is closed)",85,$guiH-195,$guiW-90)
	GUICtrlSetFont(-1,8,700)
$ListClipHistory=GUICtrlCreateList(ClipGet(),5,$guiH-175,$guiW-10,150)
	GUICtrlSetBkColor(-1,$ColorInput)
If FileExists($FileClipHistory) Then
	$count=_FileCountLines($FileClipHistory)
	For $i=1 to $count Step 1
		GUICtrlSetData($ListClipHistory,FileReadLine($FileClipHistory,$i))
	Next
EndIf



; --------------------------------------------------------------------------------------- TOP
$top=5
GUICtrlCreateLabel($version_name,5,$top,$guiW-10,17,0x01)
	GUICtrlSetFont(-1,11,600)
	GUICtrlSetBkColor(-1,$colorBlueLight)
	GUISetBkColor($colorGray)

; --------------------------------------------------------------------------------------- LEFT
$width=$guiW/2-3
$top+=20

;Software setup
Global $SoftwareInstallers[99][2]
Global $SoftwareCount=0
Global $SoftwareError=0
If _FileCountLines($FileInstallers) > 1 Then
	For $i = 2 to _FileCountLines($FileInstallers) step 1
		$SoftwareCount+=1
		$temp = StringSplit(FileReadLine($FileInstallers,$i),",")
		If $temp[0] <> 2 then
			ProgressOff()
			MsgBox(16,'ERROR Installers','There is a syntax error in the installers.txt file (line: '&$i&')' & @CRLF & FileReadLine($FileInstallers,$i))
			Exit
		EndIf
		$SoftwareInstallers[$i][0] = $temp[1]
		$SoftwareInstallers[$i][1] = $temp[2]
		$CheckSoftware[$i]=GUICtrlCreateCheckbox($temp[1],5,$top,$width,15)
		GUICtrlSetBkColor(-1,0xbdbdbd)
		$top+=20
	Next
	$SoftwareError=0

Else
	$SoftwareError=1
	_log("No Software!")
EndIf

$ButtonInstall=GUICtrlCreateButton("Install Selected",5,$top,$width,25)
	GUICtrlSetFont(-1,$FontButtons,$WeightButtons,$AttButtons,$FontNameButtons)
$top+=$SpacingButtons
$ButtonAddInstallers=GUICtrlCreateButton("Add More Installers",5,$top,$width,25)
$top+=35

$ButtonHibernateEnabled=GUICtrlCreateButton("Fast Boot On/Off",5,$top,$width,25)
	GUICtrlSetFont(-1,$FontButtons,$WeightButtons,$AttButtons,$FontNameButtons)
$top+=$SpacingButtons

$ButtonTaskbarIconsSetDefault=GUICtrlCreateButton("Taskbar Icons to Default",5,$top,$width,25)
	GUICtrlSetFont(-1,$FontButtons,$WeightButtons,$AttButtons,$FontNameButtons)
$top+=$SpacingButtons

$ButtonExplorerRestart=GUICtrlCreateButton("Restart Explorer",5,$top,$width,25)
	GUICtrlSetFont(-1,$FontButtons,$WeightButtons,$AttButtons,$FontNameButtons)
$top+=$SpacingButtons

$ButtonSetupAnyDesk=GUICtrlCreateButton("Setup AnyDesk",5,$top,$width,25)
	GUICtrlSetFont(-1,$FontButtons,$WeightButtons,$AttButtons,$FontNameButtons)
$top+=$SpacingButtons

$ButtonGoogleChromeDefault=GUICtrlCreateButton("Google Chrome Default",5,$top,$width,25)
	GUICtrlSetFont(-1,$FontButtons,$WeightButtons,$AttButtons,$FontNameButtons)
$top+=$SpacingButtons

$ButtonPowerOptions=GUICtrlCreateButton("Power Options",5,$top,$width,25)
	GUICtrlSetFont(-1,$FontButtons,$WeightButtons,$AttButtons,$FontNameButtons)
$top+=$SpacingButtons

$ButtonUpdateWindows=GUICtrlCreateButton("Update Windows",5,$top,$width,25)
	GUICtrlSetFont(-1,$FontButtons,$WeightButtons,$AttButtons,$FontNameButtons)
$top+=$SpacingButtons

$LableComputerName=GUICtrlCreateLabel("Computer Name: "&@ComputerName,5,$top,$width,25)
$top+=20
$ButtonChangeComputerName=GUICtrlCreateButton("Change",5,$top,$width*0.3,25)
	GUICtrlSetFont(-1,$FontButtons,$WeightButtons,$AttButtons,$FontNameButtons)
$InputChangeComputerName=GUICtrlCreateInput(@YEAR&"-COMPUTER",($width*0.3)+10,$top,$width*0.65,25)
	GUICtrlSetFont(-1,11,500)
	GUICtrlSetBkColor(-1,$ColorInput)
$top+=$SpacingButtons

#cs; Not used yet because of coding dificalties
$ButtonChangeUserName=GUICtrlCreateButton("Change Account User Name",5,$top,$width,25)
	GUICtrlSetFont(-1,$FontButtons,$WeightButtons,$AttButtons,$FontNameButtons)
$top+=$SpacingButtons
#ce

$ButtonReboot=GUICtrlCreateButton("Reboot Computer",5,$top,$width,25)
	GUICtrlSetFont(-1,$FontButtons,$WeightButtons,$AttButtons,$FontNameButtons)
$top+=$SpacingButtons

; --------------------------------------------------------------------------------------- RIGHT

$top=25
$left=($guiW/2)+3
$width=$guiW/2-6

GUICtrlCreateLabel("TCP:",$left,$top+3,30)
	GUICtrlSetFont(-1,10,700)
$ButtonServerOnOFF=GUICtrlCreateButton("Server",$left+35,$top,($width/2)-20)
	GUICtrlSetFont(-1,10,700)
$ButtonClientOnOFF=GUICtrlCreateButton("Client",$left+($width/2)+15,$top,($width/2)-20)
	GUICtrlSetFont(-1,10,700)
$top+=35

GUICtrlCreateLabel("Server IP:",$left,$top+2,70)
	GUICtrlSetFont(-1,10,700)
$InputServerIP=GUICtrlCreateInput($ServerIP,$left+75,$top,$width-105)
	GUICtrlSetFont(-1,9,700)
	GUICtrlSetBkColor(-1,$ColorInput)
$ButtonCycleIP=GUICtrlCreateButton("+",($left+75)+$width-105,$top-2,25)
$top+=25

GUICtrlCreateLabel("Port:",$left,$top+2,70)
	GUICtrlSetFont(-1,10,700)
$InputServerPort=GUICtrlCreateInput($ServerPort,$left+75,$top,$width-80)
	GUICtrlSetFont(-1,9,700)
	GUICtrlSetBkColor(-1,$ColorInput)
$top+=30

GUICtrlCreateLabel("  Server to Client Copy  ",$left,$top,$width,-1,0x01)
	GUICtrlSetFont(-1,10,700,4)
	GUICtrlSetColor(-1,$colorGreen)
$top+=20

$InputCopy=GUICtrlCreateInput("Message to send to client (or recive)",$left,$top,$width)
	GUICtrlSetBkColor(-1,$ColorInput)
$top+=25

$ButtonUpdateCopy=GUICtrlCreateButton("Update and Copy",$left,$top,$width/2)
	GUICtrlSetFont(-1,8,700)
$ButtonPast=GUICtrlCreateButton("Paste",$left+$width/2,$top,$width/2)
	GUICtrlSetFont(-1,8,700)
$top+=35

GUICtrlCreateLabel("  Folder Copy  ",$left,$top,$width,-1,0x01) ; -- Folder Copy
	GUICtrlSetFont(-1,10,700,4)
	GUICtrlSetColor(-1,$colorGreen)
$top+=25

$ButtonFolderBackup=GUICtrlCreateButton("Backup Folders / Drive to Drive",$left,$top,$width)
	GUICtrlSetFont(-1,$FontButtons,$WeightButtons,$AttButtons,$FontNameButtons)
$top+=25

$ButtonFolderImport=GUICtrlCreateButton("Import Folders",$left,$top,$width)
	GUICtrlSetFont(-1,$FontButtons,$WeightButtons,$AttButtons,$FontNameButtons)
$top+=25

$ButtonImportExportAutoStream=GUICtrlCreateButton("Import Outlook Autocomplete",$left,$top,$width)
	GUICtrlSetFont(-1,$FontButtons,$WeightButtons,$AttButtons,$FontNameButtons)
$top+=25

; -- Last GUI setup

GUISetState()

#EndRegion ==================================================================================================================== GUI setup

#Region ==================================================================================================================== Last call (var setup)
_StatusGoogleChromeDefault()
_StatusHibernateEnabled()

Global $ClipCurrent=ClipGet()
Global $ClipTimer=TimerInit()

ProgressSet(100,"Done")
_log("Loading Done")
Sleep(300)
#EndRegion
ProgressOff()
#Region ==================================================================================================================== While Loop 1 -- MAIN
While 1
	$guiMSG = GUIGetMsg()
	If $ServerActive=1 Then _Server()
	If $ClientActive=1 Then _Client()

	If TimerDiff($ClipTimer)>1000 Then
		$ClipRead=ClipGet()
		If $ClipRead<>$ClipCurrent And $ClipRead<>"" Then
			$ClipCurrent=ClipGet()
			GUICtrlSetData($LableCurrentClip,"Current Clipboard: "&$ClipCurrent)
			GUICtrlSetData($ListClipHistory,$ClipCurrent)
			FileWrite($FileClipHistory,$ClipCurrent&@CRLF)

		EndIf
	EndIf


	Switch $guiMSG
		Case -3
			_exit(0)

		Case $ListClipHistory ;ClipBoard History
			$ClipCurrent=GUICtrlRead($ListClipHistory)
			ClipPut($ClipCurrent)
			GUICtrlSetData($LableCurrentClip,"Current Clipboard: "&$ClipCurrent)

		Case $ButtonClear ;ClipBoard History
			FileDelete($FileClipHistory)
			GUICtrlSetData($ListClipHistory,"")

		Case $ButtonAbout
			MsgBox(0,"About","Program Designed and Written by Jacob Stewart"&@CRLF&"Version: "&$version)

		Case $ButtonTaskbarIconsSetDefault
			_TaskbarIconsToDefault()

		Case $ButtonExplorerRestart
			Run('"' & @ComSpec & '" /k ' &"taskkill /F /IM explorer.exe && start explorer",@WindowsDir,@SW_HIDE) ;restart explorer.exe
			GUICtrlSetBkColor($ButtonExplorerRestart,15069691)

		Case $ButtonUpdateWindows
			Run('"' & @ComSpec & '" /k ' &"C:\Windows\System32\control.exe /name Microsoft.WindowsUpdate",@WindowsDir,@SW_HIDE)

		Case $ButtonInstall
			_install()

		Case $ButtonGoogleChromeDefault
			_ChromeMakeDefault()

		Case $ButtonServerOnOFF
			_Server()

		Case $ButtonClientOnOFF
			_Client()

		Case $ButtonCycleIP
			If $CycleNumber=1 Then
				$CycleNumber=2
				$ServerIP=@IPAddress2
				GUICtrlSetData($InputServerIP,@IPAddress2)
			ElseIf $CycleNumber=2 Then
				$CycleNumber=3
				$ServerIP=@IPAddress3
				GUICtrlSetData($InputServerIP,@IPAddress3)
			ElseIf $CycleNumber=3 Then
				$CycleNumber=4
				$ServerIP=@IPAddress4
				GUICtrlSetData($InputServerIP,@IPAddress4)
			ElseIf $CycleNumber=4 Then
				$CycleNumber=1
				$ServerIP=@IPAddress1
				GUICtrlSetData($InputServerIP,@IPAddress1)
			EndIf

		Case $ButtonUpdateCopy
			_Client()
			ClipPut(GUICtrlRead($InputCopy))

		Case $ButtonPast
			GUICtrlSetData($InputCopy,ClipGet())

		Case $ButtonWebsite
			ShellExecute($LinkWebsite)

		Case $ButtonHelp
			ShellExecute($LinkWebsiteHelp)

		Case $ButtonSetupAnyDesk
			_SetupAnyDesk()

		Case $ButtonChangeComputerName
			_ChangeComputerName()

		Case $ButtonReboot
			_Reboot()

		Case $ButtonHibernateEnabled
			_FastBootOnOff()

		;Case $ButtonChangeUserName ;Future use
			;_ChangeUserName()

		Case $ButtonAddInstallers
			If Not FileExists($FileInstallers) Then
				MsgBox(16,"Error","The program has not been installed correctly, please download and extract the 'Build Tools' folder again.")
				_log("ERROR: "&$FileInstallers&" Does not exist, this is because the program has not been fully installed/downloaded correctly.")
			Else
				ShellExecute($FileInstallers)
				Sleep(1000)
				MsgBox(0,"Info","NOTE: Build Tools will need to be reloaded if programs are added.", 4)
			EndIf

		Case $ButtonUpdate
			_Update()

		;Case $ButtonLog
			;ShellExecute($FileLog)

		Case $ButtonPowerOptions
			_PowerOptions()

		Case $ButtonImportExportAutoStream
			_IEAS()

		Case $ButtonFolderBackup
			_FolderBackup()

		Case $ButtonFolderImport
			_FolderImport()

		;Case
	EndSwitch
WEnd
#EndRegion ==================================================================================================================== While Loop 1 -- MAIN

#Region ==================================================================================================================== FUNCTIONS

Func _FolderBackup()

	_log("_FolderBackup called")

	$temp=MsgBox(4,"USER ACCOUNT SELECTION","Backup folders from this user profile dir? (You will need to change this to the old user profile if you are doing a 'drive to drive' copy."&@CRLF&@UserProfileDir)
	If $temp=6 Then
		$_FB_DirUserAccount=@UserProfileDir
	ElseIf $temp=7 Then
		$_FB_DirUserAccount=FileSelectFolder("Browse to user folder you would like to backup from","::{20D04FE0-3AEA-1069-A2D8-08002B30309D}")
	Else
		Return
	EndIf

	If Not FileExists($_FB_DirUserAccount&"\Documents") Then
		MsgBox(16,"ERROR","This is not a user account")
		Return
	EndIf

	;var setup
	Global $_FB_CheckBox[99]
	$_FB_DriveToDrive=0

	;GUI setup
	$_FB_Width=500
	$_FB_Hight=600
	$_FB_GUI=GUICreate("Folder Backup",$_FB_Width,$_FB_Hight)

	$top=5
	GUICtrlCreateLabel("Selected 'From' User: "&$_FB_DirUserAccount,5,$top,$_FB_Width-10)
	$top+=20

	GUICtrlCreateLabel("Select folders to backup:",5,$top,$_FB_Width-10)
		GUICtrlSetFont(-1,11,700)
	$top+=20

	$_FB_CheckBoxAllButAppdata=GUICtrlCreateCheckbox("Root user folders excluding AppData (Desktop, Documents, ect...)",5,$top,$_FB_Width-10)
	GUICtrlSetState(-1,1)
	$top+=20

	If Not FileExists($_FB_DirUserAccount&"\AppData\Local\Microsoft\Outlook\RoamCache") Then
		$_FB_CheckBoxOutlookStreamAuto=GUICtrlCreateCheckbox("Outlook RoamCache (will be saved to the root backup/user folder)",5,$top,$_FB_Width-10,"",0x08000000)
	Else
		$_FB_CheckBoxOutlookStreamAuto=GUICtrlCreateCheckbox("Outlook RoamCache (will be saved to the root backup/user folder)",5,$top,$_FB_Width-10)
	EndIf
	$top+=20

	$_FB_LineCount=_FileCountLines($fileKnownDirectories)
	For $i=1 To $_FB_LineCount Step 1
		$tempdir=FileReadLine($fileKnownDirectories,$i)
		If FileExists($_FB_DirUserAccount&$tempdir) Then
			$_FB_CheckBox[$i]=GUICtrlCreateCheckbox($tempdir,5,$top,$_FB_Width-10)
		Else
			GUICtrlCreateCheckbox($tempdir,5,$top,$_FB_Width-10,"",0x08000000)
		EndIf
		$top+=20
	Next
	$top+=10

	$_FB_ButtonBackup=GUICtrlCreateButton("Backup",5,$top,75,25)
		GUICtrlSetFont(-1,$FontButtons,$WeightButtons,$AttButtons,$FontNameButtons)
	$_FB_ButtonBackupDrivetoDrive=GUICtrlCreateButton("Copy Drive to Drive",80,$top,150,25)
		GUICtrlSetFont(-1,$FontButtons,$WeightButtons,$AttButtons,$FontNameButtons)
	$_FB_ButtonAddDirectories=GUICtrlCreateButton("Add more directories",230,$top,115,25)
	$top+=25
	GUICtrlCreateLabel("WANRING: If you are doing a 'Drive to Drive' copy, the backup location will be the new user profile root folder.",5,$top,$_FB_Width-10,50)

	GUISetState(@SW_SHOW,$_FB_GUI)

	;Loop setup
	While 1
		$guiMSG=GUIGetMsg()

		Switch $guiMSG
			Case -3
				GUIDelete($_FB_GUI)
				Return

			Case $_FB_ButtonBackup
				ExitLoop

			Case $_FB_ButtonBackupDrivetoDrive
				$_FB_DriveToDrive=1
				_log("Drive to Drive selected 1/2")
				ExitLoop

			Case $_FB_ButtonAddDirectories
				ShellExecute($fileKnownDirectories)

		EndSwitch

	WEnd

	;Backup process
	$_FB_DirBackupLocation=FileSelectFolder("Browse to Backup location","::{20D04FE0-3AEA-1069-A2D8-08002B30309D}")
	If $_FB_DriveToDrive=0 Then
		$_FB_DirBackupLocation=$_FB_DirBackupLocation&"build_tools_backup_"&InputBox("User name","Input the name of the user/customer you are backing up and any other information you want.","_"&@YEAR&@MON&@MDAY)
	EndIf
	$temp=MsgBox(4,"Example","From: '"&$_FB_DirUserAccount&"\Documents Folder'"&@CRLF&"To: '"&$_FB_DirBackupLocation&"\Documents Folder'"&@CRLF&"Does this look correct?")
	If $temp<>6 Then Return

	If GUICtrlRead($_FB_CheckBoxAllButAppdata)=1 Then
		_log("Copying all but appdata")
		Run('"' & @ComSpec & '" /k ' &'robocopy "'&$_FB_DirUserAccount&'" "'&$_FB_DirBackupLocation&'" /E /Z /ZB /R:2 /W:1 /V /XA:ST /xjd /XD "'&$_FB_DirUserAccount&'\Appdata"',@WindowsDir,@SW_SHOW)
	EndIf

	If GUICtrlRead($_FB_CheckBoxOutlookStreamAuto)=1 Then
		_log("Copying OutlookStreamAutocompleate")
		Run('"' & @ComSpec & '" /k ' &'robocopy "'&$_FB_DirUserAccount&"\AppData\Local\Microsoft\Outlook\RoamCache"&'" "'&$_FB_DirBackupLocation&'\RoamCache'&'" /E /Z /ZB /R:2 /W:1 /V /xjd"',@WindowsDir,@SW_SHOW)
	EndIf

	For $i=1 To $_FB_LineCount Step 1
		If GUICtrlRead($_FB_CheckBox[$i])=1 Then
			$tempdir=FileReadLine($fileKnownDirectories,$i)
			_log("Copying "&$tempdir)
			Run('"' & @ComSpec & '" /k ' &'robocopy "'&$_FB_DirUserAccount&$tempdir&'" "'&$_FB_DirBackupLocation&$tempdir&'" /E /Z /ZB /R:2 /W:1 /V /xjd"',@WindowsDir,@SW_SHOW)
		EndIf
	Next


	GUIDelete($_FB_GUI)
	Return

EndFunc

Func _FolderImport() ;-- Folder Import

	_log("_FolderImport called")
	$temp=MsgBox(52,'Warning','Did you backup user folders using Build Tools?'&@CRLF&'If you did not, the copy to a new user account will not work as permissions might be corrupt!')

	$temp=MsgBox(4,"USER ACCOUNT SELECTION","Import folders into this user profile dir?"&@CRLF&@UserProfileDir)
	If $temp=6 Then
		$_FI_DirUserAccount=@UserProfileDir
	ElseIf $temp=7 Then
		$_FI_DirUserAccount=FileSelectFolder("Browse to user folder you would like to import folders to","::{20D04FE0-3AEA-1069-A2D8-08002B30309D}")
	Else
		Return
	EndIf

	If $temp<>6 Then Return

	$_FI_DirImportLocation=FileSelectFolder("Select 'Build_Tools_Backup folder'","::{20D04FE0-3AEA-1069-A2D8-08002B30309D}")

	$temp=MsgBox(4,'Confirm',"Copy folders and files:"&@CRLF&'From: '&$_FI_DirImportLocation&@CRLF&'To: '&$_FI_DirUserAccount)
	If $temp<>6 Then Return

	_log('')
	Run('"' & @ComSpec & '" /k ' &'robocopy "'&$_FI_DirImportLocation&'" "'&$_FI_DirUserAccount&'" /E /Z /ZB /R:2 /W:1 /V /xjd"',@WindowsDir,@SW_SHOW)

EndFunc

Func _IEAS()

	_log("_IEAS called")


	If Not FileExists($dirLocalRoamCache) Then
		MsgBox(16,"Error","Outlook 'RoamCache' folder does not exist!"&@CRLF&"Please setup Outlook First.")
		Return
	EndIf

	MsgBox(48,"WARNING","1. Please close outlook!"&@CRLF&"2. Please use the 'Backup Folders' Tool and then the 'Import Folders' tool in Build Tools to export the RoamCache folder out of the old user profile."& _
	@CRLF&"3. Note, this is for Outlook versions using Stream files only (not NK2)")


	FileChangeDir($dirLocalRoamCache)
	$_IEAS_Search=FileFindFirstFile("Stream_Autocomplete*.dat")
	If $_IEAS_Search==-1 Then
		MsgBox(16,"ERROR","No Stream file found!")
		_log("ERROR: Could not find stream file.")
		Return
	EndIf
	$count=0
	Do
		$_IEAS_SearchTemp=FileFindNextFile($_IEAS_Search)
		If @error<>1 Then
			$_IEAS_FileCurrentLocalStream=$_IEAS_SearchTemp
			$count+=1
		EndIf
	Until @error=1
	If $count>1 Then
		MsgBox(16,"ERROR","There is more than 1 Auto Stream File! This automation process will not work, please notify the program admin.")
		_log("ERROR: More than one auto stream file found. Count: "&$count)
		ShellExecute($dirLocalRoamCache)
		Return
	EndIf

	If Not FileExists(@UserProfileDir&"\RoamCache") Then MsgBox(48,"WARNING","You have not used Build Tools to export the Outlook RoamCache folder,"& _
	" if you have please contact the program admin. You can now select the Stream file manualy and the process will continue.")
	$_IEAS_FileStreamToImport=FileOpenDialog("Import Auto Stream File",@UserProfileDir&"\RoamCache","Stream (Stream_Autocomplete*.dat)",3)
	If @error<>0 Then Return

	;The automation part
	FileCopy($dirLocalRoamCache&"\"&$_IEAS_FileCurrentLocalStream,$dirLocalRoamCache&"\"&$_IEAS_FileCurrentLocalStream&".build_tools_backup",0)
	Do
		FileDelete($dirLocalRoamCache&"\"&$_IEAS_FileCurrentLocalStream)
		Sleep(1000)
		FileCopy($_IEAS_FileStreamToImport,$dirLocalRoamCache&"\"&$_IEAS_FileCurrentLocalStream,1)
		$temp=MsgBox(4,"Repeat","Repeat delete and copy of Stream file?"&@CRLF&"(Outlook will sometimes overwite the Stream_autocompleate file on its 1st boot after the copy)")
	Until $temp<>6

	Return

EndFunc

Func _PowerOptions()

	_log("_PowerOptions called")
	ShellExecute("powercfg.cpl")

EndFunc

Func _Update()

	_log("_Update called")
	_log("Current Version: "&$CurrentVersion)
	_log("Version: "&$version)

	$_UpdateLink="https://github.com/kingjacob280/BuildTools/raw/main/Build%20Tools%20"&$CurrentVersion&".exe"
	$_UpdateFileName="Build Tools "&$CurrentVersion&".exe"

	If $CurrentVersion>$version And $CurrentVersion<>"unknown" Then
		$temp=MsgBox(4,"Update","There is a new update (Version: "&$CurrentVersion&"). Would you like to download and run this update?"&@CRLF&"It is recomended that you read the version log changes on the GitHub page first.")
		If $temp=6 Then
			_log("There is a new version. Downloading...")
			$temp=InetGet($_UpdateLink,$_UpdateFileName,0,1)
			$temp3=0
			$_UpdateError=0
			$tempTimer=TimerInit()
			Do
				$temp2=InetGetInfo($temp,0)
				If $temp2=0 And TimerDiff($tempTimer)>3000 Then
					$temp3=1
					$_UpdateError=1
				EndIf
				If InetGetInfo($temp,3)="True" Then $temp3=1
				Sleep(50)
			Until $temp3=1
			If $_UpdateError=1 Then
				_log("ERROR: downloading new build tools.exe from link: "&$_UpdateLink)
				MsgBox(48,"ERROR","There was an error downloading the update!",5)
			Else
				ShellExecute($_UpdateFileName)
				_exit(0)
			EndIf
		EndIf
	Else
		MsgBox(0,"Update","There is no new updates :)")
	EndIf

EndFunc

Func _ChangeUserName()

	_log("_ChangeUserName called")
	MsgBox(0,"ERROR","Work in Progress, please see source code.")
	#cs ; This command does not yet work, dir does not get renamed AND the full name of the user does not update. -Change user name -Change Dir name
	$_ChangeUserName_SID=_SidGet()
	$temp=MsgBox(4,"Change User Name","Please Read:"&@CRLF&@CRLF&"Do you want to change the name of user "&@UserName&" and do these two number look similar?"&@CRLF&"S-1-5-21-3912756739-280575556-4175553296-500"&@CRLF&$_ChangeUserName_SID)
	If $temp=6 Then
		$_ChangeUserName_NewUserName=InputBox("Change User Name","Input the new user name you would like to change to:")
		If $_ChangeUserName_NewUserName<>"" Then
			$_ChangeUserName_RegPath="HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\"&$_ChangeUserName_SID
			$_ChangeUserName_DirOLD=RegRead($_ChangeUserName_RegPath,"ProfileImagePath")
			$_ChangeUserName_DirNEW=@HomeDrive&"\Users\"&$_ChangeUserName_NewUserName
			$temp=MsgBox(4,"","This will also change the user folder for this account."&@CRLF&"From: "&$_ChangeUserName_DirOLD&@CRLF&" To: "&$_ChangeUserName_DirNEW)

			If $temp=6 Then
				_log("Changing User Name...")
				$i=Run('"' & @ComSpec & '" /k ' &"wmic useraccount where name='"&@UserName&"' rename '"&$_ChangeUserName_NewUserName&"'",@WindowsDir,@SW_HIDE,2)
				ProcessWaitClose($i)
				_log("CMD: "&StdoutRead($i))
				_log("Reg change: "&$_ChangeUserName_RegPath)
				$temp=RegWrite($_ChangeUserName_RegPath,"ProfileImagePath","REG_EXPAND_SZ",@HomeDrive&"\Users\"&$_ChangeUserName_NewUserName)
				_log("RegWrite out Code: "&$temp)
				_log("Chaging Dir name...")
				$i=Run('"' & @ComSpec & '" /k ' &"ren "&$_ChangeUserName_DirOLD&" "&$_ChangeUserName_DirNEW,@WindowsDir,@SW_HIDE,2)
				ProcessWaitClose($i)
				_log("CMD: "&StdoutRead($i))
			EndIf

		EndIf
	EndIf
	#ce


EndFunc

Func _SidGet()

	_log("_SidGet called")
	$i=Run('"' & @ComSpec & '" /k ' &"wmic useraccount where name='"&@UserName&"' get sid",@WindowsDir,@SW_HIDE,2)
	ProcessWaitClose($i)
	$Read=StdoutRead($i)
	$Read=StringSplit($Read,"D")
	$Read=StringSplit($Read[2],StringTrimRight(@HomeDrive,1))
	$sid=StringStripWS($Read[1],7)
	_log("SID: "&$sid)
	Return $sid

EndFunc

Func _FastBootOnOff() ;Turns windows fast boot on or off  by looking at reg values

	_log("_FastBootOnOff called")
	$regHibernateEnabledRead=RegRead($regHibernateEnabled[0],$regHibernateEnabled[1])
	If $regHibernateEnabledRead=1 Then
		$temp=MsgBox(4,"Fast Boot","Fast Boot is ON, do you want to run the CMD OFF command? (This does not work on some computers)")
		If $temp=6 Then
			Run('"' & @ComSpec & '" /k ' &"powercfg -h off",@WindowsDir,@SW_SHOW)
			_log("Turned Fast Boot Off")
		EndIf
	ElseIf $regHibernateEnabledRead=0 Then
		$temp=MsgBox(4,"Fast Boot","Fast Boot is OFF, do you want to run the CMD ON command? (This does not work on some computers)")
		If $temp=6 Then
			Run('"' & @ComSpec & '" /k ' &"powercfg -h on",@WindowsDir,@SW_SHOW)
			_log("Turned Fast Boot On")
		EndIf
	Else
		MsgBox(48,"WARNING","Could not read power options value!")
		_log("WARNING: Could not read reg value for fast boot.")
	EndIf
	Sleep(500)
	_StatusHibernateEnabled()

EndFunc

Func _Reboot()

	_log("_Reboot called")
	$temp=MsgBox(4,"Reboot?","Reboot computer?")
	#cs -- auto restart not working
	If $temp=6 Then
		$temp=FileCreateShortcut(@ScriptFullPath,$FileStartUpLink)
		If $temp=0 Then
			MsgBox(48,"Warning","Could not create startup link, please start Build Tools manualy on startup.")
			_log("WARNING: Could not creat startup link: "&$FileStartUpLink)
		Else
			FileWrite($FileStartUp,"True")
	EndIf
	#ce
	If $temp=6 Then
		;Shutdown(6);The shutdown in now done in the _exit() function
		_exit("Reboot")
	EndIf

EndFunc

Func _ChangeComputerName()

	_log("_ChangeComputerName called")
	$ChangeComputerNameNewName=GUICtrlRead($InputChangeComputerName)
	$temp=MsgBox(4,"Change Computer Name","Are you sure you want to change the computer name"&@CRLF&"From:"&@CRLF&@ComputerName&@CRLF&"To:"&@CRLF&$ChangeComputerNameNewName)
	If $temp=6 Then
		Run('"' & @ComSpec & '" /k ' &"WMIC computersystem where caption='"&@ComputerName&"' rename '"&$ChangeComputerNameNewName&"'",@WindowsDir,@SW_SHOW)
	EndIf
	GUICtrlSetBkColor($ButtonChangeComputerName,$colorGreen)

EndFunc

Func _SetupAnyDesk()

	_log("_SetupAnyDesk called")
	$temp=FileCopy($FileAnyDesk,@DesktopCommonDir&"\AnyDesk - HELP.exe",1)
	If $temp=0 Then
		MsgBox(16,"Error","The AnyDesk.exe file could not be copied!")
		_log("ERROR: Could not copy anydesk.exe to "&@DesktopCommonDir)
		GUICtrlSetBkColor($ButtonSetupAnyDesk,$colorRed)
	Else
		GUICtrlSetBkColor($ButtonSetupAnyDesk,$colorGreen)
	EndIf

EndFunc

#cs -- OLD Copy functions
Func _CopyFromCombo()

	_log("_CopyFromCombo called")
	$_CopyFromCombo_DirFromFolder=$DirFromFolder&GUICtrlRead($ComboCopyFrom)
	$_CopyFromCombo_DirToFolder=$DirToFolder&GUICtrlRead($ComboCopyFrom)

	If FileExists($_CopyFromCombo_DirFromFolder) Then
		$temp=MsgBox(4,'Copy','Copy all (Excuding: system and temp files)"'&@CRLF&"From: "&$_CopyFromCombo_DirFromFolder&@CRLF&'To: '&$_CopyFromCombo_DirToFolder)
		If $temp=6 Then
			_log("Copying From: "&$_CopyFromCombo_DirFromFolder&"To: "&$_CopyFromCombo_DirToFolder)
			Run('"' & @ComSpec & '" /k ' &'robocopy "'&$_CopyFromCombo_DirFromFolder&'" "'&$_CopyFromCombo_DirToFolder&'" /E /Z /ZB /R:2 /W:1 /V /xjd /XA:ST',@WindowsDir,@SW_SHOW)
		EndIf
	Else
		MsgBox(16,"Error","This dir does not exist"&@CRLF&"From: "&$_CopyFromCombo_DirFromFolder)
	EndIf

EndFunc

Func _CopyAllButAppdata()

	_log("_CopyAllButAppdata called")
	If FileExists($DirFromFolder) And FileExists($DirToFolder) Then
		$temp=MsgBox(4,'Copy','Copy all folder exept folder called "appdata" and will skip any system and temp files.'&@CRLF&"From: "&$DirFromFolder&@CRLF&'To: '&$DirToFolder)
		If $temp=6 Then
			_log("Copying without appdata From: "&$DirFromFolder&" To: "&$DirToFolder)
			Run('"' & @ComSpec & '" /k ' &'robocopy "'&$DirFromFolder&'" "'&$DirToFolder&'" /E /Z /ZB /R:2 /W:1 /V /XA:ST /xjd /XD "'&$DirFromFolder&'\Appdata"',@WindowsDir,@SW_SHOW)
		EndIf
	Else
		MsgBox(16,"Error","one or more of these dirs does not exist"&@CRLF&"From: "&$DirFromFolder&@CRLF&'To: '&$DirToFolder)
	EndIf
EndFunc

Func _copyChromeData() ;------------------------------------------------------------------------------ Copy Google Chrome User Data

	_log("_CopyChromeData Called")
	$DirFromChromeData=$DirFromFolder&"\AppData\Local\Google\Chrome\User Data\Default"
	$DirToChromeData=$DirToFolder&"\AppData\Local\Google\Chrome\User Data\Default"

	If FileExists($DirFromChromeData) Then
		$temp=MsgBox(4,'Copy','Copy Chrome Data?'&@CRLF&"From: "&$DirFromChromeData&@CRLF&'To: '&$DirToChromeData)
		If $temp=6 Then
			_log("Copying Chrome Data From: "&$DirFromChromeData&"To: "&$DirToChromeData)
			Run('"' & @ComSpec & '" /k ' &'robocopy "'&$DirFromChromeData&'" "'&$DirToChromeData&'" /E /Z /ZB /R:2 /W:1 /V',@WindowsDir,@SW_SHOW)
		EndIf
	Else
		MsgBox(16,"Error","Error, no Chrome Data found. (please specify the user dir)"&@CRLF&"From: "&$DirFromFolder&@CRLF&'To: '&$DirToFolder)
	EndIf

EndFunc
#ce

Func _HelpGUI() ;------------------------------------------------------------------------------ Help GUI (Not in use)
	_log("_Help Called")
	$HelpGUI=GUICreate("HELP",300,300)
EndFunc

Func _Server() ;------------------------------------------------------------------------------ Server TCP

	_log("_Server called")
	If $ClientActive=1 Then
		MsgBox(16,"Server","You cant be a server when you are a client!")
		Return
	EndIf

	If $ServerActive=0 Then ;start the server for the first time
		If MsgBox(4,"Server","Are you sure you want to start the server?"&@CRLF&"(Please close the program to terminate the server).")<>6 Then Return

		_log("Server: Starting...")
		$ServerIP=GUICtrlRead($InputServerIP)
		$ServerPort=GUICtrlRead($InputServerPort)
		TCPStartup()
		$SocketListen=TCPListen($ServerIP,$ServerPort,5)
		If @error Then
			_log("Error("&@error&"): Starting TCP Server, PORT: "&$ServerPort&" IP: "&$ServerIP)
			MsgBox(16,'Server Error', 'Could not start the server: ' & @error)
			GUICtrlSetColor($ButtonServerOnOFF,$colorRed)
			GUICtrlSetBkColor($ButtonServerOnOFF,14408667)
			TCPShutdown()
			Return
		EndIf


		$ServerActive=1
		GUICtrlSetBkColor($ButtonServerOnOFF,$colorGreen)
		GUICtrlSetColor($ButtonServerOnOFF,$colorBlack)
		_log("Server: Done")

	EndIf

	$Socket=TCPAccept($SocketListen)
	If $Socket<>-1 Then
		_log("Server: Sending Data")
		TCPSend($Socket,GUICtrlRead($InputCopy))
		TCPCloseSocket($Socket)
	EndIf

EndFunc

Func _Client() ;------------------------------------------------------------------------------ Client TCP

	_log("_Client called")
	If $ServerActive=1 Then
		MsgBox(16,"Client","You cant be a Client when you are a Server!")
		Return
	EndIf

	If $ClientActive=0 Then ;start the client server for the first time
		$ClientActive = 1
		$ServerIP=GUICtrlRead($InputServerIP)
		$ServerPort=GUICtrlRead($InputServerPort)

		TCPStartup()

		$iSocket=TCPConnect($ServerIP,$ServerPort)
		If @error Then
			_log("ERROR("&@error&"): TCP Server not found.")
			GUICtrlSetColor($ButtonClientOnOFF,$colorRed)
			Return
		EndIf
	EndIf

	$recive=TCPRecv($iSocket,500)
	GUICtrlSetData($InputCopy,$recive)
	GUICtrlSetBkColor($ButtonClientOnOFF,$colorGreen)
	GUICtrlSetColor($ButtonClientOnOFF,$colorBlack)

EndFunc

Func _install() ;------------------------------------------------------------------------------ Install Software

	_log("_install() called")
	$SoftwareString =  ""
	$InstallError = 1
	If $SoftwareError=0 Then
		For $i=2 To $SoftwareCount+2 step 1
			If GUICtrlRead($CheckSoftware[$i])=1 Then
				GUICtrlSetState($CheckSoftware[$i],4)
				$InstallError = 0
				$SoftwareString = $SoftwareString & " " & $SoftwareInstallers[$i][1]
			EndIf
		Next
		If $InstallError = 1 Then
			MsgBox(48,"warning!","Please select software to install.")
			Return
		EndIf
		_log("_install() run command: " & "winget install -h --wait --verbose --disable-interactivity --no-upgrade" & $SoftwareString)
		Run("winget install -h --wait --verbose --disable-interactivity --no-upgrade" & $SoftwareString)

	Else
		MsgBox(48,'Warning','Warning! There is no software to install!')
	EndIf

EndFunc

Func _ChromeMakeDefault() ;------------------------------------------------------------------------------ Google Chrome Deafult

	_log("_ChromeMakeDefault() called")
	If RegRead($regBrowser1[0],$regBrowser1[1])="ChromeHTML" Then
		_StatusGoogleChromeDefault()
		_log("Button: Chrome called and default already set")
	Else
		ShellExecuteWait($FileDefaultBrowserEXE,"Chrome")
		_StatusGoogleChromeDefault()
	EndIf
EndFunc

Func _TaskbarIconsToDefault()
	RegWrite($regSearch[0],$regSearch[1],$regSearch[2],1) ;make search small
		_log("REG: Search set 1")
	RegWrite($regTask[0],$regTask[1],$regTask[2],0) ;disable Task
		_log("REG: Task set 0")
	RegWrite($regCortana[0],$regCortana[1],$regCortana[2],0) ;disable Cortana
		_log("REG: Cortana set 0")

	GUICtrlSetBkColor($ButtonExplorerRestart,0xF89123)
EndFunc

Func _log($_logMSG) ;------------------------------------------------------------------------------ Log
	_FileWriteLog($FileLog,$_logMSG,1)
EndFunc

Func _exit($_exitCode) ;------------------------------------------------------------------------------ EXIT

	$_exitCode=String($_exitCode)
	_log("_exit() called (code: "&$_exitCode&")")
	TCPShutdown()

	If $_exitCode="Reboot" Then
		_log("Rebooting computer (called on exit)")
		Shutdown(6)
	EndIf

	_log("---stopping---")
	Exit

EndFunc
#EndRegion ==================================================================================================================== FUNCTIONS




MsgBox(16,"ERROR","END OF SCRIPT, you have fallen of the edge")