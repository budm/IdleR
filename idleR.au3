#NoTrayIcon
#include <Timers.au3>
#include <Date.au3>
#include <Process.au3>
#Include <WinAPI.au3>
#include <GUIConstantsEx.au3>
#include <Array.au3>

;;;;;;;;;;;;;;;;;;;;;
;; IdleR Config     ;
;;;;;;;;;;;;;;;;;;;;;
$IDLE_SEC = 60  ;Idle Time in Seconds
$IDLE_MNR = "xmrig.exe"  ;Name of Program to run

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;     IdleR Internals         ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
$MINER_STARTED = False
$MINER_PID = Null
$MANUAL_SKIP_COUNT = 0

MainLoop()
Func MainLoop()
   ; Loop until the user exits.
   While 1
	  Sleep(10)
	  Switch GUIGetMsg()
	  Case $GUI_EVENT_CLOSE
			; User exit
			KillMiner()
			ExitLoop
		 EndSwitch
	  ; Main Loop
	  $idleTimer = _Timer_GetIdleTime()
	  If Not $MINER_STARTED and UserIsIdle($idleTimer) Then
		 StartMiner()
	  ElseIf $MINER_STARTED and UserNotIdle($idleTimer) Then
		 KillMiner()
	  EndIf
   WEnd
EndFunc

 Func UserIsIdle($idleTimer)
   Local $idleMax = ($IDLE_SEC * 1000)
   Return $idleTimer > $idleMax
 EndFunc

 Func UserNotIdle($idleTimer)
	; Allow the user to be active for a few seconds
	If $MANUAL_SKIP_COUNT > 0 Then
	   $MANUAL_SKIP_COUNT -= 1
	   Return False
	EndIf
	Return $idleTimer < 10
 EndFunc

 Func StartMiner()
	If Not $MINER_STARTED Then
	  $MINER_PID = ShellExecute( @ScriptDir & "\" & $IDLE_MNR, "" , "" , "" , @SW_HIDE )
	  $MINER_STARTED = True
	EndIf
 EndFunc

 Func KillMiner()
	  If $MINER_STARTED Then
		 ProcessClose($MINER_PID)
		 $MINER_STARTED = False
		 $MINER_PID = Null
	  EndIf
 EndFunc