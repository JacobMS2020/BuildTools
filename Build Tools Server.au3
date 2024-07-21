Global $version="Server v1.0"

#cs ==================================================================================================================== Version Log
---- Version Log ----
ADD = Added
CHA = Changed
REM = Removed

0.1
Re-build of build tools



#ce

#Region ==================================================================================================================== Var

;Include
#include <File.au3>
#include <GUIComboBoxEx.au3>

;COLOR
Global $colorOrange=0xF89123
Global $colorRED_dark=0x990000
Global $colorRed=0xff0000
Global $colorGreen=0x478a00
Global $colorBlue=0x000fb0
Global $colorBlack=0x000000

;Server
Global $ServerActive=0
Global $ClientActive=0
Global $ServerIP=@IPAddress2
Global $ServerPort=3000

;----Running live
#EndRegion ==================================================================================================================== Var

#Region ==================================================================================================================== GUI setup
Global $guiH, $guiW
$guiH=200
$guiW=228
GUICreate("Build Tools (v"&$version&")",$guiW,$guiH)
	GUISetBkColor(0xffffff)
	;WinSetOnTop("Build Tools (v"&$version&")","",1) ;Removed due to issues with message boxes (might bring back)


;Server stuff
$top=25
$left=5
$width=219

GUICtrlCreateLabel("TCP:",$left,$top+3,30)
	GUICtrlSetFont(-1,10,700)
$ButtonServerOnOFF=GUICtrlCreateButton("Server",$left+35,$top,($width/2)-20)
	GUICtrlSetFont(-1,10,700)
$ButtonClientOnOFF=GUICtrlCreateButton("Client",$left+($width/2)+15,$top,($width/2)-20)
	GUICtrlSetFont(-1,10,700)
$top+=35

GUICtrlCreateLabel("Server IP:",$left,$top+2,70)
	GUICtrlSetFont(-1,10,700)
$InputServerIP=GUICtrlCreateInput($ServerIP,$left+75,$top,$width-80)
	GUICtrlSetFont(-1,9,700)
$top+=25

GUICtrlCreateLabel("Port:",$left,$top+2,70)
	GUICtrlSetFont(-1,10,700)
$InputServerPort=GUICtrlCreateInput($ServerPort,$left+75,$top,$width-80)
	GUICtrlSetFont(-1,9,700)
$top+=30

GUICtrlCreateLabel("  Server to Client Copy  ",$left,$top,$width,-1,0x01)
	GUICtrlSetFont(-1,10,700,4)
	GUICtrlSetColor(-1,$colorGreen)
$top+=20

$InputCopy=GUICtrlCreateInput("Message to send to client (or recive)",$left,$top,$width)
$top+=25

$ButtonUpdateCopy=GUICtrlCreateButton("Update and Copy",$left,$top,$width/2)
	GUICtrlSetFont(-1,8,700)
$ButtonPast=GUICtrlCreateButton("Past",$left+$width/2,$top,$width/2)
	GUICtrlSetFont(-1,8,700)
$top+=50

GUISetState()

#EndRegion ==================================================================================================================== GUI setup

#Region ==================================================================================================================== While Loop 1 -- MAIN
While 1
	$guiMSG = GUIGetMsg()
	If $ServerActive=1 Then _Server()
	If $ClientActive=1 Then _Client()

	Switch $guiMSG

		Case -3
			_exit()

		Case $ButtonServerOnOFF
			_Server()

		Case $ButtonClientOnOFF
			_Client()

		Case $ButtonUpdateCopy
			_Client()
			ClipPut(GUICtrlRead($InputCopy))

		Case $ButtonPast
			GUICtrlSetData($InputCopy,ClipGet())

		;Case

		;Case

		;Case
	EndSwitch
WEnd
#EndRegion ==================================================================================================================== While Loop 1 -- MAIN

#Region ==================================================================================================================== FUNCTIONS

Func _Server() ;------------------------------------------------------------------------------ Server TCP

	If $ClientActive=1 Then
		MsgBox(16,"Server","You cant be a server when you are a client!")
		Return
	EndIf

	If $ServerActive=0 Then ;start the server for the first time
		If MsgBox(4,"Server","Are you sure you want to start the server?"&@CRLF&"(Please close the program to terminate the server).")<>6 Then Return

		$ServerIP=GUICtrlRead($InputServerIP)
		$ServerPort=GUICtrlRead($InputServerPort)
		TCPStartup()
		Global $SocketListen=TCPListen($ServerIP,$ServerPort,5)
		If @error Then
			GUICtrlSetColor($ButtonServerOnOFF,$colorRed)
			GUICtrlSetBkColor($ButtonServerOnOFF,14408667)
			TCPShutdown()
			Return
		EndIf


		$ServerActive=1
		GUICtrlSetBkColor($ButtonServerOnOFF,$colorGreen)
		GUICtrlSetColor($ButtonServerOnOFF,$colorBlack)

	EndIf

	$Socket=TCPAccept($SocketListen)
	If $Socket<>-1 Then
		TCPSend($Socket,GUICtrlRead($InputCopy))
		TCPCloseSocket($Socket)
	EndIf

EndFunc

Func _Client() ;------------------------------------------------------------------------------ Client TCP
	If $ServerActive=1 Then
		MsgBox(16,"Client","You cant be a Client when you are a Server!")
		Return
	EndIf
	$ServerIP=GUICtrlRead($InputServerIP)
	$ServerPort=GUICtrlRead($InputServerPort)

	TCPStartup()

	$iSocket=TCPConnect($ServerIP,$ServerPort)
	If @error Then
		GUICtrlSetColor($ButtonClientOnOFF,$colorOrange)
		Return
	EndIf

	$recive=TCPRecv($iSocket,500)
	GUICtrlSetData($InputCopy,$recive)
	GUICtrlSetBkColor($ButtonClientOnOFF,$colorGreen)
	GUICtrlSetColor($ButtonClientOnOFF,$colorBlack)

EndFunc

Func _exit() ;------------------------------------------------------------------------------ EXIT
	TCPShutdown()
	Exit
EndFunc
#EndRegion ==================================================================================================================== FUNCTIONS





MsgBox(16,"ERROR","END OF SCRIPT, you have fallen of the edge")






