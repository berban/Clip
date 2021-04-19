; Clip() - Send and Retrieve Text Using the Clipboard
; by berban - updated February 18, 2019
; https://www.autohotkey.com/boards/viewtopic.php?f=6&t=62156

; adapted by Gewerd Strauss

fClip(Text="", Reselect="",Restore:=1)
{
	ClipStore:=Clipboard
	if RegExMatch(Text,"[&|]") ; check if needle contains cursor-pos. 
	{
		move := StrLen(Text) - RegExMatch(Text, "[&|]")
		Text := RegExReplace(Text, "[&|]")
		sleep, 20
		MoveCursor=true
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
				if WinActive("E-Mail - - Google Chrome") ; removed identifiying information. 
				{
					WinActivate
					sleep, 20
					WinActivate, "E-Mail - - Google Chrome"
					if !ReSelect and (ReSelect = False)
						SendInput, % "{Left " move-1 "}"
					else if (Reselect="")
						SendInput, % "{Left " move-1 "}"
					
				}	
				else
					if !ReSelect and (ReSelect = False)
						SendInput, % "{Left " move-1 "}"
				else if (Reselect="")
					SendInput, % "{Left " move-1 "}"
			}
		}
		SetTimer, %A_ThisFunc%, -700
		Sleep 20 ; Short sleep in case Clip() is followed by more keystrokes such as {Enter}
		If (Text = "") ; we are pulling text rn, not pasting
		{
			SetTimer, %A_ThisFunc%, Off
			{
				f_unstickKeys()
				if !Restore
					return LastClip := Clipboard
				else	
				LastClip := Clipboard
				Clipboard:=""
				ClipWait, LongCopy ? 0.6 : 0.2, True
				Clipboard:=ClipStore
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
	Return
	fClip:
	f_unstickKeys()
	Return fClip()
}

f_unstickKeys()
{
	SendInput, {Ctrl Up}
	SendInput, {V Up}
	SendInput, {Shift Up}
	SendInput, {Alt Up}
}
