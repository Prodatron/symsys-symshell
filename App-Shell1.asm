nolist

READ "..\..\..\SRC-Main\SymbOS-Constants.asm"

PLATFORM_TYPE equ    PLATFORM_CPC

org #1000
    if PLATFORM_TYPE=PLATFORM_CPC
    write "f:\symbos\cmd.exe"
elseif PLATFORM_TYPE=PLATFORM_MSX
    write "f:\symbos\msx\cmd.exe"
elseif PLATFORM_TYPE=PLATFORM_PCW
    write "f:\symbos\pcw\cmd.exe"
elseif PLATFORM_TYPE=PLATFORM_EPR
    write "f:\symbos\ep\cmd.exe"
elseif PLATFORM_TYPE=PLATFORM_SVM
    write "f:\symbos\svm\cmd.exe"
elseif PLATFORM_TYPE=PLATFORM_NCX
    write "f:\symbos\nc\cmd.exe"
elseif PLATFORM_TYPE=PLATFORM_ZNX
    write "f:\symbos\nxt\cmd.exe"
elseif PLATFORM_TYPE=PLATFORM_ISA
    write "f:\symbos\isa\cmd.exe"
endif

READ "..\..\..\SRC-Main\SymbOS-File-Const.asm"
READ "App-Shell.asm"
