#InstallKeybdHook
#Persistent
#HotkeyInterval,100
SetKeyDelay, -1

Menu, TRAY, Icon, ahk.ico

ahk      = "C:\Program Files\AutoHotkey\AutoHotkey.exe"
chrome   = "C:\Program Files\ChromePlus\chrome.exe"
notepad  = "C:\Program Files\npp-5.6.6\notepad++.exe"
timer    = "H:\bin\ahk\timer.ahk"
desktop  = "H:\desktop"
context  = O

^+d::FileRecycleEmpty

#a::
  selection := Clipboard
  Clipboard := selection
return

+#a::
  Clipboard  := getSelection()
return

F4::openSelection()

F1::openSelection()

; Desktop
#IfWinActive, ahk_class Progman
F7::createDirOnPath("h:\desktop")
^d::Run, cmd, h:\desktop
#IfWinActive

; Directory window
#IfWinActive, ahk_class CabinetWClass
F7::createDirFromWinTitle()
^d::openDosFromWinTitle()
#IfWinActive

#IfWinActive, ahk_class ExploreWClass
F7::createDirFromWinTitle()
^d::openDosFromWinTitle()
#IfWinActive

getContext() {
	global
	context = O
	IfWinActive, ahk_class Progman
		context = ED
  IfWinActive, ahk_class CabinetWClass
		context = E
	IfWinActive, ahk_class ExploreWClass
		context = E
	return context
}

openSelection() {
	global
	selection := getSelection()
	FileGetAttrib, attribs, %selection%
	If attribs = ""
  	return
	IfInString, attribs, D
		openDir(selection)
  else
		Run %notepad% %selection%
}

openDosFromWinTitle() {
  WinGetTitle dir
  Run, cmd, %dir%
}

openDir(path) {
	Run, explorer /n`,%path%
}

getDirFromWinTitle() {
  WinGetTitle dir
	return dir
}

createDirFromWinTitle() {
  WinGetTitle dir
  createDirOnPath(dir)
}

createDirOnPath(dir) {
  selection := getSelection()
  StringGetPos, p, selection, \, R1
  fname := SubStr(selection, p + 2)
  InputBox, name, New folder name, , , 300, 100, , , , , %fname%
  if ErrorLevel
    return
  path = "%dir%\%name%"
	RunWait, cmd /c md %path%, , Hide
	openDir(path)
}


#+t::Run %ahk% %timer% -a

#ESC::WinMinimizeAll

#+ESC::WinMinimizeAllUndo


; disable CapsLock
*Capslock::Send !{Space}


#c::Run %chrome%

#q::WinMinimize,A
#+q::WinSet AlwaysOnTop, Toggle, A

#i::
; XML indend in Notepad++
  SetTitleMatchMode, 2
  IfWinActive ahk_class Notepad++
    PostMessage, 0x111, 22226,,,Notepad++
return


; ------------------------------------------------------------------------
; Functions
; ------------------------------------------------------------------------

getSelection()
{
  theClipboard := ClipboardAll
  Clipboard =
  Send ^c
  ClipWait 0.5
  selection := Clipboard
  Clipboard := theClipboard
  Return %selection%
}


showHideAppWin(winTitle, appPath) {
  if WinExist(winTitle) {
    if WinActive() {
      WinMinimize
    } else  {
      WinActivate
    }
  } else {
    Run %appPath%
  }
}

showAppWin(winTitle, appPath) {
  if WinExist(winTitle)
  {
    WinActivate
  }
  else
  {
    Run %appPath%
  }
}



; Eclipse
#IfWinActive ahk_class SWT_Window0
#IfWinActive

#j::Down
#k::Up
#h::Left
#l::Right


; NPP
#IfWinActive ahk_class Notepad++
~Escape::
  WinMinimize
return
#IfWinActive

; MS Communicator
#IfWinActive ahk_class CommunicatorMainWindowClass
  ~Escape::SendInput !{F4}
return
;
#IfWinActive ahk_class Framework::CFrame
~Escape::SendInput !{F4}
return
; Adobe AcrobatReader
#IfWinActive ahk_class AdobeAcrobat
  ~Escape::SendInput !{F4}
return
; BTB Viewer
#IfWinActive ahk_class ICL Frame0
  ~Esc::SendInput !{F4}
return

; FARR
#IfWinActive ahk_class TMainForm
~Escape::SendInput {Esc 2}
#IfWinActive