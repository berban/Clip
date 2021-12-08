 ;Clip() - Send and Retrieve Text Using the Clipboard
 ;by berban - updated February 18, 2019
 ;https://www.autohotkey.com/boards/viewtopic.php?f=6&t=62156

 ;modified by Gewerd Strauss

fClip(Text="", Reselect="",Restore:=1,DefaultMethod:=1)
{
	/*
	Parameters
	Text: variable whose contents to paste. 
	*/
	if !DefaultMethod
	{
		BlockInput,On
		if InStr(Text,"&|") ;; check if needle contains cursor-pos. The needle must be &|, without brackets
		{
			move := StrLen(Text) - RegExMatch(Text, "[&|]")
			Text := RegExReplace(Text, "[&|]")
			sleep, 20
			MoveCursor:=true
		}
		Else
		{
			MoveCursor:=false
			move:=1 			;; offset the left-moves for the edgecase that this is not guarded by movecursor
		}
		Static BackUpClip, Stored, LastClip
		If (A_ThisLabel = A_ThisFunc)
		{
			If (Clipboard == LastClip)
				Clipboard := BackUpClip
			BackUpClip := LastClip := Stored := ""
		} 
		Else 
		{
			If !Stored 
			{
				Stored := True
				BackUpClip := ClipboardAll ; ClipboardAll must be on its own line
			} 
			Else
				SetTimer, %A_ThisFunc%, Off
			LongCopy := A_TickCount, Clipboard := "", LongCopy -= A_TickCount ; LongCopy gauges the amount of time it takes to empty the clipboard which can predict how long the subsequent clipwait will need
			If (Text = "") ; No text is pasted, hence we pull it. 
			{
				SendInput, ^c 
				ClipWait, LongCopy ? 0.6 : 0.2, True
			} 
			Else 
			{
				Clipboard := LastClip := Text
				ClipWait, 10
				SendInput, ^v
				if MoveCursor
				{
					if WinActive("E-Mail – ") and Winactive("— Mozilla Firefox")
					{
						WinActivate
						sleep, 20
						BlockInput,On
						WinActivate, "E-Mail – "
						if !ReSelect and (ReSelect = False)
							SendInput, % "{Left " move-1 "}"
						else if (Reselect="")
							SendInput, % "{Left " move-1 "}"
					}	
					else
						if !ReSelect and (ReSelect = False)
							SendInput, % "{Left " move-2 "}"
					else if (Reselect="")
					{
						SendInput, % "{Left " move-2 "}"
					}
				}
			}
			SetTimer, %A_ThisFunc%, -700
			Sleep 200 ; Short sleep in case Clip() is followed by more keystrokes such as {Enter}
			If (Text = "") ; we are pulling, not pasting
			{
				SetTimer, %A_ThisFunc%, Off
				{
					f_unstickKeys()
					if !Restore
					{
						BlockInput, Off
						return LastClip := Clipboard
					}
					LastClip := Clipboard
					ClipWait, LongCopy ? 0.6 : 0.2, True
					BlockInput,Off
					Return LastClip
				}
			}
			Else If ReSelect and ((ReSelect = True) or (StrLen(Text) < 3000))
			{
				SetTimer, %A_ThisFunc%, Off
				SendInput, % "{Shift Down}{Left " StrLen(StrReplace(Text, "`r")) "}{Shift Up}"
			}
		}
		f_unstickKeys()  
		BlockInput, Off
		Return
		
	}
	else
	{
		if InStr(Text,"&|") ;; check if needle contains cursor-pos. The needle must be &|, without brackets
		{
			move := StrLen(Text) - RegExMatch(Text, "[&|]")
			Text := RegExReplace(Text, "[&|]")
			sleep, 20
			MoveCursor:=true
		}
		Else
		{
			MoveCursor:=false
			move:=1 			;; offset the left-moves for the edgecase that this is not guarded by movecursor
		}
		If (A_ThisLabel = A_ThisFunc) {
			If (Clipboard == LastClip)
				Clipboard := BackUpClip
			BackUpClip := LastClip := Stored := ""
		} Else {
			If !Stored {
				Stored := True
				BackUpClip := ClipboardAll ; ClipboardAll must be on its own line
			} Else
				SetTimer, %A_ThisFunc%, Off
			LongCopy := A_TickCount, Clipboard := "", LongCopy -= A_TickCount ; LongCopy gauges the amount of time it takes to empty the clipboard which can predict how long the subsequent clipwait will need
			If (Text = "") {
				SendInput, ^c
				ClipWait, LongCopy ? 0.6 : 0.2, True
			} Else {
				Clipboard := LastClip := Text
				ClipWait, 10
				SendInput, ^v
			}
			SetTimer, %A_ThisFunc%, -700
			Sleep 20 ; Short sleep in case Clip() is followed by more keystrokes such as {Enter}
			If (Text = "")
				Return LastClip := Clipboard
			Else If ReSelect and ((ReSelect = True) or (StrLen(Text) < 3000))
				SendInput, % "{Shift Down}{Left " StrLen(StrReplace(Text, "`r")) "}{Shift Up}"
			if Move and !ReSelect{
				SendInput, % "{Left " move-2 "}"
			}
		}
		Return
		
	}
	fClip:
	f_unstickKeys()
	BlockInput,Off
	Return fClip()
}


f_unstickKeys()
{
	BlockInput, On
	SendInput, {Ctrl Up}
	SendInput, {V Up}
	SendInput, {Shift Up}
	SendInput, {Alt Up}
	BlockInput, Off
}


/* original by berban https://github.com/berban/Clip/blob/master/Clip.ahk
	; Clip() - Send and Retrieve Text Using the Clipboard
; by berban - updated February 18, 2019
; https://www.autohotkey.com/boards/viewtopic.php?f=6&t=62156
	Clip(Text="", Reselect="")
	{
		Static BackUpClip, Stored, LastClip
		If (A_ThisLabel = A_ThisFunc) {
			If (Clipboard == LastClip)
				Clipboard := BackUpClip
			BackUpClip := LastClip := Stored := ""
		} Else {
			If !Stored {
				Stored := True
				BackUpClip := ClipboardAll ; ClipboardAll must be on its own line
			} Else
				SetTimer, %A_ThisFunc%, Off
			LongCopy := A_TickCount, Clipboard := "", LongCopy -= A_TickCount ; LongCopy gauges the amount of time it takes to empty the clipboard which can predict how long the subsequent clipwait will need
			If (Text = "") {
				SendInput, ^c
				ClipWait, LongCopy ? 0.6 : 0.2, True
			} Else {
				Clipboard := LastClip := Text
				ClipWait, 10
				SendInput, ^v
			}
			SetTimer, %A_ThisFunc%, -700
			Sleep 20 ; Short sleep in case Clip() is followed by more keystrokes such as {Enter}
			If (Text = "")
				Return LastClip := Clipboard
			Else If ReSelect and ((ReSelect = True) or (StrLen(Text) < 3000))
				SendInput, % "{Shift Down}{Left " StrLen(StrReplace(Text, "`r")) "}{Shift Up}"
		}
		Return
		Clip:
		Return Clip()
	}
*/

