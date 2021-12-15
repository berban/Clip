# Clip
Clip() - Send and Retrieve Text using the Clipboard


Forum link: https://www.autohotkey.com/boards/viewtopic.php?f=6&t=62156

edited and changed by Gewerd-Strauss

## Paste a variable while reliably restoring the clipboard

```
Numpad0::
txt:="Hello World"
fClip(txt)
return
```

## Retrieving selected text

```
Numpad0::
txt:=fClip()
msgbox, % txt 
return
```
For further explanation on the different parameters meaning, check the function itself.
