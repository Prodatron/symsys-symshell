nolist
computer_mode equ 4     ;0=cpc, 1=msx, 2=pcw, 3=ep, 4=svm, 5=nc, 6=nxt

org #1000
if computer_mode=0
    write "f:\symbos\cmd.exe"
elseif computer_mode=1
    write "f:\symbos\msx\cmd.exe"
elseif computer_mode=2
    write "f:\symbos\pcw\cmd.exe"
elseif computer_mode=3
    write "f:\symbos\ep\cmd.exe"
elseif computer_mode=4
    write "f:\symbos\svm\cmd.exe"
elseif computer_mode=5
    write "f:\symbos\nc\cmd.exe"
elseif computer_mode=6
    write "f:\symbos\nxt\cmd.exe"
endif

READ "..\..\..\SRC-Main\SymbOS-Constants.asm"
READ "..\..\..\SRC-Main\SymbOS-File-Const.asm"
READ "App-Shell.asm"
