; mouseHide() v1.0
; Hide mouse pointer after %inactiveDetay% (ms)
; and show again when mouse moves.

; set menu tray icon
Menu, TRAY, Icon, mouseHide.ico

; init variables
CoordMode, Mouse, Screen
inactiveDelay = 1000 ; can change here (ms)
sleepDelay = 100
isMouseVisible = 1
showMouse = 1
mouseMovedTick := A_TickCount

Loop:
  MouseGetPos, x, y
  ; when mouse moves restart delay counter
  if (lastX != x or lastY != y)
    mouseMovedTick := A_TickCount
  ; set pointer flag according to mouse inactive ticks
  if (A_TickCount - mouseMovedTick >= inactiveDelay)
    showMouse = 0
  else
    showMouse = 1

  ; change mouse pointer visibility if necessary
  if (isMouseVisible != showMouse)
  {
    setMouseVisible(showMouse)
    ; store new poiter visibility flag
    isMouseVisible := showMose
  }

  ; store mouse coords for next loop
  lastX := x
  lastY := y
  ; wait for a while
  Sleep, sleepDelay
Goto, Loop


setMouseVisible(show = 1)
{
  ; show/hide mouse pointer according flag
  ;ToolTip, %show%
  SystemCursor(show)
}

; This script is from www.autohotkey.com/forum/topic6107.html
SystemCursor(OnOff=1)   ; INIT = "I","Init"; OFF = 0,"Off"; TOGGLE = -1,"T","Toggle"; ON = others
{
    static AndMask, XorMask, $, h_cursor
        ,c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13 ; system cursors
        , b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13   ; blank cursors
        , h1,h2,h3,h4,h5,h6,h7,h8,h9,h10,h11,h12,h13   ; handles of default cursors
    if (OnOff = "Init" or OnOff = "I" or $ = "")       ; init when requested or at first call
    {
        $ = h                                          ; active default cursors
        VarSetCapacity( h_cursor, 4444, 1 )
        VarSetCapacity( AndMask, 32*4, 0xFF )
        VarSetCapacity( XorMask, 32*4, 0 )
        system_cursors = 32512,32513,32514,32515,32516,32642,32643,32644,32645,32646,32648,32649,32650
        StringSplit c, system_cursors, `,
        Loop %c0%
        {
            h_cursor   := DllCall( "LoadCursor", "uint",0, "uint",c%A_Index% )
            h%A_Index% := DllCall( "CopyImage",  "uint",h_cursor, "uint",2, "int",0, "int",0, "uint",0 )
            b%A_Index% := DllCall("CreateCursor","uint",0, "int",0, "int",0
                , "int",32, "int",32, "uint",&AndMask, "uint",&XorMask )
        }
    }
    if (OnOff = 0 or OnOff = "Off" or $ = "h" and (OnOff < 0 or OnOff = "Toggle" or OnOff = "T"))
        $ = b  ; use blank cursors
    else
        $ = h  ; use the saved cursors

    Loop %c0%
    {
        h_cursor := DllCall( "CopyImage", "uint",%$%%A_Index%, "uint",2, "int",0, "int",0, "uint",0 )
        DllCall( "SetSystemCursor", "uint",h_cursor, "uint",c%A_Index% )
    }
}
