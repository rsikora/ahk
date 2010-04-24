; Count down timer
; usage
; timer.ahk minutes [--displayAlert | -a]
; 2008-07-27 sikorric

; new timer will automaticaly replace old one
#SingleInstance force

; Settings
fontType = Candara
fontSize := 20
fontColor = Green
fontColorHalf = Yellow
fontColorTimeout = Red
alertTimeout := 5

; process parameters
argc = %0%
minutes = %1%
option = %2%
if (argc = 1)
  option = %1%

isAlert := false
if (option = "--displayAlert" or option = "-a")
  isAlert := true

; get countdown minutes, try first parameter, then user input
if not checkMinutesInput(minutes)
{
  InputBox, minutes, Timer, Set countdown minutes, , 230, 120,,,,, 25
  if ErrorLevel {
    ExitApp
  }
  if not checkMinutesInput(minutes) {
    ExitApp
  }
}

; initialize globals
totalSeconds := minutes * 60
;totalSeconds := 4
halfSeconds := totalSeconds / 2
seconds := totalSeconds
isHalf := false
isCompleted := false

; create display window
Gui +LastFound +AlwaysOnTop -Caption +ToolWindow
customColor = 0000FF
Gui, Color, %customColor%
Gui, Font, s%fontSize% wBold c%fontColor%, %fontType%
Gui, Add, Text, vMyText, 00:000
WinSet, TransColor, %customColor% 150
displayTimer()

; display the window
WinGetPos x, y, dx, dy, ahk_class Progman
yy := dy - 60
Gui, Show, x0 y%yy% NoActivate

; initialize timer
SetTimer, refreshWindow, 1000

return

#+p::
  if paused
    paused := false
  else
    paused := true
  if paused
    GuiControl,, MyText, Paused
return

#+q::ExitApp

refreshWindow:
  if paused
    return
    
  ; display current timer status
  displayTimer()
  
  ; half time reached
  if (not isHalf and seconds <= halfSeconds) {
    secondHalfTimer()
  }

  ; timer completed
  if (not isCompleted and seconds = 0) {
    if isAlert
    {
      displayAlert()
      return
    }
    else
    {
      timeoutTimer()
    }
  }

  ; update seconds
  if not isCompleted
    seconds := seconds - 1
  else
    seconds := seconds + 1
return

initializeTimer() {
  global
  seconds := totalSeconds
  isHalf := false
  isCompleted := false
  paused := false
  updateDisplayColor(fontColor)
}

secondHalfTimer() {
  global
  updateDisplayColor(fontColorHalf)
  isHalf := true
}

timeoutTimer() {
  global
  updateDisplayColor(fontColorTimeout)
  isCompleted := true
}

formatSeconds(sec) {
  return formatDec(sec // 60) . ":" . formatDec(Mod(sec, 60))
}

formatDec(dec) {
  return SubStr("0" . dec, -1)
}

displayAlert() {
  global
  MsgBox ,33, Timer, Countdown of %minutes% minute(s) completed! Restart the timer?, % alertTimeout ;%
  IfMsgBox Cancel
  {
    ExitApp
  }
  else IfMsgBox OK
  {
    initializeTimer()
  }
  else IfMsgBox Timeout
  {
    timeoutTimer()
  }
}

checkMinutesInput(min) {
  if min is not integer
    return false
  if (0 < min and min < 100)
    return true
  else
    return false
}

displayTimer() {
  global
  GuiControl,, MyText, % formatSeconds(seconds) ; % just for formatter
}

updateDisplayColor(color) {
;  msgbox %color%
  Gui, Font, c%color%
  GuiControl,Font, MyText
}
