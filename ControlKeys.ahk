; Copyright (c) 2007-2012 Pavel Chikulaev
; Modified by Degtyar Eugene aka MrJackphil
; Distributed under BSD license

SetTitleMatchMode,RegEx

if not A_IsAdmin
{
   DllCall("shell32\ShellExecuteA", uint, 0, str, "RunAs", str, A_AhkPath
      , str, """" . A_ScriptFullPath . """", str, A_WorkingDir, int, 1)
   ExitApp
}

#InstallKeybdHook



press_count = 0

MyAppsKeyHotkeys(enable)
{
   if (enable = "Off")
   {
      Menu, TRAY, Icon, %A_ScriptDir%\Letter-E.ico
      Gui, Name: New
      Gui, Destroy
   }
   else
   {
      width := A_ScreenWidth-150
      Menu, TRAY, Icon, %A_ScriptDir%\Letter-C.ico
      Gui, Name: New
      Gui, Add, Text,, F - FF
      Gui, Add, Text,, Q - MouseOff
      Gui, Add, Text,, H - Left
      Gui, Add, Text,, L - Right
      Gui, Add, Text,, K - Up
      Gui, Add, Text,, J - Down
      Gui, Add, Text,, M - Apps
      Gui, Add, Text,, N - PgDn
      Gui, Add, Text,, P - Bs
      Gui, Add, Text,, U - Enter
      Gui, Add, Text,, X - Del
      Gui, Add, Text,, Y - Esc
      Gui, Add, Text,, ; - Enter
      Gui, Add, Text,, . - TglSnd
      Gui, Add, Text,, ^ - Home
      Gui, Add, Text,, $ - End
      Gui, Add, Text,, E - Block
      ; Make a transparent background
      Gui, Color, FFFFFFAA
      Gui +LastFound

      Gui, -Caption -Border -Resize -MaximizeBox +AlwaysOnTop +Disabled +ToolWindow
      Gui, Show, x%width% y0 NoActivate
   }
    ;Hotkey, IfWinNotActive, ahk_exe (sublime_text.exe)
    ;HotKey,  a, MyEmpty, %enable%
    ;HotKey,  b, MyEmpty, %enable%
    ;HotKey,  c, MyEmpty, %enable%
    ;HotKey,  d, MyEmpty, %enable%
    ;HotKey,  e, MyEmpty, %enable%
     HotKey,  f, FirefoxActive, %enable%
    ;HotKey,  g, MyEmpty, %enable%
     HotKey, *h, MyLeft,  %enable%
     HotKey, *q, MyMouseOff, %enable%
     HotKey, *j, MyDown,  %enable%
     HotKey, *k, MyUp,    %enable%
     HotKey, *l, MyRight, %enable%
     Hotkey, *m, MyApps,  %enable%
     HotKey, *n, MyPgDn,  %enable%
    ;HotKey, *o, MyEnd,   %enable%
     HotKey, *p, MyBS,    %enable%
    ;HotKey,  q, MyEmpty, %enable%
    ;HotKey,  r, MyEmpty, %enable%
    ;HotKey,  s, MyEmpty, %enable%
    ;HotKey,  t, MyEmpty, %enable%
     HotKey, *u, MyEnter, %enable%
    ;HotKey,  v, MyEmpty, %enable%
    ;HotKey,  w, MyEmpty, %enable%
     HotKey,  x, MyDel,   %enable%
     Hotkey, *y, MyEsc,   %enable%
    ;HotKey,  z, MyEmpty, %enable%
     HotKey, *;, MyEnter, %enable%
     HotKey, *[, MyDel,   %enable%
    ;HotKey,  ], MyEmpty, %enable%
    ;HotKey,  ', MyEmpty, %enable%
     HotKey,  ., MySoundToggle, %enable%
    ;HotKey,  /, MyEmpty, %enable%
     HotKey, *^, MyHome,  %enable%
     HotKey, *$, MyEnd,   %enable%
     HotKey,  e, Block,   %enable%
}
FirefoxActive:
   press_count += 1
   DetectHiddenWindows, On
   WinActivate, Mozilla Firefox
   Return
MyMouseOff:
   press_count += 1
   CoordMode, Mouse
   SendEvent {Click 1796, 53}
   KeyWait, i
   SendEvent {Click 1712, 220}
   Return
Block:
  press_count += 1
  CoordMode, Mouse
  SendEvent, {Click 1322, 945}
  SendEvent, {Click 1678, 887}
  Return
MySoundToggle:
   press_count += 1           
   SoundSet, +1, , mute
   Return
MyEmpty:
 ;  Return
MyUp:
   press_count += 1
   Send {Blind}{Up} ;fix for OneNote use SendPlay
   Return
MyDown:
   press_count += 1
   Send {Blind}{Down} ;fix for OneNote use SendPlay
   Return
MyLeft:
   press_count += 1
   Send {Blind}{Left}
   Return
MyRight:
   press_count += 1
   Send {Blind}{Right}
   Return
MyPgUp:
   press_count += 1
   Send {Blind}{PgUp}
   Return
MyPgDn:
   press_count += 1
   Send {Blind}{PgDn}
   Return
MyEnter:
   press_count += 1
   Send {Blind}{Enter}
   Return
MyBS:
   press_count += 1
   Send {Blind}{BS}
   Return
MyDel:
   press_count += 1
   Send {Blind}{Del}
   Return
MyHome:
   press_count += 1
   Send {Blind}{Home}
   Return
MyEnd:
   press_count += 1
   Send {Blind}{End}
   Return
MyApps:
   press_count += 1
   Send {Blind}{AppsKey}
   Return
MyEsc:
   press_count += 1
   Send {Esc}
   Return

SetCapsLockState, AlwaysOff

#IfWinNotActive ahk_class TscShellContainerClass
CapsLock::HotkeyHook("Down")
CapsLock Up::HotkeyHook("Up")
#IfWinNotActive

HotkeyHook(Mode)
{
   static sticky_hotkeys = 0
   global press_count
   if (Mode = "Down")
   {
      if (sticky_hotkeys = 1)
      {
         sticky_hotkeys = 2
      }
      else
      {
         MyAppsKeyHotkeys("On")
         press_count = 0
      }
   }
   else if (Mode = "Up")
   {
      if (sticky_hotkeys = 0)
      {
         if (press_count = 0)
         {
            sticky_hotkeys = 1
         }
         else
         {
            MyAppsKeyHotkeys("Off")
         }
      }
      else if (sticky_hotkeys = 2)
      {
         MyAppsKeyHotkeys("Off")
         sticky_hotkeys = 0
      }
   }
}