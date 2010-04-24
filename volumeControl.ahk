#Up::
  SoundSet +5
  SoundSet, +5, wave
  gosub, vupdt
return

#Down::
  SoundSet -5
  SoundSet, -5, wave
  gosub, vupdt
return

#WheelUp::
  SoundSet +5
  SoundSet, +5, wave
  gosub, vupdt
return

#WheelDown::
  SoundSet -5
  SoundSet, -5, wave
  gosub, vupdt
return

#XButton1::
  SoundSet, -0, Microphone, mute
  IfWinExist, volume
  {
    SoundGet, m_m, Microphone, mute
    if m_m = On
      GuiControl,, R, 0
    else
      GuiControl,, R, 1
    SetTimer,label, 500
    return
  }
  Gosub, show
Return

#XButton2::
  SoundSet, -0, MASTER, mute
  IfWinExist, volume
  {
    SoundGet, v_m, master, mute
    if v_m = On
      GuiControl,, Pic1,*icon40 C:\WINDOWS\system32\mmsys.cpl
    else
      GuiControl,, Pic1, *icon1 C:\WINDOWS\system32\mmsys.cpl
    SetTimer,label, 500
    return
  }
  Gosub, show
Return

;This routine is isolated to avoid icon flashing
vupdt:
  IfWinExist, volume
  {
    SoundGet, master_volume
    GuiControl,, MP, %master_volume%
    SetTimer,label, 500
    return
  }
  Gosub, show
Return

show:
  SoundGet, master_volume
  SoundGet, m_m, Microphone, mute
  SoundGet, v_m, master, mute
  IfWinNotExist, volume
  {
    CustomColor = black ; Can be any RGB color (it will be made transparent below).
    Gui +LastFound +AlwaysOnTop -Caption +ToolWindow
    Gui, Color, %CustomColor%
    WinSet, TransColor, %CustomColor% 200
    Gui, Add, GroupBox, x3 y12 w40 h45 cblack,
    Gui, Add, GroupBox, x3 y60 w40 h35 cLime, Mic:
    ;Gui, Add, text, x10 y1 ,Volume:
    Gui, Add, Progress,vertical vMP x45 y18 w13 h77 cRed Background%CustomColor%,%master_volume%
    Gui, Add, checkbox, vR x16 y75 w15 h15 cBlue,
    if v_m = On
      Gui, Add, pic, x7 y22 vPic1 icon40 -Background, C:\WINDOWS\system32\mmsys.cpl
    else
      Gui, Add, pic, x7 y22 vPic1 icon1, C:\WINDOWS\system32\mmsys.cpl
    if m_m = On
      GuiControl,, R, 0
    else
      GuiControl,, R, 1
    OsdVolPosX := A_ScreenWidth - 67
    OsdVolPosY := A_ScreenHeight - 135
    Gui, Show, NoActivate x%OsdVolPosX% y%OsdVolPosY% h100 w60, volume
  }
  SetTimer,label, 500
return

label:
  SetTimer,label, off
  Gui, destroy