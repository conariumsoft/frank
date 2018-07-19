init:
#NoEnv
#SingleInstance, Force
#Persistent
#InstallKeybdHook
#UseHook
#KeyHistory, 0
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000


SetKeyDelay,-1, 1
SetControlDelay, -1
SetMouseDelay, -1
SetWinDelay,-1
SendMode, InputThenPlay
SetBatchLines,-1
ListLines, Off
CoordMode, Pixel, Screen, RGB
CoordMode, Mouse, Screen
PID := DllCall("GetCurrentProcessId")
Process, Priority, %PID%, High
 
EMCol := 0xFFFFB3
ColVn := 0
AntiShakeX := (A_ScreenHeight // 160)
AntiShakeY := (A_ScreenHeight // 128)
ZeroX := (A_ScreenWidth // 2)
ZeroY := (A_ScreenHeight // 2)
CFovX := (A_ScreenWidth // 3)
CFovY := (A_ScreenHeight // 6)
ScanL := ZeroX - CFovX
ScanT := ZeroY
ScanR := ZeroX + CFovX
ScanB := ZeroY + CFovY
NearAimScanL := ZeroX - AntiShakeX
NearAimScanT := ZeroY - AntiShakeY
NearAimScanR := ZeroX + AntiShakeX
NearAimScanB := ZeroY + AntiShakeY

Loop, {
    KeyWait, RButton, D
    PixelSearch, AimPixelX, AimPixelY, NearAimScanL, NearAimScanT, NearAimScanR, NearAimScanB, EMCol, ColVn, Fast RGB
    if (!ErrorLevel=0) {
        loop, 15 {
            PixelSearch, AimPixelX, AimPixelY, ScanL, ScanT, ScanR, ScanB, EMCol, ColVn, Fast RGB
            AimX := AimPixelX - ZeroX
            AimY := AimPixelY - ZeroY
            DirX := -1
            DirY := -1
            If ( AimX > 0 ) {
                DirX := 1
            }
            If ( AimY > 0 ) {
                DirY := 1
            }
            AimOffsetX := AimX * DirX
            AimOffsetY := AimY * DirY
            MoveX := Floor(( AimOffsetX ** ( 1 / 2 ))) * DirX
            MoveY := Floor(( AimOffsetY ** ( 1 / 2 ))) * DirY
            DllCall("mouse_event", uint, 1, int, MoveX * 0.99, int, MoveY, uint, 0, int, 0)
        }
    }
}

Pause:: pause
return:
goto, init


exit:
exitapp