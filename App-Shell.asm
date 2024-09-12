;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;@                                                                            @
;@                        S y m b O S   -   S h e l l                         @
;@                                                                            @
;@             (c) 2005-2024 by Prodatron / SymbiosiS (Jörn Mika)             @
;@                                                                            @
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

relocate_start

shvs_maj    equ "2"
shvs_min    equ "4"

if computer_mode=4
max_xlen    equ 120
max_ylen    equ 50
else
max_xlen    equ 80
max_ylen    equ 25
endif


;- svm -> kein cursor und space/clr im window mode (alt font issue?)


;- next -> center in fullscreen mode
;- cmd quit -> ask tasks to quit, if they don't quit within a few cycles, kill them

;- msx-basic
;  - does resizes at the beginning
;  - wrong cursor placement
;  - does some shit, when textoutput on/off is activated

;- app hangs after loosing focus AND continuing printing
;- chars >127 EP

;- "focus" process-kill key-combination
;- kein tab complete bei strinp
;- bf.com debuggen
;- change pen/paper colour in application

;- half cursor (?)
;? msx -> 25 statt 24 lines ???
;# paste (ctrl+v)
;# mouse buttons rausfiltern (chrinp)
;# tab+shift -> tab complete (9 und 11)

;new
;- config speichern

;fixed
;- scrolling muß desktop-manager-scroll-messages aufnehmen (beispiel type)
;? seltsames verhalten mit eingabezeile nach einer weile
;? falsche apps werden beendet

;bugs
;- bei zu langer eingabe absturz (buffer overflow durch ergänzungen)

;todo
;- batch files not found
;- 16colour selection, colours für fullscreen beachten
;- type mit crtl+c

;nextgen
;- input history dynamisch, auf 512 kürzen, doppelte überall entfernen
;- commandos sind eigene prozesse
;- dir zeigt label an/vol
;- del löscht verzeichnis inhalt falls directory angabe


;--- CONSOLEN-ROUTINEN --------------------------------------------------------
;>>> CNSMSG -> Verarbeitet Message an Shell
;>>> CNSKEY -> Tastatur-Eingabe verarbeiten
;>>> CNSCHK -> Prüft, ob Tastatur-Anfragen vorliegen und arbeitet diese, wenn möglich, ab
;>>> CNSGET -> Zeichen aus dem Tastaturbuffer holen
;>>> CNSERR -> Gibt Fehlermeldung aus
;>>> CNSINL -> Zeile wird angefordert
;>>> CNSINC -> Zeichen wird angefordert
;>>> CNSOUC -> Zeichen soll ausgegeben werden
;>>> CNSOUL -> String soll ausgegeben werden
;>>> CNSDAT -> Daten eines Prozesses holen
;>>> CNSHND -> Erstellt Filehandler für einen neuen Prozess
;>>> CNSADD -> Fügt Prozess der Konsole hinzu
;>>> CNSDEL -> Entfernt Prozess aus der Liste

;--- COMMAND-ROUTINEN ---------------------------------------------------------
;>>> CMDPRZ -> Verarbeitet Kommando
;>>> CMDRED -> Ermittelt Redirection und Hintergrundstart Angaben bei Commando
;>>> CMDERR -> Gibt Fehlermeldung aus
;>>> CMDPAR -> Erstellt Parameter-Liste aus Eingabe-String
;>>> CMDCHK -> Prüft, ob richtige Zahl Parameter übergeben wurde

;--- SHELL-ROUTINEN -----------------------------------------------------------
;>>> SHLOUT -> Gibt String aus
;>>> SHLCHR -> Gibt Zeichen aus
;>>> SHLNEW -> Startet neue Shell-Instanz
;>>> SHLREP -> Fährt mit aktueller Shell-Instanz fort
;>>> SHLDWN -> Geht eine Shell-Instanz tiefer
;>>> SHLGET -> Empfängt Message an Shell
;>>> SHLFOC -> Testet, ob Shell Focus hat
;>>> SHLRES -> Resettet den Shell-Speicher
;>>> SHLDIR -> Plottet das Shell-Directory
;>>> SHLINI -> Initialisiert die Shell
;>>> SHLTAB -> Autocomplete
;>>> SHLINP -> Zeileneingabe

;--- TERMINAL-ROUTINEN --------------------------------------------------------
;>>> TRMINI -> Initialisiert die Konsole
;>>> TRMCHR -> Ausgabe eines Zeichens auf der Konsole
;>>> TRMOUT -> Ausgabe eines Strings auf der Konsole

;--- SCREEN-ROUTINEN ----------------------------------------------------------
;>>> SCRSET -> Ausgabe-Treiber setzen
;>>> SCRINI -> Initialisiert den Bildschirm
;>>> SCRCLR -> Löscht den kompletten Bildschirm
;>>> SCRSRU -> Scrollt Bildschirm nach oben und fügt unten Leerzeile ein
;>>> SCRSRD -> Scrollt Bildschirm nach unten und fügt oben Leerzeile ein
;>>> SCRPLT -> Fügt Text in Bildschirm ein
;>>> SCRFLL -> Füllt Bildschirm-Bereich mit gleichem Zeichen
;>>> SCRCON -> Cursor positionieren und einblenden
;>>> SCRCOF -> Cursor ausblenden

;--- DIRECTORY-ROUTINEN -------------------------------------------------------
;>>> DIREXI -> Test, ob Directory existiert
;>>> DIRADD -> Setzt Directory-Angabe mit aktuellem Shell-Directory zu neuem Directory zusammen
;>>> DIRFIL -> Stellt Applications-Pfad zusammen
;>>> DIRRUN -> Versucht Application zu starten

;--- MASSEN-FILEOPERATION -----------------------------------------------------
;>>> MULPRE -> Bereitet Massen-Fileoperation vor
;>>> MULDIR -> Liest Directory für Massen-Fileoperation ein
;>>> MULSRC -> Holt vollen Pfad der nächsten Quelldatei
;>>> MULDST -> Holt vollen Pfad der nächsten Zieldatei
;>>> MULPLT -> Plottet Quelldatei
;>>> MULRES -> Plottet Ergebnis

;--- SORTIER-ROUTINEN ---------------------------------------------------------
;>>> SRTDAT -> Zeigertabelle sortieren
;>>> SRTPAR -> Teil einer Tabelle sortieren
;>>> SRTSWP -> Vertauscht zwei Zeilen
;>>> SRTCMP -> Vergleicht zwei Elemente

;--- "CONFIG" FUNKTIONEN ------------------------------------------------------
;>>> CFGSET -> Config-Dialog

;--- SUB-ROUTINEN -------------------------------------------------------------
;>>> MSGGET -> Message für Programm abholen
;>>> MSGDSK -> Message für Programm von Desktop-Prozess abholen
;>>> MSGSND -> Message an Desktop-Prozess senden
;>>> SYSCLL -> Betriebssystem-Funktion aufrufen
;>>> CLCN32 -> Wandelt 32Bit-Zahl in ASCII-String um (mit 0 abgeschlossen)
;>>> CLCDEZ -> Rechnet Byte in zwei Dezimalziffern um
;>>> CLCLEN -> Ermittelt Länge eines Strings
;>>> CLCLCS -> Wandelt Groß- in Kleinbuchstaben um
;>>> CLCM16 -> Multipliziert zwei Werte (16bit)
;>>> CLCD16 -> Dividiert zwei Werte (16bit)
;>>> CLCR16 -> Wandelt String in 16Bit Zahl um
;>>> CLCI16 -> Fügt Zahl in Eingabefeld ein
;>>> CLCGDY -> Wochen-Tag errechnen
;>>> INIVER -> Holt Versionstext des Betriebssystems und prüft, ob korrekte Plattform
;>>> FILF2T -> Wandelt Filesystem-Timestamp in Uhrzeit um
;>>> DSKSRV -> Desktop Service nutzen

read"..\..\..\SVN-Main\trunk\_svm\hardware.cpc"

macro   nextreg number,value
    if "value"="a"
        db #ed,#92,number
    elseif "value"="A"
        db #ed,#92,number
    else
        db #ed,#91,number,value
    endif
mend

SPRITE_CONTROL_NR_15            equ #15     ;LoRes mode, Sprites configuration, layers priority
CLIP_LAYER2_NR_18               equ #18
CLIP_TILEMAP_NR_1B              equ #1B
CLIP_WINDOW_CONTROL_NR_1C       equ #1C     ;set to 15 to reset all clip-window indices to 0
TILEMAP_CONTROL_NR_6B           equ #6B
TILEMAP_BASE_ADR_NR_6E          equ #6E     ;Tilemap base address of map
TILEMAP_GFX_ADR_NR_6F           equ #6F     ;Tilemap definitions (graphics of tiles)
PALETTE_INDEX_NR_40             equ #40     ;Chooses a ULANext palette number to configure.
PALETTE_CONTROL_NR_43           equ #43     ;Enables or disables ULANext interpretation of attribute values and toggles active palette.
PALETTE_VALUE_9BIT_NR_44        equ #44     ;Holds the additional blue color bit for RGB333 color selection.



;==============================================================================
;### CODE-TEIL ################################################################
;==============================================================================

;### PROGRAMM-KOPF ############################################################

prgdatcod       equ 0           ;Länge Code-Teil (Pos+Len beliebig; inklusive Kopf!)
prgdatdat       equ 2           ;Länge Daten-Teil (innerhalb 16K Block)
prgdattra       equ 4           ;Länge Transfer-Teil (ab #C000)
prgdatorg       equ 6           ;Original-Origin
prgdatrel       equ 8           ;Anzahl Einträge Relocator-Tabelle
prgdatstk       equ 10          ;Länge Stack (Transfer-Teil beginnt immer mit Stack)
prgdatrsv       equ 12          ;*reserved* (3 bytes)
prgdatnam       equ 15          ;program name (24+1[0] chars)
prgdatflg       equ 40          ;flags (+1=16colour icon available)
prgdat16i       equ 41          ;file offset of 16colour icon
prgdatrs2       equ 43          ;*reserved* (5 bytes)
prgdatidn       equ 48          ;"SymExe10"
prgdatcex       equ 56          ;zusätzlicher Speicher für Code-Bereich
prgdatdex       equ 58          ;zusätzlicher Speicher für Data-Bereich
prgdattex       equ 60          ;zusätzlicher Speicher für Transfer-Bereich
prgdatres       equ 62          ;*reserviert* (26 bytes)
prgdatver       equ 88          ;required OS version (minor,major)
prgdatism       equ 90          ;Icon (klein)
prgdatibg       equ 109         ;Icon (gross)
prgdatlen       equ 256         ;Datensatzlänge

prgpstdat       equ 6           ;Adresse Daten-Teil
prgpsttra       equ 8           ;Adresse Transfer-Teil
prgpstspz       equ 10          ;zusätzliche Prozessnummern (4*1)
prgpstbnk       equ 14          ;Bank (1-8)
prgpstmem       equ 48          ;zusätzliche Memory-Bereiche (8*5)
prgpstnum       equ 88          ;Programm-Nummer
prgpstprz       equ 89          ;Prozess-Nummer

prgcodbeg   dw prgdatbeg-prgcodbeg  ;Länge Code-Teil
            dw prgtrnbeg-prgdatbeg  ;Länge Daten-Teil
            dw prgtrnend-prgtrnbeg  ;Länge Transfer-Teil
prgdatadr   dw #1000                ;Original-Origin                    POST Adresse Daten-Teil
prgtrnadr   dw relocate_count       ;Anzahl Einträge Relocator-Tabelle  POST Adresse Transfer-Teil
prgprztab   dw prgstk-prgtrnbeg     ;Länge Stack                        POST Tabelle Prozesse
            dw 0                    ;*reserved*
prgbnknum   db 0                    ;*reserved*                         POST bank number
            db "SymShell":ds 16:db 0 ;Name
            db 1                    ;flags (+1=16c icon)
            dw prgicn16c-prgcodbeg  ;16 colour icon offset
            ds 5                    ;*reserved*
prgmemtab   db "SymExe10"           ;SymbOS-EXE-Kennung                 POST Tabelle Speicherbereiche
            dw 0                    ;zusätzlicher Code-Speicher
            dw max_xlen*max_ylen+max_ylen   ;zusätzlicher Data-Speicher
            dw 128*8+dirbufmax      ;zusätzlicher Transfer-Speicher
            ds 26                   ;*reserviert*
            db 0,3                  ;required OS version (3.0)
prgicnsml   db 2,8,8,#0F,#0F,#2F,#0F,#5F,#4F,#7F,#2F,#5F,#4F,#5F,#0F,#0F,#0F,#0F,#0F
prgicnbig   db 6,24,24,#F0,#F0,#F0,#F0,#F0,#F0,#D7,#FF,#FF,#FF,#FF,#B4,#87,#FA,#F5,#F7,#FF,#5A,#A7,#FF,#FF,#FF,#FF,#B4,#F0,#F0,#F0,#F0,#F0,#F0,#87,#0F,#0F,#0F,#0F,#1E,#B4,#F0,#F0,#F0,#F0,#D2,#B4,#F0,#F0,#F0,#F0,#D2,#B4,#F0,#F0,#F0
            db #F0,#D2,#B4,#F0,#F0,#F0,#F0,#D2,#B4,#00,#F0,#B0,#F0,#D2,#A4,#60,#70,#B0,#B0,#D2,#A4,#60,#40,#90,#90,#D2,#A4,#00,#40,#D0,#C0,#D2,#A4,#60,#70,#C0,#C0,#D2,#A4,#60,#40,#E0,#90,#D2,#A4,#60,#40,#E0,#B0,#D2,#B4,#F0,#F0,#F0
            db #F0,#D2,#B4,#F0,#F0,#F0,#F0,#D2,#B4,#F0,#F0,#F0,#F0,#D2,#B4,#F0,#F0,#F0,#F0,#D2,#B4,#F0,#F0,#F0,#F0,#D2,#87,#0F,#0F,#0F,#0F,#1E,#F0,#F0,#F0,#F0,#F0,#F0


;### PRGPRZ -> Programm-Prozess
windatprz   equ 3   ;Prozeßnummer
windatsup   equ 51  ;Nummer des Superfensters+1 oder 0
prgwin      db 0    ;Nummer des Haupt-Fensters
diawin      db 0    ;Nummer des Dialog-Fensters

prgprz  ld a,(prgprzn)
        ld (prgwindat+windatprz),a
        ld (configwin+windatprz),a

        call iniver
        jp c,prgend4
        call prgpar
        push af
        call cfglod
if computer_mode=1
elseif computer_mode=2
elseif computer_mode=4
else
        call fulrel             ;fullscreen mode relocation for CPC,EP,NC,NXT
endif
        xor a
        call scrset
        call scrini
        call memclr
        call trmini
        call shlres
        call SySystem_HLPINI

        ld c,MSC_DSK_WINOPN
        ld a,(prgbnknum)
        ld b,a
        ld de,prgwindat
        call msgsnd             ;Fenster aufbauen
prgprz1 call msgdsk             ;Message holen -> IXL=Status, IXH=Absender-Prozeß
        cp MSR_DSK_WOPNER
        jp z,prgend4            ;kein Speicher für Fenster -> Prozeß beenden
        cp MSR_DSK_WOPNOK
        jr nz,prgprz1           ;andere Message als "Fenster geöffnet" -> ignorieren
        ld a,(prgmsgb+4)
        ld (prgwin),a           ;Fenster wurde geöffnet -> Nummer merken

        pop af
        jr nc,prgprz6
        ld a,1
        ld (cmdredf),a
        call cmdprzq
        call shlget5
        jr prgprz0

prgprz6 ld hl,0
        ld de,0
        ld b,1
        call shlnew             ;neue Shell starten
        jp c,prgend
        call shlrep
        call cnschk

prgprz0 call msgget
        jr nc,prgprz0
        cp MSR_DSK_WCLICK       ;*** Fenster-Aktion wurde geklickt
        jr z,prgprz7
        call cnsmsg             ;*** Prozess-Message an Shell verarbeiten
        jr prgprz0
prgprz7 ld e,(iy+1)
        ld a,(prgwin)
        cp e
        jr z,prgprz4
        ld a,(diawin)
        cp e
        jr nz,prgprz0
        ld a,(iy+2)             ;*** DIALOG-FENSTER
        cp DSK_ACT_CLOSE        ;*** Close wurde geklickt
        jp z,diacnc
        jr prgprz5
prgprz4 ld a,(iy+2)             ;*** HAUPT-FENSTER
        cp DSK_ACT_CLOSE        ;*** Close wurde geklickt
        jp z,prgend
prgprz5 cp DSK_ACT_MENU         ;*** Menü wurde geklickt
        jr z,prgprz2
        cp DSK_ACT_KEY          ;*** Taste wurde gedrückt
        jr z,prgkey
        cp DSK_ACT_CONTENT      ;*** Inhalt wurde geklickt
        jr nz,prgprz0
prgprz2 ld l,(iy+8)
        ld h,(iy+9)
        ld a,l
        or h
        jr z,prgprz0
        ld a,(iy+3)             ;A=Klick-Typ (0/1/2=Maus links/rechts/doppelt, 7=Tastatur)
        jp (hl)

;### PRGKEY -> Taste auswerten
prgkey  ld a,(cmdwai)
        or a
        ret nz              ;##!!## ??NIRVANA??
        ld a,(iy+4)
        cp 13
        jr nz,prgkey1
        push af             ;** alt+return -> fullscreen
        ld hl,jmp_keysta
        rst #28
        pop af
        bit 2,e
        jr z,prgkey1
        call cmdful
        jr prgprz0
prgkey1 cp 22
        jr z,prgkey2
        call cnskey         ;** normal key
        jr prgprz0
prgkey2 rst #20:dw #8154    ;** ctrl+V -> paste
        ld a,d
        cp 1
        jr nz,prgprz0
        push ix:pop hl
        ld a,e
        push iy:pop de
prgkey3 push af
        push de
        rst #20:dw #812A
        push hl
        ld a,b
        call cnskey
        pop hl
        pop de
        pop bc
        dec de
        ld a,e
        or d
        ld a,b
        jr nz,prgkey3
        jp prgprz0

;### PRGEND -> Programm beenden
prgend  ld a,(cnsprzanz)
        or a
        jr z,prgend2
        ld a,(cnsprzmem+cnsprznum)
        cp 128
        jr nc,prgend1
        push af
        call prgend3
        pop af
prgend1 call cnsdel         ;Handler schließen
        jr prgend
prgend2 ld a,(scrmod)
        dec a
        push af
        call z,cmdful0      ;Fullscreen aus, falls aktiv
        pop af
        ld c,MSC_DSK_WINCLS
        call nz,msgsnd2
        call cfgsav
prgend4 ld a,(prgprzn)
        db #dd:ld l,a
        db #dd:ld h,PRC_ID_SYSTEM
        ld iy,prgmsgb
        ld (iy+0),MSC_SYS_PRGEND
        ld a,(prgcodbeg+prgpstnum)
        ld (iy+1),a
        rst #10
prgend0 rst #30
        jr prgend0
prgend3 db #dd:ld h,a       ;A=Prozess -> Ende senden
        ld a,(prgprzn)
        db #dd:ld l,a
        ld iy,prgmsgb
        ld (iy+0),MSC_GEN_QUIT
        rst #10
        ret

;### PRGINF -> Info-Fenster anzeigen
prginf  ld hl,prgmsginf         ;*** Info-Fenster
        ld b,1+128
        call prginf0
        jp prgprz0
prginf0 ld (prgmsgb+1),hl
        ld a,(prgbnknum)
        ld c,a
        ld (prgmsgb+3),bc
        ld a,MSC_SYS_SYSWRN
        ld (prgmsgb),a
        ld a,(prgprzn)
        db #dd:ld l,a
        db #dd:ld h,PRC_ID_SYSTEM
        ld iy,prgmsgb
        rst #10
        ret

;### PRGPAR -> Startpfad und angehängte Commandozeile auswerten
;### Ausgabe    CF=1 Commandozeile vorhanden
prgparp dw 0    ;start pfad
prgparf dw 0    ;start filename

prgpar  ld hl,(prgcodbeg)       ;nach angehängter Datei suchen
        ld de,prgcodbeg
        dec h
        add hl,de               ;HL=CodeEnde=Pfad
        ld (prgparp),hl
        call prgpar0
        ld (prgparf),de
        jr nc,prgpar2
prgpar6 ld a,e                  ;Pfad übernehmen
        or d
        ret z
        xor a
        ld (de),a
        push hl
        ld hl,(prgparp)
        inc hl
        ld a,(hl)
        cp ":"
        jr nz,prgpar5
        dec hl
        ld de,shlpth
        ld bc,256
        ldir
prgpar5 pop hl
        or a
        ret
prgpar2 call prgpar6
prgpar4 inc hl                  ;Parameter suchen
        ld a,(hl)
        or a
        ret z
        cp 32
        jr z,prgpar4
        ld de,shlinplin
        ld bc,256
        ldir
        scf
        ret
;HL=String -> DE=letztes /, CF=0 pfad hört mit Leerzeichen auf
prgpar0 ld de,0
        ld b,255
prgpar1 ld a,(hl)
        cp "\"
        jr z,prgpar7
        cp "/"
        jr nz,prgpar3
prgpar7 ld e,l
        ld d,h
prgpar3 or a
        scf
        ret z
        cp 32
        ret z
        inc hl
        djnz prgpar1
        scf
        ret


;==============================================================================
;### CONSOLEN-ROUTINEN ########################################################
;==============================================================================

cnsprznum   equ 0   ;Prozessnummer, >=128=Shell
cnsprzinp   equ 2   ;Eingabe-Handler, 255=Tastatur
cnsprzout   equ 3   ;Ausgabe-Handler, 255=Bildschirm
cnsprzlen   equ 4   ;Länge eines Prozess-Datensatzes
cnsprzmax   equ 8   ;Maximal 8 Prozesse pro Konsole

cnsprzmem   ds cnsprzmax*cnsprzlen  ;Prozessdatensätze
cnsprzanz   db 0

cnscmdprz   equ 0   ;Prozessnummer, 248-255=Shell
cnscmdbnk   equ 1   ;0=Zeichen wird verlangt, 1-8=String wird verlangt (Banknummer)
cnscmdadr   equ 2   ;Adresse, wenn String verlangt wird
cnscmdsub   equ 4   ;0 oder Subroutine, falls Rückkehr in internes Commando
cnscmdlen   equ 8
cnscmdmax   equ 8

cnscmdmem   ds cnscmdmax*cnscmdlen
cnscmdpos   db 0    ;Position nach dem zuletzt eingefügten
cnscmdlst   db 0    ;Position des zuerst zu lesendem (lst=pos -> keine vorhanden)

cnskeymax   equ 32
cnskeybuf   ds cnskeymax    ;Tastatur-Buffer
cnskeypos   db 0
cnskeylen   db 0
cnskeywbk   db 0    ;watch byte bank
cnskeywad   dw 0    ;watch byte adr

cnsmod      db 0    ;0=Taste in Buffer, 1=Taste an Zeileneingabe senden
cnsbuf      ds 256


;### CNSMSG -> Verarbeitet Message an Shell
;### Eingabe    IXH=Absender, (prgmsgb)=Message, A=(prgmsgb+0), IY=prgmsgb
cnsmsgp dw 0
cnsmsg  ld (cnsmsgp),ix
        sub MSC_SHL_CHRINP
        ld b,a
        db #dd:ld a,h
        ld d,(iy+1)         ;d=channel
        ld e,(iy+2)         ;e=parameter
        ld hl,(prgmsgb+3)
        jr nz,cnsmsg1           ;** MSC_SHL_CHRINP
        call cnsinc
        ld c,MSR_SHL_CHRINP
        jr c,cnsmsg5
        ret nz
        ld l,a
        jr cnsmsg0
cnsmsg1 dec b                   ;** MSC_SHL_STRINP
        jr nz,cnsmsg2
        call cnsinl
        ld c,MSR_SHL_STRINP
        jr c,cnsmsg5
        ret nz
cnsmsg0 ld a,(cnsmsgp+1)
        jp cnschk5
cnsmsg2 dec b                   ;** MSC_SHL_CHROUT
        jr nz,cnsmsg3
        call cnsouc
        ld c,MSR_SHL_CHROUT
        jr c,cnsmsg5
        jr cnsmsg0
cnsmsg3 dec b                   ;** MSC_SHL_STROUT
        jr nz,cnsmsg4
        ld c,(iy+5)
        call cnsoul
        ld c,MSR_SHL_STROUT
        jr c,cnsmsg5
        jr cnsmsg0
cnsmsg4 dec b                   ;** MSC_SHL_EXIT
        jr nz,cnsmsg7
        ld a,d              ;0=Quit, 1=Blur
        or a
        jr nz,cnsmsg6
        db #dd:ld a,h
        call cnsdel
cnsmsg6 call shlfoc
        jp c,shlrep         ;Shell hat keinen Focus -> fortsetzen
        ret
cnsmsg5 push af
        ld a,(cnsmsgp+1)
        ld b,1
        call cnschk6
        pop af
        jp cnserr
cnsmsg7 dec b                   ;** MSC_SHL_PTHADD
        jr nz,cnsmsg9
        ld a,e              ;swap d,e
        ld e,d
        ld d,a
        push de             ;de=base path, hl=add path
        ld a,(prgbnknum)
        add a:add a:add a:add a
        add (iy+7)
        ld de,shlpthnew2    ;add path in shlpthnew2
        ld bc,256
        push af
        rst #20:dw jmp_bnkcop
        pop bc
        pop de
        ld a,e
        or d
        ld a,b
        ld bc,shlpth
        jr z,cnsmsg8        ;kein base path -> standard nehmen
        ex de,hl
        ld de,shlpthnew     ;base path in shlpthnew
        push de
        ld bc,256
        rst #20:dw jmp_bnkcop
        pop bc              ;hl=base path, shlpthnew2=add path, shlpthnew=new path
cnsmsg8 ld hl,shlpthnew2
        ld de,shlpthnew
        call diradd0        ;DE=Terminatorposition, A=Type (+1=hört mit \ auf, +2=enthält filemask), HL=pos hinter letztem \
        push hl
        ld hl,(prgmsgb+5)
        ld bc,shlpthnew
        or a
        sbc hl,bc
        ld c,l
        ld b,h              ;bc=real new - temp new
        pop hl
        add hl,bc
        ld (prgmsgb+3),hl
        ex de,hl
        add hl,bc
        ld (prgmsgb+1),hl
        ld de,(prgmsgb+5)
        ld (prgmsgb+5),a
        ld a,(prgmsgb+7)
        add a:add a:add a:add a
        ld hl,prgbnknum
        add (hl)
        ld hl,shlpthnew
        ld bc,256
        rst #20:dw jmp_bnkcop
        ld ix,(cnsmsgp)
        ld a,(prgprzn)
        db #dd:ld l,a
        ld (iy+0),MSR_SHL_PTHADD
        rst #10
        ret
cnsmsg9 dec b                   ;** MSC_SHL_CHRTST
        jr nz,cnsmsgd
        ;...check if not keyboard channel
        ;...check eof (ctrl+C)
        dec e
        jr nz,cnsmsga
        call cnsget         ;* take it if available
        jr nc,cnsmsgb
        ld h,0
        jr cnsmsgc
cnsmsga ld a,(cnskeylen)    ;* only lookahead
        or a
        ld h,a
        jr z,cnsmsgc        ;no char available
        ld c,a
        call cnsget1
cnsmsgb ld l,a
        ld h,2              ;char available
cnsmsgc ld c,MSR_SHL_CHRTST
        jp cnsmsg0
cnsmsgd dec b                   ;** MSC_SHL_CHRWTC
        ret nz
        dec d               ;e=bank, hl=adr, d=add[1]/remove[0]
        jr z,cnsmsge
        ld e,0
cnsmsge ld a,e
        ld (cnskeywbk),a
        ld (cnskeywad),hl
        xor a
        ld c,MSR_SHL_CHRWTC
        jp cnsmsg0

;### CNSKEY -> Tastatur-Eingabe verarbeiten
;### Eingabe    A=ASCII-Code
cnskey  cp 188
        jr c,cnskey0
        cp 192
        ret c
cnskey0 ld e,a
        ld a,(cnsmod)
        or a
        ld a,e
        jr nz,cnskey1
        ld a,(cnskeylen)    ;*** Zeichen-Eingabe
        cp cnskeymax
        scf
        ret z               ;Buffer voll
        inc a
        ld (cnskeylen),a    ;neue Länge eintragen
        dec a
        ld a,e
        call z,cnswtc       ;first byte in buffer -> update watch byte
        ld a,(cnskeypos)
        ld c,a
        ld b,0
        ld hl,cnskeybuf
        add hl,bc
        ld (hl),e           ;Zeichen eintragen
        inc a
        and cnskeymax-1
        ld (cnskeypos),a    ;neue Position eintragen
        jr cnschk
cnskey1 call shlinp         ;*** Zeilen-Eingabe -> CF=1 Eingabe wurde abgeschlossen -> (shlinplin)=String, (shlinplen)=Länge, ZF=1 Abschluß durch Abbruch
        jr c,cnskey3
cnskey2 call cnsget
        jr nc,cnskey1
        ret
cnskey3 push af             ;Zeile absenden
        call cnschk0        ;Eintrag aus Commando-Buffer löschen
        dec a
        and cnscmdmax-1
        call cnschk4        ;Commando holen
        pop af
        ld h,1
        jr z,cnskey4        ;Abschluß durch Abbruch, nur Code senden
        ld a,(ix+cnscmdbnk)
        add a:add a:add a:add a
        ld hl,prgbnknum
        add (hl)
        ld hl,shlinplin
        ld bc,256
        ld e,(ix+cnscmdadr+0)
        ld d,(ix+cnscmdadr+1)
        rst #20:dw jmp_bnkcop
        ld h,0
cnskey4 ld c,MSR_SHL_STRINP
        jr cnschk2

;### CNSCHK -> Prüft, ob Tastatur-Anfragen vorliegen und arbeitet diese, wenn möglich, ab
cnschk  xor a
        ld (cnsmod),a
        ld hl,cnscmdlst
        ld a,(cnscmdpos)
        cp (hl)
        ret z
        ld a,(hl)
        call cnschk4
        ld a,(ix+cnscmdbnk)
        cp -1
        jr nz,cnschk8
        call cnschk0        ;Eintrag ungültig -> entfernen und nochmal
        jr cnschk
cnschk8 or a
        jr nz,cnschk3
        call cnsget         ;*** Zeichen wird angefragt -> senden, falls vorhanden
        ret c               ;kein Zeichen da
        cp 3
        ld h,0
        jr nz,cnschk1
        inc h
cnschk1 ld l,a
        call cnschk0
        ld c,MSR_SHL_CHRINP
cnschk2 ld a,(ix+cnscmdprz) ;A=Prozess
        call cnschk5
        jr cnschk
cnschk5 ld b,0          ;A=process ID (>127 -> ?), C=response ID, B=error status (0=ok, >0=error code), L=parameter, H=EOF (0=no EOF)
cnschk6 cp 128
        jp nc,shlget
        ld iy,prgmsgb
        ld (iy+0),c
        ld (iy+1),h
        ld (iy+2),l
        ld (iy+3),b
cnschk7 db #dd:ld h,a
        ld a,(prgprzn)
        db #dd:ld l,a
        rst #10
        ret
cnschk3 call shlini         ;*** Zeile wird angefragt -> Zeilen-Eingabe starten
        ld a,1
        ld (cnsmod),a
        jp cnskey2
cnschk0 ld bc,cnscmdlst     ;*** Eintrag aus Commando-Buffer löschen
        ld a,(bc)
        inc a
        and cnscmdmax-1
        ld (bc),a
        ret
cnschk4 add a:add a:add a   ;*** Commando holen
        ld c,a
        ld b,0
        ld ix,cnscmdmem
        add ix,bc
        ret

;### CNSGET -> Zeichen aus dem Tastaturbuffer holen
;### Ausgabe    CF=0-> A=Zeichen, CF=1-> kein Zeichen vorhanden
;### Veraendert BC,HL
cnsget  ld a,(cnskeylen)
        or a
        scf
        ret z               ;kein Zeichen vorhanden
        ld c,a
        dec a
        ld (cnskeylen),a    ;Länge kürzen
        jr z,cnsget2
        push bc
        dec c
        call cnsget1
        pop bc
cnsget2 call cnswtc         ;send A to watch byte
cnsget1 ld a,(cnskeypos)
        sub c
        and cnskeymax-1
        ld c,a
        ld b,0
        ld hl,cnskeybuf
        add hl,bc
        ld a,(hl)           ;Zeichen holen
        ret

;### CNSWTC -> write A to console watch byte
;### Input      A=char/0, (cnskeywbk),(cnskeywad)=watch byte
;### Destroyed  AF,HL
cnswtc  push bc
        ld b,a
        ld a,(cnskeywbk)
        or a
        jr z,cnswtc1
        ld hl,(cnskeywad)
        rst #20:dw jmp_bnkwbt
cnswtc1 pop bc
        ret

;### CNSERR -> Gibt Fehlermeldung aus
;### Eingabe    CF=0 -> keine Fehlermeldung ausgeben
;###            CF=1 -> A=Code Filemanager-Fehlercode (254=Prozess ist unbekannt, 253=Gerät ist voll, 252=Ringbuffer voll,
;###                    251=zu viele Prozesse), 250=memory full, 249=help file error, 248=help command not found
prgmsgerru  db "*Undefined Error*",0
prgmsgerrp  db "Unknown requester process",0
prgmsgerrf  db "Device full",0
prgmsgerrb  db "Command buffer full",0
prgmsgerrm  db "Too many processes",0
prgmsgerrn  db "Memory full",0
prgmsgerrh  db "Error while reading help file",0
prgmsgerri  db "Command not found",0

cnserrz dw prgmsgerru,prgmsgerrp,prgmsgerrf,prgmsgerrb,prgmsgerrm,prgmsgerrn,prgmsgerrh,prgmsgerri
cnserr  ret nc
        call cnserr0
        call trmout
        ld hl,shlinpret0
        jp trmout
cnserr0 cp 128
        ld bc,prgmsgerrtb
        jr nc,cnserr2
        cp prgmsgerrmx+1
        jr c,cnserr1
        ld hl,prgmsgerrxx
        ret
cnserr2 cpl
        ld bc,cnserrz
cnserr1 add a
        ld l,a
        ld h,0
        add hl,bc
        ld e,(hl)
        inc hl
        ld d,(hl)
        ex de,hl
        ret

;### CNSINL -> Zeile wird angefordert
;### Eingabe    A=Prozess, D=Kanal (0=Standard, 1=Tastatur), E=Bank, HL=Adresse (,BC=Adresse internal CommandSub)
;### Ausgabe    CF=0 -> kein Fehler, ZF=0 bisher keine Zeile verfügbar, ZF=1 Zeile wurde geladen, H=EOF-Flag (0=kein EOF)
;###            CF=1 -> Fehler (A=Fehlercode, 254=Prozess ist unbekannt, 252=Ringbuffer voll)
cnsinl  ld bc,0
cnsinl0 dec d
        jr z,cnsincx
        push bc
        call cnsdat             ;A=Prozess -> CF=1 unbekannt, CF=0 -> IX=Daten, BC,IY verändert
        pop bc
        ret c
        ld a,(ix+cnsprznum)
        ld d,(ix+cnsprzinp)
        inc d
        jr z,cnsincx
        dec d                   ;*** Input aus Datei
        ld a,d
        call syscll             ;Zeile aus Datei lesen
        db MSC_SYS_SYSFIL
        db FNC_FIL_FILLIN
        ret c
        ld h,1
        ret z
        dec h
        ret

;### CNSINC -> Zeichen wird angefordert
;### Eingabe    A=Prozess, D=Kanal (0=Standard, 1=Tastatur) (,BC=Adresse internal CommandSub)
;### Ausgabe    CF=0 -> kein Fehler, ZF=0 bisher kein Zeichen verfügbar, ZF=1 Zeichen verfügbar (A=Zeichen), H=EOF-Flag (0=kein  EOF)
;###            CF=1 -> Fehler (A=Fehlercode, 254=Prozess ist unbekannt, 252=Ringbuffer voll)
cnsinc  ld bc,0
cnsinc0 ld e,0
        dec d
        jr z,cnsincx
        call cnsdat             ;IX=Datensatz, CF=1 unbekannt
        ret c
        ld a,(ix+cnsprznum)
        ld d,(ix+cnsprzinp)
        inc d
        jr z,cnsincx
        dec d                   ;*** Input aus Datei
        ld a,d
        ld de,(prgbnknum)
        ld bc,1
        ld hl,cnsoucb
        call syscll             ;Zeichen aus Datei lesen
        db MSC_SYS_SYSFIL
        db FNC_FIL_FILINP
        ret c
        ld a,(cnsoucb)
        ld h,0
        ret z
        inc h
        xor a
        ret
;A=Prozess, E=0 oder Bank, HL=Adresse (,BC=Addresse internal CommandSub) -> fügt Anfrage in Ringbuffer ein
cnsinc1 ld bc,0
cnsincx push af
        ld ix,cnscmdpos
        ld a,(ix+0)
        inc a
        and cnscmdmax-1
        cp (ix+1)
        jr nz,cnsinc2
        pop af
        scf
        ld a,252
        ret
cnsinc2 ld (ix+0),a
        dec a
        and cnscmdmax-1
        add a:add a:add a
        push bc
        ld c,a
        ld b,0
        ld ix,cnscmdmem
        add ix,bc
        pop bc
        pop af
        ld (ix+cnscmdprz),a
        ld (ix+cnscmdbnk),e
        ld (ix+cnscmdadr+0),l
        ld (ix+cnscmdadr+1),h
        ld (ix+cnscmdsub+0),c
        ld (ix+cnscmdsub+1),b
        call cnschk
        ld a,1
        or a
        ret

;### CNSOUC -> Zeichen soll ausgegeben werden
;### Eingabe    A=Prozess, D=Kanal (0=Standard, 1=Screen), E=Zeichen
;### Ausgabe    CF=0 alles ok, CF=1 Fehler (A=Fehlercode, 254=Prozess ist unbekannt, 253=Gerät ist voll)
;### Verändert  AF,BC,DE,HL,IX,IY
cnsoucb dw 0
cnsouc  dec d
        jr nz,cnsouc2
cnsouc1 ld a,e
        call trmchr
        or a
        ret
cnsouc2 call cnsdat
        ret c
        ld a,(ix+cnsprzout)
        inc a
        jr z,cnsouc1
        dec a
        ld hl,cnsoucb
        ld (hl),e
        ld de,(prgbnknum)
        ld bc,1
        jr cnsoul7

;### CNSOUL -> String soll ausgegeben werden
;### Eingabe    A=Prozess, D=Kanal (0=Standard, 1=Screen), E=Bank, HL=Adresse (muß mit 0 terminiert sein), C=Länge (ohne 0)
;### Ausgabe    CF=0 alles ok, CF=1 Fehler (A=Fehlercode, 254=Prozess ist unbekannt, 253=Gerät ist voll)
;### Verändert  AF,BC,DE,HL,IX,IY
cnsoul  dec d
        jr nz,cnsoul4
cnsoul5 call cnsoul1
        call trmout
        or a
        ret
cnsoul4 push bc
        call cnsdat
        pop bc
        ret c
        ld a,(ix+cnsprzout)
        inc a
        jr z,cnsoul5
        dec a
        ld b,0
        ld d,e
        inc d
        jr nz,cnsoul7
        ld de,(prgbnknum)
cnsoul7 call syscll             ;Zeile in Datei schreiben
        db MSC_SYS_SYSFIL
        db FNC_FIL_FILOUT
        ret c
        dec a
        ret nz
        ld a,253
        scf
        ret
;E,HL=QuellAdresse -> String kopieren -> HL=ZielAdresse
cnsoul1 inc e
        ret z
        dec e
        ld a,(prgbnknum)
        add a:add a:add a:add a
        add e
        ld de,cnsbuf
        ld bc,255
        push de
        rst #20:dw jmp_bnkcop
        pop hl
        ret

;### CNSDAT -> Daten eines Prozesses holen
;### Eingabe    A=Prozess
;### Ausgabe    CF=0 -> IX=Daten
;###            CF=1 -> unbekannt
;### Verändert  BC,IY
cnsdat ld iy,(cnsprzanz)
        db #fd:inc l
        db #fd:dec l
        jr z,cnsdat2
        ld ix,cnsprzmem
        ld bc,4
cnsdat1 cp (ix+cnsprznum)
        ret z
        add ix,bc
        db #fd:dec l
        jr nz,cnsdat1
cnsdat2 scf
        ld a,254
        ret

;### CNSHND -> Erstellt Filehandler für einen neuen Prozess
;### Eingabe    HL=Eingabe-File (0=Tastatur), DE=Ausgabe-File (0=Bildschirm), C=Ausgabe-Typ (nur, wenn DE>0; 0=neu, 1=anhängen)
;### Ausgabe    CF=0 -> L=Eingabe-Handler, H=Ausgabe-Handler, CF=1 -> Fehler (A=Fehlercode, 251=zuviele Prozesse)
;### Verändert  BC,DE,IX,IY
cnshndl dw 0
cnshnd  ld a,(cnsprzanz)
        cp cnsprzmax
        scf
        ld a,251
        ret z                   ;kein Prozess-Slot mehr frei
        push hl                 ;*** Ausgabe-Handler holen
        ld a,e
        or d
        sub 1
        ccf
        jp nc,cnshnd2           ;Bildschirm
        ex de,hl
        ld a,(prgbnknum)
        db #dd:ld h,a
        dec c
        jr nz,cnshnd1
        call syscll             ;** bestehende Datei erweitern
        db MSC_SYS_SYSFIL
        db FNC_FIL_FILOPN
        pop hl
        ret c
        push hl
        push af
        ld ix,0
        ld iy,0
        ld c,2
        push af
        call syscll
        db MSC_SYS_SYSFIL
        db FNC_FIL_FILPOI       ;IY,IX=Dateilänge
        pop bc
        jr c,cnshnd8
        ld c,128
        db #fd:ld a,l           ;Test, ob Datei mindestens 128 byte groß ist
        db #fd:or h
        jr nz,cnshnd6
        db #dd:ld a,h
        or a
        jr nz,cnshnd6
        db #dd:ld a,l
        cp c
        jr nc,cnshnd6
        ld c,a                  ;C=min(128,dateilänge)
cnshnd6 ld a,c
        ld (cnshndl),a
        call cnshnd9
        jr c,cnshnd8
        ld a,b
        ld hl,cnsbuf
        ld de,(prgbnknum)
        ld bc,(cnshndl)
        push af
        call syscll
        db MSC_SYS_SYSFIL
        db FNC_FIL_FILINP       ;letzte 128Bytes laden
        pop de
        jr c,cnshnd8
        ld hl,cnsbuf
        ld bc,(cnshndl)
        ld a,26
        cpir
        jr nz,cnshnd8           ;kein EOF gefunden -> alles klar
        inc c
        ld a,c
        ld b,d
        call cnshnd9
        jr cnshnd8
cnshnd9 neg                     ;Zeiger um -A verschieben
        db #dd:ld l,a
        db #dd:ld h,-1
        ld iy,-1
        ld a,b
        ld c,2
        push af
        call syscll
        db MSC_SYS_SYSFIL
        db FNC_FIL_FILPOI
        pop bc
        ret
cnshnd8 pop bc
        jr cnshnd3
cnshnd1 xor a
        call syscll             ;** neue Datei
        db MSC_SYS_SYSFIL
        db FNC_FIL_FILNEW
cnshnd2 ld b,a
cnshnd3 pop hl
        ret c
        push bc                 ;*** Eingabe-Handler holen
        ld a,l
        or h
        sub 1
        ccf
        jr nc,cnshnd4           ;Tastatur
        ld a,(prgbnknum)
        db #dd:ld h,a
        call syscll             ;vorhandene Datei
        db MSC_SYS_SYSFIL
        db FNC_FIL_FILOPN
cnshnd4 pop hl
        jr c,cnshnd5
        ld l,a
        ret
cnshnd5 push af                 ;*** Fehler bei zweiter Datei -> erste schließen
        ld a,h
        call syscll
        db MSC_SYS_SYSFIL
        db FNC_FIL_FILCLO
        pop af
        ret

;### CNSADD -> Fügt Prozess der Konsole hinzu
;### Eingabe    C=Prozess-Nummer, L=Eingabe-Handler, H=Ausgabe-Handler
;### Verändert  AF,DE,HL,IX
cnsadd  push bc
        ex de,hl
        ld hl,cnsprzanz
        ld a,(hl)
        inc (hl)
        add a:add a
        ld c,a
        ld b,0
        ld ix,cnsprzmem
        add ix,bc
        pop bc
        ld (ix+cnsprznum),c
        ld (ix+cnsprzinp),e
        ld (ix+cnsprzout),d
        ret

;### CNSDEL -> Entfernt Prozess aus der Liste
;### Eingabe    A=Prozess-Nummer (>=128 = Shell)
;### Verändert  AF,BC,DE,HL,IX,IY
cnsdel  ld bc,(cnsprzanz)
        inc c
        dec c
        ret z                   ;kein Prozess vorhanden

        ld b,a
        push bc                 ;B=prozess
        ld ix,cnscmdmem
        ld de,cnscmdlen
        ld b,cnscmdmax
cnsdel5 cp (ix+cnscmdprz)
        jr nz,cnsdel6
        ld (ix+cnscmdbnk),-1
cnsdel6 add ix,de
        djnz cnsdel5
cnsdel4 pop bc
        ld a,b

        ld hl,cnsprzmem
        ld de,cnsprzlen
        ld b,c
cnsdel1 cp (hl)                 ;Prozess suchen
        jr z,cnsdel2
        add hl,de
        djnz cnsdel1
        ret
cnsdel2 ld a,c                  ;C=Anzahl, C-B=Position, B=Nachfolgende Elemente+1
        dec a
        ld (cnsprzanz),a
        sub b
        inc a
        add a:add a
        ld l,a
        ld h,0
        ld de,cnsprzmem
        add hl,de               ;HL=zu löschender Prozess
        push hl
        push bc
        inc hl
        inc hl
        push hl
        ld c,0
        call cnsdel3            ;ggf. Dateien schließen
        pop hl
        inc hl
        ld c,1
        call cnsdel3
        pop af
        pop hl
        ld e,l
        ld d,h
        cp 2
        ret c
        dec a
        ld bc,4
        add hl,bc
        add a:add a
        ld c,a
        ld b,0
        ldir
        ret
cnsdel3 ld a,(hl)
        cp -1
        ret z
        ld h,a
        dec c
        jp nz,cnshnd5
        push hl             ;Ausgabe-Datei -> vor dem Schließen noch EOF schreiben
        ld c,h
        ld a,26
        ld hl,cnsoucb
        ld (hl),a
        ld a,c
        ld bc,1
        ld de,(prgbnknum)
        call syscll         ;EOF in Datei schreiben
        db MSC_SYS_SYSFIL
        db FNC_FIL_FILOUT
        pop hl
        jp cnshnd5


;==============================================================================
;### DIALOG-ROUTINEN ##########################################################
;==============================================================================

diaopn  ld c,MSC_DSK_WINOPN     ;Fenster aufbauen
        ld a,(prgbnknum)
        ld b,a
        call msgsnd
diaopn1 call msgdsk             ;Message holen -> IXL=Status, IXH=Absender-Prozeß
        cp MSR_DSK_WOPNER
        ret z                   ;kein Speicher für Fenster -> dann halt nicht
        cp MSR_DSK_WOPNOK
        jr nz,diaopn1           ;andere Message als "Fenster geöffnet" -> ignorieren
        ld a,(prgmsgb+4)
        ld (diawin),a           ;Fenster wurde geöffnet -> Nummer merken
        inc a
        ld (prgwindat+windatsup),a
        jp prgprz0

diacnc  call diaclo             ;*** CANCEL
        jp prgprz0

diaclo  ld c,MSC_DSK_WINCLS     ;Dialog-Fenster schliessen
        ld a,(diawin)
        ld b,a
        jp msgsnd


;==============================================================================
;### COMMAND-ROUTINEN #########################################################
;==============================================================================

cmdhlptxt
db "SymShell standard command overview",13,10,0
db "  For more information about a specific command, type:",13,10,0
db "  HELP command name",13,10,0
db "ATTRIB   Displays/sets file attributes.",13,10,0
db "CD       Changes the directory or displays its name.",13,10,0
db "CLS      Clears the screen.",13,10,0
db "CMD      Starts a new shell instance.",13,10,0
db "COLOR    Changes the pen, paper and border colour.",13,10,0
db "COPY     Copies one or more files to a new destination.",13,10,0
db "DATE     Displays/sets the current date.",13,10,0
db "DEL      Deletes one of more files.",13,10,0
db "DIR      Displays the content of a directory.",13,10,0
db "ECHO     Displays a message.",13,10,0
db "EXIT     Quits the current instance of the shell.",13,10,0
db "FULL     Switches between window and fullscreen mode.",13,10,0
db "HELP     Displays command overview or specific information.",13,10,0
db "MD       Creates a new directory.",13,10,0
db "MOVE     Moves files and directories to another directory.",13,10,0
db "PAUSE    Stopps executing a batch and waits for a keypress.",13,10,0
db "RD       Deletes a directory.",13,10,0
db "REM      Starts a comment in a batch file.",13,10,0
db "REN      Renames a directory or one or more files.",13,10,0
db "SIZE     Changes the size of the terminal window.",13,10,0
db "TIME     Displays/sets the current time.",13,10,0
db "TYPE     Displays the content of one or more files.",13,10,0
db "VER      Displays the SymbOS version.",13,10,0
db 0

cmdprztab
db "cls",0,"     ":dw cmdcls    ;Bildschirm
db "echo",0,"    ":dw cmdech
db "rem",0,"     ":dw cmdrem
db "ver",0,"     ":dw cmdver
db "pause",0,"   ":dw cmdpau
db "type",0,"    ":dw cmdtyp
db "cat",0,"     ":dw cmdtyp
db "cd",0,"      ":dw cmdchd    ;Verzeichnisse und Dateien
db "chdir",0,"   ":dw cmdchd
db "cd..",0,"    ":dw cmdcdd
db "dir",0,"     ":dw cmddir
db "ls",0,"      ":dw cmddir
db "md",0,"      ":dw cmdmkd
db "mkdir",0,"   ":dw cmdmkd
db "rd",0,"      ":dw cmdrmd
db "rmdir",0,"   ":dw cmdrmd
db "ren",0,"     ":dw cmdren
db "rename",0,"  ":dw cmdren
db "move",0,"    ":dw cmdmov
db "mv",0,"      ":dw cmdmov
db "copy",0,"    ":dw cmdcop
db "cp",0,"      ":dw cmdcop
db "del",0,"     ":dw cmddel
db "erase",0,"   ":dw cmddel
db "rm",0,"      ":dw cmddel
db "attrib",0,"  ":dw cmdatr
db "chattr",0,"  ":dw cmdatr
db "exit",0,"    ":dw cmdexi    ;Shell
db "cmd",0,"     ":dw cmdcmd
db "command",0," ":dw cmdcmd
db "help",0,"    ":dw cmdhlp
db "man",0,"     ":dw cmdhlp
db "color",0,"   ":dw cmdcol    ;Konfig
db "colour",0,"  ":dw cmdcol
db "size",0,"    ":dw cmdsiz
db "full",0,"    ":dw cmdful
db "time",0,"    ":dw cmdtim
db "date",0,"    ":dw cmddat
db 0

;### CMDPRZ -> Verarbeitet Kommando
;### Eingabe    (shlinplin)=String
;### Ausgabe    CF=0 Shell bleibt aktiv
;###            CF=1 Shell ist inaktiv (ZF=0 -> wegen Programmstart oder Unterbrechung; ZF=1 -> Shell soll beendet werden) 
cmdwai      db 0        ;Flag, ob im Keywait-Mode
cmdprzep    dw 0
cmdprzec    db ".com"
cmdprzee    db ".exe"
cmdprzeb    db ".bat",0
cmdprzflg   db 0        ;0=Shell bleibt aktiv, 1=Shell soll beendet werden, 2=Shell ist inaktiv, 3=neue Shell soll gestartet werden
cmdprzcmd   dw 0        ;zeiger auf command-schreibweise

cmdprz  xor a
        ld (cmdredf),a
cmdprzq xor a
        ld (cmdprzflg),a
        ld hl,shlinplin
        call clclen
        ld a,c
        ld (shlinplen),a
        or a
        ret z                   ;*** Leer-Eingabe
        cp 2
        jr nz,cmdprz6
        ld hl,(shlinplin)       ;*** Laufwerk-Wechsel
        ld a,h
        cp ":"
        jr nz,cmdprz6
        ld a,l
        call clcucs
        cp "A"
        jr c,cmdprz6
        cp "Z"+1
        jr nc,cmdprz6
        ld l,a
        ld (shlpthnew+0),hl
        xor a
        ld (shlpthnew+2),a
        ld hl,shlpthnew
        call direxi
        ld b,a
        jp c,cmdprzi
        ld hl,shlpthnew
        ld de,shlpth
        ld bc,256
        ldir
        jp cmdprz0
cmdprz6 call cmdred             ;*** Redirections und Hintergrund-Startmarkierung suchen
        ld hl,cmdprztab         ;*** Shell-Commando
cmdprz1 ld (cmdprzcmd),hl
        ld a,(hl)
        or a
        jr z,cmdprz5
        ld de,shlinplin
        push hl
cmdprz2 ld a,(de)
        call clclcs
        cp " "
        jr nz,cmdprz3
        xor a
cmdprz3 ld c,a
        ld a,(hl)
        or a
        jr nz,cmdprzm
        xor a
cmdprzm call clclcs
        cp c
        jr nz,cmdprz4
        inc hl
        inc de
        or a
        jr nz,cmdprz2
        pop hl
        ld a,(de)
        cp "%"
        jr nz,cmdprzv
        inc de
        ld a,(de)
        cp "?"
        jr nz,cmdprzv
        ld hl,cmdflgbit
        set 0,(hl)
        ld hl,(cmdprzcmd)
        ld (cmdpartab+0),hl
        ld hl,cmdhlpc
        jr cmdprzu
cmdprzv ld de,9
        add hl,de
        ld a,(hl)
        inc hl
        ld h,(hl)
        ld l,a                  ;HL=commando-routine
cmdprzu ld a,(cmdredf)
        or a
        ld bc,cmdprz0
        jr z,cmdprzj
        push hl
        ld hl,(cmdredi)
        ld de,(cmdredo)
        ld a,(cmdredt)
        ld c,a
        ld b,0
        call shlnew
        pop hl
        ld bc,cmdprzz
        jr nc,cmdprzj
        call cmderr
        jp cmdprz0
cmdprzj push bc
        jp (hl)
cmdprz4 pop hl
        ld de,9+2
        add hl,de
        jr cmdprz1
cmdprz5 ld hl,shlinplin         ;*** File laden
        ld bc,"."*256+" "
cmdprz7 ld a,(hl)               ;Extension suchen und ggf. ergänzen
        or a
        jp z,cmdprz8
        cp c
        jr z,cmdprz8
        cp b
        jr z,cmdprz9
        inc hl
        jr cmdprz7
cmdprz9 push hl                 ;Extension angegeben
        pop ix
        ld a,(ix+1):call clclcs:cp "b":jp nz,cmdprzn
        ld a,(ix+2):call clclcs:cp "a":jr nz,cmdprzn
        ld a,(ix+3):call clclcs:cp "t":jr nz,cmdprzn
        ld a,(ix+4):            or a:  jr nz,cmdprzn
cmdprzd call cmdpar             ;*** BAT-File
        ld hl,shlinplin
        ld de,shlpthnew
        push de
        call diradd
        pop hl
        ld de,(cmdredo)
        ld bc,0
        jp cmdprzo
cmdprzn ld a,(ix+1):call clclcs:cp "c":jp nz,cmdprzb
        ld a,(ix+2):call clclcs:cp "o":jp nz,cmdprzb
        ld a,(ix+3):call clclcs:cp "m":jp nz,cmdprzb
        ld a,128+64
        ld (dirrun0+1),a
        ld a,(ix+4)
        or a
        jr z,cmdprza
        cp " "
        jr z,cmdprza
        ld a,128
        ld (dirrun0+1),a
        jr cmdprzb
cmdprz8 ld (cmdprzep),hl        ;keine Extension angegeben -> eventuell EXE, COM oder BAT gemeint
        push hl
        ex de,hl
        ld hl,shlinplin+255-4
        push hl
        or a
        sbc hl,de
        ld c,l
        ld b,h
        inc bc
        pop hl
        ld de,shlinplin+255
        lddr                    ;Platz für Extension einfügen
        pop de

        ld hl,cmdprzec          ;### 1.VERSUCH -> COM im aktuellen Pfad starten
        ld bc,4
        ldir
        ld a,128+64
        ld (dirrun0+1),a
cmdprza call dirfil
        ld a,(prgcodbeg+prgpstprz)  ;Prozessnummer, Breite, Höhe, Version als "%spPPXXYYVV" ("Shell Parameter") anhängen
        call clcdez
        ld (shlmsgprt+4),hl
        ld a,(scrxln)
        call clcdez
        ld (shlmsgprt+6),hl
        ld a,(scryln)
        call clcdez
        ld (shlmsgprt+8),hl
        ld hl,shvs_min*256+shvs_maj ;SymShell version
        ld (shlmsgprt+10),hl
        call cmdprzw            ;anhängen und startversuch
        jp nc,cmdprzh
        ld b,l
        cp 2
        jp nc,cmdprzg           ;gefunden, aber anderer Fehler

        ld hl,iniverpth         ;### 2.VERSUCH -> COM im Systempfad starten
        ld (diradd+1),hl
        call dirfil
        ld hl,shlpth
        ld (diradd+1),hl
        ld a,128+64
        ld (dirrun0+1),a
        call cmdprzw            ;anhängen und startversuch
        jp nc,cmdprzh
        ld b,l
        cp 2
        jr nc,cmdprzg           ;gefunden, aber anderer Fehler

        ld de,(cmdprzep)        ;### 3.VERSUCH -> EXE im aktuellen Pfad starten
        ld hl,cmdprzee
        ld bc,4
        ldir
cmdprzb call dirfil             ;shlpthnew=voller Applications Pfad
        call dirrun
        jr nc,cmdprz0
        ld b,l
        cp 2
        jr nc,cmdprzg

        ld de,(cmdprzep)        ;### 4.VERSUCH -> BAT im aktuellen Pfad suchen
        ld hl,cmdprzeb
        ld bc,4
        ldir
        ld a,(de)
        push de
        push af
        xor a
        ld (de),a
        call dirfil
        ld hl,shlpthnew
        ld a,(prgbnknum)
        db #dd:ld h,a
        call syscll
        db MSC_SYS_SYSFIL
        db FNC_FIL_FILOPN
        pop bc
        pop hl
        jr c,cmdprzc
        push hl
        push bc
        call syscll
        db MSC_SYS_SYSFIL
        db FNC_FIL_FILCLO
        pop bc
        pop hl
        ld (hl),b
        jp cmdprzd
cmdprzc cp stoerrxfi
        ld b,a
        jr nz,cmdprzi

        ld hl,(cmdprzep)        ;Commando wurde nicht gefunden
        ld (hl),0
        ld hl,shlmsgnf1
        call shlout
        ld hl,shlinplin
        call shlout
        ld hl,shlmsgnf2
cmdprzy call shlout
cmdprz0 ld hl,shlinpret         ;Rückkehr zur Shell nach Commando-Abarbeitung ohne Redirection
        call shlout
        ld a,(cmdprzflg)
        cp 3
        jr z,cmdprzk
        or a
        ret z
        dec a
        scf
        ret
cmdprzg ld hl,shlmsgexe
        jr z,cmdprzy            ;kein Executable
        cp 4
        ld hl,shlmsgmem
        jr z,cmdprzy            ;Speicher voll
        jr nc,cmdprz0
cmdprzi ld a,b                  ;Fehler beim Laden
        scf
        call cmderr
        jr cmdprz0

cmdprzz ld a,(cmdprzflg)        ;Rückkehr zur Shell nach Commando-Abarbeitung mit Redirection
        cp 3
        jr z,cmdprzl
        call shldwn0
        jr cmdprz0
cmdprzk ld hl,0                 ;neue Shell starten
        ld de,0
        ld bc,256
cmdprzo call shlnew
        call cmderr
        xor a
        ret
cmdprzl call shlnew1            ;in neuer Shell bleiben
        xor a
        ret
cmdprzh push hl                 ;*** COM wurde erfolgreich geladen
        ld hl,(cmdredi)         ;Handler anlegen
        ld de,(cmdredo)
        ld a,(cmdredt)
        ld c,a
        call cnshnd
        pop de                  ;D=Prozessnummer
        jr nc,cmdprzr
        push af                 ;Fehler beim Handler-Anlegen
        ld a,d
        call prgend3
        pop af
        jr cmdprz0
cmdprzr ld c,d                  ;Prozess anlegen
        call cnsadd
        ld a,(cmdredb)
        cp 1                    ;CF=0 Shell bleibt aktiv
        ret z
        inc a
        cp 2                    ;CF=1 Shell ist inaktiv, ZF=0 wegen Programmstart
        ret
;parameter anhängen und starten
cmdprzw ld hl,shlpthnew
        call clclen             ;HL=Stringende (0), BC=Länge (maximal 255)
        ex de,hl
        ld hl,shlmsgprt
        ld bc,13
        ldir
        jp dirrun

;### CMDFLG -> Flags verarbeiten
;### Eingabe    cmdflgtab=flag daten, E=Anzahl, IY=zugelassene flags (2byte adresse [0 oder DOPPELPUNKT terminiert], 2byte zeiger nach doppeltpunkt, falls solcher vorhanden)
;### Ausgabe    CF=0 -> HL,(cmdflgbit)=flags (0-15)
;###            CF=1 -> "invalid switch", HL=switch
;### Verändert  ??
cmdflgbit   dw 0            ;vorhandene flags
cmdflg  ld hl,0
        ld (cmdflgbit),hl
        ld a,e
        or a
        ret z
        ld b,e              ;b=anzahl vorhandene flags
        ld (cmdflg1+2),iy
        ld ix,cmdflgtab
cmdflg1 ld iy,0         ;** vorhandene durchgehen
        ld c,0              ;iy=liste möglicher flags, c=nummer mögliches flag
cmdflg2 ld l,(iy+0)     ;** mögliche durchgehen, hl=nächstes mögliche flag
        ld h,(iy+1)
        ld e,(ix+0)         ;de=nächstes vorhandene flag
        ld d,(ix+1)
        ld a,l
        or h
        jr nz,cmdflg3
        dec de              ;ENDE -> alle möglichen flags durchgelaufen -> "invalid switch"
        ex de,hl
        scf
        ret
cmdflg3 ld a,(de)           ;flags vergleichen
        call clclcs
        cp (hl)
        jr nz,cmdflg7       ;stimmt nicht, nächstes mögliche prüfen
        inc hl
        inc de
        or a
        jr z,cmdflg4
        cp ":"
        jr nz,cmdflg3
        ld (iy+2),e         ;flag mit doppelpunkt gefunden -> zeiger auf parameter setzen
        ld (iy+3),d
cmdflg4 ld hl,1             ;flag gefunden -> bit setzen
        inc c
cmdflg5 dec c
        jr z,cmdflg6
        add hl,hl
        jr cmdflg5
cmdflg6 ld de,(cmdflgbit)
        add hl,de
        ld (cmdflgbit),hl
        ld de,3
        add ix,de
        djnz cmdflg1
        ret                 ;ENDE -> alle vorhandenen flags erkannt, cf=0 wegen letztem add, hl enthält bereits flags
cmdflg7 ld de,4             ;nächstes mögliche prüfen
        add iy,de
        inc c
        jr cmdflg2

;### CMDKEY -> Wartet auf einfachen Tastendruck direkt von der Konsole (Redirections werden ignoriert)
cmdkey  ld a,1
        ld (cmdwai),a
        call prgprz0
        xor a
        ld (cmdwai),a
        ret

;### CMDRED -> Ermittelt Redirection und Hintergrundstart Angaben bei Commando
;### Ausgabe    (cmdredf)=Flag, ob Redirection angegeben, (cmdredi)=Input, (cmdredo)=Output, (cmdredt)=Ausgabe-Typ (0=neu, 1=anhängen)
;### Verändert  AF,BC,DE,HL,IX
cmdredf db 0    ;Flag, ob Redirection angegeben
cmdredi dw 0    ;Eingabe
cmdredo dw 0    ;Ausgabe
cmdredb db 0    ;Flag, ob sofort zur Shell zurückkehren
cmdredt db 0    ;Ausgabe-Typ

mftbuf  ;** the following 512byte buffer is used for MFT-relocation as well during init phase **
cmdredis ds 256
cmdredos ds 256
        ;**

cmdred  ld hl,0
        ld (cmdredi),hl
        ld (cmdredo),hl
        ld (cmdredb),hl
        ld hl,shlinplin
cmdred1 ld a,(hl)
        ld c,l
        ld b,h
        inc hl
        or a
        jr z,cmdred5
        cp " "
        jr nz,cmdred1
cmdred7 ld a,(hl)
        cp "&"          ;Hintergrund-Start
        jr nz,cmdred8
        xor a
        ld (bc),a
        inc a
        ld (cmdredb),a
        inc hl
        jr cmdred3
cmdred8 cp "<"          ;Input
        ld de,cmdredi
        jr z,cmdred2
        cp ">"          ;Ouput
        jr nz,cmdred1
        inc hl
        ld a,(hl)
        cp ">"          ;Output anhängen
        ld a,1
        jr z,cmdred4
        dec hl
        dec a
cmdred4 ld (cmdredt),a
        ld de,cmdredo
cmdred2 xor a
        ld (bc),a
        inc hl          ;Redirection gefunden
        ex de,hl
        ld (hl),e
        inc hl
        ld (hl),d
        ex de,hl
        ld a,1
        ld (cmdredf),a
cmdred3 ld a,(hl)       ;Stringende suchen und 0 anhängen
        inc hl
        or a
        jr z,cmdred5
        cp " "
        jr nz,cmdred3
        dec hl
        ld (hl),0
        inc hl
        jr cmdred7
cmdred5 ld hl,cmdredi   ;Ende -> Pfade erweitern, falls vorhanden
        ld de,cmdredis
        call cmdred6
        ld hl,cmdredo
        ld de,cmdredos
cmdred6 push hl         ;Pfad erweitern und Zeiger updaten
        pop ix
        ld a,(hl)
        inc hl
        ld h,(hl)
        ld l,a
        or h
        ret z
        ld (ix+0),e
        ld (ix+1),d
        jp diradd

;### CMDERR -> Gibt Fehlermeldung aus
;### Eingabe    A=Code
cmderr  ret nc
        call cnserr0
        call shlout
        ld hl,shlinpret0
        jp shlout

;### CMDPAR -> Erstellt Parameter-Liste aus Eingabe-String
;### Eingabe    (shlinplin)=String
;### Ausgabe    (cmdpartab)=Parameter-Liste, (cmdflgtab)=Flag-Liste (Byte0/1=Zeiger, Byte2=Len),
;###            D=Anzahl Parameter, E=Anzahl Flags, ZF=1 -> keine Parameter
            db 0
cmdpartab   ds 8*3
cmdflgtab   ds 8*3

cmdpar  ld hl,shlinplin     ;HL=Eingabe
        ld ix,cmdpartab     ;IX=Parameter Liste
        ld iy,cmdflgtab     ;IX=Flag      Liste
        ld bc,8*256+8       ;B=8-Anzahl Parameter, C=8-Anzahl Flags
cmdpar1 push bc
        call cmdpar2
        pop bc
        jr z,cmdpar7
        ld a,(hl)
        cp "%"
        jr z,cmdpar6
        ld (ix+0),l         ;Parameter
        ld (ix+1),h
        push hl
        call cmdpar4
        pop hl
        ld (ix+2),e
        ld de,3
        add ix,de
        dec b
        jr nz,cmdpar1
        jr cmdpar7
cmdpar6 inc hl              ;Flag
        ld (iy+0),l
        ld (iy+1),h
        push hl
        call cmdpar4
        pop hl
        ld (iy+2),e
        ld de,3
        add iy,de
        dec c
        jr nz,cmdpar1
cmdpar7 ld a,8
        sub c
        ld e,a
        ld a,8
        sub b
        ld d,a
        or e
        ret
;HL=Position im String -> zum nächsten String springen -> HL=Nächster String, ZF=1 Ende erreicht
cmdpar2 ld a,(hl)
        inc hl
        or a
        ret z
        cp " "
        jr nz,cmdpar2
        dec hl
        ld (hl),0
cmdpar3 inc hl
        ld a,(hl)
        cp " "
        jr z,cmdpar3
        or a
        ret
;HL=Position im String -> E=Länge bis Ende
cmdpar4 ld e,0
cmdpar5 ld a,(hl)
        or a
        ret z
        cp " "
        ret z
        inc e
        inc hl
        jr cmdpar5

;### CMDCHK -> Prüft, ob richtige Zahl Parameter übergeben wurde
;### Eingabe    A=Anzahl
;### Ausgabe    CF=0 ok (HL=erster Parameter pfad-erweitert), CF=1 Syntax Error
cmdchk  push af
        call cmdpar     ;(cmdpartab)=Parameter-Liste, (cmdflgtab)=Flag-Liste, D=AnzParameter, E=AnzFlags
        pop af
cmdchk0 cp d
        jr nz,cmdchk1
        ld a,e
        or a
        jr nz,cmdchk1
cmdchk2 ld hl,(cmdpartab+0)
        ld de,shlpthnew
        push de
        call diradd
        pop hl
        or a
        ret
cmdchk1 ld hl,shlmsgsyn     ;"syntax error"
        call shlout
        scf
        ret
cmdchk3 push hl             ;"invalid switch"
        ld hl,shlmsgisw
        call shlout
        pop hl
        call shlout
        ld hl,shlinpret0
        call shlout
        scf
        ret

;### CMDMOR -> Wartet nach einer Bildschirmseite auf Tastendruck
cmdmor  ld hl,dirlincnt
        dec (hl)
        ret nz
        ld a,(scryln)
        dec a
        ld (hl),a
        jp cmdpau

;### "CLS" -> Löscht den Bildschirm
cmdcls  ld a,12
        jp shlchr

;### "EXIT" -> Beendet die Shell
cmdexi  ld a,1
        ld (cmdprzflg),a
        ret

;### "CMD" -> Startet neue Shell
cmdcmd  ld a,3
        ld (cmdprzflg),a
        ret

;### "ECHO" -> Gibt Parameter als Text aus
cmdech0 db "ECHO is deactivated (OFF)",13,10,0
cmdech1 db "ECHO is activated (ON)",13,10,0
cmdechf db 1
cmdech  ld a,(shlinplen)
        cp 4
        jr z,cmdech2
        ld c,a
        ld ix,shlinplin
        ld a,(ix+5):call clclcs:cp "o":jr nz,cmdech5
        ld a,(ix+6):call clclcs:cp "f":jr nz,cmdech5
        ld a,(ix+7):call clclcs:cp "f":jr nz,cmdech5
        ld a,(ix+8):            or a  :jr nz,cmdech5
        xor a
        jr cmdech6
cmdech5 ld a,(ix+6):call clclcs:cp "n":jr nz,cmdech4
        ld a,(ix+7):            or a  :jr nz,cmdech4
        ld a,1
cmdech6 ld (cmdechf),a
        ret
cmdech4 ld a,c
        cp 6
        ld hl,shlinplin+5
        call nc,shlout
        ld hl,shlinpret
        jp shlout
cmdech2 ld a,(cmdechf)
        or a
        ld hl,cmdech0
        jr z,cmdech3
        ld hl,cmdech1
cmdech3 jp shlout

;### "VER" -> Betriebssystem-Version ausgeben
cmdver  ld hl,shlmsgini1
        call shlout
        ld hl,shlmsgver
        call shlout
        ld hl,shlmsgini2
        jp shlout

;### "REM" -> Kommentar ignorieren
cmdrem  ret

;### "PAUSE" -> Auf Tastatur-Eingabe warten
cmdpau  ld hl,shlmsgpau
        call shlout
        call cmdkey
        ld hl,shlinpret
        jp shlout

;### "TYPE" -> Datei anzeigen
cmdtypflt   dw cmddirfl0,0
            dw cmddirfl1,0
            dw cmddirfl2,0
            dw 0

cmdtyp  call mulpre
        ret c
        push de
        ld iy,cmdtypflt
        call cmdflg
        pop de
        jp c,cmdchk3
        dec d
        jp nz,cmdchk1
        ld hl,mulpretsr         ;quelle darf kein pfad sein
        bit 0,(hl)
        ld a,stoerrnfi
        scf
        jp nz,cmderr
        bit 1,(hl)
        ld hl,shlpthnew
        jr z,cmdtyp0            ;nur eine datei anzeigen
        xor a                   ;keine directories typen
        call muldir
        jp c,cmderr
cmdtyp4 call mulsrc             ;type schleife
        ret c
        push hl
        ld hl,shlinpret
        call shlout
        call mulplt
        ld hl,shlinpret
        call shlout
        pop hl
        call cmdtyp0
        jr nc,cmdtyp4
        ret
;hl=dateipfad -> file typen
cmdtyp0 ld a,(scryln)
        dec a
        ld (dirlincnt),a
        ld a,(prgbnknum)
        db #dd:ld h,a
        call syscll
        db MSC_SYS_SYSFIL
        db FNC_FIL_FILOPN
        jp c,cmderr
cmdtyp1 ld hl,shlpthnew2
        ld de,(prgbnknum)
        push af
        call syscll
        db MSC_SYS_SYSFIL
        db FNC_FIL_FILLIN
        pop de
        jr c,cmdtyp3
        jr z,cmdtyp3
        push de
        push bc
        ld hl,shlpthnew2
        call shlout
        pop bc
        dec b
        jr nz,cmdtyp2
        ld hl,shlinpret
        call shlout
cmdtyp2 pop af
        ld hl,cmdflgbit
        bit 2,(hl)
        call nz,cmdmor
        jr cmdtyp1
cmdtyp3 push af
        ld a,d
        call syscll
        db MSC_SYS_SYSFIL
        db FNC_FIL_FILCLO
        pop af
        push af
        call cmderr
        pop af
        ret

;### "DEL" -> Datei löschen
cmddelerr   db "File not found",13,10,0
cmddel  ld hl,FNC_FIL_DIRDEL*256+1
        call cmdmkd1
        jp c,cmderr
        ret nz
        ld hl,cmddelerr
        jp shlout

;### "RD" -> Verzeichnis löschen
cmdrmd  ld hl,FNC_FIL_DIRRMD*256+1
        jr cmdmkd0

;### "MD" -> Verzeichnis erstellen
cmdmkd  ld hl,FNC_FIL_DIRNEW*256+1
cmdmkd0 call cmdmkd1
        jp cmderr
cmdmkd1 ld a,l
        ld l,MSC_SYS_SYSFIL
        ld (cmdmkd2),hl
        call cmdchk
        ret c
        ld de,(cmdpartab+3)
cmdmkd3 ld a,(prgbnknum)
        db #dd:ld h,a
        call syscll
cmdmkd2 dw 0
        ret

;### "ATTRIB" -> Datei(en) Attribute ändern
cmdatrflt   dw cmddirfl0,0
            dw cmddirfl1,0
            dw cmdatrfl2,0
            dw cmdatrfl3,0
            dw cmdatrfl4,0
            dw cmdatrfl5,0
            dw cmdatrfl6,0
            dw cmdatrfl7,0
            dw cmdatrfl8,0
            dw cmdatrfl9,0
            dw 0
cmdatrfl2   db "+r",0   ;read only ON
cmdatrfl3   db "-r",0   ;read only OFF
cmdatrfl4   db "+h",0   ;hidden    ON
cmdatrfl5   db "-h",0   ;hidden    OFF
cmdatrfl6   db "+s",0   ;system    ON
cmdatrfl7   db "-s",0   ;system    OFF
cmdatrfl8   db "+a",0   ;archive   ON
cmdatrfl9   db "-a",0   ;archive   OFF

cmdatrtxt   db "RHSVDA"
cmdatrout   db "RHSVDA  ",0

cmdatr  call mulpre
        ret c
        push de
        ld iy,cmdatrflt
        call cmdflg
        pop de
        jp c,cmdchk3
        dec d
        jp nz,cmdchk1
        ld a,1
        call muldir
        jp c,cmderr
cmdatr1 call mulsrc             ;attrib schleife
        ret c
        ld a,(prgbnknum)
        db #dd:ld h,a
        xor a
        push hl
        push ix
        call syscll
        db MSC_SYS_SYSFIL
        db FNC_FIL_DIRPRR
        pop ix
        pop hl
        jp c,cmderr
        ld de,(cmdflgbit)
        ld a,e
        and #fc
        or d
        jr nz,cmdatr2
        ld hl,cmdatrtxt             ;* nur anzeigen
        ld de,cmdatrout
        ld b,6
cmdatr3 ld a," "
        rr c
        jr nc,cmdatr4
        ld a,(hl)
cmdatr4 ld (de),a
        inc hl
        inc de
        djnz cmdatr3
        ld hl,cmdatrout
        call shlout
        ld hl,(mulprensr)
        call shlout
        ld hl,shlinpret
        call shlout
        jr cmdatr1
cmdatr2 bit 2,e:jr z,$+4:set 0,c    ;* ändern
        bit 3,e:jr z,$+4:res 0,c
        bit 4,e:jr z,$+4:set 1,c
        bit 5,e:jr z,$+4:res 1,c
        bit 6,e:jr z,$+4:set 2,c
        bit 7,e:jr z,$+4:res 2,c
        bit 0,d:jr z,$+4:set 5,c
        bit 1,d:jr z,$+4:res 5,c
        res 3,c
        res 4,c
        xor a
        call syscll
        db MSC_SYS_SYSFIL
        db FNC_FIL_DIRPRS
        jp c,cmderr
        jp cmdatr1

;### "REN" -> Datei(en) umbenennen
cmdren  call mulpre
        ret c
        push de
        ld iy,cmdcopflt
        call cmdflg
        pop de
        jp c,cmdchk3
        ld a,d
        cp 2
        jp nz,cmdchk1
        ld a,(mulpretsr)        ;quelle darf kein pfad sein
        bit 0,a
        ld a,stoerrnam
        scf
        jp nz,cmderr
        ld a,1
        call muldir
        jp c,cmderr
cmdren1 call mulsrc             ;ren schleife
        ret c
        push hl
        call muldst
        pop hl
        ld de,(mulprends)
        ld a,(prgbnknum)
        db #dd:ld h,a
        call syscll
        db MSC_SYS_SYSFIL
        db FNC_FIL_DIRREN
        jp c,cmderr
        jr cmdren1

;### "MOVE" -> Datei(en) verschieben
cmdmovres   db " ########### file(s) moved",13,10,0

cmdmov  call mulpre
        ret c
        push de
        ld iy,cmdcopflt
        call cmdflg
        pop de
        jp c,cmdchk3
        ld a,(mulpretds)        ;ziel muß pfad sein
        cp 1
        ld a,stoerrndi
        scf
        jp nz,cmderr
        ld a,1
        call muldir
        jp c,cmderr
cmdmov1 call mulsrc             ;move schleife
        jp c,cmdmov2
        push hl
        call mulplt
        pop hl
        ld de,shlpthnew2
        ld a,(prgbnknum)
        db #dd:ld h,a
        call syscll
        db MSC_SYS_SYSFIL
        db FNC_FIL_DIRMOV
        jp c,cmderr
        ld hl,(muldirtot)
        inc hl
        ld (muldirtot),hl
        jr cmdmov1
cmdmov2 ld hl,cmdmovres
        jp mulres

;### "COPY" -> Datei(en) kopieren
cmdcophsr   db 0        ;Source-Handler
cmdcophds   db 0        ;Destination-Handler
cmdcopres   db " ########### file(s) copied",13,10,0

cmdcopflt   dw cmddirfl0,0  ;wird auch von cmdmov,cmdren benutzt
            dw cmddirfl1,0
            dw 0

cmdcop  call mulpre         ;pfade vorbereiten
        ret c
        push de
        ld iy,cmdcopflt
        call cmdflg
        pop de
        jp c,cmdchk3
        ld bc,62*1024       ;kopier-speicher reservieren
        call cmdcopm        ;62K versuchen
        jr nc,cmdcop4
        ld bc,16*1024
        call cmdcopm        ;16K versuchen
        jr nc,cmdcop4
        ld bc,04*1024
        call cmdcopm        ; 4K versuchen
        jr nc,cmdcop4
        ld a,250
        jp cmderr           ;keine speicher frei -> error
cmdcop4 ld (0*5+prgmemtab+0),a
        ld (0*5+prgmemtab+1),hl
        ld (0*5+prgmemtab+3),bc
        ld a,(mulpretsr)
        or a
        jr z,cmdcop2
        xor a
        call muldir
        jp c,cmdcopn
        ld a,(mulpretds)
        or a
        jr nz,cmdcop1
        call muldst             ;** sonderfall -> mehrere files in ein zielfile kopieren
        ld a,(prgbnknum)
        db #dd:ld h,a
        xor a
        call syscll
        db MSC_SYS_SYSFIL
        db FNC_FIL_FILNEW
        jr c,cmdcopn        ;error -> abbruch
        ld (cmdcophds),a    ;ziel-handler merken
cmdcopd call mulsrc
        call c,cmdcopg
        jr c,cmdcop3        ;fertig
        push hl
        call mulplt
        pop hl
        push hl
        ld de,shlpthnew2
        call cmdcopc
        pop hl
        jr c,cmdcope        ;error -> ziel schließen, abbruch
        ld a,(prgbnknum)
        db #dd:ld h,a
        call syscll
        db MSC_SYS_SYSFIL
        db FNC_FIL_FILOPN
        jr c,cmdcope        ;error -> ziel schließen, abbruch
        ld (cmdcophsr),a    ;quell-handler merken
        call cmdcop5        ;daten in zieldatei kopieren
        call c,cmdcopa
        jr c,cmdcopn
        call cmdcopb
        ld hl,(muldirtot)
        inc hl
        ld (muldirtot),hl
        jr cmdcopd
cmdcope call cmdcopg
        jr cmdcopn
cmdcop1 call mulsrc             ;** mehrere files 1-1 kopieren
        jr c,cmdcop3
        push hl
        call mulplt
        call muldst
        ex de,hl
        pop hl
        call cmdcop0        ;hl=source, de=destination -> ein file kopieren
        jr c,cmdcopn
        ld hl,(muldirtot)
        inc hl
        ld (muldirtot),hl
        jr cmdcop1
cmdcop2 call mulplt             ;** sonderfall -> genau ein file kopieren
        call muldst
        ex de,hl
        ld hl,shlpthnew
        call cmdcop0
        jp c,cmdcopn
        ld hl,1
        ld (muldirtot),hl
cmdcop3 ld hl,cmdcopres         ;** ergebnis zeigen
        call mulres
;speicher freigeben
cmdcopn push af
        ld a,(0*5+prgmemtab+0)
        ld hl,(0*5+prgmemtab+1)
        ld bc,(0*5+prgmemtab+3)
        rst #20:dw jmp_memfre
        xor a
        ld (0*5+prgmemtab+0),a
        ld l,a:ld h,a
        ld (0*5+prgmemtab+3),hl
        pop af
        jp cmderr
;speicher reservieren
cmdcopm push bc
        xor a
        ld e,a
        rst #20:dw jmp_memget
        pop bc
        ret
;hl,de vergleichen -> cf=1 gleich, A=error code
cmdcopc ld a,(de)
        call clclcs
        ld c,a
        ld a,(hl)
        call clclcs
        cp c
        scf
        ccf
        ret nz
        or a
        scf
        ld a,stoerrdbl
        ret z
        inc de
        inc hl
        jr cmdcopc
;hl=source, de=destination -> ein file kopieren
cmdcop0 push de
        push hl
        call cmdcopc
        pop hl
        pop de
        ret c
        push de
        ld a,(prgbnknum)
        db #dd:ld h,a
        call syscll
        db MSC_SYS_SYSFIL
        db FNC_FIL_FILOPN
        pop hl
        ret c               ;error -> abbruch
        ld (cmdcophsr),a    ;quell-handler merken
        ld a,(prgbnknum)
        db #dd:ld h,a
        xor a
        call syscll
        db MSC_SYS_SYSFIL
        db FNC_FIL_FILNEW
        jr c,cmdcopb        ;error -> quell-handler schließen, abbruch
        ld (cmdcophds),a    ;ziel-handler merken
        call cmdcop5
;beide handler schließen
cmdcopa call cmdcopg
cmdcopb push af
        ld a,(cmdcophsr)
        call syscll
        db MSC_SYS_SYSFIL
        db FNC_FIL_FILCLO
        pop af
        ret
cmdcopg push af
        ld a,(cmdcophds)
        call syscll
        db MSC_SYS_SYSFIL
        db FNC_FIL_FILCLO
        pop af
        ret
;kopiervorgang
cmdcop5 ld a,(0*5+prgmemtab+0)  ;Source lesen
        ld e,a
        ld hl,(0*5+prgmemtab+1)
        ld bc,(0*5+prgmemtab+3)
        ld a,(cmdcophsr)
        call syscll
        db MSC_SYS_SYSFIL
        db FNC_FIL_FILINP
        ret c
        ld a,c
        or b
        jr z,cmdcopa
        ld a,(0*5+prgmemtab+0)  ;Destination schreiben
        ld e,a
        ld hl,(0*5+prgmemtab+1)
        ld a,(cmdcophds)
        call syscll
        db MSC_SYS_SYSFIL
        db FNC_FIL_FILOUT
        ret c
        dec a
        ld a,24
        scf
        ret z
        ld hl,(0*5+prgmemtab+3)
        or a
        sbc hl,bc           ;test, ob fertig (BC<HL)
        jr z,cmdcop5
        or a
        ret

;### "DIR" -> Directory anzeigen
dirbufmax   equ 4096
diranzmax   equ 200
dirzgrtab   ds diranzmax*2
diranznum   dw 0
diranzdir   dw 0
dirlincnt   db 0

dirmsgint   db " Directory of ",0
dirmsgemp   db "File not found",13,10,0
dirlensum   ds 4
dirtxtlin   db "##.##.#### ##:##            filename.ext":ds 3
dirtxtdir   db "  <DIR>     "
dirtxtfil   db "            "
dirtxtlen   ds 12
dirtxtsum   db " ########### file(s)  ########### Bytes",13,10
dirtxtsum1  db " ########### directorie(s)",0
dirtxtsum2  db ",########### KBytes free",0
dirtxtsum0  db 13,10,0

cmddirflt   dw cmddirfl0,0
            dw cmddirfl1,0
            dw cmddirfl2,0
            dw cmddirfl3,0
            dw 0
cmddirfl0   db "h",0    ;show hidden files
cmddirfl1   db "s",0    ;show system files
cmddirfl2   db "p",0    ;pause
cmddirfl3   db "f",0    ;show free memory

cmddir  call cmdpar
        push de
        ld iy,cmddirflt
        call cmdflg
        pop de
        jp c,cmdchk3
        push de
        ld a,d
        cp 1
        jr z,cmddir2
        jr c,cmddir1
        pop de
        jp cmdchk1
cmddir1 ld hl,shlpth
        ld de,shlpthnew
        ld bc,256
        push de
        ldir
        pop hl
        call clclen
        ld (hl),"\"
        inc hl
        ld (hl),0
        jr cmddir3
cmddir2 call cmdchk2
cmddir3 ld hl,dirmsgint         ;Kopf ausgeben
        call shlout
        ld hl,shlpthnew
        call shlout
        ld hl,shlinpret
        call shlout
        ld hl,shlinpret
        call shlout
        pop de
        ld a,(cmdflgbit)
        and #03
        xor #03
        add a
        or  #88
        db #dd:ld l,a
        ld hl,shlpthnew
        ld a,(prgbnknum)
        db #dd:ld h,a
        ld de,dirbufmem
        ld bc,dirbufmax
        ld iy,0
        call syscll
        db MSC_SYS_SYSFIL       ;CF=0 -> alles ok, HL=Anzahl gelesener Zeilen, BC=Länge vom nichtgenutzten Zielbereich
        db FNC_FIL_DIRINP       ;Struktur -> 0-3=Filelänge, 4-7=Timestamp, 8=Attribut, 9-X=Filename+0
        jp c,cmderr
        ld a,l
        or h
        jr nz,cmddir7
        ld hl,dirmsgemp         ;keine Files gefunden
        jp shlout
cmddir7 ld de,diranzmax
        sbc hl,de
        jr c,cmddir4
        ld hl,0
cmddir4 add hl,de
        ld (diranznum),hl       ;maximal XXX Einträge
        ex de,hl                ;*** Zeigertabelle generieren
        ld hl,dirbufmem
        ld ix,dirzgrtab
cmddir5 ld bc,8
        add hl,bc
        ld a,(hl)
        and 16
        ld a,"A"
        jr nz,cmddir6
        ld a,"B"
cmddir6 ld (hl),a
        ld (ix+0),l
        ld (ix+1),h
        inc ix:inc ix
        xor a
        ld bc,-1
        cpir
        dec de
        ld a,d
        or e
        jr nz,cmddir5
        ld ix,dirzgrtab         ;*** Liste sortieren
        ld bc,(diranznum)
        push bc
        push ix
        ld a,2
        ld e,0
        ld hl,256*0+0
        call srtdat
        ld hl,0
        ld (dirlensum+0),hl
        ld (dirlensum+2),hl
        ld (diranzdir),hl
        pop ix
        pop bc
        ld a,(scryln)
        sub 3
        ld (dirlincnt),a
cmddir9 push bc                 ;*** Liste ausgeben
        push ix
        ld a,(ix+0)
        db #fd:ld l,a
        ld a,(ix+1)
        db #fd:ld h,a
        ld c,(iy-4)
        ld b,(iy-3)
        ld e,(iy-2)
        ld d,(iy-1)
        call filf2t             ;Timestamp
        push hl
        ld a,b:call clcdez:ld (dirtxtlin+14),hl
        ld a,c:call clcdez:ld (dirtxtlin+11),hl
        ld a,d:call clcdez:ld (dirtxtlin+00),hl
        ld a,e:call clcdez:ld (dirtxtlin+03),hl
        pop ix
        push iy
        ld de,0
        ld iy,dirtxtlin+6
        call clcn32
        ld (iy+1)," "
        pop iy
        ld a,(iy+0)             ;Länge oder "DIR"-Kennung
        cp "A"
        push iy
        jr nz,cmddira
        ld hl,dirtxtdir         ;"DIR"-Kennung
        ld de,dirtxtlin+16
        ld bc,12
        ldir
        ld hl,(diranzdir)
        inc hl
        ld (diranzdir),hl
        jr cmddirb
cmddira ld c,(iy-8)             ;Länge
        ld b,(iy-7)
        ld e,(iy-6)
        ld d,(iy-5)
        ld hl,(dirlensum+0)
        add hl,bc
        ld (dirlensum+0),hl
        ld hl,(dirlensum+2)
        adc hl,de
        ld (dirlensum+2),hl
        ld hl,dirtxtlin+16
        call cmddire
cmddirb pop hl
        ld de,dirtxtlin+28
        inc hl
        ldi
        jr cmddird
cmddirc ld a,(hl)
        call clclcs
        ld (hl),a
        ldi
cmddird ld a,(hl)
        or a
        jr nz,cmddirc
        ex de,hl
        ld (hl),13
        inc hl
        ld (hl),10
        inc hl
        ld (hl),0
        ld hl,dirtxtlin
        call shlout
        ld hl,cmdflgbit
        bit 2,(hl)
        call nz,cmdmor
        pop ix
        pop bc
        inc ix:inc ix
        dec bc
        ld a,c
        or b
        jp nz,cmddir9
        ld hl,(diranznum)       ;*** Zusammenfassung
        ld bc,(diranzdir)
        or a
        sbc hl,bc
        ld c,l
        ld b,h
        ld de,0
        ld hl,dirtxtsum+1
        call cmddire
        ld bc,(diranzdir)
        ld de,0
        ld hl,dirtxtsum1+1
        call cmddire
        ld bc,(dirlensum+0)
        ld de,(dirlensum+2)
        ld hl,dirtxtsum+22
        call cmddire
        ld hl,dirtxtsum
        call shlout
        ld hl,cmdflgbit         ;*** Freier Speicher
        bit 3,(hl)
        jr z,cmddirh
        ld a,(shlpthnew)
        ld c,1
        call syscll
        db MSC_SYS_SYSFIL       ;CF=0 -> alles ok, HL=Anzahl gelesener Zeilen, BC=Länge vom nichtgenutzten Zielbereich
        db FNC_FIL_DIRINF       ;Struktur -> 0-3=Filelänge, 4-7=Timestamp, 8=Attribut, 9-X=Filename+0
        jr c,cmddirh
        srl h:rr l:rr d:rr e
        ld c,e
        ld b,d
        ex de,hl
        ld hl,dirtxtsum2+1
        call cmddire
        ld hl,dirtxtsum2
        call shlout
cmddirh ld hl,dirtxtsum0
        jp shlout

;HL=Ziel, DE(h),BC(l)=Zahl -> 11stellige Zahl rechtsbündig einfügen
cmddire push hl
        push bc
        push de
        ex de,hl
        ld bc,12
        ld hl,dirtxtfil
        ldir
        pop de
        pop ix
        ld iy,dirtxtlen
        push iy
        call clcn32
        pop hl
        pop bc
        add hl,bc
        ld bc,10
        add hl,bc
        push iy
        pop bc
        or a
        sbc hl,bc               ;HL=Zielpos
        ex de,hl
        push iy
        pop hl
        ld bc,dirtxtlen-1
        or a
        sbc hl,bc
        ld c,l
        ld b,h
        ld hl,dirtxtlen
        ldir
        ret

;### "CD.." -> Ein Directory tiefer
cmdcdd  ld ix,shlinplin
        ld (ix+2)," "
        ld (ix+4),"."
        ld (ix+5),0
        jr cmdchd

;### "CD" -> Directory wechseln
cmdchd  call cmdpar
        jr z,cmdchd3
        ld a,1
        call cmdchk0
        ret c
        call cmdchd2
        ld hl,shlpthnew
        call direxi
        jr nc,cmdchd1
        ld b,a
        jp cmderr
cmdchd1 ld hl,shlpthnew
        ld de,shlpth
        ld bc,256
        ldir
        ret
cmdchd3 ld hl,shlpth
        call shlout
        ld hl,shlinpret
        jp shlout
cmdchd2 dec de
        ld a,(de)
        cp "\"
        ret z
        cp "/"
        ret z
        cp ":"
        ret z
        inc de
        ex de,hl
        ld (hl),"\"
        inc hl
        ld (hl),0
        ret

;### "HELP" -> Gibt eine Befehlsübersicht aus
cmdhlppth   db "\cmd.man",0
cmdhlpatx   db "-- Alias: ",0
cmdhlpapt   dw 0
cmdhlphnd   db 0

cmdhlpflt   dw cmddirfl2,0
            dw 0

cmdhlp  call cmdpar
        push de
        ld iy,cmdhlpflt
        call cmdflg
        pop de
        jp c,cmdchk3
        ld a,d
        cp 1
        jp c,cmdhlp0
        jp nz,cmdchk1
cmdhlpc ld hl,cmdhlppth     ;* man file öffnen
        ld de,(prgparf)
        ld bc,14
        ldir
        ld a,(scryln)
        dec a
        ld (dirlincnt),a
        ld hl,(prgparp)
        ld a,(prgbnknum)
        db #dd:ld h,a
        call syscll
        db MSC_SYS_SYSFIL
        db FNC_FIL_FILOPN
        ld e,a
        ld a,249
        jp c,cmderr
        ld a,e
        ld (cmdhlphnd),a
        ld de,(prgbnknum)   ;* header länge laden
        ld hl,dirbufmem
        ld bc,7
        call syscll
        db MSC_SYS_SYSFIL
        db FNC_FIL_FILINP
        jp c,cmdhlpe
        jp nz,cmdhlpe
        ld ix,dirbufmem
        ld a,13
        ld bc,0
        ld de,-2
        call clcr16
        jp c,cmdhlpe
        ld c,l              ;* header inhalt laden
        ld b,h
        ld a,(cmdhlphnd)
        ld de,(prgbnknum)
        ld hl,dirbufmem
        call syscll
        db MSC_SYS_SYSFIL
        db FNC_FIL_FILINP
        jp c,cmdhlpe
        jp nz,cmdhlpe
        push bc:pop iy          ;iy=len
        ld hl,dirbufmem     ;* befehl suchen
        ld ix,25
cmdhlp1 ld c,l
        ld b,h
        ld (cmdhlpapt),hl
cmdhlp2 ld de,(cmdpartab+0)
cmdhlp3 ld a,(de)               ;vergleichen
        or a
        jr z,cmdhlp4
        call clcucs
        cp (hl)
        jr nz,cmdhlp5
        inc de
        inc hl
        jr cmdhlp3
cmdhlp4 ld a,(hl)               ;auch ende ok?
        cp ","
        jr z,cmdhlp6
        cp " "
        jr z,cmdhlp6
cmdhlp5 ld a,(hl)               ;stimmt nicht -> nächster befehl
        inc hl
        cp ","
        jr z,cmdhlp2
        cp " "
        jr nz,cmdhlp5
        ld de,-27
        add iy,de
        db #fd:ld a,l
        db #fd:or h
        ld a,248
        scf
        jp z,cmdhlpf        ;* nicht gefunden
        push bc
        push ix
        push iy
        ld ix,27-2-5            ;nächste zeile
        add ix,bc
        ld a,13
        ld bc,0
        ld de,-2
        call clcr16
        pop iy
        pop ix
        pop bc
        ex de,hl
        add ix,de
        ld hl,27
        add hl,bc
        jr cmdhlp1
cmdhlp6 ld a,(cmdhlphnd)    ;* zum textblock springen
        ld iy,0
        ld c,1
        push af
        call syscll
        db MSC_SYS_SYSFIL
        db FNC_FIL_FILPOI
        pop de
        jr c,cmdhlpe
        ld a,d
cmdhlp7 ld hl,shlpthnew2
        ld de,(prgbnknum)
        push af
        call syscll
        db MSC_SYS_SYSFIL
        db FNC_FIL_FILLIN
        pop de
        jr c,cmdhlpe
        jr z,cmdhlpa
        ld a,(shlpthnew2)
        cp "#"
        jr z,cmdhlpa
        push de
        ld hl,shlpthnew2
        call shlout
        ld hl,shlinpret
        call shlout
        ld hl,cmdflgbit
        bit 0,(hl)
        call nz,cmdmor
        pop af
        jr cmdhlp7
cmdhlpa ld hl,cmdhlpatx
        call shlout
        ld hl,(cmdhlpapt)
        ld a," "
        push hl
        call clclen0
        ld (hl),0
        pop hl
        call shlout
        ld hl,shlinpret
        call shlout
        ld hl,cmdflgbit
        bit 0,(hl)
        call nz,cmdmor
        or a
cmdhlpe ld a,249
cmdhlpf push af
        ld a,(cmdhlphnd)
        call syscll
        db MSC_SYS_SYSFIL
        db FNC_FIL_FILCLO
        pop af
        jp cmderr

cmdhlp0 ld hl,cmdhlptxt
        ld a,(scryln)
        dec a
        ld (dirlincnt),a
cmdhlpb ld a,(hl)
        or a
        ret z
        push hl
        call shlout
        ld hl,cmdflgbit
        bit 0,(hl)
        call nz,cmdmor
        pop hl
        call clclen
        inc hl
        jr cmdhlpb

;### "COLOR" -> Ändert die Farben der Shell
cmdcol  call cmdpar
        ld a,e
        or a
        jp nz,cmdchk1
        ld a,d
        cp 2
        jr z,cmdcol3
        cp 3
        jp nz,cmdchk1
        ld ix,(2*3+cmdpartab)
        xor a
        ld bc,0
        ld de,3
        call clcr16
        jr c,cmdcol3
        ld a,l
        ld (scrbrd),a
cmdcol3 ld ix,(0*3+cmdpartab)
        xor a
        ld bc,0
        ld de,3
        call clcr16
        jr c,cmdcol1
        ld a,l
        ld (scrpen),a
cmdcol1 ld ix,(1*3+cmdpartab)
        xor a
        ld bc,0
        ld de,3
        call clcr16
        jr c,cmdcol2
        ld a,l
        ld (scrpap),a
cmdcol2 call scrini
        ld a,(scrmod)
        or a
        ret nz
        ld e,-1
        jp msgsnd0

;### "SIZE" -> Ändert die Größe der Shell
cmdsiz  call cmdpar
        ld a,e
        or a
        jp nz,cmdchk1
        ld a,d
        cp 2
        jp nz,cmdchk1
        ld ix,(0*3+cmdpartab)
        xor a
        ld bc,10
        ld de,max_xlen
        call clcr16
        jr c,cmdsiz1
        ld a,l
        ld (scrxln),a
cmdsiz1 ld ix,(1*3+cmdpartab)
        xor a
        ld bc,4
        ld de,scrymx
        call clcr16
        jr c,cmdsiz2
        ld a,l
        ld (scryln),a
cmdsiz2 call scrini
        jp cfgset9

;### "FULL" -> Wechselt zwischen Fullscreen- und Fenster-Modus
cmdful  ld a,(scrmod)
        or a
        jr nz,cmdful1
        ld a,(cfgsf2flg)
        bit 3,a
        jr z,cmdful3
        ld hl,shlmsgg9k
        call shlout
cmdful3 call fulakt         ;Fullscreen an
        ret c
        call shlfoc
        jr c,cmdful2
        ld a,(configfsz)
        or a
        jr z,cmdful2
        ld hl,256*scrymx+max_xlen
        ld (scrxln),hl
cmdful2 ld a,1
        call scrset
        jp scrini
cmdful1 ld c,MSC_DSK_WINTOP ;Fullscreen aus
        call msgsnd2
        xor a
        call scrset
        call scrini
        call cfgseta
        jp fuloff
cmdful0 ld c,MSC_DSK_WINCLS ;Fullscreen aus und Fenster schließen
        call msgsnd2
        jp fuloff

;### "TIME" -> Zeigt/setzt die Uhrzeit
cmdtimsht   db "##:##",13,10,0
cmdtimlng   db "Current time is ##:##:##",13,10,0
cmdtiminp   db "Enter new time: ",0
cmdtimerr   db 13,10,"Invalid time",13,10,0

cmdtim  call cmdtim0
        ret c
        cp 1
        ld ix,(cmdpartab+0)
        jr z,cmdtima            ;** zeit übernehmen
        jr nc,cmdtim3
        rst #20:dw jmp_timget   ;** zeit nur anzeigen
        ld a,c
        call clcdez
        ld (cmdtimsht+0),hl
        ld a,b
        call clcdez
        ld (cmdtimsht+3),hl
        ld hl,cmdtimsht
        jp shlout
cmdtim3 rst #20:dw jmp_timget   ;** zeit anzeigen und eingeben
        call clcdez
        ld (cmdtimlng+22),hl
        ld a,b
        call clcdez
        ld (cmdtimlng+19),hl
        ld a,c
        call clcdez
        ld (cmdtimlng+16),hl
        ld hl,cmdtimlng
        call shlout
cmdtim4 ld hl,cmdtiminp         ;eingabe
        call shlout
        ld a,(shlnum)
        add 128
        ld de,(prgbnknum)
        ld d,0
        ld hl,shlpthnew

        ld bc,cmdtimx       ;///###########
        call cnsinl0
        jp c,cmderr
        jr z,cmdtimd
        pop hl
        ld (cmdtimx+1),hl
        scf         ;CF=1, ZF=0 -> shell inactive because of interruption
        ret
cmdtimx ld de,0
        push de             ;\\\###########

cmdtimd dec h
        ret z
        ld ix,shlpthnew
cmdtima ld a,(ix+0)
        or a
        ret z
        db #fd:ld l,":"
        call cmdtim9
        jr c,cmdtimc
        ld a,l
        cp 24
        jr nc,cmdtimc
        ld c,a
        xor a
        ld b,a
        db #fd:dec h
        jr nz,cmdtimb
        call cmdtim9
        jr c,cmdtimc
        ld a,l
        cp 60
        jr nc,cmdtimc
        ld b,a
        xor a
        db #fd:dec h
        jr nz,cmdtimb
        call cmdtim9
        jr c,cmdtimc
        ld a,l
        cp 60
        jr nc,cmdtimc
        db #fd:dec h
        jr z,cmdtimc
cmdtimb push af
        push bc
        rst #20:dw jmp_timget
        pop bc
        pop af
        rst #20:dw jmp_timset
        ret
cmdtimc ld hl,cmdtimerr
        call shlout
        jr cmdtim4

cmdtim9 call cmdtim5
        ret c
        inc h:dec h
        scf
        ret nz
        or a
        ret

cmdtim5 ld hl,-1        ;IX=string, IYL=separator -> cf=1 error, cf=0 -> HL=eingabe, IYH=0 ende erreicht
cmdtim6 ld a,(ix+0)
        inc ix
        or a
        db #fd:ld h,0
        jr nz,cmdtim8
cmdtim7 ld a,l
        and h
        inc a
        scf
        ret z
        or a
        ret
cmdtim8 db #fd:cp l
        db #fd:ld h,1
        jr z,cmdtim7
        cp "0"
        ret c
        cp "9"+1
        ccf
        ret c
        sub "0"
        ld e,a
        ld a,l
        and h
        inc a
        ld a,e
        jr nz,cmdtime
        inc hl
cmdtime add hl,hl
        ld e,l:ld d,h
        add hl,hl
        add hl,hl
        add hl,de
        ld e,a
        ld d,0
        add hl,de
        jr cmdtim6

cmdtim0 call cmdpar     ;ausgabe -> cf=1 syntax error, cf=0 -> a=typ (0=zeit anzeigen, 1=zeit als parameter, 2=zeit anzeigen und eingeben)
        push de
        ld d,0
        ld ix,cmdflgtab-3
        ld bc,3
        inc e
cmdtim1 add ix,bc
        dec e
        jr z,cmdtim2
        ld l,(ix+0)
        ld h,(ix+1)
        ld a,(ix+2)
        dec a
        jr nz,cmdtim1
        ld a,(hl)
        call clclcs
        cp "t"
        jr nz,cmdtim1
        ld d,1
        jr cmdtim1
cmdtim2 pop af
        cp 2
        ccf
        ret c
        cp 1
        ret z
        or a
        dec d
        ret z
        ld a,2
        ret

;### "DATE" -> Zeigt/setzt das Datum
cmddatsht   db "####-##-##",13,10,0
cmddatlng   db "Current date is ### ####-##-##",13,10,0
cmddatinp   db "Enter new date (yy-mm-dd): ",0
cmddaterr   db 13,10,"Invalid date",13,10,0
cmddatday   db "Mon Tue Wed Thu Fri Sat Sun "
cmddatmmx   db 31-1,28-1,31-1,30-1,31-1,30-1,31-1,31-1,30-1,31-1,30-1,31-1

cmddat  call cmdtim0
        ret c
        cp 1
        ld ix,(cmdpartab+0)
        jr z,cmddata            ;** datum übernehmen
        jr nc,cmddat2
        ld iy,cmddatsht+0       ;** datum nur anzeigen
        call cmddat0
        ld hl,cmddatsht
        jp shlout
cmddat2 ld iy,cmddatlng+20      ;** datum anzeigen und eingeben
        call cmddat0
        rst #20:dw jmp_timget
        call clcgdy
        add a:add a
        ld l,a
        ld h,0
        ld bc,cmddatday
        add hl,bc
        ld de,cmddatlng+16
        ld bc,3
        ldir
        ld hl,cmddatlng
        call shlout
cmddat4 ld hl,cmddatinp         ;eingabe
        call shlout
        ld a,(shlnum)
        add 128
        ld de,(prgbnknum)
        ld d,0
        ld hl,shlpthnew

        ld bc,cmddatx       ;///###########
        call cnsinl0
        jp c,cmderr
        jr z,cmddatd
        pop hl
        ld (cmddatx+1),hl
        scf         ;CF=1, ZF=0 -> shell inactive because of interruption
        ret
cmddatx ld de,0
        push de             ;\\\###########

cmddatd dec h
        ret z
        ld ix,shlpthnew
cmddata ld a,(ix+0)
        or a
        ret z
        db #fd:ld l,"-"
        call cmdtim5        ;jahr
        jr c,cmddatc
        ex de,hl
        ld hl,100-1
        or a
        sbc hl,de
        jr c,cmddatf
        ld a,e
        cp 80
        jr nc,cmddate
        add 100
cmddate ld l,a
        ld h,0
        ld de,1900
        add hl,de
        jr cmddatg
cmddatf ld hl,2100-1
        or a
        sbc hl,de
        jr c,cmddatc
        ld hl,1900-1
        sbc hl,de
        jr nc,cmddatc
        ex de,hl
cmddatg push hl
        db #fd:dec h
        ld bc,#101
        jr nz,cmddatb
        call cmdtim9        ;monat
        jr c,cmddath
        ld a,l
        or a
        jr z,cmddath
        cp 12+1
        jr nc,cmddath
        ld c,a
        ld b,1
        db #fd:dec h
        jr nz,cmddatb
        call cmdtim9        ;tag
        jr c,cmddath
        db #fd:dec h
        jr z,cmddath
        ld b,l
        pop hl
        push hl
        ld a,l
        and 3
        ld a,28-1
        jr nz,cmddati
        inc a
cmddati ld (cmddatmmx+1),a
        ld a,c
        ld (cmddatj+2),a
        ld ix,cmddatmmx-1
cmddatj ld a,(ix+0)
        dec b
        cp b
        jr c,cmddath
        inc b
cmddatb push bc
        rst #20:dw jmp_timget
        pop de
        pop hl
        rst #20:dw jmp_timset
        ret
cmddath pop hl
cmddatc ld hl,cmddaterr
        call shlout
        jp cmddat4

cmddat0 push iy         ;datum in string umrechnen
        rst #20:dw jmp_timget
        pop iy
        ld bc,1900
        or a
        sbc hl,bc
        ld a,l
        ld hl,256*"9"+"1"
        cp 100
        jr c,cmddat1
        sub 100
        ld hl,256*"0"+"2"
cmddat1 ld (iy+0),l
        ld (iy+1),h
        call clcdez
        ld (iy+2),l
        ld (iy+3),h
        ld a,e
        call clcdez
        ld (iy+5),l
        ld (iy+6),h
        ld a,d
        call clcdez
        ld (iy+8),l
        ld (iy+9),h
        ret


;==============================================================================
;### SHELL-ROUTINEN ###########################################################
;==============================================================================

shlnum      db 0        ;aktuelle Shell-Instanz (1-8, 0=keine vorhanden)

shlpth      db "A:":ds 256-2
shlpthnew   ds 256
shlpthnew2  ds 256

shlmsgini1  db 2,"SYMBOS [",0
shlmsgini2  db "]",13,10,0
shlmsgini3  db "(C) Copyright 2000-2024 SymbiosiS",13,10
            db "SymShell ",shvs_maj,".",shvs_min,13,10,13,10,0

shlmsgver   ds 30
shlmsgpau   db "Please press any key . . .",0
shlmsgeof   db "Exit",13,10,0

if computer_mode=0
shlmsgg9k   db 2,"FULLSCREEN ACTIVATED:",13,10
            db   "Please switch your display to the internal CPC screen as",13,10
            db   "long as staying in fullscreen mode.",13,10,0
elseif computer_mode=1
shlmsgg9k   db 2,"FULLSCREEN ACTIVATED:",13,10
            db   "Please switch your display to the original MSX screen as",13,10
            db   "long as staying in fullscreen mode.",13,10,0
elseif computer_mode=3
shlmsgg9k   db 2,"FULLSCREEN ACTIVATED:",13,10
            db   "Please switch your display to the original EP screen as",13,10
            db   "long as staying in fullscreen mode.",13,10,0
else
shlmsgg9k   db 0
endif

shlmsgnf1   db "The command ",34,0
shlmsgnf2   db 34," is either",13,10,"wrongly typed or could not be found.",13,10,0
shlmsgexe   db "The file is not executable in the SymbOS environment.",13,10,0
shlmsgmem   db "There is not enough memory for executing the application.",13,10,0
shlmsgsyn   db "Syntax error.",13,10,0
shlmsgisw   db "Invalid switch - ",0
shlmsgprt   db " %sp########",0

prgmsgerrtb dw prgmsgerr00,prgmsgerr01,prgmsgerr02,prgmsgerr03,prgmsgerr04,prgmsgerr05,prgmsgerr06,prgmsgerr07,prgmsgerr08,prgmsgerr09
            dw prgmsgerr10,prgmsgerr11,prgmsgerr12,prgmsgerr13,prgmsgerr14,prgmsgerr15,prgmsgerr16,prgmsgerr17,prgmsgerr18,prgmsgerr19
            dw prgmsgerr20,prgmsgerr21,prgmsgerr22,prgmsgerr23,prgmsgerr24,prgmsgerr25,prgmsgerr26,prgmsgerr27,prgmsgerr28,prgmsgerr29
            dw prgmsgerr30,prgmsgerr31,prgmsgerr32,prgmsgerr33,prgmsgerr34
prgmsgerrmx equ 34
prgmsgerrxx db "Unknown file manager error",0

prgmsgerr00 db "Device does not exist",0
prgmsgerr01 db "OK",0
prgmsgerr02 db "Device not initialised",0
prgmsgerr03 db "Media is damaged",0
prgmsgerr04 db "Partition does not exist",0
prgmsgerr05 db "Unsupported media or partition",0
prgmsgerr06 db "Error while sector read/write",0
prgmsgerr07 db "Error while positioning",0
prgmsgerr08 db "Abort while volume access",0
prgmsgerr09 db "Unknown volume error",0
prgmsgerr10 db "No free filehandler",0
prgmsgerr11 db "Device does not exist",0
prgmsgerr12 db "Path does not exist",0
prgmsgerr13 db "File does not exist",0
prgmsgerr14 db "Access is forbidden",0
prgmsgerr15 db "Invalid path or filename",0
prgmsgerr16 db "Filehandler does not exist",0
prgmsgerr17 db "Device slot already occupied",0
prgmsgerr18 db "Error in file organisation",0
prgmsgerr19 db "Invalid destination name",0
prgmsgerr20 db "File/path already exists",0
prgmsgerr21 db "Wrong sub command code",0
prgmsgerr22 db "Wrong attribute",0
prgmsgerr23 db "Directory full",0
prgmsgerr24 db "Media full",0
prgmsgerr25 db "Media is write protected",0
prgmsgerr26 db "Device is not ready",0
prgmsgerr27 db "Directory is not empty",0
prgmsgerr28 db "Invalid destination device",0
prgmsgerr29 db "Not supported by file system",0
prgmsgerr30 db "Unsupported device",0
prgmsgerr31 db "File is read only",0
prgmsgerr32 db "Device channel not available",0
prgmsgerr33 db "Destination is not a directory",0
prgmsgerr34 db "Destination is not a file",0

;### SHLOUT -> Gibt String aus
;### Eingabe    HL=Quelle
shlout  push hl
        call clclen
        pop hl
        ld a,(shlnum)
        add 128
        ld de,(prgbnknum)
        ld d,0
        call cnsoul
        jp cnserr

;### SHLCHR -> Gibt Zeichen aus
;### Eingabe    A=Zeichen
shlchr  ld e,a
        ld d,0
        ld a,(shlnum)
        add 128
        call cnsouc
        jp cnserr

;### SHLNEW -> Startet neue Shell-Instanz
;### Eingabe    HL=Input, DE=Output, C=Ausgabe-Typ, B=Flag, ob Startmeldung zeigen (0=nein)
;### Ausgabe    CF=0 ok, CF=1 -> Fehler (A=Fehlercode)
shlnew  push bc
        call cnshnd         ;Handler generieren -> CF=0 -> L=Eingabe-Handler, H=Ausgabe-Handler, CF=1 -> Fehler (A=Fehlercode)
        pop bc
        ret c
        ld a,1
        ld (cmdechf),a
        ld a,(shlnum)
        inc a
        ld (shlnum),a
        add 128
        ld c,a
        push bc
        call cnsadd         ;"Prozess" hinzufügen
        pop af
        or a
        ret z
shlnew1 ld hl,shlmsgini1    ;optional Startmeldung ausgeben
        call shlout
        ld hl,shlmsgver
        call shlout
        ld hl,shlmsgini2
        call shlout
        ld hl,shlmsgini3
        call shlout
        xor a
        ret

;### SHLREP -> Fährt mit aktueller Shell-Instanz fort
shlrep  ld a,(shlnum)
        or a
        jp z,prgend         ;keine Shell-Instanz aktiv -> Shell beenden
        add 128
        push af
        call cnsdat         ;A=Prozess -> CF=1 unbekannt, CF=0 -> IX=Daten, BC,IY verändert
        jr c,shlrep2
        ld a,(ix+cnsprzinp)
        inc a
        call z,shldir       ;aktuellen Pfad anzeigen, wenn Eingabe von Tastatur
shlrep2 pop af
        ld de,(prgbnknum)
        ld d,0
        ld hl,shlinplin
        call cnsinl         ;Zeile anfordern
        jr c,shlrep1
        ret nz              ;bisher liegt keine Zeile vor
        jr shlget1
shlrep1 call cnserr         ;Fehler beim Zeile-Anfordern
        jr shldwn

;### SHLDWN -> Geht eine Shell-Instanz tiefer
shldwn  call shldwn0
        jr shlrep
shldwn0 ld a,1
        ld (cmdechf),a
        ld hl,shlnum
        ld a,(hl)
        cp 2
        jp c,prgend
        dec (hl)
        add 128
        jp cnsdel           ;"Prozess" entfernen

;### SHLGET -> Empfängt Message an Shell
;### Eingabe    C=Commando (chrinp/strinp), B=Fehlerstatus (immer 0 [?]), H=EOF-Flag (optional), L=Zeichen (optional)
shlget  ld e,(ix+cnscmdsub+0)
        ld d,(ix+cnscmdsub+1)
        ld a,e
        or d
        jr nz,shlget6
        ld a,c
        cp MSR_SHL_CHROUT   ;Ausgabe-Bestätigungen ignorieren
        ret z
        cp MSR_SHL_STROUT
        ret z
        xor a
        cp b
        jp nz,shldwn        ;Eingabe-Bestätigung und Fehler oder EOF -> aktuelle Instanz beenden
        cp h
        jp nz,shldwn
        ld a,c
        cp MSR_SHL_STRINP   ;*** Zeile wurde empfangen
        jr nz,shlget2
shlget1 dec h
        inc h
        jp nz,shlget4       ;EOF -> aktuelle Instanz beenden
        ld a,(shlnum)
        add 128
        call cnsdat         ;A=Prozess -> CF=1 unbekannt, CF=0 -> IX=Daten, BC,IY verändert
        jr c,shlget3
        ld a,(ix+cnsprzinp)
        inc a
        jr z,shlget3
        ld a,(cmdechf)
        or a
        jr z,shlget3
        call shldir         ;falls nicht aus Tastatureingabe und Echo aktiviert -> ausgeben
        ld hl,shlinplin
        call shlout
        ld hl,shlinpret
        call shlout
shlget3 call cmdprz         ;Commando abarbeiten
shlget5 jp nc,shlrep
        jr z,shldwn
        ret
shlget4 call shldwn0
        jp shlrep
shlget2 cp MSR_SHL_CHRINP   ;*** Zeichen wurde empfangen
        ret nz
        ;...
        ret
shlget6 ld bc,shlget5       ;*** Commando nach Eingabe fortführen
        push bc
        push de      
        ret

;### SHLFOC -> Testet, ob Shell Focus hat
;### Ausgabe    CF=1 Shell hat keinen Focus
shlfoc  ld a,(cnscmdlst)
        ld hl,cnscmdpos
        cp (hl)
        scf
        ret z
        call cnschk4
        ld a,(ix+cnscmdbnk)
        cp -1
        jr nz,shlfoc1
        call cnschk0
        jr shlfoc
shlfoc1 ld a,(ix+cnscmdprz)
        cp 128
        ret

;### SHLRES -> Resettet den Shell-Speicher
shlres  ld hl,dirbufmem
        ld bc,dirbufmax
        add hl,bc
        ld (shlinphis),hl
        ld e,l
        ld d,h
        ld (hl),0
        inc de
        ld bc,128*8-1
        ldir
        ret

;### SHLDIR -> Plottet das Shell-Directory
shldir  ld hl,shlpth
        push hl
        ld a,(hl)
        call clcucs
        ld (hl),a
shldir2 inc hl
        ld a,(hl)
        or a
        jr z,shldir3
        cp "/"
        jr nz,shldir2
        ld (hl),"\"
        jr shldir2
shldir3 dec hl
        ld a,(hl)
        cp "\"
        jr nz,shldir4
        ld (hl),0
shldir4 pop hl
        call shlout
        ld a,(shlpth+2)
        or a
        jr nz,shldir1
        ld a,"\"
        call shlchr
shldir1 ld a,">"
        jp shlchr

;### SHLINI -> Initialisiert die Shell
shlini  xor a
        ld (shlinppos),a        ;Parameter resetten
        ld (shlinplen),a
        ld (shlinpmod),a
        ld (shlinphps),a
        ld (shlinplin),a
        ld a,3
        jp trmchr

;### SHLTAB -> Autocomplete
shltabpos   dw 0        ;aktuelle pos im directory
shltabmax   dw 0        ;anzahl directory einträge
shltabcur   dw 0        ;position ab der namen eingefügt werden
shltabmsk   db "*.*",0

shltab  ld hl,(shltabmax)
        ld a,l
        or h
        jp nz,shltaba
        ld a,(shlinppos)        ;*** directory einträge gefiltert laden
        ld e,a              ;e=kompletter anfang
        ld d,0              ;d=namen anfang (0=kompletter anfang)
        ld c,0              ;c=länge
        ld hl,shlinplin
        add hl,de
shltab1 dec hl
        inc e
        dec e
        jr z,shltab2        ;anfang erreicht -> fertig
        ld a,(hl)
        cp "/"
        call z,shltabf
        cp "\"
        call z,shltabf
        cp ":"
        call z,shltabf
        cp " "
        jr z,shltab2        ;leerzeichen -> fertig
        dec e
        inc c
        jr shltab1
shltabf inc d:dec d
        ret nz
        ld d,e
        ret
shltab2 call shltabf
        push hl
        ld e,d
        ld d,0
        ld hl,shlinplin
        add hl,de
        ld (shltabcur),hl
        pop hl
        ld de,shlpthnew
        push de
        xor a
        cp c
        jr z,shltab3
        ld b,a
        inc hl
        ldir                ;wort herauskopieren
shltab3 ld (de),a
        pop hl
        ld de,shlpthnew2
        call diradd         ;komplettes verzeichnis zusammenfügen -> DE=Terminatorposition, A=Type (+1=hört mit \ auf, +2=enthält filemask), HL=pos hinter letztem \
        bit 1,a
        jr nz,shltab9
        bit 0,a
        jr z,shltab5
        ex de,hl
        ld hl,shltabmsk
shltab4 ld bc,4
        ldir
        jr shltab9
shltab5 db #dd:ld l,11      ;test, welche wildcard-maske angefügt werden muß
        ld bc,shltabmsk
shltab6 ld a,(hl)
        inc hl
        or a
        jr z,shltab8
        cp "."
        jr z,shltab7
        db #dd:dec l
        jr z,shltab9        ;8+3 zeichen erreicht -> keine maske anfügen
        db #dd:ld a,l
        cp 11-8
        jr nz,shltab6
        ld bc,shltabmsk+1   ;8zeichen erreicht -> nur .*
        jr shltab6
shltab7 ld bc,shltabmsk+2   ;punkt erreicht -> nur *
        db #dd:ld l,3
        jr shltab6
shltab8 ld l,c
        ld h,b
        jr shltab4
shltab9 ld hl,shlpthnew2
        ld a,(prgbnknum)
        db #dd:ld h,a
        db #dd:ld l,#8e
        ld de,dirbufmem
        ld bc,dirbufmax
        ld iy,0
        call syscll
        db MSC_SYS_SYSFIL   ;CF=0 -> alles ok, HL=Anzahl gelesener Zeilen, BC=Länge vom nichtgenutzten Zielbereich
        db FNC_FIL_DIRINP   ;Struktur -> 0-3=Filelänge, 4-7=Timestamp, 8=Attribut, 9-X=Filename+0
        ccf
        ret nc
        ld a,l
        or h
        ret z
        ld (shltabmax),hl
        dec hl
        ld (shltabpos),hl
shltaba ld de,(shltabpos)       ;*** nächsten Eintrag holen
        ld hl,(shltabmax)
        inc de
        or a
        sbc hl,de
        jr nz,shltabb
        ld de,0
shltabb ld (shltabpos),de
        ld hl,dirbufmem
shltabc ld bc,9
        add hl,bc
        ld a,e
        or d
        jr z,shltabd
        dec de
        xor a
        ld bc,-1
        cpir
        jr shltabc
shltabd ld de,(shltabcur)
        ld a,(hl)
        cp "."
        jr nz,shltabe
        ld hl,(shltabmax)
        dec hl
        ld a,l
        or h
        jr nz,shltaba
        ret
shltabe ld a,(hl)
        ldi
        or a
        jr nz,shltabe
        dec de:dec de
        ld a,(de)
        cp "."
        jr nz,shltabg
        xor a
        ld (de),a
        dec de
shltabg ex de,hl
        ld de,shlinplin-1
        sbc hl,de
        ld a,l
        push af
        ld hl,shlinplin
        ld de,shlpthnew
        ld bc,256
        ldir
        call shlinp0
        ld hl,shlpthnew
        ld de,shlinplin
        ld bc,256
        ldir
        pop af
        jp shlinpz

;### SHLINP -> Zeileneingabe
;### Eingabe    A=Zeichen
;### Ausgabe    CF=1 Eingabe wurde abgeschlossen -> (shlinplin)=String, (shlinplen)=Länge, ZF=1 Abschluß durch Abbruch
shlinplin   ds 256
shlinplen   db 0        ;Länge der aktuellen Eingabe
shlinpmax   equ 240
shlinppos   db 0        ;Cursor-Position
shlinpmod   db 0        ;0=Einfügen, 1=Überschreiben
shlinphis   dw 0
shlinphps   db 0
shlinphln   db 0
shlinpbuf   ds 2
shlinpret0  db "."
shlinpret   db 13,10,0

shlinp  cp 9                ;*** Tab -> Autocomplete
        jp z,shltab
        cp 11
        jp z,shltab
        ld hl,0
        ld (shltabmax),hl
        cp 3                ;*** Ctrl+C -> Abbruch
        jr nz,shlinps
        call shlinp0
        xor a
        jr shlinpt
shlinps cp 27               ;*** Escape -> bisherige Eingabe löschen
        jr nz,shlinp5
        call shlinp0
        ld a,3                  ;Ende, Cursor wieder anmachen
        call trmchr
        xor a
        ret
shlinp0 ld a,2
        call trmchr
shlinp6 ld a,(shlinppos)        ;Cursor an Eingabe-Anfang setzen
        or a
        jr z,shlinp2
        ld b,a
        ld c,8
shlinp1 push bc
        ld a,c
        call trmchr
        pop bc
        djnz shlinp1
shlinp2 ld a,(shlinplen)
        ld (shlinppos),a
        or a
        ret z
        ld hl,shlinplin         ;bisherige Eingabe löschen
        ld de,shlinplin+1
        ld (hl),32
        ld c,a
        xor a
        ld b,a
        ld (shlinplen),a
        ldir
        ld (hl),a
        ld hl,shlinplin
        push hl
        call trmout
        pop hl
        ld (hl),0
        jr shlinp6
shlinp5 cp 13               ;*** Return -> Eingabe abschließen
        jr nz,shlinp7
        ld a,1
shlinpt push af
        ld a,2
        call trmchr             ;Cursor Aus
        ld a,(shlinplen)
        ld hl,shlinppos
        sub (hl)
        jr z,shlinpp
        ld b,a
        ld c,9
shlinpq push bc
        ld a,c
        call trmchr             ;Cursor ans Zeilenende
        pop bc
        djnz shlinpq
shlinpp ld hl,shlinpret         ;Zeilenvorschub
        call trmout
        ld a,(shlinplen)
        cp 128
        jr c,shlinpr
        ld a,127                ;max. 127 Zeichen+0 in die History kopieren
shlinpr ld c,a
        or a
        jr z,shlinpu
        ld hl,(shlinphis)
        push hl
        push bc
        ld de,shlinplin         ;Zeile mit letzter in der History vergleichen
        ld b,c
        inc b
shlinpv ld a,(de)
        cp (hl)
        jr nz,shlinpw
        inc de
        inc hl
        djnz shlinpv
shlinpw pop bc
        pop hl
        jr z,shlinpu            ;identisch -> nicht neu in History einfügen
        push bc
        push hl
        ld bc,128*8-1
        add hl,bc
        ex de,hl
        pop hl
        ld bc,128*8-1-128
        add hl,bc
        inc bc
        lddr
        pop bc
        ld b,0
        inc c
        ld hl,shlinplin         ;Zeile in History einfügen
        ld de,(shlinphis)
        ldir
        ld a,(shlinphln)
        inc a
        cp 9
        jr z,shlinpu
        ld (shlinphln),a
shlinpu pop af
        or a
        scf
        ret
shlinp7 cp 138              ;*** Cursor Links
        jr nz,shlinp9
        ld a,(shlinppos)
        or a
        ret z
        dec a
        ld (shlinppos),a
        ld a,8
shlinp8 call trmchr
        xor a
        ret
shlinp9 cp 139              ;*** Cursor Rechts
        jr nz,shlinpa
        ld a,(shlinplen)
        ld hl,shlinppos
        cp (hl)
        ret z
        inc (hl)
        ld a,9
        jr shlinp8
shlinpa cp 137              ;*** Cursor Runter
        jr nz,shlinpe
        ld a,(shlinphps)
        cp 2
        ccf
        ret nc
        dec a
shlinpb ld (shlinphps),a
        push af
        call shlinp0
        pop af
        dec a
        add a:add a:add a:add a:add a
        ld l,a
        ld h,0
        add hl,hl:add hl,hl
        ld bc,(shlinphis)
        add hl,bc
        ld de,shlinplin
        ld bc,127*256+255
shlinpc ld a,(hl)
        ldi
        or a
        jr z,shlinpd
        djnz shlinpc
        xor a
        ld (de),a
shlinpd ld a,127
        sub b
shlinpz ld (shlinplen),a
        ld (shlinppos),a
        ld hl,shlinplin
        call trmout
        ld a,3
        call trmchr
        xor a
        ret
shlinpe cp 136              ;*** Cursor Rauf
        jr nz,shlinpf
        ld hl,shlinphln
        ld a,(shlinphps)
        cp (hl)
        inc a
        jr c,shlinpb
        ret
shlinpf cp 14               ;*** Ctrl+N -> Einfügemodus ein/aus
        jr nz,shlinpg
        ld a,(shlinpmod)
        xor 1
        ld (shlinpmod),a
        ret
shlinpg cp 8                ;*** Del -> Zeichen vor Cursor löschen
        jr nz,shlinph
        ld a,(shlinppos)
        or a
        ret z
        dec a
        ld (shlinppos),a
        ld a,8
        call trmchr
        jr shlinpi
shlinph cp 127              ;*** Clr -> Zeichen unter Cursor löschen
        jr nz,shlinpk
shlinpi ld a,(shlinplen)
        or a
        ret z
        ld hl,shlinppos
        sub (hl)
        ret z
        push af
        push hl
        ld a,2
        call trmchr
        pop hl
        pop af
        ld c,a
        ld b,0
        ld l,(hl)
        ld h,b
        ld de,shlinplin
        add hl,de
        push bc
        push hl
        ld e,l
        ld d,h
        inc hl
        ldir
        pop hl
        call trmout
        ld a," "
        call trmchr
        pop bc
        ld b,c
        ld c,8
shlinpj push bc
        ld a,c
        call trmchr
        pop bc
        djnz shlinpj
        ld a,3
        call trmchr
        ld hl,shlinplen
        dec (hl)
        xor a
        ret
shlinpk cp 32               ;*** Zeicheneingabe
        ccf
        ret nc
        cp 128
        ret nc
        ld c,a
        ld a,(shlinplen)
        ld hl,shlinppos
        cp (hl)
        jr nz,shlinpl
        inc a                   ;Zeichen am Ende einfügen
        cp shlinpmax+1
        ret z
        ld (shlinplen),a
        ld e,(hl)
        ld d,0
        ld (hl),a
        ld hl,shlinplin
        add hl,de
        ld (hl),c
        inc hl
        ld (hl),0
shlinpm ld a,c
        call trmchr
        xor a
        ret
shlinpl ld b,a
        ld a,(shlinpmod)
        or a
        jr z,shlinpn
        ld e,(hl)               ;Zeichen im String überschreiben
        ld d,0
        inc (hl)
        ld hl,shlinplin
        add hl,de
        ld (hl),c
        jr shlinpm
shlinpn ld a,b                  ;Zeichen im String einfügen
        cp shlinpmax
        ret z
        sub (hl)                ;A=Len-Pos
        push af
        ld e,b
        ld d,0
        ld hl,shlinplin+1
        add hl,de
        ld e,l
        ld d,h                  ;DE=hinter Ende
        dec hl                  ;HL=Ende
        ld b,c
        ld c,a
        inc c
        ld a,b                  ;A=Zeichen
        ld b,0                  ;BC=Len-Pos+1
        lddr
        ld (de),a
        ex de,hl
        push hl
        ld a,2
        call trmchr
        pop hl
        call trmout
        pop bc
        ld c,8
shlinpo push bc
        ld a,c
        call trmchr
        pop bc
        djnz shlinpo
        ld a,3
        call trmchr
        ld hl,shlinplen
        inc (hl)
        ld hl,shlinppos
        inc (hl)
        xor a
        ret


;==============================================================================
;### TERMINAL-ROUTINEN ########################################################
;==============================================================================

trmbuf  ds max_xlen ;Buffer für Textausgabe
trmbln  db 0        ;Größe des Buffer-Inhaltes
trmcxp  db 0        ;Cursor Xpos
trmcyp  db 0        ;Cursor Ypos
trmcst  db 0,0      ;stored cursor position
trmcfl  db 1        ;Flag, ob Cursor aktiviert
trmtfl  db 1        ;Flag, ob Text aktiviert
trmtab  ds max_xlen ;tab-flags
        db 1        ;tab terminator

trmpbf  ds 5        ;buffer for 5 additional code parameters
trmplf  db 0        ;number of missing parameters
trmppo  dw 0        ;pointer to next missing parameter in buffer

;### TRMINI -> Initialisiert die Konsole
trmini  ld hl,0
        ld (trmcxp),hl
        ret

;### TRMCHR -> Ausgabe eines Zeichens auf der Konsole
;### Eingabe    A=Zeichen
trmchrb ds 2
trmchr  ld hl,trmchrb
        ld (hl),a
        jp trmout

;### TRMOUT -> Ausgabe eines Strings auf der Konsole
;### Eingabe    HL=Quelle
;Sondercodes
;00 = Ende
    ;01 = Request (p1=type, 1=cursor pos, 2=window size)
;02 = Cursor aus
;03 = Cursor an
;04 = Save Cursor Position
;05 = Restore Cursor Position
;06 = Textausgabe aktivieren
    ;07 = Beep
;08 = Cursor links
;09 = Cursor rechts
;10 = Cursor unten
;11 = Cursor oben
;12 = Bildschirm löschen
;13 = Cursor in erste Spalte
;14 = Move Cursor (p1=direction and steps; 1-80=right, 81-160=left, 161-185=down, 186-210=up; cursor will not cross any border)
    ;15 = ## not defined ##
;16 = Zeichen unter Cursor löschen
;17 = Zeile bis Cursor löschen
;18 = Zeile ab Cursor löschen
;19 = Screen bis Cursor löschen
;20 = Screen ab Cursor löschen
;21 = Textausgabe deaktivieren
;22 = Set Tab
;23 = Clear Tab
;24 = Clear all Tabs
;25 = Jump to next Tab
;26 = Screenbereich füllen (p1=Zeichen, p2/p3=xybeg, p4/p5=xyend)
    ;27 = ## not defined ##
    ;28 = Set Window Size (p1=10-80, p2=4-25)
;29 = Scroll Window (p1=0 up, p1=1 down)
;30 = Cursor in linke obere Ecke
;31 = Cursor positionieren (p1=0-79, p2=0-24)

trmjmp  dw 0,trmcxx,0,trmcxx,0,trmc02,0,trmc03,0,trmc04,0,trmc05,0,trmcxx,0,trmc07,0,trmc08,0,trmc09
        dw 0,trmc10,0,trmc11,0,trmc12,0,trmc13,1,trmc14,0,trmcxx,0,trmc16,0,trmc17,0,trmc18,0,trmc19
        dw 0,trmc20,0,trmc21,0,trmc22,0,trmc23,0,trmc24,0,trmc25,5,trmc26,0,trmcxx,2,trmc28,1,trmc29
        dw 0,trmc30,2,trmc31

;debugging
;- aktuell window size deaktivert
;- aktuell deactivate output deaktivert

trmout  xor a
        ld (trmbln),a
        ld a,(trmcfl)
        or a
        jr z,trmout1
        push hl
        call scrcof
        pop hl
trmout1 ld a,(trmtfl)
        or a
        jr nz,trmoutd
trmout2 ld a,(hl)           ;*** Textausgabe deaktiviert -> nach Aktivierung oder Ende suchen
        inc hl
        or a
        jp z,trmouta
        cp 6
        jr nz,trmout2
        ld (trmtfl),a
trmoutd ld a,(trmplf)
        or a
        jr z,trmoutb
        push hl
        jp trmoute
trmoutb ld de,trmbuf
trmout3 ld a,(hl)           ;*** Hauptschleife (HL=Text, DE=Buffer)
        inc hl
        cp 32
        jr c,trmout8
        ld (de),a
        inc de
        ld a,(trmbln)
        inc a
        ld (trmbln),a
        cp max_xlen
        call nc,trmout4
        jr trmout3
trmout4 ld a,(trmbln)       ;*** Textbuffer ausgeben, leeren und Cursor neu setzen
        or a
        ret z
        push hl
        ld hl,trmbuf
        ld de,(trmcxp)
trmout7 ld c,a
        ld a,(scrxln)
        sub e           ;A=Maxlänge
        cp c
        jr nc,trmout5
        ld c,a
trmout5 push de
        push hl
        push bc
        call scrplt     ;Text ausgeben
        pop bc
        pop hl
        ld b,0
        add hl,bc
        pop de
        ld a,c
        add e           ;Cursor X korrigieren
        ld e,a
        ld a,(scrxln)
        cp e
        jr nz,trmout6
        ld e,0          ;Cursor in nächste Zeile
        inc d
        ld a,(scryln)
        cp d
        jr nz,trmout6
        dec d
        push hl
        push de
        push bc
        call scrsru     ;Scrollen, falls letzte Zeile
        pop bc
        pop de
        pop hl
trmout6 ld a,(trmbln)   ;falls Buffer nicht leer, nochmal Text ausgeben
        sub c
        ld (trmbln),a
        jr nz,trmout7
        ld (trmcxp),de
        ld de,trmbuf
        pop hl
        ret
trmout8 push af             ;*** Code ausführen
        call trmout4        ;plot (flush) remaining buffer
        pop af
        or a
        jr z,trmouta        ;code=0 -> finish
        push hl
        add a
        add a
        ld l,a
        ld h,0
        ld bc,trmjmp
        add hl,bc
        ld a,(hl)           ;get number of parameters
        inc hl:inc hl
        ld c,(hl)
        inc hl
        ld h,(hl)
        ld l,c              ;get jump address
        ld (trmpjp+1),hl
        or a
        jr z,trmoutc        ;no params -> execute code at once
        ld (trmplf),a       ;init parameter buffer
        ld hl,trmpbf
        ld (trmppo),hl
trmoute ld ix,trmplf        ;load as much parameters as required from the stream
        pop hl
        ld de,(trmppo)
trmoutf ld a,(hl)
        inc hl
        or a
        jr z,trmouta        ;stream end, and not all paramas have been loaded -> finish
        ld (de),a
        inc de
        ld (trmppo),de
        dec (ix+0)
        jr nz,trmoutf
        push hl             ;all loaded -> execute code
trmoutc ld bc,trmout9
        push bc
trmpjp  jp 0
trmout9 pop hl              ;*** Code Rücksprung
        jp trmoutb
trmouta ld a,(trmcfl)       ;*** Ende
        or a
        ret z
        ld de,(trmcxp)
        jp scrcon

trmc02  xor a               ;### 02 = Cursor aus
        ld (trmcfl),a
trmcxx  ret
trmc03  ld a,1              ;### 03 = Cursor an
        ld (trmcfl),a
        ret
trmc04  ld hl,(trmcxp)      ;### 04 = save cursor position
        ld (trmcst),hl
        ret
trmc05  ld hl,(trmcst)      ;### 05 = restore cursor position
        ld (trmcxp),hl
        ret
trmc07  ;...                ;### 07 = Beep
        ret
trmc08  ld a,(trmcxp)       ;### 08 = Cursor links
        sub 1
        jr nc,trmc082
        call trmc11
        ld a,(scrxln)
        dec a
trmc082 ld (trmcxp),a
        ret
trmc09  ld a,(trmcxp)       ;### 09 = Cursor rechts
trmc091 inc a
        ld c,a
        ld a,(scrxln)
        cp c
        jr nz,trmc092
        call trmc10
        ld c,0
trmc092 ld a,c
        ld (trmcxp),a
        ret
trmc10  ld a,(trmcyp)       ;### 10 = Cursor unten
        inc a
        ld c,a
        ld a,(scryln)
        cp c
        jr nz,trmc101
        push bc
        call scrsru
        pop bc
        dec c
trmc101 ld a,c
        ld (trmcyp),a
        ret
trmc11  ld a,(trmcyp)       ;### 11 = Cursor oben
        sub 1
        jr nc,trmc111
        call scrsrd
        xor a
trmc111 ld (trmcyp),a
        ret
trmc12  call scrclr         ;### 12 = Bildschirm löschen
        jp trmc30
trmc13  xor a               ;### 13 = Cursor in erste Spalte
        ld (trmcxp),a
        ret
trmc14  ld a,(trmpbf+0)     ;### 14 = Move Cursor (p1=direction and steps; 1-80=right, 81-160=left, 161-185=down, 186-210=up)
        dec a
        cp 210
        ret nc
        inc a
        cp 161
        jr c,trmc141
        sub 160
        ld hl,scryln
        ld de,trmcyp
        ld c,25+1           ;##!!##
        jr trmc142
trmc141 ld hl,scrxln
        ld de,trmcxp
        ld c,80+1           ;##!!##
trmc142 cp c
        jr c,trmc143
        sub c
        inc a
        neg
trmc143 ld b,a
        ld a,(de)
        add b
        cp (hl)
        jr c,trmc144
        xor a
        bit 7,b
        jr nz,trmc144
        ld a,(hl)
        dec a
trmc144 ld (de),a
        ret
;A=Zeichen, E=Spalte, D=Zeile, C=XLen, B=YLen
trmc16  ld de,(trmcxp)      ;### 16 = Zeichen unter Cursor löschen
        ld bc,#101
trmc161 ld a,32
        jp scrfls
trmc17  ld de,(trmcxp)      ;### 17 = Zeile bis Cursor löschen
        ld c,e
        inc c
        ld e,0
trmcl71 ld b,1
        jr trmc161
trmc18  ld de,(trmcxp)      ;### 18 = Zeile ab Cursor löschen
        ld a,(scrxln)
        sub e
        ld c,a
        jr trmcl71
trmc19  ld a,(trmcyp)       ;### 19 = Screen bis Cursor löschen
        or a
        jr z,trmc17
        ld b,a
        ld a,(scrxln)
        ld c,a
        ld de,0
        ld a,32
        call scrfls
        jr trmc17
trmc20  ld bc,(scrxln)      ;### 20 = Screen ab Cursor löschen
        ld a,(trmcyp)
        inc a
        ld d,a
        sub b
        jr z,trmc18
        neg
        ld b,a
        ld e,0
        ld a,32
        call scrfls
        jr trmc18
trmc21  xor a               ;### 21 = Textausgabe deaktivieren
;        ld (trmtfl),a
        pop hl
        pop hl
        jp trmout2
trmc22  ld a,1              ;### 22 = set tab
trmc221 call trmc222
        ld (hl),a
        ret
trmc222 ld hl,(trmcxp)
        ld h,0
        ld de,trmtab
        add hl,de
        ret
trmc23  xor a               ;### 23 = clear tab
        jr trmc221
trmc24  ld hl,trmtab        ;### 24 = clear all tabs
        ld de,trmtab+1
        ld bc,max_xlen-1
        ld (hl),0
        ldir
        ret
trmc25  call trmc222        ;### 25 = jump to next tab
        inc hl
        ld a,1
        ld bc,max_xlen-1
        cpir
        ld a,max_xlen-1
        sub c
        ld hl,trmcxp
        add (hl)
        ld c,a
        ld a,(scrxln)
        dec a
        cp c
        jp c,trmc091
        ld (hl),c
        ret
trmc26  ;...                ;### 26 = Screenbereich füllen (p1=Zeichen, p2/p3=xybeg, p4/p5=xylen)
ret
        ;...bereichs-überprüfung
        ;jp scrfll
trmc28  ld hl,(trmpbf+0)    ;### 28 = Set Window Size (p1=10-80, p2=4-25)
ret
        ld a,l
        cp max_xlen-1+1
        jr c,trmc281
        ld a,max_xlen-1
trmc281 cp 10
        jr nc,trmc282
        ld a,10
trmc282 ld (scrxln),a
        ld a,h
        cp scrymx+1
        jr c,trmc283
        ld a,scrymx
trmc283 cp 4
        jr nc,trmc284
        ld a,4
trmc284 ld (scryln),a
        jp cmdsiz2
trmc29  ld a,(trmpbf+0)     ;### 29 = Scroll Window (p1 -> 1=up, 2=down)
        or a
        ret z
        cp 2
        jp c,scrsru
        jp z,scrsrd
        ret
trmc30  xor a               ;### 30 = Cursor in linke obere Ecke
        ld (trmcyp),a
        jp trmc13
trmc31  ld hl,(trmpbf+0)    ;### 31 = Cursor positionieren (p1=1-80, p2=1-25)
        inc l:dec l
        jr nz,trmc313
        inc l
trmc313 ld a,(scrxln)
        cp l
        jr nc,trmc311
        ld l,a
trmc311 inc h:dec h
        jr nz,trmc314
        inc h
trmc314 ld a,(scryln)
        cp h
        jr nc,trmc312
        ld h,a
trmc312 dec l
        dec h
        ld (trmcxp),hl
        ret


;==============================================================================
;### SCREEN-ROUTINEN ##########################################################
;==============================================================================

if computer_mode=0
scrymx  equ max_ylen
elseif computer_mode=1
scrymx  equ max_ylen
elseif computer_mode=2
scrymx  equ max_ylen
elseif computer_mode=3
scrymx  equ max_ylen
elseif computer_mode=4
scrymx  equ max_ylen
elseif computer_mode=5
scrymx  equ max_ylen
elseif computer_mode=6
scrymx  equ max_ylen
endif

scrmod  db 0

;### SCRSET -> Ausgabe-Treiber setzen
;### Eingabe    A=Typ (0=Window, 1=Fullscreen)
scrseta dw winini,winclr,winsru,winsrd,winplt,winfll,winfll,wincon,wincof
scrsetb
if     computer_mode=2
else
        dw fulini,fulclr,fulsru,fulsrd,fulplt,fulfll,fulfls,fulcon,fulcof
endif

scrset  ld (scrmod),a
        or a
        ld hl,scrseta
        jr z,scrset1
        ld hl,scrsetb
scrset1 ld de,scrini+1+3
        ld bc,9*256+255
scrset2 ldi:ldi
        inc de:inc de:inc de:inc de
        djnz scrset2
        ret

scrini  call memini:jp 0    ;### SCRINI -> Initialisiert den Bildschirm und updatet Größe und Farben
scrclr  call memclr:jp 0    ;### SCRCLR -> Löscht den kompletten Bildschirm
scrsru  call memsru:jp 0    ;### SCRSRU -> Scrollt Bildschirm nach oben und fügt unten Leerzeile ein
scrsrd  call memsrd:jp 0    ;### SCRSRD -> Scrollt Bildschirm nach unten und fügt oben Leerzeile ein
scrplt  call memplt:jp 0    ;### SCRPLT -> Fügt Text in Bildschirm ein
scrfll  call memfll:jp 0    ;### SCRFLL -> Füllt Bildschirm-Bereich mit gleichem Zeichen
scrfls  call memfll:jp 0    ;### SCRFLS -> Füllt Bildschirm-Bereich mit Spaces
scrcon  call memcon:jp 0    ;### SCRCON -> Cursor positionieren und einblenden
scrcof  call memcof:jp 0    ;### SCRCOF -> Cursor ausblenden


;==============================================================================
;### SCREEN-ROUTINEN (NUR SPEICHER) ###########################################
;==============================================================================

;### MEMINI -> Initialisiert den Bildschirm
;### Ausgabe    C=Xlen, B=Ylen, E=Paper, D=Pen, A=Border
memini  ld a,(scrbrd)
        ld de,(scrpap)
        ld bc,(scrxln)
        ret

;### MEMCLR -> Löscht den kompletten Bildschirm
memclr  ld hl,scrmap
        ld e,l:ld d,h
        inc de
        ld (hl),0
        ld bc,max_xlen*max_ylen+max_ylen-1
        ldir
        ret

;### MEMSRU -> Scrollt Bildschirm nach oben und fügt unten Leerzeile ein
memsru  call memsru0
        ld de,scrmap
        ld a,c
        or b
        jr z,memsru1
        ld hl,max_xlen+1
        add hl,de
        ldir
memsru1 ld l,e
        ld h,d
        inc de
        ld (hl),0
        ld bc,max_xlen
        ldir
        ret
memsru0 ld a,(scryln)
        dec a
memsru2 
if max_xlen=80
        ld c,a
        ld b,0
        add a
        add a
        add c
        add a       ;*10
        ld l,a
        ld h,b
        add hl,hl
        add hl,hl   ;*40
        add hl,hl   ;*80
        add hl,bc   ;*81
else
        push de
        ld de,max_xlen+1
        call clcm16
        pop de
endif
        ld c,l
        ld b,h
        ret

;### MEMSRD -> Scrollt Bildschirm nach unten und fügt oben Leerzeile ein
memsrd  call memsru0
        ld de,max_xlen
        ld hl,scrmap
        add hl,de
        add hl,bc
        ex de,hl
        ld a,c
        or b
        jr z,memsrd1
        ld hl,scrmap-1
        add hl,bc
        lddr
memsrd1 ld hl,-max_xlen
        add hl,de
        ex de,hl
        jr memsru1

;### MEMPLT -> Fügt Text in Bildschirm ein
;### Eingabe    HL=Text, E=Spalte, D=Zeile, C=Länge
memplt  push hl:push de:push bc
        push bc
        push hl
        call memplt0
        ex de,hl
        pop hl
        pop bc
        ld b,0
        ldir
        pop bc:pop de:pop hl
        ret
memplt0 ld a,d
        call memsru2
        ex de,hl
        ld h,0
        add hl,bc
        ld bc,scrmap
        add hl,bc
        ret

;### MEMFLL -> Füllt Bildschirm-Bereich mit gleichem Zeichen
;### Eingabe    A=Zeichen, E=Spalte, D=Zeile, C=XLen, B=YLen
memfll  push af:push de:push bc
        push bc
        push af
        call memplt0
        pop af
        pop bc
        ld de,max_xlen+1
memfll1 push bc
        push hl
memfll2 ld (hl),a
        inc hl
        dec c
        jr nz,memfll2
        pop hl
        add hl,de
        pop bc
        djnz memfll1
        pop bc:pop de:pop af
        ret

;### MEMCON -> Cursor positionieren und einblenden
;### Eingabe    E=Spalte, D=Zeile
memcfl  db 0
memcps  dw 0
memcon  ld (memcps),de
        ld a,1
        ld (memcfl),a
        push de
        call memplt0
        ld a,(hl)
        or a
        jr nz,memcon1
        ld a," "
memcon1 ld (scrcur),a
        pop de
        ret

;### MEMCOF -> Cursor ausblenden
memcof  xor a
        ld (memcfl),a
        ret

;### MEMOPT -> Zeile "optimieren" (Leerzeichen am Ende durch Nullen ersetzen)
;### Eingabe    D=Zeile
;### Verändert  AF,BC,DE,HL
memopt  ld e,max_xlen-1
        call memplt0
        ld bc,max_xlen*256+32
memopt1 ld a,(hl)
        or a
        jr z,memopt5
        cp c
        jr nz,memopt2
        ld (hl),0
memopt5 dec hl
        djnz memopt1
        ret
memopt2 xor a
memopt3 cp (hl)
        jr nz,memopt4
        ld (hl),c
memopt4 dec hl
        djnz memopt3
        ret


;==============================================================================
;### SCREEN-ROUTINEN (WINDOW) #################################################
;==============================================================================

;### WININI -> Initialisiert den Bildschirm und updatet Größe und Farben
;### Eingabe    A=Rahmen, E=Paper, D=Pen, C=Xlen, B=Ylen
winini  push bc
        ld (16*3+prgwinobj0+4),a
        ld (16*6+prgwinobj0+4),a
        ld c,a
        add a:add a:add a:add a
        or c
        ld (16*1+prgwinobj+4+1),a
        ld a,e
        add 128
        ld (16*0+prgwinobj+4),a
        ld (16*2+prgwinobj0+4),a
        ld (16*4+prgwinobj0+4),a
        ld (16*5+prgwinobj0+4),a
        ld (16*7+prgwinobj0+4),a
        ld (16*8+prgwinobj0+4),a
        and 127
        add a:add a:add a:add a
        or d
        ld (prgwincur1+2),a
        ld a,d
        add a:add a:add a:add a
        or e
        ld (prgwinbuf+2),a
        ld (prgwincur0+2),a
        ld ix,prgwinlin
        db #fd:ld l,max_ylen
        ld b,0
        ld de,smlfnt
        ld hl,scrmap
winini1 ld (ix+0),l
        ld (ix+1),h
        ld (ix+2),a
        ld (ix+3),128
        ld (ix+4),e
        ld (ix+5),d
        ld c,6
        add ix,bc
        ld c,max_xlen+1
        add hl,bc
        db #fd:dec l
        jr nz,winini1
        pop de                  ;e=xlen, d=ylen
        call wincon0            ;hl=xlen*4+2, de=ylen*6+8
        dec de:dec de:dec de:dec de
        inc hl
        inc hl                  ;HL=Xlen in Pixeln+4, DE=Ylen in Pixeln+4

        ld (prgwindat+08),hl
        ld (prgwindat+10),de
        ld (prgwindat+20),hl
        ld (prgwindat+22),de
        ld (prgwindat+24),hl
        ld (prgwindat+26),de
        ld (prgwinobj+16+10),hl
        ld (prgwinobj+16+12),de
        ld (prgwindat+16),hl
        ld (16*3+prgwinobj0+10),hl
        ld (16*6+prgwinobj0+10),hl
        dec hl:dec hl
        ld (16*4+prgwinobj0+10),hl
        ld (16*5+prgwinobj0+10),hl
        ld (16*7+prgwinobj0+10),hl
        ld (16*8+prgwinobj0+10),hl

        dec de             :ld (16*8+prgwinobj0+8),de
        ld hl,1+4:add hl,de:ld (16*7+prgwinobj0+8),hl
        inc hl             :ld (16*6+prgwinobj0+8),hl
        ld de,7  :add hl,de:ld (prgwindat+18),hl

        ld a,(memcfl)
        or a
        ret z
        ld de,(memcps)
        jp wincon1

;### WINCLR -> Löscht den kompletten Bildschirm
winclr  ld de,0*256+256-2
        jp msgsnd0

;### WINSRU -> Scrollt Bildschirm nach oben und fügt unten Leerzeile ein
winsru  ld de,30+prgwintxl*256+35+prgwintxl
        xor a
winsru1 ld (prgwindat+14),a
        push de
        call msgsnd0
        ld de,6
        ld c,MSC_DSK_WINMVY
        call msgsnd2
        rst #30
        call msgdsk                 ;capture scroll-message
        cp MSR_DSK_WSCROL
        jr z,winsru2
        db #dd:ld l,PRC_ID_DESKTOP  ;-> if it's a different, send again and skip
        ld a,(prgprzn)
        db #dd:ld h,a
        call msgsnd3
winsru2 ld a,6
        ld (prgwindat+14),a
        pop de
        ld e,-2
        jp msgsnd0

;### WINSRD -> Scrollt Bildschirm nach unten und fügt oben Leerzeile ein
winsrd  ld de,33+prgwintxl*256+32+prgwintxl
        ld a,12
        jr winsru1

;### WINPLT -> Fügt Text in Bildschirm ein
;### Eingabe    HL=Text, E=Spalte, D=Zeile, C=Länge
winplt  push de
        ld de,scrbuf
        xor a
        ld b,a
        ldir
        ld (de),a
        pop de
        push de
        call memopt
        pop de
        call wincon0
        ld (prgwinobj0+16+6),hl
        ld (prgwinobj0+16+8),de
        ld e,28+prgwintxl
winplt0 call msgsnd0
        rst #30
        ret

;### WINFLL -> Füllt Bildschirm-Bereich mit gleichem Zeichen
;### Eingabe    A=Zeichen, E=Spalte, D=Zeile, C=XLen, B=YLen
winfll  push af
        push de
        push bc
        ld e,b
winfll1 push de
        call memopt
        pop de
        inc d
        dec e
        jr nz,winfll1
        pop bc
        pop de
        pop af
        cp 32
        jr z,winfll2
        inc d:inc d
        xor a
        sub b
        ld e,a
        jr winplt0
winfll2 push bc             ;*** Leerzeichen-Sonderfall
        call wincon0
        ld (prgwinobj0+32+6),hl
        ld (prgwinobj0+32+8),de
        pop de
        call wincon0
        dec hl:dec hl
        ld (prgwinobj0+32+10),hl
        ld hl,-8
        add hl,de
        ld (prgwinobj0+32+12),hl
        ld e,29
        jr winplt0

;### WINCON -> Cursor positionieren und einblenden
;### Eingabe    E=Spalte, D=Zeile
wincon  call wincon1
        ld e,27+prgwintxl
        call msgsnd0
        rst #30
        ret
wincon1 call wincon0
        ld (0*16+prgwinobj0+6),hl
        ld (0*16+prgwinobj0+8),de
        ld (9*16+prgwinobj0+6),hl
        ld (9*16+prgwinobj0+8),de
        ld a,5
        ld (prgwinobj0+2),a
        ret
wincon0 ld l,e
        ld h,0
        add hl,hl
        add hl,hl
        inc hl:inc hl       ;hl=e*4+2
        ex de,hl
        ld l,h
        ld h,0
        add hl,hl
        ld c,l:ld b,h
        add hl,hl
        add hl,bc
        ld bc,8
        add hl,bc
        ex de,hl            ;de=d*6+8
        ret

;### WINCOF -> Cursor ausblenden
wincof  ld a,64
        ld (prgwinobj0+2),a
        ld e,36+prgwintxl
        call msgsnd0
        rst #30
        ret


;==============================================================================
;### SCREEN-ROUTINEN (FULLSCREEN) #############################################
;==============================================================================

;### FULAKT -> Stoppt Desktop und aktiviert Fullscreen Mode
;### Ausgabe    CF=1 -> nicht möglich, da Desktop bereits eingefroren ist oder Fullscreen derzeit für Plattform nicht unterstützt wird
fulakt
if computer_mode=1
        ld a,(cfgcpctyp)        ;no fullscreen for MSX1
        and #1f
        cp 7
        scf
        ret z
endif
if computer_mode=2              ;no fullscreen for PCW
        scf
        ret
else
        ld a,(prgwin)           ;Desktop abschalten
        ld d,a
        ld e,-1
        ld a,DSK_SRV_DSKSTP
        call dsksrv
        dec d
        scf
        ret z
        ld a,DSK_SRV_MODGET     ;Mode merken
        call dsksrv
        ld (fulbuf),de
        ld ix,fulbuf+2
        ld b,16                 ;Farben merken
fulakt1 push bc
        push ix
        ld a,16
        sub b
        ld e,a
        ld a,DSK_SRV_COLGET
        call dsksrv
        pop ix
        pop bc
        ld (ix+0),d
        ld (ix+1),l
        inc ix:inc ix
        djnz fulakt1
if computer_mode=0      ;*** CPC
        ;ld a,(cfgcpctyp)
        ;rla
        ;jr nc,fulakt2      ;##!!## WOZU??
        ;ld a,2
        ;ld (fulbuf),a
;fulakt2
        call fulclr             ;Bildschirm löschen
        ld e,2
        ld hl,jmp_scrset        ;Mode 2 merken
        rst #28
        ld b,#7f                ;Mode 2 aktivieren
        ld a,#8c+2
        out (c),a
        ld hl,0                 ;Offset setzen
        call fulset
        or a
        ret
elseif computer_mode=1  ;*** MSX
        ld hl,#217
        ld de,fulaktt+9
        push de
        ld bc,1
        ld a,(prgbnknum)
        add a:add a:add a:add a
        inc a
        rst #20:dw jmp_bnkcop
        pop hl
        set 7,(hl)
        ld hl,fulaktt           ;Screen 0/80 aktivieren
        ld bc,256*14+0
        call vdpreg
        ld bc,10
        call fulakt4
        ld hl,#1000
        call vdpwrt
        ld hl,fulfnt            ;Char0=Leer
        ld bc,8*256+#98
        otir
        ld hl,32*8+#1000        ;Font kopieren
        call vdpwrt
        ld hl,fulfnt
        ld bc,#98
        ld a,7
fulakt2 otir
        dec a
        jr nz,fulakt2
        or a
        ret
fulakt4 ld hl,#0000             ;Screen und Blink resetten
        call vdpwrt
        xor a
fulakt3 out (#98),a
        djnz fulakt3
        dec c
        jr nz,fulakt3
        ret
fulaktt db #04,#70,#03,#27,#02,#36,#07,#21,#08,#02,0,0,#12,#42

elseif computer_mode=3  ;*** EP
        ld ix,mftdat5
        ld hl,jmp_bnk16c
        rst #28
        ei
        call fulclr
        xor a
        call fulset
        or a
        ret

elseif computer_mode=4  ;*** SVM
        in a,(P_VIDPTR_L):ld (fulscradr+0),a
        in a,(P_VIDPTR_H):ld (fulscradr+1),a
        in a,(P_VIDPTR_U):ld (fulscradr+2),a
        ld c,P_MPTRX_LO
        ld hl,-256
        out (c),l:inc c
        out (c),h:inc c
        out (c),l:inc c
        out (c),h
        call fulclr
        ld a,D_CHRFNT8X16
        out (P_CHRSEL),a
        ld bc,P_CHRDAT
        ld hl,svmfnt
        ld a,8
fulakt5 otir
        dec a
        jr nz,fulakt5
        ld a,D_CHRFNTCUR
        out (P_CHRSEL),a
        ld hl,svmcur
        ld bc,256*16+P_CHRDAT
        otir
        ret
svmcur  db 0,0,0,0,0,0,0,0,-1,-1,-1,-1,-1,-1,-1,-1

elseif computer_mode=5  ;*** NC
        call fulclr
        ld a,#c0
        out (#00),a
        or a
        ret

elseif computer_mode=6  ;*** NXT
        nextreg SPRITE_CONTROL_NR_15,%00010100      ;switch off sprites, ULS order (ula/tilemap in front of layer2 and sprites)
        nextreg TILEMAP_CONTROL_NR_6B,%11001011     ;enable tilemap, 80x32, use attribs in map, palette 0, texmode on, res(0), 512tilemode, tilemap over ula
        nextreg TILEMAP_BASE_ADR_NR_6E,0            ;tilemap starts at offset 0 in page5
        nextreg TILEMAP_GFX_ADR_NR_6F,80*32*2/256   ;tiledef starts behind tilemap in page5
        ld ix,mftdat1           ;prepare tiles
        ld hl,jmp_bnk16c
        rst #28
        or a
        ret
endif
endif

;### FULOFF -> Deaktiviert Fullscreen Mode und kehrt zum Desktop zurück
fuloff
if     computer_mode=2
else
        ld d,max_ylen
fuloff1 push de
        dec d
        call memopt             ;alle Zeilen optimieren
        pop de
        dec d
        jr nz,fuloff1

        ld de,(fulbuf)          ;##!!## cpc only
        ld hl,jmp_scrset        ;alten Mode merken
        rst #28

        call fuloff0
        ld ix,fulbuf+2
        ld b,4                  ;Farben wiederherstellen
fuloff2 push bc
        push ix
        ld a,4
        sub b
        ld e,a
        ld a,DSK_SRV_COLSET
        ld d,(ix+0)
        ld l,(ix+1)
        call dsksrv
        pop ix
        pop bc
        inc ix:inc ix
        djnz fuloff2
        ld a,DSK_SRV_DSKCNT     ;Desktop einschalten
        jp dsksrv
if computer_mode=0      ;*** CPC
fuloff0 call fulclr
        ld b,#7f                ;Mode wiederherstellen
        ld a,(fulbuf)
        add a,#8c
        out (c),a
        ld hl,0                 ;Null-Offset wiederherstellen
        call fulset
        ld de,25*256+80         ;Größe wiederherstellen
        jp fulini0
elseif computer_mode=1  ;*** MSX
fuloff0 ld bc,scrymx    ;24
        call fulakt4
        ld de,(fulbuf)
        set 7,e
        ld a,DSK_SRV_MODSET
        jp dsksrv
elseif computer_mode=2  ;*** PCW
        ;##!!## PCW
elseif computer_mode=3  ;*** EP
fuloff0 ld de,(fulbuf)
        set 7,e
        ld a,DSK_SRV_MODSET
        jp dsksrv
elseif computer_mode=4  ;*** SVM
fuloff0 call fulcof
        ld de,(fulbuf)
        set 7,e
        ld a,DSK_SRV_MODSET
        jp dsksrv
elseif computer_mode=5  ;*** NC
fuloff0 ld de,(fulbuf)
        set 7,e
        ld a,DSK_SRV_MODSET
        jp dsksrv
elseif computer_mode=6  ;*** NXT
fuloff0 nextreg SPRITE_CONTROL_NR_15,%00000011          ;SLU, sprites visible + no clipping
        nextreg CLIP_WINDOW_CONTROL_NR_1C,1             ;layer2 clip 256x128 in middle
        nextreg CLIP_LAYER2_NR_18,0
        nextreg CLIP_LAYER2_NR_18,255
        nextreg CLIP_LAYER2_NR_18,0
        nextreg CLIP_LAYER2_NR_18,255

        ld de,(fulbuf)
        set 7,e
        ld a,DSK_SRV_MODSET
        jp dsksrv
endif
endif

if computer_mode=0

;==============================================================================
;### SCREEN-ROUTINEN (CPC-FULLSCREEN) #########################################
;==============================================================================

fulofs  dw 0        ;0-2047

;### FULINI -> Initialisiert den Bildschirm und updatet Größe und Farben
;### Eingabe    A=Rahmen, E=Paper, D=Pen, C=Xlen, B=Ylen
fulini  ld a,c
        and #fe                 ;Xlen muß gerade sein
        ld c,a
        ld (scrxln),a
        push bc
        call fulhid             ;ausblenden
        ld a,(scryln)           ;bestehenden Text plotten
        ld b,a
        ld c,0
fulini2 push bc
        ld e,0
        ld d,c
        push de
        call memplt0            ;HL=Textadr
        push hl
        call clclen             ;C=Länge
        pop hl
        pop de
        inc c
        dec c
        jr z,fulini3
        ld e,0
        call fulplt
fulini3 pop bc
        inc c
        djnz fulini2
        ld a,(memcfl)
        or a
        ld de,(memcps)
        call nz,fulcon
        call fulshw             ;Farbe setzen
        pop de                  ;Größe setzen
fulini0 srl e
        ld b,#f5
        in a,(c)
        and #10
        ld a,30-12
        jr nz,fulini4
        sub 3
fulini4 push af
        ld bc,#bc00+1
        ld a,46-20
        call fulini1
        ld c,6
        ld e,d
        pop af
fulini1 out (c),c
        inc b
        out (c),e
        dec b
        inc c
        srl e
        add e
        out (c),c
        inc b
        out (c),a
        dec b
        ret

;### FULCLR -> Löscht den kompletten Bildschirm
fulclr  call fulhid
        ld ix,mftdat2
        ld hl,jmp_bnk16c
        rst #28
        ei
        jp fulshw

;### FULSRU -> Scrollt Bildschirm nach oben und fügt unten Leerzeile ein
fulsru  ld de,(scrxln)
        push de
        ld d,0
        ld hl,(fulofs)
        add hl,de
        call fulset
        pop de
        ld c,e
        dec d
fulsru1 ld e,0
        ld b,1
        jr fulfls

;### FULSRD -> Scrollt Bildschirm nach unten und fügt oben Leerzeile ein
fulsrd  ld a,(scrxln)
        push af
        neg
        ld d,-1
        ld e,a
        ld hl,(fulofs)
        add hl,de
        call fulset
        pop af
        ld c,a
        ld d,0
        jr fulsru1

;### FULPLT -> Fügt Text in Bildschirm ein
;### Eingabe    HL=Text, E=Spalte, D=Zeile, C=Länge
fulplt  db #fd:ld l,c   ;IYL=Länge
        push de
        ld de,scrbuf
        ld b,0
        ldir            ;scrbuf=Textadr
        pop de
        call fuladr     ;DE=ScrAdr
        ld ix,mftdat1
        ld hl,jmp_bnk16c
        rst #28
        ei
        ret

;### FULFLL -> Füllt Bildschirm-Bereich mit gleichem Zeichen
;### Eingabe    A=Zeichen, E=Spalte, D=Zeile, C=XLen, B=YLen
fulfll  ld (scrbuf),a
        ld hl,0
        ld (mftout3),hl
fulfll1 push bc
        push de
        db #fd:ld l,c
        call fuladr
        ld ix,mftdat1
        ld hl,jmp_bnk16c
        rst #28
        ei
        pop de
        pop bc
        inc d
        djnz fulfll1
        db #21:inc ix
        ld (mftout3),hl
        ret

;### FULFLS -> Füllt Bildschirm-Bereich mit Spaces
;### Eingabe    E=Spalte, D=Zeile, C=XLen, B=YLen
fulfls  push bc
        push de
        db #fd:ld l,c
        call fuladr
        ld ix,mftdat4
        ld hl,jmp_bnk16c
        rst #28
        ei
        pop de
        pop bc
        inc d
        djnz fulfls
        ret

;### FULCON -> Cursor positionieren und einblenden
;### Eingabe    E=Spalte, D=Zeile
fulcps  dw 0
fulcon  call fuladr
        ld (fulcps),de
fulcon1 ld ix,mftdat3
        ld hl,jmp_bnk16c
        rst #28
        ei
        ret

;### FULCOF -> Cursor ausblenden
fulcof  ld de,(fulcps)
        jr fulcon1

;### FULADR -> Berechnet Bildschirm-Adresse von Zeichen
;### Eingabe    E=Spalte, D=Zeile
;### Ausgabe    DE=Screenadresse
;### Verändert  AF,BC,HL
fuladr  ld c,e
        ld b,0
        ld a,d
        ld de,(scrxln)
        ld d,b
        call clcm16
        add hl,bc   ;HL=D*Xlen+E
        ld de,(fulofs)
        add hl,de   ;HL = D*80 + E + ScrollOffset
        ld a,h
        add #c0
        ld h,a
        res 3,h
        ex de,hl
        ret

;### FULHID -> Blendet Bildschirm aus
fulhid  ld a,(cfgcpctyp)
        rla
        ld de,84*256+84
        jr c,fulshw1
        ld a,(scrpap)
        push af
        ld e,0
        call fulhid1
        pop af
fulhid0 ld e,1
fulhid1 add a
        ld c,a
        ld b,0
        ld hl,fulbuf+2
        add hl,bc
        ld d,(hl)
        inc hl
        ld l,(hl)
        ld a,DSK_SRV_COLSET
        jp dsksrv

;### FULSHW -> Blendet Bildschirm ein
fulshw  ld a,(cfgcpctyp)
        rla
        ld a,(scrpen)
        jr nc,fulhid0
        ld de,75*256+84
fulshw1 ld bc,#7f00
        out (c),c
        out (c),e
        inc c
        out (c),c
        out (c),d
        ret

;### FULSET -> Setzt Bildschirm-Offset neu
;### Eingabe    HL=neuer Offset
fulset  ld a,h
        and 7
        ld h,a
        ld (fulofs),hl
        srl h:rr l
        ld a,48
        add h
        ld bc,#bc00+12
        di
        out (c),c
        inc b
        out (c),a
        dec b
        inc c
        out (c),c
        inc b
        out (c),l
        ei
        ret

;### FULREL -> Relociert Fullscreen-Textausgabe
fulrel  ld ix,mftdat1
        ld a,(prgbnknum)
        ld (ix+0),a
        ld (ix+3),a
        ld (ix+6),a
        ld (ix+9),a
        ld hl,mftout+3
        call fulrel0
        ld hl,mftchrtab
        ld a,h
        set 6,a
        res 7,a
        ld (mftout4+1),a
        ld b,0
        ld ix,mftbuf+128
fulrel1 call fulrel2
        inc hl
        inc hl
        set 6,h
        res 7,h
        ld (ix-128),l
        inc ix
        ld (ix+127),h
        ex de,hl
        djnz fulrel1
        call fulrel2
        ld hl,mftbuf
        ld de,mftchrtab
        ld bc,512
        ldir
        ret
fulrel2 ld e,(hl)
        inc hl
        ld d,(hl)
        inc hl
        ex de,hl
        dec hl
        dec hl
fulrel0 set 6,(hl)
        res 7,(hl)
        ret

elseif computer_mode=1

;==============================================================================
;### SCREEN-ROUTINEN (MSX-FULLSCREEN) #########################################
;==============================================================================

fulfnt
db #00,#00,#00,#00,#00,#00,#00,#00  ;032( )
db #20,#20,#20,#20,#00,#00,#20,#00  ;033(!)
db #50,#50,#50,#00,#00,#00,#00,#00  ;034(")
db #50,#50,#F8,#50,#F8,#50,#50,#00  ;035(#)
db #20,#78,#A0,#70,#28,#F0,#20,#00  ;036($)
db #C0,#C8,#10,#20,#40,#98,#18,#00  ;037(%)
db #40,#A0,#40,#A8,#90,#98,#60,#00  ;038(&)
db #10,#20,#40,#00,#00,#00,#00,#00  ;039(')
db #10,#20,#40,#40,#40,#20,#10,#00  ;040(()
db #40,#20,#10,#10,#10,#20,#40,#00  ;041())
db #20,#A8,#70,#20,#70,#A8,#20,#00  ;042(*)
db #00,#20,#20,#F8,#20,#20,#00,#00  ;043(+)
db #00,#00,#00,#00,#00,#20,#20,#40  ;044(,)
db #00,#00,#00,#78,#00,#00,#00,#00  ;045(-)
db #00,#00,#00,#00,#00,#60,#60,#00  ;046(.)
db #00,#00,#08,#10,#20,#40,#80,#00  ;047(/)
db #70,#88,#98,#A8,#C8,#88,#70,#00  ;048(0)
db #20,#60,#A0,#20,#20,#20,#F8,#00  ;049(1)
db #70,#88,#08,#10,#60,#80,#F8,#00  ;050(2)
db #70,#88,#08,#30,#08,#88,#70,#00  ;051(3)
db #10,#30,#50,#90,#F8,#10,#10,#00  ;052(4)
db #F8,#80,#E0,#10,#08,#10,#E0,#00  ;053(5)
db #30,#40,#80,#F0,#88,#88,#70,#00  ;054(6)
db #F8,#88,#10,#20,#20,#20,#20,#00  ;055(7)
db #70,#88,#88,#70,#88,#88,#70,#00  ;056(8)
db #70,#88,#88,#78,#08,#10,#60,#00  ;057(9)
db #00,#00,#20,#00,#00,#20,#00,#00  ;058(doppelpunkt)
db #00,#00,#20,#00,#00,#20,#20,#40  ;059(;)
db #18,#30,#60,#C0,#60,#30,#18,#00  ;060(<)
db #00,#00,#F8,#00,#F8,#00,#00,#00  ;061(=)
db #C0,#60,#30,#18,#30,#60,#C0,#00  ;062(>)
db #70,#88,#08,#10,#20,#00,#20,#00  ;063(?)
db #70,#88,#08,#68,#A8,#A8,#70,#00  ;064(@)
db #20,#50,#88,#88,#F8,#88,#88,#00  ;065(A)
db #F0,#48,#48,#70,#48,#48,#F0,#00  ;066(B)
db #30,#48,#80,#80,#80,#48,#30,#00  ;067(C)
db #E0,#50,#48,#48,#48,#50,#E0,#00  ;068(D)
db #F8,#80,#80,#F0,#80,#80,#F8,#00  ;069(E)
db #F8,#80,#80,#F0,#80,#80,#80,#00  ;070(F)
db #70,#88,#80,#B8,#88,#88,#70,#00  ;071(G)
db #88,#88,#88,#F8,#88,#88,#88,#00  ;072(H)
db #70,#20,#20,#20,#20,#20,#70,#00  ;073(I)
db #38,#10,#10,#10,#90,#90,#60,#00  ;074(J)
db #88,#90,#A0,#C0,#A0,#90,#88,#00  ;075(K)
db #80,#80,#80,#80,#80,#80,#F8,#00  ;076(L)
db #88,#D8,#A8,#A8,#88,#88,#88,#00  ;077(M)
db #88,#C8,#C8,#A8,#98,#98,#88,#00  ;078(N)
db #70,#88,#88,#88,#88,#88,#70,#00  ;079(O)
db #F0,#88,#88,#F0,#80,#80,#80,#00  ;080(P)
db #70,#88,#88,#88,#A8,#90,#68,#00  ;081(Q)
db #F0,#88,#88,#F0,#A0,#90,#88,#00  ;082(R)
db #70,#88,#80,#70,#08,#88,#70,#00  ;083(S)
db #F8,#20,#20,#20,#20,#20,#20,#00  ;084(T)
db #88,#88,#88,#88,#88,#88,#70,#00  ;085(U)
db #88,#88,#88,#88,#50,#50,#20,#00  ;086(V)
db #88,#88,#88,#A8,#A8,#D8,#88,#00  ;087(W)
db #88,#88,#50,#20,#50,#88,#88,#00  ;088(X)
db #88,#88,#88,#70,#20,#20,#20,#00  ;089(Y)
db #F8,#08,#10,#20,#40,#80,#F8,#00  ;090(Z)
db #70,#40,#40,#40,#40,#40,#70,#00  ;091([)
db #00,#00,#80,#40,#20,#10,#08,#00  ;092(\)
db #70,#10,#10,#10,#10,#10,#70,#00  ;093(])
db #20,#50,#88,#00,#00,#00,#00,#00  ;094(^)
db #00,#00,#00,#00,#00,#00,#F8,#00  ;095(_)
db #40,#20,#10,#00,#00,#00,#00,#00  ;096(`)
db #00,#00,#70,#08,#78,#88,#78,#00  ;097(a)
db #80,#80,#B0,#C8,#88,#C8,#B0,#00  ;098(b)
db #00,#00,#70,#88,#80,#88,#70,#00  ;099(c)
db #08,#08,#68,#98,#88,#98,#68,#00  ;100(d)
db #00,#00,#70,#88,#F8,#80,#70,#00  ;101(e)
db #10,#28,#20,#F8,#20,#20,#20,#00  ;102(f)
db #00,#00,#68,#98,#98,#68,#08,#70  ;103(g)
db #80,#80,#F0,#88,#88,#88,#88,#00  ;104(h)
db #20,#00,#60,#20,#20,#20,#70,#00  ;105(i)
db #10,#00,#30,#10,#10,#10,#90,#60  ;106(j)
db #40,#40,#48,#50,#60,#50,#48,#00  ;107(k)
db #60,#20,#20,#20,#20,#20,#70,#00  ;108(l)
db #00,#00,#D0,#A8,#A8,#A8,#A8,#00  ;109(m)
db #00,#00,#B0,#C8,#88,#88,#88,#00  ;110(n)
db #00,#00,#70,#88,#88,#88,#70,#00  ;111(o)
db #00,#00,#B0,#C8,#C8,#B0,#80,#80  ;112(p)
db #00,#00,#68,#98,#98,#68,#08,#08  ;113(q)
db #00,#00,#B0,#C8,#80,#80,#80,#00  ;114(r)
db #00,#00,#78,#80,#F0,#08,#F0,#00  ;115(s)
db #40,#40,#F0,#40,#40,#48,#30,#00  ;116(t)
db #00,#00,#90,#90,#90,#90,#68,#00  ;117(u)
db #00,#00,#88,#88,#88,#50,#20,#00  ;118(v)
db #00,#00,#88,#A8,#A8,#A8,#50,#00  ;119(w)
db #00,#00,#88,#50,#20,#50,#88,#00  ;120(x)
db #00,#00,#88,#88,#98,#68,#08,#70  ;121(y)
db #00,#00,#F8,#10,#20,#40,#F8,#00  ;122(z)
db #18,#20,#20,#40,#20,#20,#18,#00  ;123({)
db #20,#20,#20,#00,#20,#20,#20,#00  ;124(|)
db #C0,#20,#20,#10,#20,#20,#C0,#00  ;125(})
db #40,#A8,#10,#00,#00,#00,#00,#00  ;126(~)
db #00,#20,#50,#88,#88,#88,#f8,#00  ;127
db #70,#88,#80,#80,#88,#70,#20,#60
db #90,#00,#00,#90,#90,#90,#68,#00
db #10,#20,#70,#88,#f8,#80,#70,#00
db #20,#50,#70,#08,#78,#88,#78,#00
db #48,#00,#70,#08,#78,#88,#78,#00
db #20,#10,#70,#08,#78,#88,#78,#00
db #20,#00,#70,#08,#78,#88,#78,#00
db #00,#70,#80,#80,#80,#70,#10,#60
db #20,#50,#70,#88,#f8,#80,#70,#00
db #50,#00,#70,#88,#f8,#80,#70,#00
db #20,#10,#70,#88,#f8,#80,#70,#00
db #50,#00,#00,#60,#20,#20,#70,#00
db #20,#50,#00,#60,#20,#20,#70,#00
db #40,#20,#00,#60,#20,#20,#70,#00
db #50,#00,#20,#50,#88,#f8,#88,#00
db #20,#00,#20,#50,#88,#f8,#88,#00
db #10,#20,#f8,#80,#f0,#80,#f8,#00
db #00,#00,#6c,#10,#7c,#90,#6c,#00
db #3c,#50,#90,#9c,#f0,#90,#9c,#00
db #60,#90,#00,#60,#90,#90,#60,#00
db #90,#00,#00,#60,#90,#90,#60,#00
db #40,#20,#00,#60,#90,#90,#60,#00
db #40,#a0,#00,#a0,#a0,#a0,#50,#00
db #40,#20,#00,#a0,#a0,#a0,#50,#00
db #90,#00,#90,#90,#b0,#50,#10,#e0
db #50,#00,#70,#88,#88,#88,#70,#00
db #50,#00,#88,#88,#88,#88,#70,#00
db #20,#20,#78,#80,#80,#78,#20,#20
db #18,#24,#20,#f8,#20,#e0,#5c,#00
db #88,#50,#20,#f8,#20,#f8,#20,#00
db #c0,#a0,#a0,#c8,#9c,#88,#88,#8c
db #18,#20,#20,#f8,#20,#20,#20,#40
db #10,#20,#70,#08,#78,#88,#78,#00
db #10,#20,#00,#60,#20,#20,#70,#00
db #20,#40,#00,#60,#90,#90,#60,#00
db #20,#40,#00,#90,#90,#90,#68,#00
db #50,#a0,#00,#a0,#d0,#90,#90,#00
db #28,#50,#00,#c8,#a8,#98,#88,#00
db #00,#70,#08,#78,#88,#78,#00,#f8
db #00,#60,#90,#90,#90,#60,#00,#f0
db #20,#00,#20,#40,#80,#88,#70,#00
db #00,#00,#00,#f8,#80,#80,#00,#00
db #00,#00,#00,#f8,#08,#08,#00,#00
db #84,#88,#90,#a8,#54,#84,#08,#1c
db #84,#88,#90,#a8,#58,#a8,#3c,#08
db #20,#00,#00,#20,#20,#20,#20,#00
db #00,#00,#24,#48,#90,#48,#24,#00
db #00,#00,#90,#48,#24,#48,#90,#00
db #90,#48,#24,#90,#48,#24,#90,#48
db #a8,#54,#a8,#54,#a8,#54,#a8,#54
db #6c,#b4,#d8,#6c,#b4,#d8,#6c,#b4
db #20,#20,#20,#20,#20,#20,#20,#20
db #20,#20,#20,#e0,#20,#20,#20,#20
db #20,#20,#e0,#20,#e0,#20,#20,#20
db #50,#50,#50,#d0,#50,#50,#50,#50
db #00,#00,#00,#f0,#50,#50,#50,#50
db #00,#00,#e0,#20,#e0,#20,#20,#20
db #50,#50,#d0,#10,#d0,#50,#50,#50
db #50,#50,#50,#50,#50,#50,#50,#50
db #00,#00,#f0,#10,#d0,#50,#50,#50
db #50,#50,#d0,#10,#f0,#00,#00,#00
db #50,#50,#50,#f0,#00,#00,#00,#00
db #20,#20,#e0,#20,#e0,#00,#00,#00
db #00,#00,#00,#e0,#20,#20,#20,#20
db #20,#20,#20,#3c,#00,#00,#00,#00
db #20,#20,#20,#fc,#00,#00,#00,#00
db #00,#00,#00,#fc,#20,#20,#20,#20
db #20,#20,#20,#3c,#20,#20,#20,#20
db #00,#00,#00,#fc,#00,#00,#00,#00
db #20,#20,#20,#fc,#20,#20,#20,#20
db #20,#20,#3c,#20,#3c,#20,#20,#20
db #50,#50,#50,#5c,#50,#50,#50,#50
db #50,#50,#5c,#40,#7c,#00,#00,#00
db #00,#00,#7c,#40,#5c,#50,#50,#50
db #50,#50,#dc,#00,#fc,#00,#00,#00
db #00,#00,#fc,#00,#dc,#50,#50,#50
db #50,#50,#5c,#40,#5c,#50,#50,#50
db #00,#00,#fc,#00,#fc,#00,#00,#00
db #50,#50,#dc,#00,#dc,#50,#50,#50
db #20,#20,#fc,#00,#fc,#00,#00,#00
db #50,#50,#50,#fc,#00,#00,#00,#00
db #00,#00,#fc,#00,#fc,#20,#20,#20
db #00,#00,#00,#fc,#50,#50,#50,#50
db #50,#50,#50,#7c,#00,#00,#00,#00
db #20,#20,#3c,#20,#3c,#00,#00,#00
db #00,#00,#3c,#20,#3c,#20,#20,#20
db #00,#00,#00,#7c,#50,#50,#50,#50
db #50,#50,#50,#fc,#50,#50,#50,#50
db #20,#20,#fc,#20,#fc,#20,#20,#20
db #20,#20,#20,#e0,#00,#00,#00,#00
db #00,#00,#00,#3c,#20,#20,#20,#20
db #fc,#fc,#fc,#fc,#fc,#fc,#fc,#fc
db #00,#00,#00,#00,#fc,#fc,#fc,#fc
db #e0,#e0,#e0,#e0,#e0,#e0,#e0,#e0
db #1c,#1c,#1c,#1c,#1c,#1c,#1c,#1c
db #fc,#fc,#fc,#fc,#00,#00,#00,#00
db #00,#00,#68,#90,#90,#90,#68,#00
db #30,#48,#48,#70,#48,#48,#70,#c0
db #f8,#88,#80,#80,#80,#80,#80,#00
db #f8,#50,#50,#50,#50,#50,#98,#00
db #f8,#88,#40,#20,#40,#88,#f8,#00
db #00,#00,#78,#90,#90,#90,#60,#00
db #00,#50,#50,#50,#50,#68,#80,#80
db #00,#50,#a0,#20,#20,#20,#20,#00
db #f8,#20,#70,#a8,#a8,#70,#20,#f8
db #20,#50,#88,#f8,#88,#50,#20,#00
db #70,#88,#88,#88,#50,#50,#d8,#00
db #30,#40,#40,#20,#50,#50,#50,#20
db #00,#00,#00,#50,#a8,#a8,#50,#00
db #08,#70,#a8,#a8,#a8,#70,#80,#00
db #38,#40,#80,#f8,#80,#40,#38,#00
db #70,#88,#88,#88,#88,#88,#88,#00
db #00,#f8,#00,#f8,#00,#f8,#00,#00
db #20,#20,#f8,#20,#20,#00,#f8,#00
db #c0,#30,#08,#30,#c0,#00,#f8,#00
db #18,#60,#80,#60,#18,#00,#f8,#00
db #10,#28,#20,#20,#20,#20,#20,#20
db #20,#20,#20,#20,#20,#20,#a0,#40
db #00,#20,#00,#f8,#00,#20,#00,#00
db #00,#50,#a0,#00,#50,#a0,#00,#00
db #00,#18,#24,#24,#18,#00,#00,#00
db #00,#30,#78,#78,#30,#00,#00,#00
db #00,#00,#00,#00,#30,#00,#00,#00
db #04,#04,#08,#08,#90,#70,#20,#00
db #a0,#50,#50,#50,#00,#00,#00,#00
db #40,#a0,#20,#40,#e0,#00,#00,#00
db #00,#00,#30,#30,#30,#30,#00,#00
db #fc,#fc,#fc,#fc,#fc,#fc,#fc,#fc

;### FULINI -> Initialisiert den Bildschirm und updatet Größe und Farben
;### Eingabe    A=Rahmen, E=Paper, D=Pen, C=Xlen, B=Ylen
fulini  ld a,c
        and #fe                 ;Xlen muß gerade sein
        ld c,a
        ld (scrxln),a
        ld a,e
        ld e,1
        push de
        call fulini1
        pop de
        ld a,d
        ld e,2
        call fulini1
        jr fulall
fulini1 add a           ;farben immer für interne msx grafik setzen
        ld c,a
        ld b,0
        ld hl,fulbuf+2
        add hl,bc
        ld c,(hl)
        inc hl
        ld b,(hl)       ;e=pen, bc=rgb
        ld a,e
        di
        out (#99),a
        ld a,16+128
        ei
        out (#99),a
        ld a,c
        and #e
        rrca
        ld l,a
        ld a,b
        and #e
        add a:add a:add a
        or l
        out (#9a),a
        ld a,c
        and #e0
        rlca:rlca:rlca
        out (#9a),a
        ret

;### FULCLR -> Löscht den kompletten Bildschirm
fulclr
;### FULSRU -> Scrollt Bildschirm nach oben und fügt unten Leerzeile ein
fulsru
;### FULSRD -> Scrollt Bildschirm nach unten und fügt oben Leerzeile ein
fulsrd
;### FULALL -> Zeichnet den gesamten Bildschirm neu
fulall  ld de,0
        call fuladr
        call vdpwrt
        ld hl,scrmap
        ld a,scrymx
        ld c,#98
fulall1 ld b,80
        otir
        inc hl
        dec a
        jr nz,fulall1
        ret

;### FULPLT -> Fügt Text in Bildschirm ein
;### Eingabe    HL=Text, E=Spalte, D=Zeile, C=Länge
fulplt  push hl
        push bc
        call fuladr
        call vdpwrt
        pop bc
        pop hl
        ld b,c
        ld c,#98
        otir
        ret

;### FULFLL -> Füllt Bildschirm-Bereich mit gleichem Zeichen
;### Eingabe    A=Zeichen, E=Spalte, D=Zeile, C=XLen, B=YLen
fulfls
fulfll  push bc
        push af
        call fuladr
        pop af
        pop bc
        ld de,80
fulfll1 push bc
        push hl
        push af
        call vdpwrt
        pop af
fulfll2 out (#98),a
        dec c
        jr nz,fulfll2
        pop hl
        add hl,de
        pop bc
        djnz fulfll1
        ret

;### FULCON -> Cursor positionieren und einblenden
;### Eingabe    E=Spalte, D=Zeile
fulcps  dw 0
fulcon  push de
        srl e
        srl e
        srl e
        ld a,d
        call fuladr1
        ld bc,#800
        add hl,bc
        ld (fulcps),hl
        call vdpwrt
        pop de
        ld a,e
        and 7
        inc a
        ld b,a
        ld a,1
fulcon1 rrca
        djnz fulcon1
        out (#98),a
        ret

;### FULCOF -> Cursor ausblenden
fulcof  ld hl,(fulcps)
        call vdpwrt
        xor a
        out (#98),a
        ret

;### FULADR -> Berechnet Bildschirm-Adresse von Zeichen
;### Eingabe    E=Spalte, D=Zeile
;### Ausgabe    HL=Screenadresse
;### Verändert  AF,BC,HL,D
fuladr  ld a,d
        add a:add a:add a   ;*8
fuladr1 ld l,a
        ld h,0
        ld d,h
        add hl,hl           ;*16
        ld c,l
        ld b,h              ;BC=*16
        add hl,hl
        add hl,hl           ;*64
        add hl,bc           ;*64+*16=*80
        add hl,de
        ret

;### VDPREG -> Setzt eine Anzahl an VDP-Registern
;### Eingabe    HL=Register-Data, C=erstes Register, B=Anzahl Register
;### Verändert  AF,BC,HL
vdpreg  ld a,c
        di
        out (#99),a
        ld  a,17+128
        ei
        out (#99),a
        ld  c,#9B
        otir
        ret

;### VDPWRT -> VDP-Adresse zum Schreiben setzen
;### Eingabe    HL=Adresse
;### Verändert  AF,HL
vdpwrt  call vdpwai
        xor a
        rlc h
        rla
        rlc h
        rla
        srl h
        srl h
        di
        out (#99),a
        ld a,14+128
        out (#99),a
        ld a,l
        nop
        out (#99),a
        ld a,h
        or 64
        ei
        out (#99),a
        ret

;### VDPWAI -> Wartet, bis VDP für Kommando bereit ist
;### Verändert  AF
vdpwai  ld  a,2
        di
        out (#99),a
        ld a,15+128
        out (#99),a
        in a,(#99)
        rra
        ld a,0
        out (#99),a
        ld a,15+128
        ei
        out (#99),a
        jr c,vdpwai
        ret

elseif computer_mode=2
    ;##!!## PCW
elseif computer_mode=3

;==============================================================================
;### SCREEN-ROUTINEN (EP-FULLSCREEN) ##########################################
;==============================================================================

fulofs  db 0        ;0-24

;### FULINI -> Initialisiert den Bildschirm und updatet Größe und Farben
;### Eingabe    A=Rahmen, E=Paper, D=Pen, C=Xlen, B=Ylen
fulini  ld a,c
        and #fe                 ;Xlen muß gerade sein
        ld c,a
        ld (scrxln),a
        call fulhid             ;ausblenden
        ld a,(scryln)           ;bestehenden Text plotten
        ld b,a
        ld c,0
fulini2 push bc
        ld e,0
        ld d,c
        push de
        call memplt0            ;HL=Textadr
        push hl
        call clclen             ;C=Länge
        pop hl
        pop de
        inc c
        dec c
        jr z,fulini3
        ld e,0
        call fulplt
fulini3 pop bc
        inc c
        djnz fulini2
        ld a,(memcfl)
        or a
        ld de,(memcps)
        call nz,fulcon
        xor a
        call fulset
        jp fulshw               ;Farbe setzen

;### FULCLR -> Löscht den kompletten Bildschirm
fulclr  call fulhid
        ld ix,mftdat2
        ld hl,jmp_bnk16c
        rst #28
        ei
        jp fulshw

;### FULSRU -> Scrollt Bildschirm nach oben und fügt unten Leerzeile ein
fulsru  ld a,(fulofs)
        inc a
        cp 25
        jr c,fulsru1
        xor a
fulsru1 call fulset
        ld a,(scryln)
        dec a
fulsru2 ld d,a
        ld e,0
        ld a,(scrxln)
        ld c,a
        ld b,1
        jr fulfls

;### FULSRD -> Scrollt Bildschirm nach unten und fügt oben Leerzeile ein
fulsrd  ld a,(fulofs)
        sub 1
        jr nc,fulsrd1
        ld a,24
fulsrd1 call fulset
        xor a
        jr fulsru2

;### FULPLT -> Fügt Text in Bildschirm ein
;### Eingabe    HL=Text, E=Spalte, D=Zeile, C=Länge
fulplt  db #fd:ld l,c   ;IYL=Länge
        push de
        ld de,scrbuf
        ld b,0
        ldir            ;scrbuf=Textadr
        pop de
        call fuladr     ;DE=ScrAdr
        ld ix,mftdat1
        ld hl,jmp_bnk16c
        rst #28
        ei
        ret

;### FULFLL -> Füllt Bildschirm-Bereich mit gleichem Zeichen
;### Eingabe    A=Zeichen, E=Spalte, D=Zeile, C=XLen, B=YLen
fulfll  ld (scrbuf),a
        ld hl,0
        ld (mftout3),hl
fulfll1 push bc
        push de
        db #fd:ld l,c
        call fuladr
        ld ix,mftdat1
        ld hl,jmp_bnk16c
        rst #28
        ei
        pop de
        pop bc
        inc d
        djnz fulfll1
        db #21:inc ix
        ld (mftout3),hl
        ret

;### FULFLS -> Füllt Bildschirm-Bereich mit Spaces
;### Eingabe    E=Spalte, D=Zeile, C=XLen, B=YLen
fulfls  push bc
        push de
        db #fd:ld l,c
        call fuladr
        ld ix,mftdat4
        ld hl,jmp_bnk16c
        rst #28
        ei
        pop de
        pop bc
        inc d
        djnz fulfls
        ret

;### FULCON -> Cursor positionieren und einblenden
;### Eingabe    E=Spalte, D=Zeile
fulcps  dw 0
fulcon  call fuladr
        ld (fulcps),de
fulcon1 ld ix,mftdat3
        ld hl,jmp_bnk16c
        rst #28
        ei
        ret

;### FULCOF -> Cursor ausblenden
fulcof  ld de,(fulcps)
        jr fulcon1

;### FULADR -> Berechnet Bildschirm-Adresse von Zeichen
;### Eingabe    E=Spalte, D=Zeile
;### Ausgabe    DE=Screenadresse
;### Verändert  AF,BC,HL
fuladr  ld a,(fulofs)
        add d
        cp 25
        jr c,fuladr1
        sub 25
fuladr1 push de
        ld de,8*80
        call clcm16
        pop de
        ld d,#c0
        ld a,(scrxln)
        srl a
        cpl
        add 41
        add e
        ld e,a
        add hl,de
        ex de,hl
        ret

;### FULHID -> Blendet Bildschirm aus
fulhid  ld a,(scrpap)
        ld iy,scrlptadr+8
        push af
        call fulhid1
        pop af
fulhid0 ld iy,scrlptadr+9
fulhid1 add a
        ld e,a
        ld d,0
        ld hl,fulbuf+2
        add hl,de
        ld e,(hl)
        inc hl
        ld d,(hl)
        ld ix,mftdat7
        ld hl,jmp_bnk16c
        rst #28
        ei
        ret

;### FULSHW -> Blendet Bildschirm ein
fulshw  ld a,(scrpen)
        jr fulhid0

;### FULSET -> Setzt Bildschirm-Offset neu
;### Eingabe    A=neuer Offset (0-24)
fulset  ld (fulofs),a
        add a:add a:add a
        ld e,a
        ld l,a
        ld h,0
        ld d,h
        add hl,hl
        add hl,hl
        add hl,de
        add hl,hl
        add hl,hl
        add hl,hl
        add hl,hl
        ld a,h
        add #c0
        db #fd:ld h,a
        ld a,l
        db #fd:ld l,a
        ld a,(scryln)
        add a:add a:add a
        ld d,a
        ld ix,mftdat6
        ld hl,jmp_bnk16c
        rst #28
        ei
        ret

;### FULREL -> Relociert Fullscreen-Textausgabe
fulrel  ld ix,mftdat1
        ld a,(prgbnknum)
        ld (ix+00),a
        ld (ix+03),a
        ld (ix+06),a
        ld (ix+09),a
        ld (ix+12),a
        ld (ix+15),a
        ld (ix+18),a
        ld hl,mftout+3
        call fulrel0
        ld hl,mftchrtab
        ld a,h
        set 6,a
        res 7,a
        ld (mftout4+1),a
        ld b,128+1
fulrel1 ld e,(hl)
        inc hl
        ld d,(hl)
        dec hl
        ex de,hl
        dec hl
        dec hl
        call fulrel0
        inc hl
        inc hl
        set 6,h
        res 7,h
        ex de,hl
        ld (hl),e
        inc hl
        ld (hl),d
        inc hl
        djnz fulrel1
        ret
fulrel0 set 6,(hl)
        res 7,(hl)
        ret

elseif computer_mode=4

;==============================================================================
;### SCREEN-ROUTINEN (SVM-FULLSCREEN) #########################################
;==============================================================================

fulscradr   ds 3

;### FULINI -> Initialisiert den Bildschirm und updatet Größe und Farben
;### Input      A=border colour, E=paper colour, D=pen colout, C=xlen, B=ylen
fulini  ld a,c
        and #fe         ;Xlen muß gerade sein
        ld c,a
        ld (scrxln),a
        ld a,e
        push de
        ld e,0
        call fulini1    ;paper
        pop af
        ld e,1
        call fulini1    ;pen
        ld a,(scrxln)
        ld de,8
        call clcm16
        ld a,l:out (P_VIDRESX_L),a
        ld a,h:out (P_VIDRESX_H),a
        ld a,(scryln)
        ld de,16
        call clcm16
        ld a,l:out (P_VIDRESY_L),a
        ld a,h:out (P_VIDRESY_H),a
        ld	a,D_VIDTXT8X16
    	out	(P_VIDMODE),a
        jr fulall
;a=index
fulini1 add a
        ld c,a
        ld b,0
        ld hl,fulbuf+2
        add hl,bc
        ld c,(hl)
        inc hl
        ld b,(hl)       ;bc=rgb, e=index
        ld a,e
        out (P_PALSEL),a
        ld a,b
        add a:add a:add a:add a
        out (P_PALR),a
        ld a,c
        and #f0
        out (P_PALG),a
        ld a,c
        add a:add a:add a:add a
        out (P_PALB),a
        ret

;### FULSRU -> Scrollt Bildschirm nach oben und fügt unten Leerzeile ein
;### FULSRD -> Scrollt Bildschirm nach unten und fügt oben Leerzeile ein
;### FULCLR -> Löscht den kompletten Bildschirm
fulsrd
fulsru
fulclr
;### FULALL -> redraw the complete screen
fulall  di
        ld a,(prgbnknum)  :out (P_MEMPTR1_U),a
        ld a,(fulscradr+2):out (P_MEMPTR2_U),a
        ld de,scrmap
        ld hl,(fulscradr+0)
        ld ixl,max_ylen
fulall1 ld a,e            :out (P_MEMPTR1_L),a
        ld a,d            :out (P_MEMPTR1_H),a
        ld a,l            :out (P_MEMPTR2_L),a
        ld a,h            :out (P_MEMPTR2_H),a
        ld a,max_xlen+1   :out (P_MEMDMA_L),a
        ld c,a
        xor a             :out (P_MEMDMA_H),a
        ld b,0
        ex de,hl
        add hl,bc
        ex de,hl
        ld bc,256
        add hl,bc
        dec ixl
        jr nz,fulall1
        ei
        ret

;### FULCOF -> Cursor ausblenden
fulcof  ld de,-1
;### FULCON -> place and show cursor
;### Eingabe    E=column, D=row
fulcon  ld a,e:out (P_TXTCURX),a
        ld a,d:out (P_TXTCURY),a
        ret

;### FULPLT -> Fügt Text in Bildschirm ein
;### Eingabe    HL=Text, E=Spalte, D=Zeile, C=Länge
fulplt  di
        ld a,l          :out (P_MEMPTR1_L),a
        ld a,h          :out (P_MEMPTR1_H),a
        ld a,(prgbnknum):out (P_MEMPTR1_U),a
        call fuladr
        ld a,c          :out (P_MEMDMA_L),a
        xor a           :out (P_MEMDMA_H),a
        ei
        ret

;### FULFLS -> Füllt Bildschirm-Bereich mit Spaces
;### Eingabe    E=Spalte, D=Zeile, C=XLen, B=YLen
fulfls  ld a,32
;### FULFLL -> Füllt Bildschirm-Bereich mit gleichem Zeichen
;### Eingabe    A=Zeichen, E=Spalte, D=Zeile, C=XLen, B=YLen
fulfll  push de
        push bc
        ld hl,fulfllb
        ld de,fulfllb+1
        ld (hl),a
        dec c
        ld b,0
        ldir
        pop bc
        pop de
fulfll1 push bc
        push de
        ld hl,fulfllb
        call fulplt
        pop de
        pop bc
        inc d
        djnz fulfll1
        ret

fulfllb ds max_xlen

;### FULADR -> calculates char address
;### Input      E=Spalte, D=Zeile
;### Output     HL=l/h scradr, P_MEMPTR2_L/H/U set, DI
;### Destroyed  AF
fuladr  ld hl,(fulscradr)
        add hl,de
fuladr1 di
        ld a,l:out (P_MEMPTR2_L),a
        ld a,h:out (P_MEMPTR2_H),a
        ld a,(fulscradr+2)
               out (P_MEMPTR2_U),a
        ret

elseif computer_mode=5

;==============================================================================
;### SCREEN-ROUTINEN (NC-FULLSCREEN) ##########################################
;==============================================================================

;### FULINI -> Initialisiert den Bildschirm und updatet Größe und Farben
;### Eingabe    A=Rahmen, E=Paper, D=Pen, C=Xlen, B=Ylen
fulini  ld a,c
        and #fe                 ;Xlen muß gerade sein
        ld c,a
        ld (scrxln),a
        ld a,(scryln)           ;bestehenden Text plotten
        ld b,a
        ld c,0
fulini2 push bc
        ld e,0
        ld d,c
        push de
        call memplt0            ;HL=Textadr
        push hl
        call clclen             ;C=Länge
        pop hl
        pop de
        inc c
        dec c
        jr z,fulini3
        ld e,0
        call fulplt
fulini3 pop bc
        inc c
        djnz fulini2
        ld a,(memcfl)
        or a
        ret z
        ld de,(memcps)
;### FULCON -> Cursor positionieren und einblenden
;### Eingabe    E=Spalte, D=Zeile
fulcon  call fuladr
        ld (fulcps+0),de
        ld (fulcps+2),iy
fulcon1 ld ix,mftdat3
        ld hl,jmp_bnk16c
        rst #28
        ei
        ret

;### FULCOF -> Cursor ausblenden
fulcps  dw 0,0
fulcof  ld de,(fulcps+0)
        ld iy,(fulcps+2)
        jr fulcon1

;### FULCLR -> Löscht den kompletten Bildschirm
fulclr  ld ix,mftdat2
        ld hl,jmp_bnk16c
        rst #28
        ei
        ret

;### FULSRU -> Scrollt Bildschirm nach oben und fügt unten Leerzeile ein
fulsru  ld ix,mftdat4
fulsru1 ld de,(scrxln)
        ld hl,jmp_bnk16c
        rst #28
        ei
        ret

;### FULSRD -> Scrollt Bildschirm nach unten und fügt oben Leerzeile ein
fulsrd  ld ix,mftdat5
        jr fulsru1

;### FULPLT -> Fügt Text in Bildschirm ein
;### Eingabe    HL=Text, E=Spalte, D=Zeile, C=Länge
fulplt  db #fd:ld l,c   ;IYL=Länge
        push de
        ld de,scrbuf
        ld b,0
        ldir            ;scrbuf=Textadr
        pop de
        call fuladr     ;DE=ScrAdr, IYH=ofs
        ld ix,mftdat1
        ld hl,jmp_bnk16c
        rst #28
        ei
        ret


;### FULFLS -> Füllt Bildschirm-Bereich mit Spaces
;### Eingabe    E=Spalte, D=Zeile, C=XLen, B=YLen
fulfls  ld a,32
;### FULFLL -> Füllt Bildschirm-Bereich mit gleichem Zeichen
;### Eingabe    A=Zeichen, E=Spalte, D=Zeile, C=XLen, B=YLen
fulfll  ld (scrbuf),a
        ld hl,0
        ld (nctout0),hl
fulfll1 push bc
        push de
        db #fd:ld l,c
        call fuladr
        ld ix,mftdat1
        ld hl,jmp_bnk16c
        rst #28
        ei
        pop de
        pop bc
        inc d
        djnz fulfll1
        db #21:inc ix
        ld (nctout0),hl
        ret

;### FULADR -> Berechnet Bildschirm-Adresse von Zeichen
;### Eingabe    E=Spalte, D=Zeile
;### Ausgabe    DE=Screenadresse, IYH=offset (0-3)
;### Verändert  AF,BC,HL
fuladr  ld a,d      ;al=y*256
        ld l,1
        scf
        rra:rr l
        rra:rr l
        ld h,a      ;hl=y*64+#c000
        ld c,e
        ld e,0      ;de=y*256
        add hl,de   ;hl=y*320=y*5*64 = lineadr
        ld a,c
        and 3       ;0, 1, 2, 3
        jr z,fuladr1
        cpl         ;  -2,-3,-4
        add 5       ;   3, 2, 1
fuladr1 ld iyh,a    ;iyh=offset
        or a
        ld a,c
        jr z,fuladr2
        dec a
fuladr2 srl c:srl c
        sub c
        ld d,e
        ld e,a
        add hl,de
        ex de,hl
        ret

;### FULREL -> Relociert Fullscreen-Textausgabe
fulrelt
dw mftinv1+2, nctout+3,  nctouta+2, nctoutb+2, nctoutp+2, nctoutd+2, nctout5+2
dw nctoute+2, nctoutg+2, nctouth+2, nctout7+2, nctouti+2, nctoutj+2, nctoutk+2
dw nctoutl+2, nctoutm+2, nctoutn+3, mftsrua+2, mftsrd+2
dw 0

fulrel  ld ix,mftdat1
        ld a,(prgbnknum)
        ld (ix+0),a
        ld (ix+3),a
        ld (ix+6),a
        ld (ix+9),a
        ld (ix+12),a
        ld hl,nctfnt
        ld a,h
        set 6,a
        res 7,a
        ld (nctoutq+1),a
        ld hl,fulrelt
fulrel1 ld e,(hl)
        inc hl
        ld d,(hl)
        inc hl
        ld a,d
        or e
        ret z
        ex de,hl
        set 6,(hl)
        res 7,(hl)
        ex de,hl
        jr fulrel1

elseif computer_mode=6

;==============================================================================
;### SCREEN-ROUTINEN (NXT-FULLSCREEN) #########################################
;==============================================================================

;### FULINI -> Initialisiert den Bildschirm und updatet Größe und Farben
;### Input      A=border colour, E=paper colour, D=pen colout, C=xlen, B=ylen
fulini  nextreg CLIP_WINDOW_CONTROL_NR_1C,#0f   ;reset all clip writings
        nextreg CLIP_LAYER2_NR_18,128           ;shrink layer2 to nothing
        nextreg CLIP_LAYER2_NR_18,128
        nextreg CLIP_LAYER2_NR_18,96
        nextreg CLIP_LAYER2_NR_18,96
        nextreg CLIP_TILEMAP_NR_1B,0            ;clip tilemap
        nextreg CLIP_TILEMAP_NR_1B,159
        nextreg CLIP_TILEMAP_NR_1B,3*8
        nextreg CLIP_TILEMAP_NR_1B,28*8-1
        nextreg PALETTE_CONTROL_NR_43,%00110001 ;select tilemap first palette
        nextreg PALETTE_INDEX_NR_40,0
        ld a,e
        push de
        call fulini1
        pop af
        call fulini1
        nextreg PALETTE_CONTROL_NR_43,%00010001 ;select layer2 first palette
        jr fulall
;a=index
fulini1 add a
        ld c,a
        ld b,0
        ld hl,fulbuf+2
        add hl,bc
        ld c,(hl)
        inc hl
        ld b,(hl)       ;e=pen, bc=rgb
        ld e,0
        rr c        ;ignore 4th B bit
        rr c:rl e   ;shift 3rd B bit into C
        rr c:rra
        rr c:rra    ;shift 1-2 B bit into A
        rr c        ;ignote 4th G bit
        rr c:rra
        rr c:rra
        rr c:rra    ;shift 1-3 G bit into A
        rr b        ;ignote 4th G bit
        rr b:rra
        rr b:rra
        rr b:rra    ;shift 1-3 R bit into A
        nextreg PALETTE_VALUE_9BIT_NR_44,a
        ld a,e
        nextreg PALETTE_VALUE_9BIT_NR_44,a
        ret

;### FULSRU -> Scrollt Bildschirm nach oben und fügt unten Leerzeile ein
;### FULSRD -> Scrollt Bildschirm nach unten und fügt oben Leerzeile ein
;### FULCLR -> Löscht den kompletten Bildschirm
fulsrd
fulsru
fulclr
;### FULALL -> redraw the complete screen
fulall  ei
        ld ix,mftdat2           ;copy complete memory to screen
        ld hl,jmp_bnk16c
        rst #28
        ei
        ret

;### FULCON -> place and show cursor
;### Eingabe    E=column, D=row
fulcon  call fuladr
        ld (fulcps),de
        ld iyl,1
fulcon1 ld ix,mftdat3
        ld hl,jmp_bnk16c
        rst #28
        ei
        ret

;### FULCOF -> Cursor ausblenden
fulcps  dw 0
fulcof  ld de,(fulcps)
        ld iyl,0
        jr fulcon1

;### FULPLT -> Fügt Text in Bildschirm ein
;### Eingabe    HL=Text, E=Spalte, D=Zeile, C=Länge
fulplt  db #fd:ld l,c   ;IYL=Länge
        push de
        ld de,scrbuf
        ld b,0
        ldir            ;scrbuf=Textadr
        pop de
        call fuladr     ;DE=ScrAdr
        ld ix,mftdat4
        ld hl,jmp_bnk16c
        rst #28
        ei
        ret

;### FULFLS -> Füllt Bildschirm-Bereich mit Spaces
;### Eingabe    E=Spalte, D=Zeile, C=XLen, B=YLen
fulfls  ld a,32
;### FULFLL -> Füllt Bildschirm-Bereich mit gleichem Zeichen
;### Eingabe    A=Zeichen, E=Spalte, D=Zeile, C=XLen, B=YLen
fulfll  ld (scrbuf),a
        db #3e:dec hl
        ld (nxtplt0),a
fulfll1 push bc
        push de
        db #fd:ld l,c
        call fuladr
        ld ix,mftdat4
        ld hl,jmp_bnk16c
        rst #28
        ei
        pop de
        pop bc
        inc d
        djnz fulfll1
        xor a
        ld (nxtplt0),a
        ret

;### FULADR -> get tilemap address
;### Input      E=column, D=row
;### Output     DE=address
;### Destroyed  AF,BC,HL
fuladr  ld a,d
        add a:add a:add a   ;*8
        ld l,a
        ld h,0
        ld d,h
        add hl,hl           ;*16
        ld c,l
        ld b,h              ;BC=*16
        add hl,hl
        add hl,hl           ;*64
        add hl,bc           ;*64+*16=*80
        add hl,de           ;+column
        add hl,hl           ;*2 -> final tilemapadr
        ld bc,160*3+#c000
        add hl,bc
        ex de,hl
        ret

;### FULREL -> Relociert Fullscreen-Textausgabe
fulrelt dw nxtini1+2,nxtall+2,nxtplt+2, 0

fulrel  ld ix,mftdat1
        ld a,(prgbnknum)
        ld (ix+0),a     ;mftdat1
        ld (ix+3),a     ;mftdat2
        ld (ix+6),a     ;mftdat3
        ld (ix+9),a     ;mftdat4
        ld hl,fulrelt
fulrel1 ld e,(hl)
        inc hl
        ld d,(hl)
        inc hl
        ld a,d
        or e
        ret z
        ex de,hl
        set 6,(hl)
        res 7,(hl)
        ex de,hl
        jr fulrel1

endif

;==============================================================================
;### DIRECTORY-ROUTINEN #######################################################
;==============================================================================

;### DIREXI -> Test, ob Directory existiert
;### Eingabe    HL=Neues Directory
;### Ausgabe    CF=0 ok, CF=1 Fehler (A=Fehlercode)
direxi  ld a,(prgbnknum)
        db #dd:ld h,a
        call syscll
        db MSC_SYS_SYSFIL
        db FNC_FIL_DIRPTH
        ret

;### DIRADD -> Setzt Pfad-Angabe mit aktuellem (Shell-)Directory zu neuem Pfad zusammen
;### Eingabe    HL=Pfad-Angabe (bis 0, \ am Ende meint Dir-Angabe, sonst File-Angabe, kann Wildcards enthalten), DE=Buffer für neues Directory (, BC=aktuelles Directory [ohne \ am Ende])
;### Ausgabe    DE=Terminatorposition, A=Type (+1=hört mit \ auf, +2=enthält filemask), HL=pos hinter letztem \
;### Verändert  F,BC
diraddz dw 0
diraddf db 0
diraddn dw 0
diradd  ld bc,shlpth
diradd0 xor a
        ld (diraddf),a
        push hl
        ld (diraddz),de
        ld l,c              ;Original-Verzeichnis zunächst übernehmen
        ld h,b
diradd1 ldi
        ld a,(hl)
        or a
        jr nz,diradd1
        ld a,"\"
        ld (de),a
        inc de
        pop hl
        call diradd4        ;Test, ob Root
        jr nz,diradd2
        ld de,(diraddz)     ;Root -> direkt hinter Laufwerk komplett übernehmen
        inc de
        inc de
        inc hl
diradd8 ld a,"\"
        ld (de),a
        inc de
        jr diradd3
diradd2 ld a,(hl)
        or a
        jr z,diradd3
        inc hl
        ld a,(hl)           ;Test, ob Laufwerk
        dec hl
        cp ":"
        jr nz,diradd3
        ld de,(diraddz)     ;Laufwerk -> neuen Pfad komplett übernehmen
        ld a,(hl)
        call clcucs
        ld (de),a
        inc hl
        inc de
        ldi
        call diradd4
        ld a,"\"
        jr nz,diradd9
        inc hl
diradd9 ld (de),a
        inc de

diradd3 ld (diraddn),de     ;** Loop -> Pfadangabe parsen
        ld a,(hl)
        cp "."
        jr nz,diraddd
        inc hl
        cp (hl)
        jr z,diradd5
        call diraddj
        jr nz,diraddc
        jr diradd7          ;./ ->  im selben directory bleiben
diradd5 inc hl
        call diraddj
        dec hl
        jr nz,diraddc
        dec de              ;../ -> ein directory höher
diradd6 dec de
        ld a,(de)
        cp ":"
        inc de
        jr z,diraddb
        dec de
        call diradda
        jr nz,diradd6
diraddb inc de
        inc hl
        ld a,(hl)
        or a
        jr nz,diradd7
        ld l,e              ;sonderfall -> pfadangabe hört mit .. auf
        ld h,d
        ld (hl),0
        ld a,1
        ret
diraddc dec hl              ;* file/subdir/end
        ld a,(hl)
diraddd ldi
        or a
        jr nz,diraddg
        ld hl,diraddf       ;0 -> pfad hört mit / auf (directory)
        set 0,(hl)
diradde dec de              ;** fertig
        ld hl,(diraddn)
        ld a,(diraddf)
        ret
diradd7 inc hl
diraddg call diradda        ;name-loop
        jr z,diradd3        ;/ -> nächster teil
        or a
        jr z,diradde        ;0 -> fertig
        cp "?"
        jr z,diraddh
        cp "*"
        jr nz,diraddi
diraddh ld a,(diraddf)      ;wildcards enthalten
        set 1,a
        ld (diraddf),a
diraddi ld a,(hl)
        ldi
        jr diraddg

diradd4 ld a,(hl)       ;(HL)="/","\"
diradda cp "\"          ;A="/","\"
        ret z
        cp "/"
        ret
diraddj call diradd4    ;(HL)="/","\",0
        ret z
        or a
        ret

;### DIRFIL -> Stellt Applications-Pfad zusammen
;### Eingabe    (shlinplin)=Eingabe, (shlpth)=Shellpfad
;### Ausgabe    (shlpthnew)=voller Pfad
dirfil  ld hl,shlinplin-1       ;Fileende suchen
dirfil1 inc hl
        ld a,(hl)
        or a
        jr z,dirfil2
        cp " "
        jr nz,dirfil1
dirfil2 push hl                 ;File mit Pfad zusammenfügen
        push af
        ld (hl),0
        ld hl,shlinplin
        ld de,shlpthnew
        call diradd
        ld hl,shlpthnew+254
        or a
        sbc hl,de
        ld c,l
        ld b,h
        pop af
        pop hl
        ld (hl),a
        ldir
        ret

;### DIRRUN -> Versucht Application zu starten
;### Eingabe    (shlpthnew)=voller Pfad
;### Ausgabe    CF=0 -> alles ok (A=0, H=Prozessnummer)
;###            CF=1 -> A=Fehler-Code (1=Datei existiert nicht, 2=Datei ist kein Programm, 3=Fehler beim Laden [L=Filemanager-Errorcode],
;###                                   4=Speicher voll)
dirrun  ld c,MSC_SYS_PRGRUN     ;Datei starten
        ld a,(prgbnknum)
dirrun0 or 128
        ld d,a
        ld a,128
        ld (dirrun0+1),a
        ld hl,shlpthnew
        ld b,l
        ld e,h
        ld a,PRC_ID_SYSTEM
        call msgsnd1
dirrun1 rst #30
        ld iy,prgmsgb
        ld a,(prgprzn)
        db #dd:ld l,a
        db #dd:ld h,PRC_ID_SYSTEM
        rst #18                 ;auf Antwort warten
        db #dd:dec l
        jr nz,dirrun1
        ld a,(prgmsgb)
        cp MSR_SYS_PRGRUN
        jr nz,dirrun1
        ld a,(prgmsgb+1)
        ld hl,(prgmsgb+8)
        cp 1
        ccf
        ret

;==============================================================================
;### MASSEN-FILEOPERATION #####################################################
;==============================================================================

;### MULPRE -> Bereitet Massen-Fileoperation vor
;### Ausgabe    CF=0 -> shlpthnew=Quellpfad mit Maske/-Datei, shlpthnew2=Zielpfad/-Datei, mulpremds=Zielmaske
;###                    (mulprensr)=Position Namensteil Quellpfad, (mulprends)=Position Namensteil Zielpfad
;###                    (mulpretsr)=Quelltyp (0=einzelnes File), (mulpretds)=Zieltyp (0=einzelnes File)
;###                    D=Anzahl Parameter, E=Anzahl Flags
;###            CF=1 -> Syntax Error (Fehlermeldung wurde ausgegeben)
mulpremal   db "*.*",0  ;mask for any files
mulprenul   db 0        ;actual path
mulprensr   dw 0        ;position namensteil quellpfad
mulprends   dw 0        ;position namensteil zielpfad
mulpremds   ds 13       ;maske ziel
mulpretsr   db 0        ;typ quelle (0=single file)
mulpretds   db 0        ;typ ziel (0=single file)

mulpre  call cmdpar
        ld a,d
        cp 3
        jp nc,cmdchk1
        cp 1
        jp c,cmdchk1
        push de
        push af
        ld hl,(cmdpartab+0)
        ld de,shlpthnew
        call diradd
        ld (mulprensr),hl
        ld (mulpretsr),a
        bit 0,a
        jr z,mulpre1
        ld hl,mulpremal
        ld bc,4
        ldir
        dec de
mulpre1 pop af
        ld hl,(cmdpartab+3)
        jr nz,mulpre2
        ld hl,mulprenul
mulpre2 ld de,shlpthnew2
        call diradd
        ld (mulprends),hl
        ld (mulpretds),a
        bit 0,a
        jr z,mulpre3
        ld hl,mulpremal     ;ziel hört als pfad auf -> all-maske nehmen
mulpre3 ld bc,13
        ld de,mulpremds
        ldir
        pop de
        or a
        ret

;### MULDIR -> Liest Directory für Massen-Fileoperation ein
;### Eingabe    A    -> =1  Directories nur berücksichtigen, wenn einzelnes File
;###                    <>1 Directories nie berücksichtigen
;### Ausgabe    CF=0 -> ok (ZF=1 keine Dateien gefunden), (muldiradr)=aktuelles File, (muldirnum)=Anzahl Files, (muldirtot)=0
;###            CF=1 -> Error (A=Code)
muldiradr   dw 0    ;Zeiger auf aktuelle Datei
muldirnum   dw 0    ;Anzahl verbliebener Dateien
muldirtot   dw 0    ;Anzahl bearbeiteter Dateien
muldir  ld e,a
        ld hl,0
        ld (muldirtot),hl
        ld a,(cmdflgbit)
        and #03
        xor #03
        add a
        add 16+8                ;keine volumes, zunächst keine directories
        dec e
        jr nz,muldir1           ;nie directories berücksichtigen
        ld e,a
        ld a,(mulpretsr)
        or a
        jr z,muldir2
        ld a,e
muldir1 db #dd:ld l,a
        ld hl,shlpthnew
        ld a,(prgbnknum)
        db #dd:ld h,a
        ld de,dirbufmem
        ld (muldiradr),de
        ld bc,dirbufmax
        ld iy,0
        call syscll
        db MSC_SYS_SYSFIL       ;CF=0 -> alles ok, HL=Anzahl gelesener Zeilen, BC=Länge vom nichtgenutzten Zielbereich
        db FNC_FIL_DIRINP       ;Struktur -> 0-3=Filelänge, 4-7=Timestamp, 8=Attribut, 9-X=Filename+0
        ret c
        ld (muldirnum),hl
        ld a,l
        or h
        ret
muldir2 ld hl,1                 ;einzelnes file -> alles berücksichtigen
        ld (muldirnum),hl
        dec hl
        ld (muldirtot),hl
        ld hl,dirbufmem
        ld (muldiradr),hl
        ld bc,9
        add hl,bc
        ex de,hl
        ld hl,(mulprensr)
        ld bc,13
        ldir
        ret
        xor a
        inc a
        ret

;### MULSRC -> Holt vollen Pfad der nächsten Quelldatei
;### Ausgabe    CF=0 -> HL=voller Pfad
;###            CF=1 -> keine weitere Datei vorhanden
mulsrc  ld hl,(muldirnum)
        ld a,l
        or h
        scf
        ret z
        dec hl
        ld (muldirnum),hl
        ld hl,(muldiradr)
        ld bc,9
        add hl,bc
        ld de,(mulprensr)
mulsrc1 ld a,(hl)
        ldi
        or a
        jr nz,mulsrc1
        ld (muldiradr),hl
        ld hl,shlpthnew
        ret

;### MULDST -> Holt vollen Pfad der nächsten Zieldatei
;### Ausgabe    HL=voller Pfad
muldst  ld hl,(mulprensr)
        ld de,(mulprends)
        ld bc,mulpremds
muldst1 ld a,(bc)
        inc bc
        or a
        jr z,muldst7
        cp "?"
        jr z,muldst4
        cp "*"
        jr z,muldst5
        cp "."
        jr z,muldst6
        push af             ;** X -> zeichen aus zielmaske übernehmen
        call muldst3
        pop af
muldst2 ld (de),a
        inc de
        jr muldst1
muldst3 ld a,(hl)
        or a
        ret z
        cp "."
        ret z
        inc hl
        ret
muldst4 call muldst3        ;** ? -> zeichen aus quellname übernehmen, falls vorhanden
        jr z,muldst1
        jr muldst2
muldst5 call muldst3        ;** * -> verbleibende zeichen aus quellname übernehmen
        ld (de),a
        inc de
        jr nz,muldst5
        dec de
        jr muldst1
muldst6 call muldst3        ;** . -> quellname bis . oder ende vorrücken, in zielname . setzen
        jr nz,muldst6
        or a
        ld a,"."
        jr z,muldst2
        inc hl
        jr muldst2
muldst7 ld (de),a           ;** 0 -> fertig
        ld hl,shlpthnew2
        ret

;### MULPLT -> Plottet Quelldatei
mulplt  ld hl,(mulprensr)
        push hl
mulplt1 ld a,(hl)
        call clcucs
        ld (hl),a
        inc hl
        or a
        jr nz,mulplt1
        pop hl
        call shlout
        ld hl,shlinpret
        jp shlout

;### MULRES -> Plottet Ergebnis
mulres  push hl
        ld bc,(muldirtot)
        ld a,c
        or b
        jr nz,mulres1
        ld hl,cmddelerr
        push bc
        call shlout
        pop bc
mulres1 ld de,0
        pop hl
        push hl
        inc hl
        call cmddire
        pop hl
        call shlout
        xor a
        ret


;==============================================================================
;### SORTIER-ROUTINEN #########################################################
;==============================================================================

;### SRTDAT -> Zeigertabelle sortieren
;### Eingabe    IX=(Zeiger)Tabelle, BC=Anzahl, A=Breite in Bytes, E=SpaltenIndex, L=Sortierung (0=aufsteigend, 1=absteigend),
;###            H=Typ (0=Zeiger auf Text [bis 0], 2=Wert, 3=Zeiger auf 4Byte-Wert)
;### Veraendert AF,BC,DE,HL,IX
srtsiz  db 0,0              ;Breite einer Spalte in Bytes
srtrow  db 0,0              ;Spaltenoffset in Bytes
srttab  dw 0                ;Tabelle
srtdir  db 0                ;Sortierrichtung (0=aufsteigend, 1=absteigend)
srttyp  db 0                ;Datentyp

srtdat  ld (srtsiz),a       ;Zeilenbreite merken
        ld (srtdir),hl      ;Datentyp und Sortierrichtung merken
        ld l,a
        ld a,e
        add a
        ld (srtrow),a
        ld e,a
        ld d,0
        add ix,de
        ld (srttab),ix      ;Tabelle mit Spaltenoffset merken
        ld e,c:ld d,b
        ld a,e:or d
        ret z
        dec de
        ld a,l
        call clcm16
        db #dd:ld e,l
        db #dd:ld d,h       ;DE=erstes Element
        add hl,de           ;HL=letztes Element
        jr srtpar

;### SRTPAR -> Teil einer Tabelle sortieren
;### Eingabe    DE=Erstes Element, HL=Letztes Element, (srttab)=Tabelle, (srtsiz)=Zeilenbreite
;### Veraendert AF,BC,DE,HL,IX
srtfir  dw 0                ;erstes Element
srtlas  dw 0                ;letztes Element

srtpar  ld (srtfir),de
        ld (srtlas),hl
        push hl
        or a
        sbc hl,de
        pop hl
        ret c
        ret z               ;Abbruch, falls HL<=DE
        push hl
        push de
        ld bc,(srttab)
        or a
        sbc hl,bc
        ex de,hl
        sbc hl,bc           ;HL,DE=Offsets auf die Elemente
        push bc
        add hl,de
        ld c,l
        ld b,h
        ld de,(srtsiz)
        call clcd16         ;HL=(Offset1+Offset2)/Zeilenlänge=Index1+Index2
        srl h
        rr l
        ex de,hl
        ld a,(srtsiz)
        call clcm16         ;HL=(Index1+Index2)/2*Zeilenlänge=OffsetMitte
        pop ix
        ex de,hl
        add ix,de           ;(IX)=mittleres Element
        pop hl              ;(HL)=erstes Element
        pop de              ;(DE)=letztes Element
srtpar1 call srtcmp         ;** 1. Schritt -> HL erhöhen, solange (HL)<(IX)
        jr nc,srtpar2
        ld bc,(srtsiz)
        add hl,bc
        jr srtpar1
srtpar2 ex de,hl            ;** 2. Schritt -> DE erniedrigen, solange (DE)>(IX)
srtpar3 call srtcmp
        jr nz,srtpar4
        ld bc,(srtsiz)
        or a
        sbc hl,bc
        jr srtpar3
srtpar4 push hl             ;** 3. Schritt -> wenn HL<=DE -> (HL) mit (DE) tauschen, HL erhöhen, DE erniedrigen
        or a                ;(Anmerkung -> DE/HL vertauscht)
        sbc hl,de
        pop hl
        jr c,srtpar5        ;DE<HL -> kein Tausch
        call srtpar6
        jr z,srtpar7
        ex de,hl
        call srtpar6
        ex de,hl
srtpar7 call srtswp
        ld bc,(srtsiz)
        ex de,hl
        add hl,bc           ;HL erhöhen
        ex de,hl
        sbc hl,bc           ;DE erniedrigen
srtpar5 push hl
        or a
        sbc hl,de           ;weitermachen solange DE>=HL
        pop hl
        ex de,hl            ;HL=erstes, DE=letztes
        jr nc,srtpar1
        push hl
        ld hl,(srtlas)
        push hl
        ld hl,(srtfir)
        ex de,hl            ;DE=Low, HL=letztes
        call srtpar
        pop hl              ;HL=High
        pop de              ;DE=erstes
        jp srtpar
;IX=DE?IX=HL
srtpar6 push ix
        ex (sp),hl          ;HL=IX,(SP)=HL
        sbc hl,de
        pop hl
        ret nz
        push hl
        pop ix
        ret

;### SRTSWP -> Vertauscht zwei Zeilen
;### Eingabe    HL=Zeiger innerhalb Zeile 1, DE=Zeiger innerhalb Zeile 2
;### Veraendert AF,BC
srtswp  push de
        push hl
        ld bc,(srtrow)
        or a
        sbc hl,bc
        ex de,hl            ;DE=Zeilenanfang
        sbc hl,bc           ;HL=Zeilenanfang
        ld a,(srtsiz)
        ld b,a
        ld c,a
srtswp1 ld a,(de)
        ldi
        dec hl
        ld (hl),a
        inc hl
        djnz srtswp1
        pop hl
        pop de
        ret

;### SRTCMP -> Vergleicht zwei Elemente
;### Eingabe    (HL)=Element1, (IX)=Element2
;### Ausgabe    CF=1 -> (HL)<(IX), ZF=1 -> (HL)>(IX)
;### Veraendert A,BC
srtcmp  push de
        ld e,(hl)
        inc hl
        ld d,(hl)           ;DE=Element1
        dec hl
        ld c,(ix+0)
        ld b,(ix+1)         ;BC=Element2
        ld a,(srtdir)
        or a
        jr z,srtcmp7        ;Elemente tauschen, falls absteigende Sortierung
        ld a,c:ld c,e:ld e,a
        ld a,b:ld b,d:ld d,a
srtcmp7 ld a,(srttyp)
        cp 2
        jr nz,srtcmp2
        ex de,hl            ;*** 16Bit Wert [anstelle von Zeiger]
        or a
        sbc hl,bc
        ex de,hl
srtcmp0 pop de
        ret c               ;CF=1, ZF=0 -> (HL)<(IX)
        jr z,srtcmp1
        sub a               ;CF=0, ZF=1 -> (HL)>(IX)
        ret
srtcmp1 ld a,1
        or a                ;CF=0, ZF=0 -> (HL)=(IX)
        ret
srtcmp2 push ix             ;*** Text oder 32Bit
        db #dd:ld l,c
        db #dd:ld h,b       ;IX=Ele2
        or a
        jr nz,srtcmp5
        ld b,32             ;*** Text (maximal 32 Vergleiche)
srtcmp3 dec b
        jr z,srtcmp4
        ld a,(de)   
        cp (ix+0)
        inc de
        inc ix
        jr nz,srtcmp4
        or a
        jr nz,srtcmp3
srtcmp4 pop ix
        jr srtcmp0
srtcmp5 inc de:inc de:inc de
        ld b,4              ;*** 32Bit (maximal 4 Vergleiche)
srtcmp6 dec b
        jr z,srtcmp4
        ld a,(de)
        cp (ix+3)
        dec de
        dec ix
        jr z,srtcmp6
        jr srtcmp4


;==============================================================================
;### "CONFIG" FUNKTIONEN ######################################################
;==============================================================================

cfgpthfil   db "/cmd.ini",0:cfgpthfil0

;### CFGPTH -> Generates config path
cfgpth  ld hl,cfgpthfil
        ld de,(prgparf)
        ld bc,cfgpthfil0-cfgpthfil
        ldir
        ret

;### CFGLOD -> load config data
cfglod  call cfgpth
        ld hl,(prgparp)
        ld a,(prgbnknum)
        db #dd:ld h,a
        call syscll                 ;open file
        db MSC_SYS_SYSFIL
        db FNC_FIL_FILOPN
        ret c
        ld hl,cfg_beg
        ld bc,cfg_end-cfg_beg
        ld de,(prgbnknum)
        push af
        call syscll                 ;load configdata
        db MSC_SYS_SYSFIL
        db FNC_FIL_FILINP
        pop af
        call syscll                 ;close file
        db MSC_SYS_SYSFIL
        db FNC_FIL_FILCLO
        ret

;### CFGSAV -> save config data
cfgsav  call cfgpth
        ld hl,(prgparp)
        ld a,(prgbnknum)
        db #dd:ld h,a
        xor a
        call syscll                 ;create file
        db MSC_SYS_SYSFIL
        db FNC_FIL_FILNEW
        ret c
        ld hl,cfg_beg
        ld bc,cfg_end-cfg_beg
        ld de,(prgbnknum)
        push af
        call syscll                 ;save configdata
        db MSC_SYS_SYSFIL
        db FNC_FIL_FILOUT
        pop af
        call syscll                 ;close file
        db MSC_SYS_SYSFIL
        db FNC_FIL_FILCLO
        ret

;### CFGSET -> Config-Dialog
cfgsetb ds 4
cfgsetc db 0            ;flag, if size changed
cfgset  call cfgsete                ;*** farbflächen setzen
        xor a
        ld (configful),a
        call cfgset2
        ld a,(scrxln)
        db #dd:ld l,a
        db #dd:ld h,0
        ld iy,configinp0
        call clci16
        ld a,(scryln)
        db #dd:ld l,a
        db #dd:ld h,0
        ld iy,configinp1
        call clci16
        ld de,configwin
        jp diaopn
cfgset1 call diaclo                 ;*** Änderung übernehmen
        xor a
        ld (cfgsetc),a
        call shlfoc
        jr c,cfgset7                ;Fenster-Größe nicht änderbar, wenn Shell kein Focus hat
        ld ix,configbuf0
        xor a
        ld bc,10
        ld de,max_xlen
        call clcr16
        jr c,cfgset6
        ld a,l
        ld hl,scrxln
        cp (hl)
        jr z,cfgset6
        ld (hl),a
        ld (cfgsetc),a
cfgset6 ld ix,configbuf1
        xor a
        ld bc,4
        ld de,scrymx
        call clcr16
        jr c,cfgset7
        ld a,l
        ld hl,scryln
        cp (hl)
        jr z,cfgset7
        ld (hl),a
        ld (cfgsetc),a
cfgset7 xor a
        call cfgsetl
        ld (scrpap),a
        ld a,1
        call cfgsetl
        ld (scrpen),a
        ld a,2
        call cfgsetl
        ld (scrbrd),a
        ld a,(configful)
        or a
        jr z,cfgsetd
        call cmdful
        jp prgprz0
cfgsetd call scrini
        ld a,(cfgsetc)
        or a
        jr nz,cfgset8
        ld e,-1
        call msgsnd0
        jp prgprz0
cfgset8 call cfgset9                ;*** Größe setzen
        call shldir
        call shlini
        jp prgprz0
cfgset9 call scrcof
        call scrclr
        call trmini
cfgseta ld c,MSC_DSK_WINSIZ
        ld de,(prgwindat+08)
        ld hl,(prgwindat+10)
        jp msgsnd2

cfgset2 ld a,0                      ;*** Preview-Farben setzen
        call cfgsetl
        ld e,a          ;e=pap
        ld a,2
        call cfgsetl
        ld d,a          ;d=rhm
        ld a,1
        call cfgsetl    ;a=pen
        add a:add a:add a:add a
        or e
        ld (configdscb+2),a
        ld a,d
        add a:add a:add a:add a
        add d
        ld (configdat1+4+1+16),a
        ld a,e
        add 64+128
        ld (configdat1+4),a
        ret

cfgset4 ld c,MSC_DSK_WININH
        ld a,(diawin)
        ld b,a
        jp msgsnd

cfgsete ld de,scrpap                ;*** Farbbuttons setzen
        ld hl,configdat0+4
        ld bc,16
        db #dd:ld l,3
cfgsetf ld a,(de)
        inc de
        add 64+128
        ld (hl),a
        add hl,bc
        db #dd:dec l
        jr nz,cfgsetf
cfgsetg call cfgseti
        call cfgsetk
        ld (colselobj+12),a
        ret
cfgseti ld a,(configobj7)
cfgsetj add a:add a:add a:add a
        ld c,a
        ld b,0
        ld hl,configdat0+4
        add hl,bc
        ret
cfgsetl call cfgsetj
cfgsetk ld a,(hl)
        and #0f
        ret

cfgset3 call cfgsetg                ;*** Farbobjekt geändert
        ld e,19
        call cfgset4
        jp prgprz0

cfgseth call cfgseti                ;*** Farbe geändert
        ld a,(colselobj+12)
        add 64+128
        ld (hl),a
        call cfgset2
        ld de,256*15+256-3
        call cfgset4
        ld de,256*21+256-3
        call cfgset4
        jp prgprz0


;==============================================================================
;### SUB-ROUTINEN #############################################################
;==============================================================================

;### MSGGET -> Message für Programm abholen
;### Ausgabe    CF=0 -> keine Message vorhanden, CF=1 -> IXH=Absender, (prgmsgb)=Message, A=(prgmsgb+0), IY=prgmsgb
;### Veraendert 
msgget  ld a,(cmdwai)
        or a
        db #dd:ld h,PRC_ID_DESKTOP
        jr nz,msgget1
        db #dd:ld h,-1
msgget1 ld a,(prgprzn)
        db #dd:ld l,a           ;IXL=Rechner-Prozeß-Nummer
        ld iy,prgmsgb           ;IY=Messagebuffer
        rst #08                 ;Message holen -> IXL=Status, IXH=Absender-Prozeß
        or a
        db #dd:dec l
        ret nz
        ld iy,prgmsgb
        ld a,(iy+0)
        or a
        jp z,prgend
        scf
        ret

;### MSGDSK -> Message für Programm von Desktop-Prozess abholen
;### Ausgabe    (recmsgb)=Message, A=(recmsgb+0), IY=recmsgb
;### Veraendert 
msgdsk  db #dd:ld h,PRC_ID_DESKTOP
        call msgget1
        jr nc,msgdsk            ;keine Message
        ld a,(prgmsgb)
        ret

;### MSGSND -> Message an Desktop-Prozess senden
;### Eingabe    C=Kommando, B/E/D/L/H=Parameter1/2/3/4/5
msgsnd0 ld c,MSC_DSK_WININH
msgsnd2 ld a,(prgwin)
        ld b,a
msgsnd  ld a,PRC_ID_DESKTOP
msgsnd1 db #dd:ld h,a
        ld a,(prgprzn)
        db #dd:ld l,a
        ld (prgmsgb+0),bc
        ld (prgmsgb+2),de
        ld (prgmsgb+4),hl
msgsnd3 ld iy,prgmsgb
        rst #10
        ret

;### SYSCLL -> Betriebssystem-Funktion aufrufen
;### Eingabe    (SP)=Modul/Funktion, AF,BC,DE,HL,IX,IY=Register
;### Ausgabe    AF,BC,DE,HL,IX,IY=Register
sysclln db 0
syscll  ld (prgmsgb+04),bc      ;Register in Message-Buffer kopieren
        ld (prgmsgb+06),de
        ld (prgmsgb+08),hl
        ld (prgmsgb+10),ix
        ld (prgmsgb+12),iy
        push af
        pop hl
        ld (prgmsgb+02),hl
        pop hl
        ld e,(hl)
        inc hl
        ld d,(hl)
        inc hl
        push hl
        ld (prgmsgb+00),de      ;Modul und Funktion in Message-Buffer kopieren
        ld a,e
        ld (sysclln),a
        ld iy,prgmsgb
        ld a,(prgprzn)          ;Desktop und System-Prozessnummer holen
        db #dd:ld l,a
        db #dd:ld h,PRC_ID_SYSTEM
        rst #10                 ;Message senden
syscll1 rst #30
        ld iy,prgmsgb
        ld a,(prgprzn)
        db #dd:ld l,a
        db #dd:ld h,PRC_ID_SYSTEM
        rst #18                 ;auf Antwort warten
        db #dd:dec l
        jr nz,syscll1
        ld a,(prgmsgb)
        sub 128
        ld e,a
        ld a,(sysclln)
        cp e
        jr nz,syscll1
        ld hl,(prgmsgb+02)      ;Register aus Message-Buffer holen
        push hl
        pop af
        ld bc,(prgmsgb+04)
        ld de,(prgmsgb+06)
        ld hl,(prgmsgb+08)
        ld ix,(prgmsgb+10)
        ld iy,(prgmsgb+12)
        ret

;### CLCN32 -> Wandelt 32Bit-Zahl in ASCII-String um (mit 0 abgeschlossen)
;### Eingabe    DE,IX=Wert, IY=Adresse
;### Ausgabe    IY=Adresse letztes Zeichen
;### Veraendert AF,BC,DE,HL,IX,IY
clcn32t dw 1,0,     10,0,     100,0,     1000,0,     10000,0
        dw #86a0,1, #4240,#f, #9680,#98, #e100,#5f5, #ca00,#3b9a
clcn32z ds 4

clcn32  ld (clcn32z),ix
        ld (clcn32z+2),de
        ld ix,clcn32t+36
        ld b,9
        ld c,0
clcn321 ld a,"0"
        or a
clcn322 ld e,(ix+0):ld d,(ix+1):ld hl,(clcn32z):  sbc hl,de:ld (clcn32z),hl
        ld e,(ix+2):ld d,(ix+3):ld hl,(clcn32z+2):sbc hl,de:ld (clcn32z+2),hl
        jr c,clcn325
        inc c
        inc a
        jr clcn322
clcn325 ld e,(ix+0):ld d,(ix+1):ld hl,(clcn32z):  add hl,de:ld (clcn32z),hl
        ld e,(ix+2):ld d,(ix+3):ld hl,(clcn32z+2):adc hl,de:ld (clcn32z+2),hl
        ld de,-4
        add ix,de
        inc c
        dec c
        jr z,clcn323
        ld (iy+0),a
        inc iy
clcn323 djnz clcn321
        ld a,(clcn32z)
        add "0"
        ld (iy+0),a
        ld (iy+1),0
        ret

;### CLCDEZ -> Rechnet Byte in zwei Dezimalziffern um
;### Eingabe    A=Wert
;### Ausgabe    L=10er-Ascii-Ziffer, H=1er-Ascii-Ziffer
;### Veraendert AF
clcdez  ld l,0
clcdez1 sub 10
        jr c,clcdez2
        inc l
        jr clcdez1
clcdez2 add "0"+10
        ld h,a
        ld a,"0"
        add l
        ld l,a
        sub "9"+1
        ret c
        add "A"
        ld l,a
        ret

;### CLCLEN -> Ermittelt Länge eines Strings
;### Eingabe    HL=String (,A=Terminator)
;### Ausgabe    HL=Stringende (0), BC=Länge (maximal 255)
;### Verändert  -
clclen0 push af
        jr clclen1
clclen  push af
        xor a
clclen1 ld bc,255
        cpir
        ld a,254
        sub c
        ld c,a
        dec hl
        pop af
        ret

;### CLCLCS -> Wandelt Groß- in Kleinbuchstaben um
;### Eingabe    A=Zeichen
;### Ausgabe    A=lcase(Zeichen)
;### Verändert  F
clclcs  cp "A"
        ret c
        cp "Z"+1
        ret nc
        add "a"-"A"
        ret

;### CLCUCS -> Wandelt Klein- in Großbuchstaben um
;### Eingabe    A=Zeichen
;### Ausgabe    A=ucase(Zeichen)
;### Verändert  F
clcucs  cp "a"
        ret c
        cp "z"+1
        ret nc
        add "A"-"a"
        ret

;### CLCM16 -> Multipliziert zwei Werte (16bit)
;### Eingabe    A=Wert1, DE=Wert2
;### Ausgabe    HL=Wert1*Wert2 (16bit)
;### Veraendert AF,DE
clcm16  ld hl,0
        or a
clcm161 rra
        jr nc,clcm162
        add hl,de
clcm162 sla e
        rl d
        or a
        jr nz,clcm161
        ret

;### CLCD16 -> Dividiert zwei Werte (16bit)
;### Eingabe    BC=Wert1, DE=Wert2
;### Ausgabe    HL=Wert1/Wert2, DE=Wert1 MOD Wert2
;### Veraendert AF,BC,DE
clcd16  ld a,e
        or d
        ld hl,0
        ret z
        ld a,b
        ld b,16
clcd161 rl c
        rla
        rl l
        rl h
        sbc hl,de
        jr nc,clcd162
        add hl,de
clcd162 ccf
        djnz clcd161
        ex de,hl
        rl c
        rla
        ld h,a
        ld l,c
        ret

;### CLCR16 -> Wandelt String in 16Bit Zahl um
;### Eingabe    IX=String, A=Terminator, BC=Untergrenze (>=0), DE=Obergrenze (<=65534)
;### Ausgabe    IX=String hinter Terminator, HL=Zahl, CF=1 -> Ungültiges Format (zu groß/klein, falsches Zeichen/Terminator)
;### Veraendert AF,DE,IYL
clcr16  ld hl,0
        db #fd:ld l,a
clcr161 ld a,(ix+0)
        inc ix
        db #fd:cp l
        jr z,clcr163
        sub "0"
        jr c,clcr162
        cp 10
        jr nc,clcr162
        push af
        push de
        ld a,10
        ex de,hl
        call clcm16
        pop de
        pop af
        add l
        ld l,a
        ld a,0
        adc h
        ld h,a
        jr clcr161
clcr162 scf
        ret
clcr163 sbc hl,bc
        ret c
        add hl,bc
        inc de
        sbc hl,de
        jr nc,clcr162
        add hl,de
        or a
        ret

;### CLCI16 -> Fügt Zahl in Eingabefeld ein
;### Eingabe    IX=Zahl, IY=Input-Control
;### Verändert  AF,BC,DE,HL,IX
clci16  push iy
        ld e,(iy+0)
        ld d,(iy+1)
        push de
        pop iy
        push de
        ld de,0
        call clcn32
        pop hl
        db #fd:ld e,l
        db #fd:ld d,h
        ex de,hl
        or a
        sbc hl,de
        inc l
        pop iy
        ld (iy+2),0
        ld (iy+4),l
        ld (iy+6),0
        ld (iy+8),l
        ret

;### CLCGDY -> Wochen-Tag errechnen
;### Eingabe    D=Tag (ab 1), E=Monat (ab 1), HL=Jahr
;### Ausgabe    A=Wochentag (0-6; 0=Montag)
;### Veraendert F,BC,DE,HL
clcgdyn db 0,3,3,6,1,4,6,2,5,0,3,5
clcgdys db 0,3,4,0,2,5,0,3,6,1,4,6
clcgdy  ld bc,1980
        or a
        sbc hl,bc
        ld b,l          ;B=Jahre seit 1980
        ld c,3          ;A=Schaltjahr-Checker
        ld a,1          ;A=Wochentag (01.01.1980 war Dienstag)
        inc b
clcgdy1 dec b
        jr z,clcgdy3
        inc a           ;neues Jahr -> Wochentag+1
        inc c
        bit 2,c
        jr z,clcgdy2
        ld c,0          ;Schaltjahr -> Wochentag+2
        inc a
clcgdy2 cp 7
        jr c,clcgdy1
        sub 7
        jr clcgdy1
clcgdy3 ld b,a          ;B=Wochentag vom 1.1. des Jahres
        ld a,c
        cp 3
        ld hl,clcgdyn
        jr nz,clcgdy4
        ld hl,clcgdys
clcgdy4 ld a,d
        dec a
        ld d,0
        dec e
        add hl,de
        add (hl)
        add b
clcgdy5 sub 7
        jr nc,clcgdy5
        add 7
        ret

;### INIVER -> Holt Versionstext des Betriebssystems und prüft, ob korrekte Plattform
iniverpth   ds 32

iniver  ld e,7
        ld hl,jmp_sysinf
        rst #28             ;DE=System, IX=Data, IYL=Databank
        push de
        push iy
        ld e,8
        ld hl,jmp_sysinf
        rst #28                 ;IY=Adr
        push iy
        pop hl
        inc hl:inc hl
        ld de,shlmsgver
        ld a,(prgbnknum)
        add a:add a:add a:add a
        pop bc
        push af
        add c
        ld bc,30
        rst #20:dw jmp_bnkcop   ;kopieren

        pop af                  ;systempfad holen
        pop de
        ld hl,6+163
        add hl,de
        ld de,iniverpth
        ld bc,32
        rst #20:dw jmp_bnkcop
        ld hl,iniverpth-1
iniver2 inc hl
        ld a,(hl)
        or a
        jr nz,iniver2
        dec hl
        call diradd4
        jr nz,iniver3
        ld (hl),0               ;letzten / entfernen, falls vorhanden

iniver3 ld hl,jmp_sysinf        ;Computer-Typ holen
        ld de,256*6+5
        ld ix,cfgsf2flg
        ld iy,66+2+6+8-5
        rst #28

        ld a,(cfgcpctyp)        ;plattform check
        and #1f
if computer_mode=0          ;CPC -> 0-4 OK
        cp 4+1
        ccf
elseif computer_mode=1      ;MSX -> 7-10 OK
        cp 7
        jr c,iniver1
        cp 10+1
        ccf
elseif computer_mode=2      ;PCW -> 12-13 OK
        cp 12
        jr c,iniver1
        cp 13+1
        ccf
elseif computer_mode=3      ;EP  -> 6 OK
        cp 6
        jr c,iniver1
        cp 6+1
        ccf
elseif computer_mode=4      ;SVM -> 18 OK
        cp 18
        jr c,iniver1
        cp 18+1
        ccf
elseif computer_mode=5      ;NC  -> 15-17 OK
        cp 15
        jr c,iniver1
        cp 17+1
        ccf
elseif computer_mode=6      ;NXT -> 20 OK
        cp 20
        jr c,iniver1
        cp 20+1
        ccf
endif
iniver1 ret nc
        ld b,1
        ld hl,prgmsgwpf
        call prginf0
        scf
        ret

;### FILF2T -> Wandelt Filesystem-Timestamp in Uhrzeit um
;### Eingabe    BC=Uhrzeit (b0-4=Sekunde*2, b5-10=Minute, b11-15=Stunde), DE=Datum (b0-4=Tag, b5-8=Monat, b9-15=Jahr-1980)
;### Ausgabe    A=Sekunden, B=Minuten, C=Stunden, D=Tag (ab 1), E=Monat (ab 1), HL=Jahr
;### Veraendert F
filf2t  ld l,d
        srl l               ;L=Jahr-1980
        ld a,e
        and 31              ;A=Tag ab 1
        srl d:rr e
        srl e:srl e
        srl e:srl e         ;E=Monat ab 1
        ld d,a              ;D=Tag ab 1
        ld a,#bc
        add l
        ld l,a
        ld a,7
        adc 0
        ld h,a              ;HL=Jahr
        ld a,c
        ld c,b
        ld b,a
        and 31
        add a               ;A=Sekunden
        srl c:rr b
        srl c:rr b
        srl c:rr b          ;C=Stunden
        srl b:srl b         ;B=Minuten
        ret

;### DSKSRV -> Desktop Service nutzen
;### Eingabe    A=Dienst, DE,HL = Parameter
;### Ausgabe    DE,HL = Parameter
dsksrvn db 0
dsksrv  ld c,MSC_DSK_DSKSRV
        ld (dsksrvn),a
        push af
        call SyDesktop_SendMessage
        pop af
        cp 1
        jr z,dsksrv1
        cp 3
        jr z,dsksrv1
        cp 5
        ret nz
dsksrv1 call SyDesktop_WaitMessage
        cp MSR_DSK_DSKSRV
        jr nz,dsksrv1
        ld a,(dsksrvn)
        cp (iy+1)
        jr nz,dsksrv1
        ld e,(iy+2)
        ld d,(iy+3)
        ld l,(iy+4)
        ld h,(iy+5)
        ret
SyDesktop_SendMessage
        ld iy,prgmsgb
        ld (iy+0),c
        ld (iy+1),a
        ld (iy+2),e
        ld (iy+3),d
        ld (iy+4),l
        ld (iy+5),h
        db #dd:ld h,2       ;2 is the number of the desktop manager process
        ld a,(prgprzn)
        db #dd:ld l,a
        rst #10
        ret
SyDesktop_WaitMessage
        ld iy,prgmsgb
SyDWMs1 db #dd:ld h,2       ;2 is the number of the desktop manager process
        ld a,(prgprzn)
        db #dd:ld l,a
        rst #08             ;wait for a desktop manager message
        db #dd:dec l
        jr nz,SyDWMs1
        ld a,(iy+0)
        ret

;### HELP-FILE
SySystem_HLPFLG db 0    ;flag, if HLP-path is valid
SySystem_HLPPTH db "%help.exe "
SySystem_HLPPTH1 ds 128
SySHInX db ".HLP",0

SySystem_HLPINI
        ld hl,(prgcodbeg)
        ld de,prgcodbeg
        dec h
        add hl,de                   ;HL = CodeEnd = Command line
        ld de,SySystem_HLPPTH1
        ld bc,0
        db #dd:ld l,128
SySHIn1 ld a,(hl)
        or a
        jr z,SySHIn3
        cp " "
        jr z,SySHIn3
        cp "."
        jr nz,SySHIn2
        ld c,e
        ld b,d
SySHIn2 ld (de),a
        inc hl
        inc de
        db #dd:dec l
        ret z
        jr SySHIn1
SySHIn3 ld a,c
        or b
        ret z
        ld e,c
        ld d,b
        ld hl,SySHInX
        ld bc,5
        ldir
        ld a,1
        ld (SySystem_HLPFLG),a
        ret

hlpopn  ld a,(SySystem_HLPFLG)
        or a
        jp z,prgprz0
        ld a,(prgbnknum)
        ld d,a
        ld a,PRC_ID_SYSTEM
        ld c,MSC_SYS_PRGRUN
        ld hl,SySystem_HLPPTH
        ld b,l
        ld e,h
        call msgsnd1
        jp prgprz0


;==============================================================================
;### DATEN-TEIL ###############################################################
;==============================================================================

prgdatbeg

;==============================================================================
;--- CPC ----------------------------------------------------------------------
;==============================================================================

if computer_mode=0

mftchrtab
dw mftchr177,mftchr177,mftchr177,mftchr177,mftchr177,mftchr177,mftchr177,mftchr177,mftchr177,mftchr177,mftchr177,mftchr177,mftchr177,mftchr177,mftchr177,mftchr177
dw mftchr177,mftchr177,mftchr177,mftchr177,mftchr177,mftchr177,mftchr177,mftchr177,mftchr177,mftchr177,mftchr177,mftchr177,mftchr177,mftchr177,mftchr177,mftchr177
dw mftchr032,mftchr033,mftchr034,mftchr035,mftchr036,mftchr037,mftchr038,mftchr039,mftchr040,mftchr041,mftchr042,mftchr043,mftchr044,mftchr045,mftchr046,mftchr047
dw mftchr048,mftchr049,mftchr050,mftchr051,mftchr052,mftchr053,mftchr054,mftchr055,mftchr056,mftchr057,mftchr058,mftchr059,mftchr060,mftchr061,mftchr062,mftchr063
dw mftchr064,mftchr065,mftchr066,mftchr067,mftchr068,mftchr069,mftchr070,mftchr071,mftchr072,mftchr073,mftchr074,mftchr075,mftchr076,mftchr077,mftchr078,mftchr079
dw mftchr080,mftchr081,mftchr082,mftchr083,mftchr084,mftchr085,mftchr086,mftchr087,mftchr088,mftchr089,mftchr090,mftchr091,mftchr092,mftchr093,mftchr094,mftchr095
dw mftchr096,mftchr097,mftchr098,mftchr099,mftchr100,mftchr101,mftchr102,mftchr103,mftchr104,mftchr105,mftchr106,mftchr107,mftchr108,mftchr109,mftchr110,mftchr111
dw mftchr112,mftchr113,mftchr114,mftchr115,mftchr116,mftchr117,mftchr118,mftchr119,mftchr120,mftchr121,mftchr122,mftchr123,mftchr124,mftchr125,mftchr126,mftchr127

dw mftchr128,mftchr129,mftchr130,mftchr131,mftchr132,mftchr133,mftchr134,mftchr135,mftchr136,mftchr137,mftchr138,mftchr139,mftchr140,mftchr141,mftchr142,mftchr143
dw mftchr144,mftchr145,mftchr146,mftchr147,mftchr148,mftchr149,mftchr150,mftchr151,mftchr152,mftchr153,mftchr154,mftchr155,mftchr156,mftchr157,mftchr158,mftchr159
dw mftchr160,mftchr161,mftchr162,mftchr163,mftchr164,mftchr165,mftchr166,mftchr167,mftchr168,mftchr169,mftchr170,mftchr171,mftchr172,mftchr173,mftchr174,mftchr175
dw mftchr176,mftchr177,mftchr178,mftchr179,mftchr180,mftchr181,mftchr182,mftchr183,mftchr184,mftchr185,mftchr186,mftchr187,mftchr188,mftchr189,mftchr190,mftchr191
dw mftchr192,mftchr193,mftchr194,mftchr195,mftchr196,mftchr197,mftchr198,mftchr199,mftchr200,mftchr201,mftchr202,mftchr203,mftchr204,mftchr205,mftchr206,mftchr207
dw mftchr208,mftchr209,mftchr210,mftchr211,mftchr212,mftchr213,mftchr214,mftchr215,mftchr216,mftchr217,mftchr218,mftchr219,mftchr220,mftchr221,mftchr222,mftchr223
dw mftchr224,mftchr225,mftchr226,mftchr227,mftchr228,mftchr229,mftchr230,mftchr231,mftchr232,mftchr233,mftchr234,mftchr235,mftchr236,mftchr237,mftchr238,mftchr239
dw mftchr240,mftchr241,mftchr242,mftchr243,mftchr244,mftchr245,mftchr246,mftchr247,mftchr248,mftchr249,mftchr250,mftchr251,mftchr252,mftchr253,mftchr254,mftchr255

dw mftchr128    ;for relocating

;### MFTCLR -> Löscht den Bildschirm
mftclr  ei
        ld hl,#c000
        ld de,#c001
        ld (hl),l
        ld bc,#3fff
        ldir
        ret

;### MFTINV -> Invertiert die untern 4 Zeilen eines Zeichens
;### Eingabe    DE=Bildschirmadresse
mftinv  ei
        ld hl,#800*4
        add hl,de
        ld de,#800
        ld b,4
mftinv1 ld a,(hl)
        cpl
        ld (hl),a
        add hl,de
        djnz mftinv1
        ret

;### MFTFLL -> Löscht mehrere Zeichen hintereinander
;### Eingabe    IYL=Länge, DE=Bildschirmadresse
mftfll  ei
        db #fd:ld b,l
        ex de,hl
        xor a
mftfll1 ld (hl),a:set 3,h
        ld (hl),a:set 4,h
        ld (hl),a:set 5,h
        ld (hl),a:res 4,h
        ld (hl),a:res 3,h
        ld (hl),a:set 4,h
        ld (hl),a:res 5,h
        ld (hl),a:res 4,h
        inc hl   :res 3,h
        djnz mftfll1
        ret

;### MFTOUT -> Gibt Text in Mode2 mit maximal möglicher Geschwindigkeit aus
;### Eingabe    scrbuf=Text, IYL=Länge, DE=Bildschirmadresse
mftout  ld ix,scrbuf
        ei
        db #fd:ld b,l
        xor a
        jr mftout2
mftout1 res 4,h             ;2
        inc hl              ;2
        res 3,h             ;2
        ex de,hl            ;1
mftout2 ld l,(ix+0)         ;5
mftout3 inc ix              ;3
mftout4 ld h,0              ;2
        ld c,(hl)           ;2
        inc h               ;1
        ld h,(hl)           ;2
        ld l,c              ;1
        jp (hl)             ;1 24 + 35-43 -> 59-66 (64 average for all 96 chars, 63 for random text)

ds 3    ;for relocating
mftchr032 ex de,hl:         ld (hl),a  :set 3,h:ld (hl),a  :set 4,h:ld (hl),a  :set 5,h:ld (hl),a  :res 4,h:ld (hl),a  :res 3,h:ld (hl),a  :set 4,h:ld (hl),a  :res 5,h:ld (hl),a  :dec b:jp nz,mftout1:ret     ; 
mftchr033 ex de,hl:ld c,#18:ld (hl),c  :set 3,h:ld (hl),#3C:set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),a  :res 3,h:ld (hl),c  :set 4,h:ld (hl),c  :res 5,h:ld (hl),#3C:dec b:jp nz,mftout1:ret     ;!
mftchr034 ex de,hl:         ld (hl),#6C:set 3,h:ld (hl),#6C:set 4,h:ld (hl),a  :set 5,h:ld (hl),a  :res 4,h:ld (hl),a  :res 3,h:ld (hl),a  :set 4,h:ld (hl),a  :res 5,h:ld (hl),#28:dec b:jp nz,mftout1:ret     ;"
mftchr035 ex de,hl:ld c,#6c:ld (hl),c  :set 3,h:ld (hl),c  :set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),#FE:set 4,h:ld (hl),c  :res 5,h:ld (hl),#FE:dec b:jp nz,mftout1:ret     ;#
mftchr036 ex de,hl:         ld (hl),#18:set 3,h:ld (hl),#3E:set 4,h:ld (hl),#3C:set 5,h:ld (hl),a  :res 4,h:ld (hl),#7C:res 3,h:ld (hl),#06:set 4,h:ld (hl),#18:res 5,h:ld (hl),#60:dec b:jp nz,mftout1:ret     ;$
mftchr037 ex de,hl:         ld (hl),a  :set 3,h:ld (hl),#C6:set 4,h:ld (hl),#18:set 5,h:ld (hl),a  :res 4,h:ld (hl),#66:res 3,h:ld (hl),#30:set 4,h:ld (hl),#C6:res 5,h:ld (hl),#CC:dec b:jp nz,mftout1:ret     ;%
mftchr038 ex de,hl:         ld (hl),#38:set 3,h:ld (hl),#6C:set 4,h:ld (hl),#76:set 5,h:ld (hl),a  :res 4,h:ld (hl),#CC:res 3,h:ld (hl),#DC:set 4,h:ld (hl),#76:res 5,h:ld (hl),#38:dec b:jp nz,mftout1:ret     ;&
mftchr039 ex de,hl:         ld (hl),#18:set 3,h:ld (hl),#18:set 4,h:ld (hl),a  :set 5,h:ld (hl),a  :res 4,h:ld (hl),a  :res 3,h:ld (hl),a  :set 4,h:ld (hl),a  :res 5,h:ld (hl),#30:dec b:jp nz,mftout1:ret     ;'
mftchr040 ex de,hl:ld c,#30:ld (hl),#0C:set 3,h:ld (hl),#18:set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),#18:res 3,h:ld (hl),c  :set 4,h:ld (hl),#0C:res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;(
mftchr041 ex de,hl:ld c,#0c:ld (hl),#30:set 3,h:ld (hl),#18:set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),#18:res 3,h:ld (hl),c  :set 4,h:ld (hl),#30:res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;)
mftchr042 ex de,hl:         ld (hl),a  :set 3,h:ld (hl),#66:set 4,h:ld (hl),#FF:set 5,h:ld (hl),a  :res 4,h:ld (hl),#66:res 3,h:ld (hl),#3C:set 4,h:ld (hl),a  :res 5,h:ld (hl),#3C:dec b:jp nz,mftout1:ret     ;*
mftchr043 ex de,hl:ld c,#18:ld (hl),a  :set 3,h:ld (hl),c  :set 4,h:ld (hl),#7E:set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),a  :res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;+
mftchr044 ex de,hl:         ld (hl),a  :set 3,h:ld (hl),a  :set 4,h:ld (hl),a  :set 5,h:ld (hl),#30:res 4,h:ld (hl),#18:res 3,h:ld (hl),a  :set 4,h:ld (hl),#18:res 5,h:ld (hl),a  :dec b:jp nz,mftout1:ret     ;,
mftchr045 ex de,hl:         ld (hl),a  :set 3,h:ld (hl),a  :set 4,h:ld (hl),#7E:set 5,h:ld (hl),a  :res 4,h:ld (hl),a  :res 3,h:ld (hl),a  :set 4,h:ld (hl),a  :res 5,h:ld (hl),a  :dec b:jp nz,mftout1:ret     ;-
mftchr046 ex de,hl:         ld (hl),a  :set 3,h:ld (hl),a  :set 4,h:ld (hl),a  :set 5,h:ld (hl),a  :res 4,h:ld (hl),#18:res 3,h:ld (hl),a  :set 4,h:ld (hl),#18:res 5,h:ld (hl),a  :dec b:jp nz,mftout1:ret     ;.
mftchr047 ex de,hl:         ld (hl),#06:set 3,h:ld (hl),#0C:set 4,h:ld (hl),#30:set 5,h:ld (hl),a  :res 4,h:ld (hl),#C0:res 3,h:ld (hl),#60:set 4,h:ld (hl),#80:res 5,h:ld (hl),#18:dec b:jp nz,mftout1:ret     ;/
mftchr048 ex de,hl:         ld (hl),#38:set 3,h:ld (hl),#6C:set 4,h:ld (hl),#D6:set 5,h:ld (hl),a  :res 4,h:ld (hl),#6C:res 3,h:ld (hl),#C6:set 4,h:ld (hl),#38:res 5,h:ld (hl),#C6:dec b:jp nz,mftout1:ret     ;0
mftchr049 ex de,hl:ld c,#18:ld (hl),c  :set 3,h:ld (hl),#38:set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),#7E:res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;1
mftchr050 ex de,hl:         ld (hl),#7C:set 3,h:ld (hl),#C6:set 4,h:ld (hl),#1C:set 5,h:ld (hl),a  :res 4,h:ld (hl),#66:res 3,h:ld (hl),#30:set 4,h:ld (hl),#FE:res 5,h:ld (hl),#06:dec b:jp nz,mftout1:ret     ;2
mftchr051 ex de,hl:         ld (hl),#7C:set 3,h:ld (hl),#C6:set 4,h:ld (hl),#3C:set 5,h:ld (hl),a  :res 4,h:ld (hl),#C6:res 3,h:ld (hl),#06:set 4,h:ld (hl),#7C:res 5,h:ld (hl),#06:dec b:jp nz,mftout1:ret     ;3
mftchr052 ex de,hl:         ld (hl),#1C:set 3,h:ld (hl),#3C:set 4,h:ld (hl),#CC:set 5,h:ld (hl),a  :res 4,h:ld (hl),#0C:res 3,h:ld (hl),#FE:set 4,h:ld (hl),#1E:res 5,h:ld (hl),#6C:dec b:jp nz,mftout1:ret     ;4
mftchr053 ex de,hl:         ld (hl),#FE:set 3,h:ld (hl),#C0:set 4,h:ld (hl),#FC:set 5,h:ld (hl),a  :res 4,h:ld (hl),#C6:res 3,h:ld (hl),#06:set 4,h:ld (hl),#7C:res 5,h:ld (hl),#C0:dec b:jp nz,mftout1:ret     ;5
mftchr054 ex de,hl:         ld (hl),#38:set 3,h:ld (hl),#60:set 4,h:ld (hl),#FC:set 5,h:ld (hl),a  :res 4,h:ld (hl),#C6:res 3,h:ld (hl),#C6:set 4,h:ld (hl),#7C:res 5,h:ld (hl),#C0:dec b:jp nz,mftout1:ret     ;6
mftchr055 ex de,hl:ld c,#30:ld (hl),#FE:set 3,h:ld (hl),#C6:set 4,h:ld (hl),#18:set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),c  :res 5,h:ld (hl),#0C:dec b:jp nz,mftout1:ret     ;7
mftchr056 ex de,hl:ld c,#c6:ld (hl),#7C:set 3,h:ld (hl),c  :set 4,h:ld (hl),#7C:set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),#7C:res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;8
mftchr057 ex de,hl:         ld (hl),#7C:set 3,h:ld (hl),#C6:set 4,h:ld (hl),#7E:set 5,h:ld (hl),a  :res 4,h:ld (hl),#C6:res 3,h:ld (hl),#06:set 4,h:ld (hl),#7C:res 5,h:ld (hl),#C6:dec b:jp nz,mftout1:ret     ;9
mftchr058 ex de,hl:ld c,#18:ld (hl),a  :set 3,h:ld (hl),a  :set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),a  :set 4,h:ld (hl),c  :res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;:
mftchr059 ex de,hl:ld c,#18:ld (hl),a  :set 3,h:ld (hl),a  :set 4,h:ld (hl),c  :set 5,h:ld (hl),#30:res 4,h:ld (hl),c  :res 3,h:ld (hl),a  :set 4,h:ld (hl),c  :res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;;
mftchr060 ex de,hl:         ld (hl),#0C:set 3,h:ld (hl),#18:set 4,h:ld (hl),#60:set 5,h:ld (hl),a  :res 4,h:ld (hl),#18:res 3,h:ld (hl),#30:set 4,h:ld (hl),#0C:res 5,h:ld (hl),#30:dec b:jp nz,mftout1:ret     ;<
mftchr061 ex de,hl:         ld (hl),a  :set 3,h:ld (hl),a  :set 4,h:ld (hl),a  :set 5,h:ld (hl),a  :res 4,h:ld (hl),#7E:res 3,h:ld (hl),a  :set 4,h:ld (hl),a  :res 5,h:ld (hl),#7E:dec b:jp nz,mftout1:ret     ;=
mftchr062 ex de,hl:         ld (hl),#60:set 3,h:ld (hl),#30:set 4,h:ld (hl),#0C:set 5,h:ld (hl),a  :res 4,h:ld (hl),#30:res 3,h:ld (hl),#18:set 4,h:ld (hl),#60:res 5,h:ld (hl),#18:dec b:jp nz,mftout1:ret     ;>
mftchr063 ex de,hl:ld c,#18:ld (hl),#7C:set 3,h:ld (hl),#C6:set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),a  :res 3,h:ld (hl),c  :set 4,h:ld (hl),c  :res 5,h:ld (hl),#0C:dec b:jp nz,mftout1:ret     ;?
mftchr064 ex de,hl:         ld (hl),#7C:set 3,h:ld (hl),#C6:set 4,h:ld (hl),#DE:set 5,h:ld (hl),a  :res 4,h:ld (hl),#C0:res 3,h:ld (hl),#DE:set 4,h:ld (hl),#78:res 5,h:ld (hl),#DE:dec b:jp nz,mftout1:ret     ;@
mftchr065 ex de,hl:ld c,#c6:ld (hl),#38:set 3,h:ld (hl),#6C:set 4,h:ld (hl),#FE:set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),c  :res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;A
mftchr066 ex de,hl:ld c,#66:ld (hl),#FC:set 3,h:ld (hl),c  :set 4,h:ld (hl),#7C:set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),#FC:res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;B
mftchr067 ex de,hl:ld c,#c0:ld (hl),#3C:set 3,h:ld (hl),#66:set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),#66:res 3,h:ld (hl),c  :set 4,h:ld (hl),#3C:res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;C
mftchr068 ex de,hl:ld c,#66:ld (hl),#F8:set 3,h:ld (hl),#6C:set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),#6C:res 3,h:ld (hl),c  :set 4,h:ld (hl),#F8:res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;D
mftchr069 ex de,hl:         ld (hl),#FE:set 3,h:ld (hl),#62:set 4,h:ld (hl),#78:set 5,h:ld (hl),a  :res 4,h:ld (hl),#62:res 3,h:ld (hl),#68:set 4,h:ld (hl),#FE:res 5,h:ld (hl),#68:dec b:jp nz,mftout1:ret     ;E
mftchr070 ex de,hl:         ld (hl),#FE:set 3,h:ld (hl),#62:set 4,h:ld (hl),#78:set 5,h:ld (hl),a  :res 4,h:ld (hl),#60:res 3,h:ld (hl),#68:set 4,h:ld (hl),#F0:res 5,h:ld (hl),#68:dec b:jp nz,mftout1:ret     ;F
mftchr071 ex de,hl:         ld (hl),#3C:set 3,h:ld (hl),#66:set 4,h:ld (hl),#C0:set 5,h:ld (hl),a  :res 4,h:ld (hl),#66:res 3,h:ld (hl),#CE:set 4,h:ld (hl),#3A:res 5,h:ld (hl),#C0:dec b:jp nz,mftout1:ret     ;G
mftchr072 ex de,hl:ld c,#c6:ld (hl),c  :set 3,h:ld (hl),c  :set 4,h:ld (hl),#FE:set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),c  :res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;H
mftchr073 ex de,hl:ld c,#18:ld (hl),#3C:set 3,h:ld (hl),c  :set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),#3C:res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;I
mftchr074 ex de,hl:ld c,#0c:ld (hl),#1E:set 3,h:ld (hl),c  :set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),#CC:res 3,h:ld (hl),#CC:set 4,h:ld (hl),#78:res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;J
mftchr075 ex de,hl:         ld (hl),#E6:set 3,h:ld (hl),#66:set 4,h:ld (hl),#78:set 5,h:ld (hl),a  :res 4,h:ld (hl),#66:res 3,h:ld (hl),#6C:set 4,h:ld (hl),#E6:res 5,h:ld (hl),#6C:dec b:jp nz,mftout1:ret     ;K
mftchr076 ex de,hl:ld c,#60:ld (hl),#F0:set 3,h:ld (hl),c  :set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),#66:res 3,h:ld (hl),#62:set 4,h:ld (hl),#FE:res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;L
mftchr077 ex de,hl:ld c,#c6:ld (hl),c  :set 3,h:ld (hl),#EE:set 4,h:ld (hl),#FE:set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),#D6:set 4,h:ld (hl),c  :res 5,h:ld (hl),#FE:dec b:jp nz,mftout1:ret     ;M
mftchr078 ex de,hl:ld c,#c6:ld (hl),c  :set 3,h:ld (hl),#E6:set 4,h:ld (hl),#DE:set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),#CE:set 4,h:ld (hl),c  :res 5,h:ld (hl),#F6:dec b:jp nz,mftout1:ret     ;N
mftchr079 ex de,hl:ld c,#c6:ld (hl),#7C:set 3,h:ld (hl),c  :set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),#7C:res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;O
mftchr080 ex de,hl:         ld (hl),#FC:set 3,h:ld (hl),#66:set 4,h:ld (hl),#7C:set 5,h:ld (hl),a  :res 4,h:ld (hl),#60:res 3,h:ld (hl),#60:set 4,h:ld (hl),#F0:res 5,h:ld (hl),#66:dec b:jp nz,mftout1:ret     ;P
mftchr081 ex de,hl:ld c,#c6:ld (hl),#7C:set 3,h:ld (hl),c  :set 4,h:ld (hl),c  :set 5,h:ld (hl),#0E:res 4,h:ld (hl),#CE:res 3,h:ld (hl),c  :set 4,h:ld (hl),#7C:res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;Q
mftchr082 ex de,hl:ld c,#66:ld (hl),#FC:set 3,h:ld (hl),c  :set 4,h:ld (hl),#7C:set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),#6C:set 4,h:ld (hl),#E6:res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;R
mftchr083 ex de,hl:         ld (hl),#3C:set 3,h:ld (hl),#66:set 4,h:ld (hl),#18:set 5,h:ld (hl),a  :res 4,h:ld (hl),#66:res 3,h:ld (hl),#0C:set 4,h:ld (hl),#3C:res 5,h:ld (hl),#30:dec b:jp nz,mftout1:ret     ;S
mftchr084 ex de,hl:ld c,#18:ld (hl),#7E:set 3,h:ld (hl),#7E:set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),#3C:res 5,h:ld (hl),#5A:dec b:jp nz,mftout1:ret     ;T
mftchr085 ex de,hl:ld c,#66:ld (hl),c  :set 3,h:ld (hl),c  :set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),#3C:res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;U
mftchr086 ex de,hl:ld c,#c6:ld (hl),c  :set 3,h:ld (hl),c  :set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),#6C:res 3,h:ld (hl),c  :set 4,h:ld (hl),#38:res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;V
mftchr087 ex de,hl:ld c,#c6:ld (hl),c  :set 3,h:ld (hl),c  :set 4,h:ld (hl),#D6:set 5,h:ld (hl),a  :res 4,h:ld (hl),#FE:res 3,h:ld (hl),#D6:set 4,h:ld (hl),#6C:res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;W
mftchr088 ex de,hl:ld c,#c6:ld (hl),c  :set 3,h:ld (hl),c  :set 4,h:ld (hl),#38:set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),#6C:set 4,h:ld (hl),c  :res 5,h:ld (hl),#6C:dec b:jp nz,mftout1:ret     ;X
mftchr089 ex de,hl:ld c,#66:ld (hl),c  :set 3,h:ld (hl),c  :set 4,h:ld (hl),#3C:set 5,h:ld (hl),a  :res 4,h:ld (hl),#18:res 3,h:ld (hl),#18:set 4,h:ld (hl),#3C:res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;Y
mftchr090 ex de,hl:         ld (hl),#FE:set 3,h:ld (hl),#C6:set 4,h:ld (hl),#18:set 5,h:ld (hl),a  :res 4,h:ld (hl),#66:res 3,h:ld (hl),#32:set 4,h:ld (hl),#FE:res 5,h:ld (hl),#8C:dec b:jp nz,mftout1:ret     ;Z
mftchr091 ex de,hl:ld c,#30:ld (hl),#3C:set 3,h:ld (hl),c  :set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),#3C:res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;[
mftchr092 ex de,hl:         ld (hl),#C0:set 3,h:ld (hl),#60:set 4,h:ld (hl),#18:set 5,h:ld (hl),a  :res 4,h:ld (hl),#06:res 3,h:ld (hl),#0C:set 4,h:ld (hl),#02:res 5,h:ld (hl),#30:dec b:jp nz,mftout1:ret     ;\
mftchr093 ex de,hl:ld c,#0c:ld (hl),#3C:set 3,h:ld (hl),c  :set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),#3C:res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;]
mftchr094 ex de,hl:         ld (hl),#10:set 3,h:ld (hl),#38:set 4,h:ld (hl),#C6:set 5,h:ld (hl),a  :res 4,h:ld (hl),a  :res 3,h:ld (hl),a  :set 4,h:ld (hl),a  :res 5,h:ld (hl),#6C:dec b:jp nz,mftout1:ret     ;^
mftchr095 ex de,hl:         ld (hl),a  :set 3,h:ld (hl),a  :set 4,h:ld (hl),a  :set 5,h:ld (hl),#FF:res 4,h:ld (hl),a  :res 3,h:ld (hl),a  :set 4,h:ld (hl),a  :res 5,h:ld (hl),a  :dec b:jp nz,mftout1:ret     ;_
mftchr096 ex de,hl:         ld (hl),#30:set 3,h:ld (hl),#18:set 4,h:ld (hl),a  :set 5,h:ld (hl),a  :res 4,h:ld (hl),a  :res 3,h:ld (hl),a  :set 4,h:ld (hl),a  :res 5,h:ld (hl),#0C:dec b:jp nz,mftout1:ret     ;`
mftchr097 ex de,hl:         ld (hl),a  :set 3,h:ld (hl),a  :set 4,h:ld (hl),#0C:set 5,h:ld (hl),a  :res 4,h:ld (hl),#CC:res 3,h:ld (hl),#7C:set 4,h:ld (hl),#76:res 5,h:ld (hl),#78:dec b:jp nz,mftout1:ret     ;a
mftchr098 ex de,hl:ld c,#66:ld (hl),#E0:set 3,h:ld (hl),#60:set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),#DC:res 5,h:ld (hl),#7C:dec b:jp nz,mftout1:ret     ;b
mftchr099 ex de,hl:         ld (hl),a  :set 3,h:ld (hl),a  :set 4,h:ld (hl),#C6:set 5,h:ld (hl),a  :res 4,h:ld (hl),#C6:res 3,h:ld (hl),#C0:set 4,h:ld (hl),#7C:res 5,h:ld (hl),#7C:dec b:jp nz,mftout1:ret     ;c
mftchr100 ex de,hl:ld c,#cc:ld (hl),#1C:set 3,h:ld (hl),#0C:set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),#76:res 5,h:ld (hl),#7C:dec b:jp nz,mftout1:ret     ;d
mftchr101 ex de,hl:         ld (hl),a  :set 3,h:ld (hl),a  :set 4,h:ld (hl),#C6:set 5,h:ld (hl),a  :res 4,h:ld (hl),#C0:res 3,h:ld (hl),#FE:set 4,h:ld (hl),#7C:res 5,h:ld (hl),#7C:dec b:jp nz,mftout1:ret     ;e
mftchr102 ex de,hl:ld c,#60:ld (hl),#3C:set 3,h:ld (hl),#66:set 4,h:ld (hl),#F8:set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),#F8:res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;f
mftchr103 ex de,hl:         ld (hl),a  :set 3,h:ld (hl),a  :set 4,h:ld (hl),#CC:set 5,h:ld (hl),#F8:res 4,h:ld (hl),#7C:res 3,h:ld (hl),#CC:set 4,h:ld (hl),#0C:res 5,h:ld (hl),#76:dec b:jp nz,mftout1:ret     ;g
mftchr104 ex de,hl:         ld (hl),#E0:set 3,h:ld (hl),#60:set 4,h:ld (hl),#76:set 5,h:ld (hl),a  :res 4,h:ld (hl),#66:res 3,h:ld (hl),#66:set 4,h:ld (hl),#E6:res 5,h:ld (hl),#6C:dec b:jp nz,mftout1:ret     ;h
mftchr105 ex de,hl:ld c,#18:ld (hl),c  :set 3,h:ld (hl),a  :set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),#3C:res 5,h:ld (hl),#38:dec b:jp nz,mftout1:ret     ;i
mftchr106 ex de,hl:ld c,#06:ld (hl),c  :set 3,h:ld (hl),a  :set 4,h:ld (hl),c  :set 5,h:ld (hl),#3C:res 4,h:ld (hl),#66:res 3,h:ld (hl),c  :set 4,h:ld (hl),#66:res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;j
mftchr107 ex de,hl:         ld (hl),#E0:set 3,h:ld (hl),#60:set 4,h:ld (hl),#6C:set 5,h:ld (hl),a  :res 4,h:ld (hl),#6C:res 3,h:ld (hl),#78:set 4,h:ld (hl),#E6:res 5,h:ld (hl),#66:dec b:jp nz,mftout1:ret     ;k
mftchr108 ex de,hl:ld c,#18:ld (hl),#38:set 3,h:ld (hl),c  :set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),#3C:res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;l
mftchr109 ex de,hl:ld c,#d6:ld (hl),a  :set 3,h:ld (hl),a  :set 4,h:ld (hl),#FE:set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),c  :res 5,h:ld (hl),#EC:dec b:jp nz,mftout1:ret     ;m
mftchr110 ex de,hl:ld c,#66:ld (hl),a  :set 3,h:ld (hl),a  :set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),c  :res 5,h:ld (hl),#DC:dec b:jp nz,mftout1:ret     ;n
mftchr111 ex de,hl:ld c,#c6:ld (hl),a  :set 3,h:ld (hl),a  :set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),#7C:res 5,h:ld (hl),#7C:dec b:jp nz,mftout1:ret     ;o
mftchr112 ex de,hl:         ld (hl),a  :set 3,h:ld (hl),a  :set 4,h:ld (hl),#66:set 5,h:ld (hl),#F0:res 4,h:ld (hl),#7C:res 3,h:ld (hl),#66:set 4,h:ld (hl),#60:res 5,h:ld (hl),#DC:dec b:jp nz,mftout1:ret     ;p
mftchr113 ex de,hl:         ld (hl),a  :set 3,h:ld (hl),a  :set 4,h:ld (hl),#CC:set 5,h:ld (hl),#1E:res 4,h:ld (hl),#7C:res 3,h:ld (hl),#CC:set 4,h:ld (hl),#0C:res 5,h:ld (hl),#76:dec b:jp nz,mftout1:ret     ;q
mftchr114 ex de,hl:         ld (hl),a  :set 3,h:ld (hl),a  :set 4,h:ld (hl),#76:set 5,h:ld (hl),a  :res 4,h:ld (hl),#60:res 3,h:ld (hl),#60:set 4,h:ld (hl),#F0:res 5,h:ld (hl),#DC:dec b:jp nz,mftout1:ret     ;r
mftchr115 ex de,hl:         ld (hl),a  :set 3,h:ld (hl),a  :set 4,h:ld (hl),#C0:set 5,h:ld (hl),a  :res 4,h:ld (hl),#06:res 3,h:ld (hl),#7C:set 4,h:ld (hl),#FC:res 5,h:ld (hl),#7E:dec b:jp nz,mftout1:ret     ;s
mftchr116 ex de,hl:ld c,#30:ld (hl),c  :set 3,h:ld (hl),c  :set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),#36:res 3,h:ld (hl),c  :set 4,h:ld (hl),#1C:res 5,h:ld (hl),#FC:dec b:jp nz,mftout1:ret     ;t
mftchr117 ex de,hl:ld c,#cc:ld (hl),a  :set 3,h:ld (hl),a  :set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),#76:res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;u
mftchr118 ex de,hl:ld c,#c6:ld (hl),a  :set 3,h:ld (hl),a  :set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),#6C:res 3,h:ld (hl),c  :set 4,h:ld (hl),#38:res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;v
mftchr119 ex de,hl:         ld (hl),a  :set 3,h:ld (hl),a  :set 4,h:ld (hl),#D6:set 5,h:ld (hl),a  :res 4,h:ld (hl),#FE:res 3,h:ld (hl),#D6:set 4,h:ld (hl),#6C:res 5,h:ld (hl),#C6:dec b:jp nz,mftout1:ret     ;w
mftchr120 ex de,hl:         ld (hl),a  :set 3,h:ld (hl),a  :set 4,h:ld (hl),#6C:set 5,h:ld (hl),a  :res 4,h:ld (hl),#6C:res 3,h:ld (hl),#38:set 4,h:ld (hl),#C6:res 5,h:ld (hl),#C6:dec b:jp nz,mftout1:ret     ;x
mftchr121 ex de,hl:         ld (hl),a  :set 3,h:ld (hl),a  :set 4,h:ld (hl),#C6:set 5,h:ld (hl),#FC:res 4,h:ld (hl),#7E:res 3,h:ld (hl),#C6:set 4,h:ld (hl),#06:res 5,h:ld (hl),#C6:dec b:jp nz,mftout1:ret     ;y
mftchr122 ex de,hl:         ld (hl),a  :set 3,h:ld (hl),a  :set 4,h:ld (hl),#4C:set 5,h:ld (hl),a  :res 4,h:ld (hl),#32:res 3,h:ld (hl),#18:set 4,h:ld (hl),#7E:res 5,h:ld (hl),#7E:dec b:jp nz,mftout1:ret     ;z
mftchr123 ex de,hl:ld c,#18:ld (hl),#0E:set 3,h:ld (hl),c  :set 4,h:ld (hl),#70:set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),#0E:res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;{
mftchr124 ex de,hl:ld c,#18:ld (hl),c  :set 3,h:ld (hl),c  :set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),c  :res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;|
mftchr125 ex de,hl:ld c,#18:ld (hl),#70:set 3,h:ld (hl),c  :set 4,h:ld (hl),#0E:set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),#70:res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;}
mftchr126 ex de,hl:         ld (hl),#76:set 3,h:ld (hl),#DC:set 4,h:ld (hl),a  :set 5,h:ld (hl),a  :res 4,h:ld (hl),a  :res 3,h:ld (hl),a  :set 4,h:ld (hl),a  :res 5,h:ld (hl),a  :dec b:jp nz,mftout1:ret     ;~
mftchr127 ex de,hl:         ld (hl),a  :set 3,h:ld (hl),#10:set 4,h:ld (hl),#6c:set 5,h:ld (hl),a  :res 4,h:ld (hl),#c6:res 3,h:ld (hl),#c6:set 4,h:ld (hl),#fe:res 5,h:ld (hl),#38:dec b:jp nz,mftout1:ret     ;
mftchr128 ex de,hl:ld c,#78:ld (hl),c  :set 3,h:ld (hl),#cc:set 4,h:ld (hl),#cc:set 5,h:ld (hl),c  :res 4,h:ld (hl),#18:res 3,h:ld (hl),c  :set 4,h:ld (hl),#0c:res 5,h:ld (hl),#c0:dec b:jp nz,mftout1:ret     ;€
mftchr129 ex de,hl:ld c,#cc:ld (hl),a  :set 3,h:ld (hl),c  :set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),#7e:res 5,h:ld (hl),a  :dec b:jp nz,mftout1:ret     ;
mftchr130 ex de,hl:         ld (hl),#1c:set 3,h:ld (hl),a  :set 4,h:ld (hl),#cc:set 5,h:ld (hl),a  :res 4,h:ld (hl),#c0:res 3,h:ld (hl),#fc:set 4,h:ld (hl),#78:res 5,h:ld (hl),#78:dec b:jp nz,mftout1:ret     ;‚
mftchr131 ex de,hl:         ld (hl),#7e:set 3,h:ld (hl),#c3:set 4,h:ld (hl),#06:set 5,h:ld (hl),a  :res 4,h:ld (hl),#66:res 3,h:ld (hl),#3e:set 4,h:ld (hl),#3f:res 5,h:ld (hl),#3c:dec b:jp nz,mftout1:ret     ;ƒ
mftchr132 ex de,hl:         ld (hl),#cc:set 3,h:ld (hl),a  :set 4,h:ld (hl),#0c:set 5,h:ld (hl),a  :res 4,h:ld (hl),#cc:res 3,h:ld (hl),#7c:set 4,h:ld (hl),#7e:res 5,h:ld (hl),#78:dec b:jp nz,mftout1:ret     ;„
mftchr133 ex de,hl:         ld (hl),#e0:set 3,h:ld (hl),a  :set 4,h:ld (hl),#0c:set 5,h:ld (hl),a  :res 4,h:ld (hl),#cc:res 3,h:ld (hl),#7c:set 4,h:ld (hl),#7e:res 5,h:ld (hl),#78:dec b:jp nz,mftout1:ret     ;…
mftchr134 ex de,hl:         ld (hl),#30:set 3,h:ld (hl),#30:set 4,h:ld (hl),#0c:set 5,h:ld (hl),a  :res 4,h:ld (hl),#cc:res 3,h:ld (hl),#7c:set 4,h:ld (hl),#7e:res 5,h:ld (hl),#78:dec b:jp nz,mftout1:ret     ;†
mftchr135 ex de,hl:         ld (hl),a  :set 3,h:ld (hl),a  :set 4,h:ld (hl),#c0:set 5,h:ld (hl),#38:res 4,h:ld (hl),#78:res 3,h:ld (hl),#c0:set 4,h:ld (hl),#0c:res 5,h:ld (hl),#78:dec b:jp nz,mftout1:ret     ;‡
mftchr136 ex de,hl:         ld (hl),#7e:set 3,h:ld (hl),#c3:set 4,h:ld (hl),#66:set 5,h:ld (hl),a  :res 4,h:ld (hl),#60:res 3,h:ld (hl),#7e:set 4,h:ld (hl),#3c:res 5,h:ld (hl),#3c:dec b:jp nz,mftout1:ret     ;ˆ
mftchr137 ex de,hl:         ld (hl),#cc:set 3,h:ld (hl),a  :set 4,h:ld (hl),#cc:set 5,h:ld (hl),a  :res 4,h:ld (hl),#c0:res 3,h:ld (hl),#fc:set 4,h:ld (hl),#78:res 5,h:ld (hl),#78:dec b:jp nz,mftout1:ret     ;‰
mftchr138 ex de,hl:         ld (hl),#e0:set 3,h:ld (hl),a  :set 4,h:ld (hl),#cc:set 5,h:ld (hl),a  :res 4,h:ld (hl),#c0:res 3,h:ld (hl),#fc:set 4,h:ld (hl),#78:res 5,h:ld (hl),#78:dec b:jp nz,mftout1:ret     ;Š
mftchr139 ex de,hl:ld c,#30:ld (hl),#cc:set 3,h:ld (hl),a  :set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),#78:res 5,h:ld (hl),#70:dec b:jp nz,mftout1:ret     ;‹
mftchr140 ex de,hl:ld c,#18:ld (hl),#7c:set 3,h:ld (hl),#c6:set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),#3c:res 5,h:ld (hl),#38:dec b:jp nz,mftout1:ret     ;Œ
mftchr141 ex de,hl:ld c,#30:ld (hl),#e0:set 3,h:ld (hl),a  :set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),#78:res 5,h:ld (hl),#70:dec b:jp nz,mftout1:ret     ;
mftchr142 ex de,hl:ld c,#c6:ld (hl),c  :set 3,h:ld (hl),#38:set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),#fe:set 4,h:ld (hl),c  :res 5,h:ld (hl),#6c:dec b:jp nz,mftout1:ret     ;
mftchr143 ex de,hl:         ld (hl),#30:set 3,h:ld (hl),#30:set 4,h:ld (hl),#78:set 5,h:ld (hl),a  :res 4,h:ld (hl),#fc:res 3,h:ld (hl),#cc:set 4,h:ld (hl),#cc:res 5,h:ld (hl),a  :dec b:jp nz,mftout1:ret     ;
mftchr144 ex de,hl:         ld (hl),#1c:set 3,h:ld (hl),a  :set 4,h:ld (hl),#60:set 5,h:ld (hl),a  :res 4,h:ld (hl),#60:res 3,h:ld (hl),#78:set 4,h:ld (hl),#fc:res 5,h:ld (hl),#fc:dec b:jp nz,mftout1:ret     ;
mftchr145 ex de,hl:ld c,#7f:ld (hl),a  :set 3,h:ld (hl),a  :set 4,h:ld (hl),#0c:set 5,h:ld (hl),a  :res 4,h:ld (hl),#cc:res 3,h:ld (hl),c  :set 4,h:ld (hl),c  :res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;‘
mftchr146 ex de,hl:ld c,#cc:ld (hl),#3e:set 3,h:ld (hl),#6c:set 4,h:ld (hl),#fe:set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),#ce:res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;’
mftchr147 ex de,hl:ld c,#78:ld (hl),c  :set 3,h:ld (hl),#cc:set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),#cc:res 3,h:ld (hl),#cc:set 4,h:ld (hl),c  :res 5,h:ld (hl),a  :dec b:jp nz,mftout1:ret     ;“
mftchr148 ex de,hl:ld c,#cc:ld (hl),a  :set 3,h:ld (hl),c  :set 4,h:ld (hl),#78:set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),#78:res 5,h:ld (hl),a  :dec b:jp nz,mftout1:ret     ;”
mftchr149 ex de,hl:         ld (hl),a  :set 3,h:ld (hl),#e0:set 4,h:ld (hl),#78:set 5,h:ld (hl),a  :res 4,h:ld (hl),#cc:res 3,h:ld (hl),#cc:set 4,h:ld (hl),#78:res 5,h:ld (hl),a  :dec b:jp nz,mftout1:ret     ;•
mftchr150 ex de,hl:ld c,#cc:ld (hl),#78:set 3,h:ld (hl),c  :set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),#7e:res 5,h:ld (hl),a  :dec b:jp nz,mftout1:ret     ;–
mftchr151 ex de,hl:ld c,#cc:ld (hl),a  :set 3,h:ld (hl),#e0:set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),#7e:res 5,h:ld (hl),a  :dec b:jp nz,mftout1:ret     ;—
mftchr152 ex de,hl:ld c,#cc:ld (hl),a  :set 3,h:ld (hl),c  :set 4,h:ld (hl),c  :set 5,h:ld (hl),#f8:res 4,h:ld (hl),#7c:res 3,h:ld (hl),c  :set 4,h:ld (hl),#0c:res 5,h:ld (hl),a  :dec b:jp nz,mftout1:ret     ;
mftchr153 ex de,hl:         ld (hl),#c3:set 3,h:ld (hl),#18:set 4,h:ld (hl),#66:set 5,h:ld (hl),a  :res 4,h:ld (hl),#3c:res 3,h:ld (hl),#66:set 4,h:ld (hl),#18:res 5,h:ld (hl),#3c:dec b:jp nz,mftout1:ret     ;™
mftchr154 ex de,hl:ld c,#cc:ld (hl),c  :set 3,h:ld (hl),a  :set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),#78:res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;š
mftchr155 ex de,hl:ld c,#18:ld (hl),c  :set 3,h:ld (hl),c  :set 4,h:ld (hl),#c0:set 5,h:ld (hl),c  :res 4,h:ld (hl),#7e:res 3,h:ld (hl),#c0:set 4,h:ld (hl),c  :res 5,h:ld (hl),#7e:dec b:jp nz,mftout1:ret     ;›
mftchr156 ex de,hl:         ld (hl),#38:set 3,h:ld (hl),#6c:set 4,h:ld (hl),#f0:set 5,h:ld (hl),a  :res 4,h:ld (hl),#e6:res 3,h:ld (hl),#60:set 4,h:ld (hl),#fc:res 5,h:ld (hl),#64:dec b:jp nz,mftout1:ret     ;œ
mftchr157 ex de,hl:ld c,#30:ld (hl),#cc:set 3,h:ld (hl),#cc:set 4,h:ld (hl),#fc:set 5,h:ld (hl),c  :res 4,h:ld (hl),#fc:res 3,h:ld (hl),c  :set 4,h:ld (hl),c  :res 5,h:ld (hl),#78:dec b:jp nz,mftout1:ret     ;
mftchr158 ex de,hl:         ld (hl),#f8:set 3,h:ld (hl),#cc:set 4,h:ld (hl),#fa:set 5,h:ld (hl),#c7:res 4,h:ld (hl),#cf:res 3,h:ld (hl),#c6:set 4,h:ld (hl),#c6:res 5,h:ld (hl),#cc:dec b:jp nz,mftout1:ret     ;
mftchr159 ex de,hl:ld c,#18:ld (hl),#0e:set 3,h:ld (hl),#1b:set 4,h:ld (hl),#3c:set 5,h:ld (hl),#70:res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),#d8:res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;Ÿ
mftchr160 ex de,hl:         ld (hl),#1c:set 3,h:ld (hl),a  :set 4,h:ld (hl),#0c:set 5,h:ld (hl),a  :res 4,h:ld (hl),#cc:res 3,h:ld (hl),#7c:set 4,h:ld (hl),#7e:res 5,h:ld (hl),#78:dec b:jp nz,mftout1:ret     ; 
mftchr161 ex de,hl:ld c,#30:ld (hl),#38:set 3,h:ld (hl),a  :set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),#78:res 5,h:ld (hl),#70:dec b:jp nz,mftout1:ret     ;¡
mftchr162 ex de,hl:         ld (hl),a  :set 3,h:ld (hl),#1c:set 4,h:ld (hl),#78:set 5,h:ld (hl),a  :res 4,h:ld (hl),#cc:res 3,h:ld (hl),#cc:set 4,h:ld (hl),#78:res 5,h:ld (hl),a  :dec b:jp nz,mftout1:ret     ;¢
mftchr163 ex de,hl:ld c,#cc:ld (hl),a  :set 3,h:ld (hl),#1c:set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),#7e:res 5,h:ld (hl),a  :dec b:jp nz,mftout1:ret     ;£
mftchr164 ex de,hl:ld c,#cc:ld (hl),a  :set 3,h:ld (hl),#f8:set 4,h:ld (hl),#f8:set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),c  :res 5,h:ld (hl),a  :dec b:jp nz,mftout1:ret     ;¤
mftchr165 ex de,hl:         ld (hl),#fc:set 3,h:ld (hl),a  :set 4,h:ld (hl),#ec:set 5,h:ld (hl),a  :res 4,h:ld (hl),#dc:res 3,h:ld (hl),#fc:set 4,h:ld (hl),#cc:res 5,h:ld (hl),#cc:dec b:jp nz,mftout1:ret     ;¥
mftchr166 ex de,hl:         ld (hl),#3c:set 3,h:ld (hl),#6c:set 4,h:ld (hl),#3e:set 5,h:ld (hl),a  :res 4,h:ld (hl),#7e:res 3,h:ld (hl),a  :set 4,h:ld (hl),a  :res 5,h:ld (hl),#6c:dec b:jp nz,mftout1:ret     ;¦
mftchr167 ex de,hl:         ld (hl),#38:set 3,h:ld (hl),#6c:set 4,h:ld (hl),#38:set 5,h:ld (hl),a  :res 4,h:ld (hl),#7c:res 3,h:ld (hl),a  :set 4,h:ld (hl),a  :res 5,h:ld (hl),#6c:dec b:jp nz,mftout1:ret     ;§
mftchr168 ex de,hl:         ld (hl),#30:set 3,h:ld (hl),a  :set 4,h:ld (hl),#60:set 5,h:ld (hl),a  :res 4,h:ld (hl),#cc:res 3,h:ld (hl),#c0:set 4,h:ld (hl),#78:res 5,h:ld (hl),#30:dec b:jp nz,mftout1:ret     ;¨
mftchr169 ex de,hl:         ld (hl),a  :set 3,h:ld (hl),a  :set 4,h:ld (hl),#fc:set 5,h:ld (hl),a  :res 4,h:ld (hl),#c0:res 3,h:ld (hl),#c0:set 4,h:ld (hl),a  :res 5,h:ld (hl),a  :dec b:jp nz,mftout1:ret     ;©
mftchr170 ex de,hl:         ld (hl),a  :set 3,h:ld (hl),a  :set 4,h:ld (hl),#fc:set 5,h:ld (hl),a  :res 4,h:ld (hl),#0c:res 3,h:ld (hl),#0c:set 4,h:ld (hl),a  :res 5,h:ld (hl),a  :dec b:jp nz,mftout1:ret     ;ª
mftchr171 ex de,hl:         ld (hl),#c3:set 3,h:ld (hl),#c6:set 4,h:ld (hl),#de:set 5,h:ld (hl),#0f:res 4,h:ld (hl),#66:res 3,h:ld (hl),#33:set 4,h:ld (hl),#cc:res 5,h:ld (hl),#cc:dec b:jp nz,mftout1:ret     ;«
mftchr172 ex de,hl:         ld (hl),#c3:set 3,h:ld (hl),#c6:set 4,h:ld (hl),#db:set 5,h:ld (hl),#03:res 4,h:ld (hl),#6f:res 3,h:ld (hl),#37:set 4,h:ld (hl),#cf:res 5,h:ld (hl),#cc:dec b:jp nz,mftout1:ret     ;¬
mftchr173 ex de,hl:ld c,#18:ld (hl),c  :set 3,h:ld (hl),c  :set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),c  :res 5,h:ld (hl),a  :dec b:jp nz,mftout1:ret     ;­
mftchr174 ex de,hl:         ld (hl),a  :set 3,h:ld (hl),#33:set 4,h:ld (hl),#cc:set 5,h:ld (hl),a  :res 4,h:ld (hl),#33:res 3,h:ld (hl),#66:set 4,h:ld (hl),a  :res 5,h:ld (hl),#66:dec b:jp nz,mftout1:ret     ;®
mftchr175 ex de,hl:         ld (hl),a  :set 3,h:ld (hl),#cc:set 4,h:ld (hl),#33:set 5,h:ld (hl),a  :res 4,h:ld (hl),#cc:res 3,h:ld (hl),#66:set 4,h:ld (hl),a  :res 5,h:ld (hl),#66:dec b:jp nz,mftout1:ret     ;¯
mftchr176 ex de,hl:ld c,#22:ld (hl),c  :set 3,h:ld (hl),#88:set 4,h:ld (hl),#88:set 5,h:ld (hl),#88:res 4,h:ld (hl),#88:res 3,h:ld (hl),c  :set 4,h:ld (hl),c  :res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;°
mftchr177 ex de,hl:ld c,#55:ld (hl),c  :set 3,h:ld (hl),#aa:set 4,h:ld (hl),#aa:set 5,h:ld (hl),#aa:res 4,h:ld (hl),#aa:res 3,h:ld (hl),c  :set 4,h:ld (hl),c  :res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;±
mftchr178 ex de,hl:ld c,#db:ld (hl),c  :set 3,h:ld (hl),#77:set 4,h:ld (hl),#ee:set 5,h:ld (hl),#ee:res 4,h:ld (hl),#77:res 3,h:ld (hl),c  :set 4,h:ld (hl),c  :res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;²
mftchr179 ex de,hl:ld c,#18:ld (hl),c  :set 3,h:ld (hl),c  :set 4,h:ld (hl),c  :set 5,h:ld (hl),c  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),c  :res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;³
mftchr180 ex de,hl:ld c,#18:ld (hl),c  :set 3,h:ld (hl),c  :set 4,h:ld (hl),c  :set 5,h:ld (hl),c  :res 4,h:ld (hl),c  :res 3,h:ld (hl),#f8:set 4,h:ld (hl),c  :res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;´
mftchr181 ex de,hl:ld c,#18:ld (hl),c  :set 3,h:ld (hl),c  :set 4,h:ld (hl),c  :set 5,h:ld (hl),c  :res 4,h:ld (hl),c  :res 3,h:ld (hl),#f8:set 4,h:ld (hl),c  :res 5,h:ld (hl),#f8:dec b:jp nz,mftout1:ret     ;µ
mftchr182 ex de,hl:ld c,#36:ld (hl),c  :set 3,h:ld (hl),c  :set 4,h:ld (hl),c  :set 5,h:ld (hl),c  :res 4,h:ld (hl),c  :res 3,h:ld (hl),#f6:set 4,h:ld (hl),c  :res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;¶
mftchr183 ex de,hl:ld c,#36:ld (hl),a  :set 3,h:ld (hl),a  :set 4,h:ld (hl),a  :set 5,h:ld (hl),c  :res 4,h:ld (hl),c  :res 3,h:ld (hl),#fe:set 4,h:ld (hl),c  :res 5,h:ld (hl),a  :dec b:jp nz,mftout1:ret     ;·
mftchr184 ex de,hl:ld c,#18:ld (hl),a  :set 3,h:ld (hl),a  :set 4,h:ld (hl),c  :set 5,h:ld (hl),c  :res 4,h:ld (hl),c  :res 3,h:ld (hl),#f8:set 4,h:ld (hl),c  :res 5,h:ld (hl),#f8:dec b:jp nz,mftout1:ret     ;¸
mftchr185 ex de,hl:ld c,#36:ld (hl),c  :set 3,h:ld (hl),c  :set 4,h:ld (hl),#06:set 5,h:ld (hl),c  :res 4,h:ld (hl),c  :res 3,h:ld (hl),#f6:set 4,h:ld (hl),c  :res 5,h:ld (hl),#f6:dec b:jp nz,mftout1:ret     ;¹
mftchr186 ex de,hl:ld c,#36:ld (hl),c  :set 3,h:ld (hl),c  :set 4,h:ld (hl),c  :set 5,h:ld (hl),c  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),c  :res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;º
mftchr187 ex de,hl:ld c,#36:ld (hl),a  :set 3,h:ld (hl),a  :set 4,h:ld (hl),#06:set 5,h:ld (hl),c  :res 4,h:ld (hl),c  :res 3,h:ld (hl),#f6:set 4,h:ld (hl),c  :res 5,h:ld (hl),#fe:dec b:jp nz,mftout1:ret     ;»
mftchr188 ex de,hl:         ld (hl),#36:set 3,h:ld (hl),#36:set 4,h:ld (hl),#06:set 5,h:ld (hl),a  :res 4,h:ld (hl),a  :res 3,h:ld (hl),#fe:set 4,h:ld (hl),a  :res 5,h:ld (hl),#f6:dec b:jp nz,mftout1:ret     ;¼
mftchr189 ex de,hl:ld c,#36:ld (hl),c  :set 3,h:ld (hl),c  :set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),a  :res 3,h:ld (hl),#fe:set 4,h:ld (hl),a  :res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;½
mftchr190 ex de,hl:ld c,#18:ld (hl),c  :set 3,h:ld (hl),c  :set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),a  :res 3,h:ld (hl),#f8:set 4,h:ld (hl),a  :res 5,h:ld (hl),#f8:dec b:jp nz,mftout1:ret     ;¾
mftchr191 ex de,hl:ld c,#18:ld (hl),a  :set 3,h:ld (hl),a  :set 4,h:ld (hl),a  :set 5,h:ld (hl),c  :res 4,h:ld (hl),c  :res 3,h:ld (hl),#f8:set 4,h:ld (hl),c  :res 5,h:ld (hl),a  :dec b:jp nz,mftout1:ret     ;¿
mftchr192 ex de,hl:ld c,#18:ld (hl),c  :set 3,h:ld (hl),c  :set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),a  :res 3,h:ld (hl),#1f:set 4,h:ld (hl),a  :res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;À
mftchr193 ex de,hl:ld c,#18:ld (hl),c  :set 3,h:ld (hl),c  :set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),a  :res 3,h:ld (hl),#ff:set 4,h:ld (hl),a  :res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;Á
mftchr194 ex de,hl:ld c,#18:ld (hl),a  :set 3,h:ld (hl),a  :set 4,h:ld (hl),a  :set 5,h:ld (hl),c  :res 4,h:ld (hl),c  :res 3,h:ld (hl),#ff:set 4,h:ld (hl),c  :res 5,h:ld (hl),a  :dec b:jp nz,mftout1:ret     ;Â
mftchr195 ex de,hl:ld c,#18:ld (hl),c  :set 3,h:ld (hl),c  :set 4,h:ld (hl),c  :set 5,h:ld (hl),c  :res 4,h:ld (hl),c  :res 3,h:ld (hl),#1f:set 4,h:ld (hl),c  :res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;Ã
mftchr196 ex de,hl:         ld (hl),a  :set 3,h:ld (hl),a  :set 4,h:ld (hl),a  :set 5,h:ld (hl),a  :res 4,h:ld (hl),a  :res 3,h:ld (hl),#ff:set 4,h:ld (hl),a  :res 5,h:ld (hl),a  :dec b:jp nz,mftout1:ret     ;Ä
mftchr197 ex de,hl:ld c,#18:ld (hl),c  :set 3,h:ld (hl),c  :set 4,h:ld (hl),c  :set 5,h:ld (hl),c  :res 4,h:ld (hl),c  :res 3,h:ld (hl),#ff:set 4,h:ld (hl),c  :res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;Å
mftchr198 ex de,hl:ld c,#18:ld (hl),c  :set 3,h:ld (hl),c  :set 4,h:ld (hl),c  :set 5,h:ld (hl),c  :res 4,h:ld (hl),c  :res 3,h:ld (hl),#1f:set 4,h:ld (hl),c  :res 5,h:ld (hl),#1f:dec b:jp nz,mftout1:ret     ;Æ
mftchr199 ex de,hl:ld c,#36:ld (hl),c  :set 3,h:ld (hl),c  :set 4,h:ld (hl),c  :set 5,h:ld (hl),c  :res 4,h:ld (hl),c  :res 3,h:ld (hl),#37:set 4,h:ld (hl),c  :res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;Ç
mftchr200 ex de,hl:         ld (hl),#36:set 3,h:ld (hl),#36:set 4,h:ld (hl),#30:set 5,h:ld (hl),a  :res 4,h:ld (hl),a  :res 3,h:ld (hl),#3f:set 4,h:ld (hl),a  :res 5,h:ld (hl),#37:dec b:jp nz,mftout1:ret     ;È
mftchr201 ex de,hl:ld c,#36:ld (hl),a  :set 3,h:ld (hl),a  :set 4,h:ld (hl),#30:set 5,h:ld (hl),c  :res 4,h:ld (hl),c  :res 3,h:ld (hl),#37:set 4,h:ld (hl),c  :res 5,h:ld (hl),#3f:dec b:jp nz,mftout1:ret     ;É
mftchr202 ex de,hl:         ld (hl),#36:set 3,h:ld (hl),#36:set 4,h:ld (hl),a  :set 5,h:ld (hl),a  :res 4,h:ld (hl),a  :res 3,h:ld (hl),#ff:set 4,h:ld (hl),a  :res 5,h:ld (hl),#f7:dec b:jp nz,mftout1:ret     ;Ê
mftchr203 ex de,hl:ld c,#36:ld (hl),a  :set 3,h:ld (hl),a  :set 4,h:ld (hl),a  :set 5,h:ld (hl),c  :res 4,h:ld (hl),c  :res 3,h:ld (hl),#f7:set 4,h:ld (hl),c  :res 5,h:ld (hl),#ff:dec b:jp nz,mftout1:ret     ;Ë
mftchr204 ex de,hl:ld c,#36:ld (hl),c  :set 3,h:ld (hl),c  :set 4,h:ld (hl),#30:set 5,h:ld (hl),c  :res 4,h:ld (hl),c  :res 3,h:ld (hl),#37:set 4,h:ld (hl),c  :res 5,h:ld (hl),#37:dec b:jp nz,mftout1:ret     ;Ì
mftchr205 ex de,hl:         ld (hl),a  :set 3,h:ld (hl),a  :set 4,h:ld (hl),a  :set 5,h:ld (hl),a  :res 4,h:ld (hl),a  :res 3,h:ld (hl),#ff:set 4,h:ld (hl),a  :res 5,h:ld (hl),#ff:dec b:jp nz,mftout1:ret     ;Í
mftchr206 ex de,hl:ld c,#36:ld (hl),c  :set 3,h:ld (hl),c  :set 4,h:ld (hl),a  :set 5,h:ld (hl),c  :res 4,h:ld (hl),c  :res 3,h:ld (hl),#f7:set 4,h:ld (hl),c  :res 5,h:ld (hl),#f7:dec b:jp nz,mftout1:ret     ;Î
mftchr207 ex de,hl:         ld (hl),#18:set 3,h:ld (hl),#18:set 4,h:ld (hl),a  :set 5,h:ld (hl),a  :res 4,h:ld (hl),a  :res 3,h:ld (hl),#ff:set 4,h:ld (hl),a  :res 5,h:ld (hl),#ff:dec b:jp nz,mftout1:ret     ;Ï
mftchr208 ex de,hl:ld c,#36:ld (hl),c  :set 3,h:ld (hl),c  :set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),a  :res 3,h:ld (hl),#ff:set 4,h:ld (hl),a  :res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;Ğ
mftchr209 ex de,hl:ld c,#18:ld (hl),a  :set 3,h:ld (hl),a  :set 4,h:ld (hl),a  :set 5,h:ld (hl),c  :res 4,h:ld (hl),c  :res 3,h:ld (hl),#ff:set 4,h:ld (hl),c  :res 5,h:ld (hl),#ff:dec b:jp nz,mftout1:ret     ;Ñ
mftchr210 ex de,hl:ld c,#36:ld (hl),a  :set 3,h:ld (hl),a  :set 4,h:ld (hl),a  :set 5,h:ld (hl),c  :res 4,h:ld (hl),c  :res 3,h:ld (hl),#ff:set 4,h:ld (hl),c  :res 5,h:ld (hl),a  :dec b:jp nz,mftout1:ret     ;Ò
mftchr211 ex de,hl:ld c,#36:ld (hl),c  :set 3,h:ld (hl),c  :set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),a  :res 3,h:ld (hl),#3f:set 4,h:ld (hl),a  :res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;Ó
mftchr212 ex de,hl:ld c,#18:ld (hl),c  :set 3,h:ld (hl),c  :set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),a  :res 3,h:ld (hl),#1f:set 4,h:ld (hl),a  :res 5,h:ld (hl),#1f:dec b:jp nz,mftout1:ret     ;Ô
mftchr213 ex de,hl:ld c,#18:ld (hl),a  :set 3,h:ld (hl),a  :set 4,h:ld (hl),c  :set 5,h:ld (hl),c  :res 4,h:ld (hl),c  :res 3,h:ld (hl),#1f:set 4,h:ld (hl),c  :res 5,h:ld (hl),#1f:dec b:jp nz,mftout1:ret     ;Õ
mftchr214 ex de,hl:ld c,#36:ld (hl),a  :set 3,h:ld (hl),a  :set 4,h:ld (hl),a  :set 5,h:ld (hl),c  :res 4,h:ld (hl),c  :res 3,h:ld (hl),#3f:set 4,h:ld (hl),c  :res 5,h:ld (hl),a  :dec b:jp nz,mftout1:ret     ;Ö
mftchr215 ex de,hl:ld c,#36:ld (hl),c  :set 3,h:ld (hl),c  :set 4,h:ld (hl),c  :set 5,h:ld (hl),c  :res 4,h:ld (hl),c  :res 3,h:ld (hl),#ff:set 4,h:ld (hl),c  :res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;×
mftchr216 ex de,hl:ld c,#18:ld (hl),c  :set 3,h:ld (hl),c  :set 4,h:ld (hl),c  :set 5,h:ld (hl),c  :res 4,h:ld (hl),c  :res 3,h:ld (hl),#ff:set 4,h:ld (hl),c  :res 5,h:ld (hl),#ff:dec b:jp nz,mftout1:ret     ;Ø
mftchr217 ex de,hl:ld c,#18:ld (hl),c  :set 3,h:ld (hl),c  :set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),a  :res 3,h:ld (hl),#f8:set 4,h:ld (hl),a  :res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;Ù
mftchr218 ex de,hl:ld c,#18:ld (hl),a  :set 3,h:ld (hl),a  :set 4,h:ld (hl),a  :set 5,h:ld (hl),c  :res 4,h:ld (hl),c  :res 3,h:ld (hl),#1f:set 4,h:ld (hl),c  :res 5,h:ld (hl),a  :dec b:jp nz,mftout1:ret     ;Ú
mftchr219 ex de,hl:ld c,#ff:ld (hl),c  :set 3,h:ld (hl),c  :set 4,h:ld (hl),c  :set 5,h:ld (hl),c  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),c  :res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;Û
mftchr220 ex de,hl:ld c,#ff:ld (hl),a  :set 3,h:ld (hl),a  :set 4,h:ld (hl),a  :set 5,h:ld (hl),c  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),c  :res 5,h:ld (hl),a  :dec b:jp nz,mftout1:ret     ;Ü
mftchr221 ex de,hl:ld c,#f0:ld (hl),c  :set 3,h:ld (hl),c  :set 4,h:ld (hl),c  :set 5,h:ld (hl),c  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),c  :res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;İ
mftchr222 ex de,hl:ld c,#0f:ld (hl),c  :set 3,h:ld (hl),c  :set 4,h:ld (hl),c  :set 5,h:ld (hl),c  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),c  :res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;Ş
mftchr223 ex de,hl:ld c,#ff:ld (hl),c  :set 3,h:ld (hl),c  :set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),a  :res 3,h:ld (hl),a  :set 4,h:ld (hl),a  :res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;ß
mftchr224 ex de,hl:         ld (hl),a  :set 3,h:ld (hl),a  :set 4,h:ld (hl),#dc:set 5,h:ld (hl),a  :res 4,h:ld (hl),#dc:res 3,h:ld (hl),#c8:set 4,h:ld (hl),#76:res 5,h:ld (hl),#76:dec b:jp nz,mftout1:ret     ;à
mftchr225 ex de,hl:         ld (hl),a  :set 3,h:ld (hl),#78:set 4,h:ld (hl),#f8:set 5,h:ld (hl),#c0:res 4,h:ld (hl),#f8:res 3,h:ld (hl),#cc:set 4,h:ld (hl),#c0:res 5,h:ld (hl),#cc:dec b:jp nz,mftout1:ret     ;á
mftchr226 ex de,hl:ld c,#c0:ld (hl),a  :set 3,h:ld (hl),#fc:set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),c  :res 5,h:ld (hl),#cc:dec b:jp nz,mftout1:ret     ;â
mftchr227 ex de,hl:ld c,#6c:ld (hl),a  :set 3,h:ld (hl),#fe:set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),c  :res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;ã
mftchr228 ex de,hl:         ld (hl),#fc:set 3,h:ld (hl),#cc:set 4,h:ld (hl),#30:set 5,h:ld (hl),a  :res 4,h:ld (hl),#cc:res 3,h:ld (hl),#60:set 4,h:ld (hl),#fc:res 5,h:ld (hl),#60:dec b:jp nz,mftout1:ret     ;ä
mftchr229 ex de,hl:ld c,#d8:ld (hl),a  :set 3,h:ld (hl),a  :set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),#70:res 5,h:ld (hl),#7e:dec b:jp nz,mftout1:ret     ;å
mftchr230 ex de,hl:ld c,#66:ld (hl),a  :set 3,h:ld (hl),c  :set 4,h:ld (hl),c  :set 5,h:ld (hl),#c0:res 4,h:ld (hl),#7c:res 3,h:ld (hl),c  :set 4,h:ld (hl),#60:res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;æ
mftchr231 ex de,hl:ld c,#18:ld (hl),a  :set 3,h:ld (hl),#76:set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),c  :res 5,h:ld (hl),#dc:dec b:jp nz,mftout1:ret     ;ç
mftchr232 ex de,hl:         ld (hl),#fc:set 3,h:ld (hl),#30:set 4,h:ld (hl),#cc:set 5,h:ld (hl),#fc:res 4,h:ld (hl),#78:res 3,h:ld (hl),#cc:set 4,h:ld (hl),#30:res 5,h:ld (hl),#78:dec b:jp nz,mftout1:ret     ;è
mftchr233 ex de,hl:         ld (hl),#38:set 3,h:ld (hl),#6c:set 4,h:ld (hl),#fe:set 5,h:ld (hl),a  :res 4,h:ld (hl),#6c:res 3,h:ld (hl),#c6:set 4,h:ld (hl),#38:res 5,h:ld (hl),#c6:dec b:jp nz,mftout1:ret     ;é
mftchr234 ex de,hl:ld c,#6c:ld (hl),#38:set 3,h:ld (hl),c  :set 4,h:ld (hl),#c6:set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),#ee:res 5,h:ld (hl),#c6:dec b:jp nz,mftout1:ret     ;ê
mftchr235 ex de,hl:         ld (hl),#1c:set 3,h:ld (hl),#30:set 4,h:ld (hl),#7c:set 5,h:ld (hl),a  :res 4,h:ld (hl),#cc:res 3,h:ld (hl),#cc:set 4,h:ld (hl),#78:res 5,h:ld (hl),#18:dec b:jp nz,mftout1:ret     ;ë
mftchr236 ex de,hl:         ld (hl),a  :set 3,h:ld (hl),a  :set 4,h:ld (hl),#db:set 5,h:ld (hl),a  :res 4,h:ld (hl),#7e:res 3,h:ld (hl),#db:set 4,h:ld (hl),a  :res 5,h:ld (hl),#7e:dec b:jp nz,mftout1:ret     ;ì
mftchr237 ex de,hl:         ld (hl),#06:set 3,h:ld (hl),#0c:set 4,h:ld (hl),#db:set 5,h:ld (hl),#c0:res 4,h:ld (hl),#7e:res 3,h:ld (hl),#db:set 4,h:ld (hl),#60:res 5,h:ld (hl),#7e:dec b:jp nz,mftout1:ret     ;í
mftchr238 ex de,hl:         ld (hl),#38:set 3,h:ld (hl),#60:set 4,h:ld (hl),#f8:set 5,h:ld (hl),a  :res 4,h:ld (hl),#60:res 3,h:ld (hl),#c0:set 4,h:ld (hl),#38:res 5,h:ld (hl),#c0:dec b:jp nz,mftout1:ret     ;î
mftchr239 ex de,hl:ld c,#cc:ld (hl),#78:set 3,h:ld (hl),c  :set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),c  :res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;ï
mftchr240 ex de,hl:ld c,#fc:ld (hl),a  :set 3,h:ld (hl),c  :set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),a  :set 4,h:ld (hl),a  :res 5,h:ld (hl),a  :dec b:jp nz,mftout1:ret     ;ğ
mftchr241 ex de,hl:ld c,#30:ld (hl),c  :set 3,h:ld (hl),c  :set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),a  :res 3,h:ld (hl),c  :set 4,h:ld (hl),#fc:res 5,h:ld (hl),#fc:dec b:jp nz,mftout1:ret     ;ñ
mftchr242 ex de,hl:         ld (hl),#60:set 3,h:ld (hl),#30:set 4,h:ld (hl),#30:set 5,h:ld (hl),a  :res 4,h:ld (hl),a  :res 3,h:ld (hl),#60:set 4,h:ld (hl),#fc:res 5,h:ld (hl),#18:dec b:jp nz,mftout1:ret     ;ò
mftchr243 ex de,hl:         ld (hl),#18:set 3,h:ld (hl),#30:set 4,h:ld (hl),#30:set 5,h:ld (hl),a  :res 4,h:ld (hl),a  :res 3,h:ld (hl),#18:set 4,h:ld (hl),#fc:res 5,h:ld (hl),#60:dec b:jp nz,mftout1:ret     ;ó
mftchr244 ex de,hl:ld c,#18:ld (hl),#0e:set 3,h:ld (hl),#1b:set 4,h:ld (hl),c  :set 5,h:ld (hl),c  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),c  :res 5,h:ld (hl),#1b:dec b:jp nz,mftout1:ret     ;ô
mftchr245 ex de,hl:ld c,#18:ld (hl),c  :set 3,h:ld (hl),c  :set 4,h:ld (hl),c  :set 5,h:ld (hl),#70:res 4,h:ld (hl),#d8:res 3,h:ld (hl),c  :set 4,h:ld (hl),#d8:res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;õ
mftchr246 ex de,hl:ld c,#30:ld (hl),c  :set 3,h:ld (hl),c  :set 4,h:ld (hl),#fc:set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),a  :set 4,h:ld (hl),c  :res 5,h:ld (hl),a  :dec b:jp nz,mftout1:ret     ;ö
mftchr247 ex de,hl:         ld (hl),a  :set 3,h:ld (hl),#76:set 4,h:ld (hl),a  :set 5,h:ld (hl),a  :res 4,h:ld (hl),#dc:res 3,h:ld (hl),#76:set 4,h:ld (hl),a  :res 5,h:ld (hl),#dc:dec b:jp nz,mftout1:ret     ;÷
mftchr248 ex de,hl:         ld (hl),#38:set 3,h:ld (hl),#6c:set 4,h:ld (hl),#38:set 5,h:ld (hl),a  :res 4,h:ld (hl),a  :res 3,h:ld (hl),a  :set 4,h:ld (hl),a  :res 5,h:ld (hl),#6c:dec b:jp nz,mftout1:ret     ;ø
mftchr249 ex de,hl:         ld (hl),a  :set 3,h:ld (hl),a  :set 4,h:ld (hl),#18:set 5,h:ld (hl),a  :res 4,h:ld (hl),a  :res 3,h:ld (hl),#18:set 4,h:ld (hl),a  :res 5,h:ld (hl),a  :dec b:jp nz,mftout1:ret     ;ù
mftchr250 ex de,hl:         ld (hl),a  :set 3,h:ld (hl),a  :set 4,h:ld (hl),a  :set 5,h:ld (hl),a  :res 4,h:ld (hl),a  :res 3,h:ld (hl),#18:set 4,h:ld (hl),a  :res 5,h:ld (hl),a  :dec b:jp nz,mftout1:ret     ;ú
mftchr251 ex de,hl:ld c,#0c:ld (hl),#0f:set 3,h:ld (hl),c  :set 4,h:ld (hl),c  :set 5,h:ld (hl),#1c:res 4,h:ld (hl),#6c:res 3,h:ld (hl),#ec:set 4,h:ld (hl),#3c:res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;û
mftchr252 ex de,hl:ld c,#6c:ld (hl),#78:set 3,h:ld (hl),c  :set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),a  :res 3,h:ld (hl),c  :set 4,h:ld (hl),a  :res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;ü
mftchr253 ex de,hl:         ld (hl),#70:set 3,h:ld (hl),#18:set 4,h:ld (hl),#60:set 5,h:ld (hl),a  :res 4,h:ld (hl),a  :res 3,h:ld (hl),#78:set 4,h:ld (hl),a  :res 5,h:ld (hl),#30:dec b:jp nz,mftout1:ret     ;ı
mftchr254 ex de,hl:ld c,#3c:ld (hl),a  :set 3,h:ld (hl),a  :set 4,h:ld (hl),c  :set 5,h:ld (hl),a  :res 4,h:ld (hl),c  :res 3,h:ld (hl),c  :set 4,h:ld (hl),a  :res 5,h:ld (hl),c  :dec b:jp nz,mftout1:ret     ;ş
mftchr255 ex de,hl:         ld (hl),a  :set 3,h:ld (hl),a  :set 4,h:ld (hl),a  :set 5,h:ld (hl),a  :res 4,h:ld (hl),a  :res 3,h:ld (hl),a  :set 4,h:ld (hl),a  :res 5,h:ld (hl),a  :dec b:jp nz,mftout1:ret     ;ÿ
mftchr256 ;for relocating

;==============================================================================
;--- EP -----------------------------------------------------------------------
;==============================================================================

elseif computer_mode=3

mftchrtab
dw mftchr127,mftchr127,mftchr127,mftchr127,mftchr127,mftchr127,mftchr127,mftchr127,mftchr127,mftchr127,mftchr127,mftchr127,mftchr127,mftchr127,mftchr127,mftchr127
dw mftchr127,mftchr127,mftchr127,mftchr127,mftchr127,mftchr127,mftchr127,mftchr127,mftchr127,mftchr127,mftchr127,mftchr127,mftchr127,mftchr127,mftchr127,mftchr127
dw mftchr032,mftchr033,mftchr034,mftchr035,mftchr036,mftchr037,mftchr038,mftchr039
dw mftchr040,mftchr041,mftchr042,mftchr043,mftchr044,mftchr045,mftchr046,mftchr047
dw mftchr048,mftchr049,mftchr050,mftchr051,mftchr052,mftchr053,mftchr054,mftchr055
dw mftchr056,mftchr057,mftchr058,mftchr059,mftchr060,mftchr061,mftchr062,mftchr063
dw mftchr064,mftchr065,mftchr066,mftchr067,mftchr068,mftchr069,mftchr070,mftchr071
dw mftchr072,mftchr073,mftchr074,mftchr075,mftchr076,mftchr077,mftchr078,mftchr079
dw mftchr080,mftchr081,mftchr082,mftchr083,mftchr084,mftchr085,mftchr086,mftchr087
dw mftchr088,mftchr089,mftchr090,mftchr091,mftchr092,mftchr093,mftchr094,mftchr095
dw mftchr096,mftchr097,mftchr098,mftchr099,mftchr100,mftchr101,mftchr102,mftchr103
dw mftchr104,mftchr105,mftchr106,mftchr107,mftchr108,mftchr109,mftchr110,mftchr111
dw mftchr112,mftchr113,mftchr114,mftchr115,mftchr116,mftchr117,mftchr118,mftchr119
dw mftchr120,mftchr121,mftchr122,mftchr123,mftchr124,mftchr125,mftchr126,mftchr127
dw mftchr128    ;for relocating

scrlptadr   equ #fe80
scrlpt
db 256-199,#12,11,51    ;XXX lines (display screen area)
db 256-001,#12,11,51    ;XXX lines (display screen area)
db 256-051,#12,63, 0    ; 51 lines, size of the bottom border
db 256-004,#10, 6,63    ;  4 lines, sync on
db 256-001,#90,63,32    ;  1 line, sync switch of at half line; Nick generates IRQ here
db 256-004,#12, 6,63    ;  4 empty lines (VBLANK)
db 256-052,#13,63, 0    ; 52 lines, size of top border, reload flag set

;oben    = 200-y
;unten   = y-200+ylen
;bottom  = 251-ylen

;wenn unten <=0
;oben = ylen, unten = 1, bottom = 250-ylen

mftofs  ei
        ld (scrlptadr+00+4),iy
        ld a,e
        sub 200
        add d
        jr z,mftofs2
        jr nc,mftofs2
        neg
        ld b,a
        ld a,56
        add e
        ld c,a
        ld a,5
        ld hl,256*51+11
mftofs1 add d
        ld (scrlptadr+32),a
        ld a,c
        ld (scrlptadr+00),a
        ld a,b
        ld (scrlptadr+16),a
        ld (scrlptadr+16+2),hl
        ret
mftofs2 ld a,256
        sub d
        ld c,a
        ld b,256-1
        ld a,6
        ld hl,256*00+63
        jr mftofs1
if 0
;### MFTOFS -> Set scroll offset
;### E = line offset (0-192), IY=memory offset (#c000-#fc00)
mftofs  ld a,e
        or a
        jr z,mftofs2
        neg
        ld (scrlptadr+16),a    ;unten = x -> 256-x
        add 199
        cpl
        ld hl,#c000
mftofs1 ld (scrlptadr+00),a    ;oben = 200-x -> 256-x
        ld (scrlptadr+00+4),iy
        ld (scrlptadr+16+4),hl
        ret
mftofs2 ld a,256-1
        ld (scrlptadr+16),a
        ld a,256-199
        ld hl,80*199+#c000
        jr mftofs1
endif
;### MFTINI -> Mode 2 und Farben setzen (EP)
mftini  ei
        ld hl,scrlpt
        res 7,h
        set 6,h
        ld de,scrlptadr
        db #dd:ld l,7
        xor a
        ld b,a
mftini1 ld c,4
        ldir
        ld b,12
mftini2 ld (de),a
        inc de
        djnz mftini2
        db #dd:dec l
        jr nz,mftini1
        ld hl,#c000
        ld (16*1+scrlptadr+4),hl
        ld a,#e8
        out (#82),a
        ld a,#0f
        out (#83),a
        set 6,a
        out (#83),a
        set 7,a
        out (#83),a
        ret

;### MFTCOL -> Farbe setzen
;### Eingabe        DE=colour code, IY=hintergrund(scrlptadr+8)/vordergrund(scrlptadr+9)
mftcol  ei
        ld c,e
        rr d            ;d0-2   =red
        rr e:rr e       ;e0-1   =blue
        rl c:rl c:rl c  ;c0-1,cf=green
             rla        ;g0
        rr d:rla        ;r0
        rr e:rla        ;b0
        rr c:rla        ;g1
        rr d:rla        ;r1
        rr e:rla        ;b1
        rr c:rla        ;g2
        rr d:rla        ;r2
        ld (iy+00),a
        ld (iy+16),a
        ret

;### MFTCLR -> Löscht den Bildschirm
mftclr  ei
        ld hl,#c000
        ld de,#c001
        ld (hl),l
        ld bc,80*200-1
        ldir
        ret

;### MFTINV -> Invertiert die untern 4 Zeilen eines Zeichens
;### Eingabe    DE=Bildschirmadresse
mftinv  ei
        ld hl,80*4
        add hl,de
        ld de,80
        ld b,4
mftinv1 ld a,(hl)
        cpl
        ld (hl),a
        add hl,de
        djnz mftinv1
        ret

;### MFTFLL -> Löscht mehrere Zeichen hintereinander
;### Eingabe    IYL=Länge, DE=Bildschirmadresse
mftfll  ei
        db #fd:ld a,l
        ex de,hl
        ld bc,80
        ld de,-7*80+1
mftfll1 ld (hl),b:add hl,bc
        ld (hl),b:add hl,bc
        ld (hl),b:add hl,bc
        ld (hl),b:add hl,bc
        ld (hl),b:add hl,bc
        ld (hl),b:add hl,bc
        ld (hl),b:add hl,bc
        ld (hl),b:add hl,de
        dec a
        jr nz,mftfll1
        ret

;### MFTOUT -> Gibt Text in Mode2 mit maximal möglicher Geschwindigkeit aus
;### Eingabe    scrbuf=Text, IYL=Länge, DE=Bildschirmadresse
mftout  ld ix,scrbuf
        ei
        db #fd:ld a,l
        ld b,0
        jr mftout2
mftout1 ld de,-7*80+1       ;3
        add hl,de           ;3
        ex de,hl            ;1
mftout2 ld l,(ix+0)         ;5
mftout3 inc ix              ;3
        sla l               ;2
mftout4 ld h,mftchrtab/256  ;2
        ld c,(hl)           ;2
        inc l               ;1
        ld h,(hl)           ;2
        ld l,c              ;1
        ld c,80             ;2
        jp (hl)             ;1 28 + 42-50 -> 70-78

ds 3    ;for relocating
mftchr032 ex de,hl:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;
mftchr033 ex de,hl:ld (hl),#18:add hl,bc:ld (hl),#3C:add hl,bc:ld (hl),#3C:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),b  :add hl,bc:ld (hl),#18:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;!
mftchr034 ex de,hl:ld (hl),#6C:add hl,bc:ld (hl),#6C:add hl,bc:ld (hl),#28:add hl,bc:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;"
mftchr035 ex de,hl:ld (hl),#6C:add hl,bc:ld (hl),#6C:add hl,bc:ld (hl),#FE:add hl,bc:ld (hl),#6C:add hl,bc:ld (hl),#FE:add hl,bc:ld (hl),#6C:add hl,bc:ld (hl),#6C:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;#
mftchr036 ex de,hl:ld (hl),#18:add hl,bc:ld (hl),#3E:add hl,bc:ld (hl),#60:add hl,bc:ld (hl),#3C:add hl,bc:ld (hl),#06:add hl,bc:ld (hl),#7C:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;$
mftchr037 ex de,hl:ld (hl),b  :add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#CC:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#30:add hl,bc:ld (hl),#66:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;%
mftchr038 ex de,hl:ld (hl),#38:add hl,bc:ld (hl),#6C:add hl,bc:ld (hl),#38:add hl,bc:ld (hl),#76:add hl,bc:ld (hl),#DC:add hl,bc:ld (hl),#CC:add hl,bc:ld (hl),#76:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;&
mftchr039 ex de,hl:ld (hl),#18:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#30:add hl,bc:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;'
mftchr040 ex de,hl:ld (hl),#0C:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#30:add hl,bc:ld (hl),#30:add hl,bc:ld (hl),#30:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#0C:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;(
mftchr041 ex de,hl:ld (hl),#30:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#0C:add hl,bc:ld (hl),#0C:add hl,bc:ld (hl),#0C:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#30:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;)
mftchr042 ex de,hl:ld (hl),b  :add hl,bc:ld (hl),#66:add hl,bc:ld (hl),#3C:add hl,bc:ld (hl),#FF:add hl,bc:ld (hl),#3C:add hl,bc:ld (hl),#66:add hl,bc:ld (hl),b  :add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;*
mftchr043 ex de,hl:ld (hl),b  :add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#7E:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),b  :add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;+
mftchr044 ex de,hl:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#30:dec a:jp nz,mftout1:ret ;,
mftchr045 ex de,hl:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),#7E:add hl,bc:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;-
mftchr046 ex de,hl:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;.
mftchr047 ex de,hl:ld (hl),#06:add hl,bc:ld (hl),#0C:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#30:add hl,bc:ld (hl),#60:add hl,bc:ld (hl),#C0:add hl,bc:ld (hl),#80:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;/
mftchr048 ex de,hl:ld (hl),#38:add hl,bc:ld (hl),#6C:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#D6:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#6C:add hl,bc:ld (hl),#38:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;0
mftchr049 ex de,hl:ld (hl),#18:add hl,bc:ld (hl),#38:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#7E:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;1
mftchr050 ex de,hl:ld (hl),#7C:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#06:add hl,bc:ld (hl),#1C:add hl,bc:ld (hl),#30:add hl,bc:ld (hl),#66:add hl,bc:ld (hl),#FE:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;2
mftchr051 ex de,hl:ld (hl),#7C:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#06:add hl,bc:ld (hl),#3C:add hl,bc:ld (hl),#06:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#7C:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;3
mftchr052 ex de,hl:ld (hl),#1C:add hl,bc:ld (hl),#3C:add hl,bc:ld (hl),#6C:add hl,bc:ld (hl),#CC:add hl,bc:ld (hl),#FE:add hl,bc:ld (hl),#0C:add hl,bc:ld (hl),#1E:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;4
mftchr053 ex de,hl:ld (hl),#FE:add hl,bc:ld (hl),#C0:add hl,bc:ld (hl),#C0:add hl,bc:ld (hl),#FC:add hl,bc:ld (hl),#06:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#7C:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;5
mftchr054 ex de,hl:ld (hl),#38:add hl,bc:ld (hl),#60:add hl,bc:ld (hl),#C0:add hl,bc:ld (hl),#FC:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#7C:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;6
mftchr055 ex de,hl:ld (hl),#FE:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#0C:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#30:add hl,bc:ld (hl),#30:add hl,bc:ld (hl),#30:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;7
mftchr056 ex de,hl:ld (hl),#7C:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#7C:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#7C:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;8
mftchr057 ex de,hl:ld (hl),#7C:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#7E:add hl,bc:ld (hl),#06:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#7C:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;9
mftchr058 ex de,hl:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),b  :add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;:
mftchr059 ex de,hl:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),b  :add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#30:dec a:jp nz,mftout1:ret ;;
mftchr060 ex de,hl:ld (hl),#0C:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#30:add hl,bc:ld (hl),#60:add hl,bc:ld (hl),#30:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#0C:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;<
mftchr061 ex de,hl:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),#7E:add hl,bc:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),#7E:add hl,bc:ld (hl),b  :add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;=
mftchr062 ex de,hl:ld (hl),#60:add hl,bc:ld (hl),#30:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#0C:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#30:add hl,bc:ld (hl),#60:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;>
mftchr063 ex de,hl:ld (hl),#7C:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#0C:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),b  :add hl,bc:ld (hl),#18:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;?
mftchr064 ex de,hl:ld (hl),#7C:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#DE:add hl,bc:ld (hl),#DE:add hl,bc:ld (hl),#DE:add hl,bc:ld (hl),#C0:add hl,bc:ld (hl),#78:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;@
mftchr065 ex de,hl:ld (hl),#38:add hl,bc:ld (hl),#6C:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#FE:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;A
mftchr066 ex de,hl:ld (hl),#FC:add hl,bc:ld (hl),#66:add hl,bc:ld (hl),#66:add hl,bc:ld (hl),#7C:add hl,bc:ld (hl),#66:add hl,bc:ld (hl),#66:add hl,bc:ld (hl),#FC:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;B
mftchr067 ex de,hl:ld (hl),#3C:add hl,bc:ld (hl),#66:add hl,bc:ld (hl),#C0:add hl,bc:ld (hl),#C0:add hl,bc:ld (hl),#C0:add hl,bc:ld (hl),#66:add hl,bc:ld (hl),#3C:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;C
mftchr068 ex de,hl:ld (hl),#F8:add hl,bc:ld (hl),#6C:add hl,bc:ld (hl),#66:add hl,bc:ld (hl),#66:add hl,bc:ld (hl),#66:add hl,bc:ld (hl),#6C:add hl,bc:ld (hl),#F8:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;D
mftchr069 ex de,hl:ld (hl),#FE:add hl,bc:ld (hl),#62:add hl,bc:ld (hl),#68:add hl,bc:ld (hl),#78:add hl,bc:ld (hl),#68:add hl,bc:ld (hl),#62:add hl,bc:ld (hl),#FE:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;E
mftchr070 ex de,hl:ld (hl),#FE:add hl,bc:ld (hl),#62:add hl,bc:ld (hl),#68:add hl,bc:ld (hl),#78:add hl,bc:ld (hl),#68:add hl,bc:ld (hl),#60:add hl,bc:ld (hl),#F0:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;F
mftchr071 ex de,hl:ld (hl),#3C:add hl,bc:ld (hl),#66:add hl,bc:ld (hl),#C0:add hl,bc:ld (hl),#C0:add hl,bc:ld (hl),#CE:add hl,bc:ld (hl),#66:add hl,bc:ld (hl),#3A:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;G
mftchr072 ex de,hl:ld (hl),#C6:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#FE:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;H
mftchr073 ex de,hl:ld (hl),#3C:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#3C:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;I
mftchr074 ex de,hl:ld (hl),#1E:add hl,bc:ld (hl),#0C:add hl,bc:ld (hl),#0C:add hl,bc:ld (hl),#0C:add hl,bc:ld (hl),#CC:add hl,bc:ld (hl),#CC:add hl,bc:ld (hl),#78:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;J
mftchr075 ex de,hl:ld (hl),#E6:add hl,bc:ld (hl),#66:add hl,bc:ld (hl),#6C:add hl,bc:ld (hl),#78:add hl,bc:ld (hl),#6C:add hl,bc:ld (hl),#66:add hl,bc:ld (hl),#E6:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;K
mftchr076 ex de,hl:ld (hl),#F0:add hl,bc:ld (hl),#60:add hl,bc:ld (hl),#60:add hl,bc:ld (hl),#60:add hl,bc:ld (hl),#62:add hl,bc:ld (hl),#66:add hl,bc:ld (hl),#FE:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;L
mftchr077 ex de,hl:ld (hl),#C6:add hl,bc:ld (hl),#EE:add hl,bc:ld (hl),#FE:add hl,bc:ld (hl),#FE:add hl,bc:ld (hl),#D6:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;M
mftchr078 ex de,hl:ld (hl),#C6:add hl,bc:ld (hl),#E6:add hl,bc:ld (hl),#F6:add hl,bc:ld (hl),#DE:add hl,bc:ld (hl),#CE:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;N
mftchr079 ex de,hl:ld (hl),#7C:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#7C:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;O
mftchr080 ex de,hl:ld (hl),#FC:add hl,bc:ld (hl),#66:add hl,bc:ld (hl),#66:add hl,bc:ld (hl),#7C:add hl,bc:ld (hl),#60:add hl,bc:ld (hl),#60:add hl,bc:ld (hl),#F0:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;P
mftchr081 ex de,hl:ld (hl),#7C:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#CE:add hl,bc:ld (hl),#7C:add hl,bc:ld (hl),#0E:dec a:jp nz,mftout1:ret ;Q
mftchr082 ex de,hl:ld (hl),#FC:add hl,bc:ld (hl),#66:add hl,bc:ld (hl),#66:add hl,bc:ld (hl),#7C:add hl,bc:ld (hl),#6C:add hl,bc:ld (hl),#66:add hl,bc:ld (hl),#E6:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;R
mftchr083 ex de,hl:ld (hl),#3C:add hl,bc:ld (hl),#66:add hl,bc:ld (hl),#30:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#0C:add hl,bc:ld (hl),#66:add hl,bc:ld (hl),#3C:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;S
mftchr084 ex de,hl:ld (hl),#7E:add hl,bc:ld (hl),#7E:add hl,bc:ld (hl),#5A:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#3C:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;T
mftchr085 ex de,hl:ld (hl),#66:add hl,bc:ld (hl),#66:add hl,bc:ld (hl),#66:add hl,bc:ld (hl),#66:add hl,bc:ld (hl),#66:add hl,bc:ld (hl),#66:add hl,bc:ld (hl),#3C:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;U
mftchr086 ex de,hl:ld (hl),#C6:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#6C:add hl,bc:ld (hl),#38:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;V
mftchr087 ex de,hl:ld (hl),#C6:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#D6:add hl,bc:ld (hl),#D6:add hl,bc:ld (hl),#FE:add hl,bc:ld (hl),#6C:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;W
mftchr088 ex de,hl:ld (hl),#C6:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#6C:add hl,bc:ld (hl),#38:add hl,bc:ld (hl),#6C:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;X
mftchr089 ex de,hl:ld (hl),#66:add hl,bc:ld (hl),#66:add hl,bc:ld (hl),#66:add hl,bc:ld (hl),#3C:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#3C:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;Y
mftchr090 ex de,hl:ld (hl),#FE:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#8C:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#32:add hl,bc:ld (hl),#66:add hl,bc:ld (hl),#FE:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;Z
mftchr091 ex de,hl:ld (hl),#3C:add hl,bc:ld (hl),#30:add hl,bc:ld (hl),#30:add hl,bc:ld (hl),#30:add hl,bc:ld (hl),#30:add hl,bc:ld (hl),#30:add hl,bc:ld (hl),#3C:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;[
mftchr092 ex de,hl:ld (hl),#C0:add hl,bc:ld (hl),#60:add hl,bc:ld (hl),#30:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#0C:add hl,bc:ld (hl),#06:add hl,bc:ld (hl),#02:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;\
mftchr093 ex de,hl:ld (hl),#3C:add hl,bc:ld (hl),#0C:add hl,bc:ld (hl),#0C:add hl,bc:ld (hl),#0C:add hl,bc:ld (hl),#0C:add hl,bc:ld (hl),#0C:add hl,bc:ld (hl),#3C:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;]
mftchr094 ex de,hl:ld (hl),#10:add hl,bc:ld (hl),#38:add hl,bc:ld (hl),#6C:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;^
mftchr095 ex de,hl:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),#FF:dec a:jp nz,mftout1:ret ;_
mftchr096 ex de,hl:ld (hl),#30:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#0C:add hl,bc:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;`
mftchr097 ex de,hl:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),#78:add hl,bc:ld (hl),#0C:add hl,bc:ld (hl),#7C:add hl,bc:ld (hl),#CC:add hl,bc:ld (hl),#76:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;a
mftchr098 ex de,hl:ld (hl),#E0:add hl,bc:ld (hl),#60:add hl,bc:ld (hl),#7C:add hl,bc:ld (hl),#66:add hl,bc:ld (hl),#66:add hl,bc:ld (hl),#66:add hl,bc:ld (hl),#DC:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;b
mftchr099 ex de,hl:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),#7C:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#C0:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#7C:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;c
mftchr100 ex de,hl:ld (hl),#1C:add hl,bc:ld (hl),#0C:add hl,bc:ld (hl),#7C:add hl,bc:ld (hl),#CC:add hl,bc:ld (hl),#CC:add hl,bc:ld (hl),#CC:add hl,bc:ld (hl),#76:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;d
mftchr101 ex de,hl:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),#7C:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#FE:add hl,bc:ld (hl),#C0:add hl,bc:ld (hl),#7C:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;e
mftchr102 ex de,hl:ld (hl),#3C:add hl,bc:ld (hl),#66:add hl,bc:ld (hl),#60:add hl,bc:ld (hl),#F8:add hl,bc:ld (hl),#60:add hl,bc:ld (hl),#60:add hl,bc:ld (hl),#F8:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;f
mftchr103 ex de,hl:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),#76:add hl,bc:ld (hl),#CC:add hl,bc:ld (hl),#CC:add hl,bc:ld (hl),#7C:add hl,bc:ld (hl),#0C:add hl,bc:ld (hl),#F8:dec a:jp nz,mftout1:ret ;g
mftchr104 ex de,hl:ld (hl),#E0:add hl,bc:ld (hl),#60:add hl,bc:ld (hl),#6C:add hl,bc:ld (hl),#76:add hl,bc:ld (hl),#66:add hl,bc:ld (hl),#66:add hl,bc:ld (hl),#E6:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;h
mftchr105 ex de,hl:ld (hl),#18:add hl,bc:ld (hl),b  :add hl,bc:ld (hl),#38:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#3C:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;i
mftchr106 ex de,hl:ld (hl),#06:add hl,bc:ld (hl),b  :add hl,bc:ld (hl),#06:add hl,bc:ld (hl),#06:add hl,bc:ld (hl),#06:add hl,bc:ld (hl),#66:add hl,bc:ld (hl),#66:add hl,bc:ld (hl),#3C:dec a:jp nz,mftout1:ret ;j
mftchr107 ex de,hl:ld (hl),#E0:add hl,bc:ld (hl),#60:add hl,bc:ld (hl),#66:add hl,bc:ld (hl),#6C:add hl,bc:ld (hl),#78:add hl,bc:ld (hl),#6C:add hl,bc:ld (hl),#E6:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;k
mftchr108 ex de,hl:ld (hl),#38:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#3C:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;l
mftchr109 ex de,hl:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),#EC:add hl,bc:ld (hl),#FE:add hl,bc:ld (hl),#D6:add hl,bc:ld (hl),#D6:add hl,bc:ld (hl),#D6:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;m
mftchr110 ex de,hl:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),#DC:add hl,bc:ld (hl),#66:add hl,bc:ld (hl),#66:add hl,bc:ld (hl),#66:add hl,bc:ld (hl),#66:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;n
mftchr111 ex de,hl:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),#7C:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#7C:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;o
mftchr112 ex de,hl:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),#DC:add hl,bc:ld (hl),#66:add hl,bc:ld (hl),#66:add hl,bc:ld (hl),#7C:add hl,bc:ld (hl),#60:add hl,bc:ld (hl),#F0:dec a:jp nz,mftout1:ret ;p
mftchr113 ex de,hl:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),#76:add hl,bc:ld (hl),#CC:add hl,bc:ld (hl),#CC:add hl,bc:ld (hl),#7C:add hl,bc:ld (hl),#0C:add hl,bc:ld (hl),#1E:dec a:jp nz,mftout1:ret ;q
mftchr114 ex de,hl:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),#DC:add hl,bc:ld (hl),#76:add hl,bc:ld (hl),#60:add hl,bc:ld (hl),#60:add hl,bc:ld (hl),#F0:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;r
mftchr115 ex de,hl:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),#7E:add hl,bc:ld (hl),#C0:add hl,bc:ld (hl),#7C:add hl,bc:ld (hl),#06:add hl,bc:ld (hl),#FC:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;s
mftchr116 ex de,hl:ld (hl),#30:add hl,bc:ld (hl),#30:add hl,bc:ld (hl),#FC:add hl,bc:ld (hl),#30:add hl,bc:ld (hl),#30:add hl,bc:ld (hl),#36:add hl,bc:ld (hl),#1C:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;t
mftchr117 ex de,hl:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),#CC:add hl,bc:ld (hl),#CC:add hl,bc:ld (hl),#CC:add hl,bc:ld (hl),#CC:add hl,bc:ld (hl),#76:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;u
mftchr118 ex de,hl:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#6C:add hl,bc:ld (hl),#38:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;v
mftchr119 ex de,hl:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#D6:add hl,bc:ld (hl),#D6:add hl,bc:ld (hl),#FE:add hl,bc:ld (hl),#6C:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;w
mftchr120 ex de,hl:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#6C:add hl,bc:ld (hl),#38:add hl,bc:ld (hl),#6C:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;x
mftchr121 ex de,hl:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#C6:add hl,bc:ld (hl),#7E:add hl,bc:ld (hl),#06:add hl,bc:ld (hl),#FC:dec a:jp nz,mftout1:ret ;y
mftchr122 ex de,hl:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),#7E:add hl,bc:ld (hl),#4C:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#32:add hl,bc:ld (hl),#7E:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;z
mftchr123 ex de,hl:ld (hl),#0E:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#70:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#0E:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;{
mftchr124 ex de,hl:ld (hl),#18:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;|
mftchr125 ex de,hl:ld (hl),#70:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#0E:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#18:add hl,bc:ld (hl),#70:add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;}
mftchr126 ex de,hl:ld (hl),#76:add hl,bc:ld (hl),#DC:add hl,bc:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),b  :add hl,bc:ld (hl),b  :dec a:jp nz,mftout1:ret ;~
mftchr127 ex de,hl:ld (hl),#CC:add hl,bc:ld (hl),#33:add hl,bc:ld (hl),#CC:add hl,bc:ld (hl),#33:add hl,bc:ld (hl),#CC:add hl,bc:ld (hl),#33:add hl,bc:ld (hl),#CC:add hl,bc:ld (hl),#33:dec a:jp nz,mftout1:ret ;
mftchr128   ;for relocating

;==============================================================================
;--- SVM ----------------------------------------------------------------------
;==============================================================================

elseif computer_mode=4

svmfnt
incbin"App-Shell-SVM.fnt"

;==============================================================================
;--- NC -----------------------------------------------------------------------
;==============================================================================

elseif computer_mode=5

nctfnt
db #00,#00,#00,#00,#00, #00,#00,#00,#00,#00, #00,#00,#00,#00,#00, #00,#00,#00,#00,#00, #00,#00,#00,#00,#00, #00,#00,#00,#00,#00, 0,0  ;
db #60,#60,#00,#60,#00, #18,#18,#00,#18,#00, #06,#06,#00,#06,#00, #01,#01,#00,#01,#00, #00,#00,#00,#00,#00, #80,#80,#00,#80,#00, 0,0  ;!
db #d8,#d8,#00,#00,#00, #36,#36,#00,#00,#00, #0d,#0d,#00,#00,#00, #03,#03,#00,#00,#00, #80,#80,#00,#00,#00, #60,#60,#00,#00,#00, 0,0  ;"
db #50,#f8,#50,#f8,#00, #14,#3e,#14,#3e,#00, #05,#0f,#05,#0f,#00, #01,#03,#01,#03,#00, #00,#80,#00,#80,#00, #40,#e0,#40,#e0,#00, 0,0  ;#
db #38,#60,#30,#e0,#00, #0e,#18,#0c,#38,#00, #03,#06,#03,#0e,#00, #00,#01,#00,#03,#00, #80,#00,#00,#00,#00, #e0,#80,#c0,#80,#00, 0,0  ;$
db #48,#d0,#20,#58,#90, #12,#34,#08,#16,#24, #04,#0d,#02,#05,#09, #01,#03,#00,#01,#02, #80,#00,#00,#80,#00, #20,#40,#80,#60,#40, 0,0  ;%
db #40,#a8,#50,#28,#00, #10,#2a,#14,#0a,#00, #04,#0a,#05,#02,#00, #01,#02,#01,#00,#00, #00,#80,#00,#80,#00, #00,#a0,#40,#a0,#00, 0,0  ;&
db #30,#60,#00,#00,#00, #0c,#18,#00,#00,#00, #03,#06,#00,#00,#00, #00,#01,#00,#00,#00, #00,#00,#00,#00,#00, #c0,#80,#00,#00,#00, 0,0  ;'
db #30,#60,#60,#30,#00, #0c,#18,#18,#0c,#00, #03,#06,#06,#03,#00, #00,#01,#01,#00,#00, #00,#00,#00,#00,#00, #c0,#80,#80,#c0,#00, 0,0  ;(
db #60,#30,#30,#60,#00, #18,#0c,#0c,#18,#00, #06,#03,#03,#06,#00, #01,#00,#00,#01,#00, #00,#00,#00,#00,#00, #80,#c0,#c0,#80,#00, 0,0  ;)
db #20,#f8,#70,#d8,#00, #08,#3e,#1c,#36,#00, #02,#0f,#07,#0d,#00, #00,#03,#01,#03,#00, #00,#80,#00,#80,#00, #80,#e0,#c0,#60,#00, 0,0  ;*
db #00,#20,#f8,#20,#00, #00,#08,#3e,#08,#00, #00,#02,#0f,#02,#00, #00,#00,#03,#00,#00, #00,#00,#80,#00,#00, #00,#80,#e0,#80,#00, 0,0  ;+
db #00,#00,#30,#30,#60, #00,#00,#0c,#0c,#18, #00,#00,#03,#03,#06, #00,#00,#00,#00,#01, #00,#00,#00,#00,#00, #00,#00,#c0,#c0,#80, 0,0  ;,
db #00,#00,#f8,#00,#00, #00,#00,#3e,#00,#00, #00,#00,#0f,#00,#00, #00,#00,#03,#00,#00, #00,#00,#80,#00,#00, #00,#00,#e0,#00,#00, 0,0  ;-
db #00,#00,#60,#60,#00, #00,#00,#18,#18,#00, #00,#00,#06,#06,#00, #00,#00,#01,#01,#00, #00,#00,#00,#00,#00, #00,#00,#80,#80,#00, 0,0  ;.
db #18,#30,#60,#c0,#00, #06,#0c,#18,#30,#00, #01,#03,#06,#0c,#00, #00,#00,#01,#03,#00, #80,#00,#00,#00,#00, #60,#c0,#80,#00,#00, 0,0  ;/
db #70,#d8,#e8,#70,#00, #1c,#36,#3a,#1c,#00, #07,#0d,#0e,#07,#00, #01,#03,#03,#01,#00, #00,#80,#80,#00,#00, #c0,#60,#a0,#c0,#00, 0,0  ;0
db #60,#e0,#60,#f0,#00, #18,#38,#18,#3c,#00, #06,#0e,#06,#0f,#00, #01,#03,#01,#03,#00, #00,#00,#00,#00,#00, #80,#80,#80,#c0,#00, 0,0  ;1
db #f0,#38,#c0,#f8,#00, #3c,#0e,#30,#3e,#00, #0f,#03,#0c,#0f,#00, #03,#00,#03,#03,#00, #00,#80,#00,#80,#00, #c0,#e0,#00,#e0,#00, 0,0  ;2
db #f0,#38,#18,#f0,#00, #3c,#0e,#06,#3c,#00, #0f,#03,#01,#0f,#00, #03,#00,#00,#03,#00, #00,#80,#80,#00,#00, #c0,#e0,#60,#c0,#00, 0,0  ;3
db #d8,#d8,#f8,#18,#00, #36,#36,#3e,#06,#00, #0d,#0d,#0f,#01,#00, #03,#03,#03,#00,#00, #80,#80,#80,#80,#00, #60,#60,#e0,#60,#00, 0,0  ;4
db #f8,#e0,#18,#f0,#00, #3e,#38,#06,#3c,#00, #0f,#0e,#01,#0f,#00, #03,#03,#00,#03,#00, #80,#00,#80,#00,#00, #e0,#80,#60,#c0,#00, 0,0  ;5
db #78,#e0,#d8,#70,#00, #1e,#38,#36,#1c,#00, #07,#0e,#0d,#07,#00, #01,#03,#03,#01,#00, #80,#00,#80,#00,#00, #e0,#80,#60,#c0,#00, 0,0  ;6
db #f8,#18,#30,#60,#00, #3e,#06,#0c,#18,#00, #0f,#01,#03,#06,#00, #03,#00,#00,#01,#00, #80,#80,#00,#00,#00, #e0,#60,#c0,#80,#00, 0,0  ;7
db #70,#f8,#d8,#70,#00, #1c,#3e,#36,#1c,#00, #07,#0f,#0d,#07,#00, #01,#03,#03,#01,#00, #00,#80,#80,#00,#00, #c0,#e0,#60,#c0,#00, 0,0  ;8
db #70,#f8,#18,#f0,#00, #1c,#3e,#06,#3c,#00, #07,#0f,#01,#0f,#00, #01,#03,#00,#03,#00, #00,#80,#80,#00,#00, #c0,#e0,#60,#c0,#00, 0,0  ;9
db #00,#30,#00,#30,#00, #00,#0c,#00,#0c,#00, #00,#03,#00,#03,#00, #00,#00,#00,#00,#00, #00,#00,#00,#00,#00, #00,#c0,#00,#c0,#00, 0,0  ;:
db #00,#30,#00,#30,#60, #00,#0c,#00,#0c,#18, #00,#03,#00,#03,#06, #00,#00,#00,#00,#01, #00,#00,#00,#00,#00, #00,#c0,#00,#c0,#80, 0,0  ;;
db #00,#18,#60,#18,#00, #00,#06,#18,#06,#00, #00,#01,#06,#01,#00, #00,#00,#01,#00,#00, #00,#80,#00,#80,#00, #00,#60,#80,#60,#00, 0,0  ;<
db #00,#78,#00,#78,#00, #00,#1e,#00,#1e,#00, #00,#07,#00,#07,#00, #00,#01,#00,#01,#00, #00,#80,#00,#80,#00, #00,#e0,#00,#e0,#00, 0,0  ;=
db #00,#60,#18,#60,#00, #00,#18,#06,#18,#00, #00,#06,#01,#06,#00, #00,#01,#00,#01,#00, #00,#00,#80,#00,#00, #00,#80,#60,#80,#00, 0,0  ;>
db #f0,#38,#00,#30,#00, #3c,#0e,#00,#0c,#00, #0f,#03,#00,#03,#00, #03,#00,#00,#00,#00, #00,#80,#00,#00,#00, #c0,#e0,#00,#c0,#00, 0,0  ;?
db #78,#d8,#c0,#70,#00, #1e,#36,#30,#1c,#00, #07,#0d,#0c,#07,#00, #01,#03,#03,#01,#00, #80,#80,#00,#00,#00, #e0,#60,#00,#c0,#00, 0,0  ;@
db #70,#d8,#f8,#d8,#00, #1c,#36,#3e,#36,#00, #07,#0d,#0f,#0d,#00, #01,#03,#03,#03,#00, #00,#80,#80,#80,#00, #c0,#60,#e0,#60,#00, 0,0  ;A
db #f0,#f8,#c8,#f0,#00, #3c,#3e,#32,#3c,#00, #0f,#0f,#0c,#0f,#00, #03,#03,#03,#03,#00, #00,#80,#80,#00,#00, #c0,#e0,#20,#c0,#00, 0,0  ;B
db #78,#c0,#c0,#78,#00, #1e,#30,#30,#1e,#00, #07,#0c,#0c,#07,#00, #01,#03,#03,#01,#00, #80,#00,#00,#80,#00, #e0,#00,#00,#e0,#00, 0,0  ;C
db #f0,#d8,#d8,#f0,#00, #3c,#36,#36,#3c,#00, #0f,#0d,#0d,#0f,#00, #03,#03,#03,#03,#00, #00,#80,#80,#00,#00, #c0,#60,#60,#c0,#00, 0,0  ;D
db #f8,#e0,#c0,#f8,#00, #3e,#38,#30,#3e,#00, #0f,#0e,#0c,#0f,#00, #03,#03,#03,#03,#00, #80,#00,#00,#80,#00, #e0,#80,#00,#e0,#00, 0,0  ;E
db #f8,#c0,#f0,#c0,#00, #3e,#30,#3c,#30,#00, #0f,#0c,#0f,#0c,#00, #03,#03,#03,#03,#00, #80,#00,#00,#00,#00, #e0,#00,#c0,#00,#00, 0,0  ;F
db #78,#c0,#d8,#78,#00, #1e,#30,#36,#1e,#00, #07,#0c,#0d,#07,#00, #01,#03,#03,#01,#00, #80,#00,#80,#80,#00, #e0,#00,#60,#e0,#00, 0,0  ;G
db #d8,#f8,#d8,#d8,#00, #36,#3e,#36,#36,#00, #0d,#0f,#0d,#0d,#00, #03,#03,#03,#03,#00, #80,#80,#80,#80,#00, #60,#e0,#60,#60,#00, 0,0  ;H
db #f0,#60,#60,#f0,#00, #3c,#18,#18,#3c,#00, #0f,#06,#06,#0f,#00, #03,#01,#01,#03,#00, #00,#00,#00,#00,#00, #c0,#80,#80,#c0,#00, 0,0  ;I
db #f8,#30,#b0,#60,#00, #3e,#0c,#2c,#18,#00, #0f,#03,#0b,#06,#00, #03,#00,#02,#01,#00, #80,#00,#00,#00,#00, #e0,#c0,#c0,#80,#00, 0,0  ;J
db #d8,#e0,#f0,#d8,#00, #36,#38,#3c,#36,#00, #0d,#0e,#0f,#0d,#00, #03,#03,#03,#03,#00, #80,#00,#00,#80,#00, #60,#80,#c0,#60,#00, 0,0  ;K
db #c0,#c0,#c0,#f8,#00, #30,#30,#30,#3e,#00, #0c,#0c,#0c,#0f,#00, #03,#03,#03,#03,#00, #00,#00,#00,#80,#00, #00,#00,#00,#e0,#00, 0,0  ;L
db #88,#d8,#f8,#d8,#00, #22,#36,#3e,#36,#00, #08,#0d,#0f,#0d,#00, #02,#03,#03,#03,#00, #80,#80,#80,#80,#00, #20,#60,#e0,#60,#00, 0,0  ;M
db #c8,#e8,#d8,#d8,#00, #32,#3a,#36,#36,#00, #0c,#0e,#0d,#0d,#00, #03,#03,#03,#03,#00, #80,#80,#80,#80,#00, #20,#a0,#60,#60,#00, 0,0  ;N
db #70,#d8,#d8,#70,#00, #1c,#36,#36,#1c,#00, #07,#0d,#0d,#07,#00, #01,#03,#03,#01,#00, #00,#80,#80,#00,#00, #c0,#60,#60,#c0,#00, 0,0  ;O
db #f0,#d8,#f0,#c0,#00, #3c,#36,#3c,#30,#00, #0f,#0d,#0f,#0c,#00, #03,#03,#03,#03,#00, #00,#80,#00,#00,#00, #c0,#60,#c0,#00,#00, 0,0  ;P
db #70,#c8,#d8,#70,#18, #1c,#32,#36,#1c,#06, #07,#0c,#0d,#07,#01, #01,#03,#03,#01,#00, #00,#80,#80,#00,#80, #c0,#20,#60,#c0,#60, 0,0  ;Q
db #f0,#d8,#f0,#d8,#00, #3c,#36,#3c,#36,#00, #0f,#0d,#0f,#0d,#00, #03,#03,#03,#03,#00, #00,#80,#00,#80,#00, #c0,#60,#c0,#60,#00, 0,0  ;R
db #78,#e0,#78,#f0,#00, #1e,#38,#1e,#3c,#00, #07,#0e,#07,#0f,#00, #01,#03,#01,#03,#00, #80,#00,#80,#00,#00, #e0,#80,#e0,#c0,#00, 0,0  ;S
db #f8,#60,#60,#60,#00, #3e,#18,#18,#18,#00, #0f,#06,#06,#06,#00, #03,#01,#01,#01,#00, #80,#00,#00,#00,#00, #e0,#80,#80,#80,#00, 0,0  ;T
db #d8,#d8,#d8,#70,#00, #36,#36,#36,#1c,#00, #0d,#0d,#0d,#07,#00, #03,#03,#03,#01,#00, #80,#80,#80,#00,#00, #60,#60,#60,#c0,#00, 0,0  ;U
db #d8,#d8,#70,#20,#00, #36,#36,#1c,#08,#00, #0d,#0d,#07,#02,#00, #03,#03,#01,#00,#00, #80,#80,#00,#00,#00, #60,#60,#c0,#80,#00, 0,0  ;V
db #88,#a8,#f8,#d8,#00, #22,#2a,#3e,#36,#00, #08,#0a,#0f,#0d,#00, #02,#02,#03,#03,#00, #80,#80,#80,#80,#00, #20,#a0,#e0,#60,#00, 0,0  ;W
db #d8,#70,#70,#d8,#00, #36,#1c,#1c,#36,#00, #0d,#07,#07,#0d,#00, #03,#01,#01,#03,#00, #80,#00,#00,#80,#00, #60,#c0,#c0,#60,#00, 0,0  ;X
db #d8,#70,#30,#30,#00, #36,#1c,#0c,#0c,#00, #0d,#07,#03,#03,#00, #03,#01,#00,#00,#00, #80,#00,#00,#00,#00, #60,#c0,#c0,#c0,#00, 0,0  ;Y
db #f8,#30,#60,#f8,#00, #3e,#0c,#18,#3e,#00, #0f,#03,#06,#0f,#00, #03,#00,#01,#03,#00, #80,#00,#00,#80,#00, #e0,#c0,#80,#e0,#00, 0,0  ;Z
db #70,#40,#40,#70,#00, #1c,#10,#10,#1c,#00, #07,#04,#04,#07,#00, #01,#01,#01,#01,#00, #00,#00,#00,#00,#00, #c0,#00,#00,#c0,#00, 0,0  ;[
db #c0,#60,#30,#18,#00, #30,#18,#0c,#06,#00, #0c,#06,#03,#01,#00, #03,#01,#00,#00,#00, #00,#00,#00,#80,#00, #00,#80,#c0,#60,#00, 0,0  ;\
db #70,#10,#10,#70,#00, #1c,#04,#04,#1c,#00, #07,#01,#01,#07,#00, #01,#00,#00,#01,#00, #00,#00,#00,#00,#00, #c0,#40,#40,#c0,#00, 0,0  ;]
db #20,#50,#00,#00,#00, #08,#14,#00,#00,#00, #02,#05,#00,#00,#00, #00,#01,#00,#00,#00, #00,#00,#00,#00,#00, #80,#40,#00,#00,#00, 0,0  ;^
db #00,#00,#00,#00,#f8, #00,#00,#00,#00,#3e, #00,#00,#00,#00,#0f, #00,#00,#00,#00,#03, #00,#00,#00,#00,#80, #00,#00,#00,#00,#e0, 0,0  ;_
db #60,#30,#00,#00,#00, #18,#0c,#00,#00,#00, #06,#03,#00,#00,#00, #01,#00,#00,#00,#00, #00,#00,#00,#00,#00, #80,#c0,#00,#00,#00, 0,0  ;`
db #00,#78,#d8,#78,#00, #00,#1e,#36,#1e,#00, #00,#07,#0d,#07,#00, #00,#01,#03,#01,#00, #00,#80,#80,#80,#00, #00,#e0,#60,#e0,#00, 0,0  ;a
db #c0,#f0,#d8,#f0,#00, #30,#3c,#36,#3c,#00, #0c,#0f,#0d,#0f,#00, #03,#03,#03,#03,#00, #00,#00,#80,#00,#00, #00,#c0,#60,#c0,#00, 0,0  ;b
db #00,#78,#e0,#78,#00, #00,#1e,#38,#1e,#00, #00,#07,#0e,#07,#00, #00,#01,#03,#01,#00, #00,#80,#00,#80,#00, #00,#e0,#80,#e0,#00, 0,0  ;c
db #18,#78,#d8,#78,#00, #06,#1e,#36,#1e,#00, #01,#07,#0d,#07,#00, #00,#01,#03,#01,#00, #80,#80,#80,#80,#00, #60,#e0,#60,#e0,#00, 0,0  ;d
db #00,#f0,#f0,#f8,#00, #00,#3c,#3c,#3e,#00, #00,#0f,#0f,#0f,#00, #00,#03,#03,#03,#00, #00,#00,#00,#80,#00, #00,#c0,#c0,#e0,#00, 0,0  ;e
db #38,#60,#f0,#60,#00, #0e,#18,#3c,#18,#00, #03,#06,#0f,#06,#00, #00,#01,#03,#01,#00, #80,#00,#00,#00,#00, #e0,#80,#c0,#80,#00, 0,0  ;f
db #00,#78,#f8,#18,#70, #00,#1e,#3e,#06,#1c, #00,#07,#0f,#01,#07, #00,#01,#03,#00,#01, #00,#80,#80,#80,#00, #00,#e0,#e0,#60,#c0, 0,0  ;g
db #c0,#f0,#d8,#d8,#00, #30,#3c,#36,#36,#00, #0c,#0f,#0d,#0d,#00, #03,#03,#03,#03,#00, #00,#00,#80,#80,#00, #00,#c0,#60,#60,#00, 0,0  ;h
db #60,#00,#60,#60,#00, #18,#00,#18,#18,#00, #06,#00,#06,#06,#00, #01,#00,#01,#01,#00, #00,#00,#00,#00,#00, #80,#00,#80,#80,#00, 0,0  ;i
db #30,#00,#30,#30,#60, #0c,#00,#0c,#0c,#18, #03,#00,#03,#03,#06, #00,#00,#00,#00,#01, #00,#00,#00,#00,#00, #c0,#00,#c0,#c0,#80, 0,0  ;j
db #c0,#d8,#f0,#d8,#00, #30,#36,#3c,#36,#00, #0c,#0d,#0f,#0d,#00, #03,#03,#03,#03,#00, #00,#80,#00,#80,#00, #00,#60,#c0,#60,#00, 0,0  ;k
db #60,#60,#60,#30,#00, #18,#18,#18,#0c,#00, #06,#06,#06,#03,#00, #01,#01,#01,#00,#00, #00,#00,#00,#00,#00, #80,#80,#80,#c0,#00, 0,0  ;l
db #00,#50,#f8,#d8,#00, #00,#14,#3e,#36,#00, #00,#05,#0f,#0d,#00, #00,#01,#03,#03,#00, #00,#00,#80,#80,#00, #00,#40,#e0,#60,#00, 0,0  ;m
db #00,#f0,#d8,#d8,#00, #00,#3c,#36,#36,#00, #00,#0f,#0d,#0d,#00, #00,#03,#03,#03,#00, #00,#00,#80,#80,#00, #00,#c0,#60,#60,#00, 0,0  ;n
db #00,#70,#d8,#70,#00, #00,#1c,#36,#1c,#00, #00,#07,#0d,#07,#00, #00,#01,#03,#01,#00, #00,#00,#80,#00,#00, #00,#c0,#60,#c0,#00, 0,0  ;o
db #00,#f0,#d8,#f0,#c0, #00,#3c,#36,#3c,#30, #00,#0f,#0d,#0f,#0c, #00,#03,#03,#03,#03, #00,#00,#80,#00,#00, #00,#c0,#60,#c0,#00, 0,0  ;p
db #00,#70,#d8,#78,#18, #00,#1c,#36,#1e,#06, #00,#07,#0d,#07,#01, #00,#01,#03,#01,#00, #00,#00,#80,#80,#80, #00,#c0,#60,#e0,#60, 0,0  ;q
db #00,#d8,#f0,#c0,#00, #00,#36,#3c,#30,#00, #00,#0d,#0f,#0c,#00, #00,#03,#03,#03,#00, #00,#80,#00,#00,#00, #00,#60,#c0,#00,#00, 0,0  ;r
db #00,#78,#60,#e0,#00, #00,#1e,#18,#38,#00, #00,#07,#06,#0e,#00, #00,#01,#01,#03,#00, #00,#80,#00,#00,#00, #00,#e0,#80,#80,#00, 0,0  ;s
db #60,#f0,#60,#70,#00, #18,#3c,#18,#1c,#00, #06,#0f,#06,#07,#00, #01,#03,#01,#01,#00, #00,#00,#00,#00,#00, #80,#c0,#80,#c0,#00, 0,0  ;t
db #00,#d8,#d8,#70,#00, #00,#36,#36,#1c,#00, #00,#0d,#0d,#07,#00, #00,#03,#03,#01,#00, #00,#80,#80,#00,#00, #00,#60,#60,#c0,#00, 0,0  ;u
db #00,#d8,#70,#20,#00, #00,#36,#1c,#08,#00, #00,#0d,#07,#02,#00, #00,#03,#01,#00,#00, #00,#80,#00,#00,#00, #00,#60,#c0,#80,#00, 0,0  ;v
db #00,#d8,#f8,#50,#00, #00,#36,#3e,#14,#00, #00,#0d,#0f,#05,#00, #00,#03,#03,#01,#00, #00,#80,#80,#00,#00, #00,#60,#e0,#40,#00, 0,0  ;w
db #00,#d8,#70,#d8,#00, #00,#36,#1c,#36,#00, #00,#0d,#07,#0d,#00, #00,#03,#01,#03,#00, #00,#80,#00,#80,#00, #00,#60,#c0,#60,#00, 0,0  ;x
db #00,#d8,#78,#30,#60, #00,#36,#1e,#0c,#18, #00,#0d,#07,#03,#06, #00,#03,#01,#00,#01, #00,#80,#80,#00,#00, #00,#60,#e0,#c0,#80, 0,0  ;y
db #00,#e0,#60,#78,#00, #00,#38,#18,#1e,#00, #00,#0e,#06,#07,#00, #00,#03,#01,#01,#00, #00,#00,#00,#80,#00, #00,#80,#80,#e0,#00, 0,0  ;z
db #30,#60,#20,#30,#00, #0c,#18,#08,#0c,#00, #03,#06,#02,#03,#00, #00,#01,#00,#00,#00, #00,#00,#00,#00,#00, #c0,#80,#80,#c0,#00, 0,0  ;{
db #30,#30,#30,#30,#00, #0c,#0c,#0c,#0c,#00, #03,#03,#03,#03,#00, #00,#00,#00,#00,#00, #00,#00,#00,#00,#00, #c0,#c0,#c0,#c0,#00, 0,0  ;|
db #60,#30,#20,#60,#00, #18,#0c,#08,#18,#00, #06,#03,#02,#06,#00, #01,#00,#00,#01,#00, #00,#00,#00,#00,#00, #80,#c0,#80,#80,#00, 0,0  ;}
db #50,#a0,#00,#00,#00, #14,#28,#00,#00,#00, #05,#0a,#00,#00,#00, #01,#02,#00,#00,#00, #00,#00,#00,#00,#00, #40,#80,#00,#00,#00, 0,0  ;~
db #20,#50,#88,#f8,#00, #08,#14,#22,#3e,#00, #02,#05,#08,#0f,#00, #00,#01,#02,#03,#00, #00,#00,#80,#80,#00, #80,#40,#20,#e0,#00, 0,0  ;¦


;### MFTCLR -> Löscht den Bildschirm
mftclr  ei
        ld hl,#c000
        ld de,#c001
        ld (hl),l
        ld bc,#3fff
        ldir
        ret

;### MFTINV -> Invertiert die untern 3 Zeilen eines Zeichens
;### Eingabe    DE=Bildschirmadresse, IYH=offset
mftinv  ei
        ld hl,2*64
        add hl,de
        ld a,iyh
        ld d,#fc   :or  a:jr z,mftinv2
        ld d,#3f   :dec a:jr z,mftinv2
        ld de,#0fc0:dec a:jr z,mftinv1
        ld de,#03f0
mftinv1 call mftinv2
        ld bc,1-128
        add hl,bc
        ld d,e
mftinv2 ld bc,64
        ld a,(hl):xor d:ld (hl),a:add hl,bc
        ld a,(hl):xor d:ld (hl),a:add hl,bc
        ld a,(hl):xor d:ld (hl),a
        ret

;### MFTSRU -> scrolls up and clears new line
;### Input      E=width in chars, D=height in chars
mftsru  dec d
mftsrua call mftsru0
        ld c,l
        ld b,h
        ld de,#c000
        ld hl,#c000+320
        ldir
        ld l,e
        ld h,d
        inc de
        ld (hl),0
        ld bc,64*5-1
        ldir
        ret
;d=lines -> hl=lines*64*5
mftsru0 xor a
        ld l,a
        ld e,a
        ld a,d
        rra:rr l
        rra:rr l
        ld h,a
        add hl,de
        ret

;### MFTSRU -> scrolls up and clears new line
;### Input      E=width in chars, D=height in chars
mftsrd  call mftsru0
        ex de,hl
        dec de
        ld hl,-64*5
        add hl,de
        ld c,l
        ld b,h
        inc bc
        lddr
        ld l,e
        ld h,d
        dec de
        ld (hl),0
        ld bc,64*5-1
        lddr
        ret

;### NCTOUT -> NC fullscreen textoutput
;### Input      scrbuf=text, IYL=length, DE=screenadr, IYH=offset/2 (0-3)
;### Destroyed  AF,BC,DE,HL,IX,IY
nctoutc dw 0                ;last char adr

nctout  ld ix,scrbuf
        ei
        ld b,0
        ld a,iyh
        or a
nctouta jp z,nctout7
        ld c,a                  ;*** plot first character at offset 1-3
nctoutm ld (nctouto+1),a
nctoutb call nctoutf
        ld a,c
        cp 2
        ld a,%11000000
        ld c,5
        jr c,nctout1
        ld a,%11110000
        ld c,10
        jr z,nctout1
        ld a,%11111100
        ld c,15
nctout1 add hl,bc
nctoutp ld (nctoutc),hl
nctoutd call nctout2
        ld hl,1-256
        add hl,de
        ex de,hl            ;de=next scrbyte
nctouto ld a,0              ;a=1-3
        dec a               ;a=0-2
        jr z,nctout9        ;start at new byte with next char
        dec iyl             ;a=1-2=ofs2-3
        jr nz,nctout3

        dec a                   ;*** finish this char at next scrbyte
        ld a,%00111111
        jr z,nctout5
        ld a,%00001111
nctout5 ld hl,(nctoutc)
        ld c,10
        add hl,bc
nctout2 ld c,64                 ;*** plot one char (a=mask, hl=char, de=screen -> de=de+4*64)
        ld iyh,a
        ld a,(de):and iyh:or (hl):ld (de),a:ex de,hl:add hl,bc:ex de,hl:inc hl  ;15
        ld a,(de):and iyh:or (hl):ld (de),a:ex de,hl:add hl,bc:ex de,hl:inc hl  ;15
        ld a,(de):and iyh:or (hl):ld (de),a:ex de,hl:add hl,bc:ex de,hl:inc hl  ;15
        ld a,(de):and iyh:or (hl):ld (de),a:ex de,hl:add hl,bc:ex de,hl:inc hl  ;15
        ld a,(de):and iyh:or (hl):ld (de),a
        ret

nctout3 ld iyh,a                ;*** write this char with next char at new byte
nctoute call nctoutf
        dec iyh             ;iyh -> 0=ofs2, 1=ofs3
        ld a,5
        jr z,nctout4
        ld a,10
nctout4 push ix
nctoutn ld ix,(nctoutc)     ;hl=basefont, bc=add -> de=next scr, iyl-=1 (0 -> z)
        ld c,10
        add ix,bc
        ld c,a
nctoutg call nctout8
        pop ix
        jr nz,nctout6
        dec iyh             ;next is last char; iyh -> -1=ofs2, 0=ofs3
        ret nz              ;ofs2 -> next char finished byte -> finish
        ld a,%00111111
        jr nctout5          ;ofs3 -> plot last third of next char
nctout6 dec iyh
        jr nz,nctout7
nctouth call nctoutf
        ld iyh,0
        ld a,5
        jr nctout4

nctout9 dec iyl
        ret z
nctout7 call nctoutf            ;*** start at new byte with next char
        dec iyl
        ld a,%00000011
        jr z,nctout2        ;last char -> plot it and finish
        push hl
nctouti call nctoutf
        ld c,15
        ex (sp),ix
nctoutj call nctout8
        pop ix
        ld a,2              ;was ofs3
        jr nz,nctout3
        ld a,%00001111
nctoutk jp nctout5

nctout8 add hl,bc
nctoutl ld (nctoutc),hl
        ld c,64
        ld a,(ix+0):or (hl):ld (de),a:ex de,hl:add hl,bc:ex de,hl:inc hl    ;16
        ld a,(ix+1):or (hl):ld (de),a:ex de,hl:add hl,bc:ex de,hl:inc hl    ;16
        ld a,(ix+2):or (hl):ld (de),a:ex de,hl:add hl,bc:ex de,hl:inc hl    ;16
        ld a,(ix+3):or (hl):ld (de),a:ex de,hl:add hl,bc:ex de,hl:inc hl    ;16
        ld a,(ix+4):or (hl):ld (de),a
        ld hl,1-256
        add hl,de
        ex de,hl                                                            ;16 -> 80
        dec iyl
        ret

nctoutf ld a,(ix+0)         ;iyh -> 1=ofs2, 2=ofs3
        sub 32
nctout0 inc ix
        ld l,0
        or a
        rra:rr l
        rra:rr l
        rra:rr l
nctoutq add 0   ;nctfnt/256
        ld h,a              ;hl=font
        ret


;==============================================================================
;--- NXT ----------------------------------------------------------------------
;==============================================================================

elseif computer_mode=6

nxtfnt
ds 32*8
db #00,#00,#00,#00,#00,#00,#00,#00, #18,#3C,#3C,#18,#18,#00,#18,#00, #6C,#6C,#28,#00,#00,#00,#00,#00, #6C,#6C,#FE,#6C,#FE,#6C,#6C,#00, #18,#3E,#60,#3C,#06,#7C,#18,#00, #00,#C6,#CC,#18,#30,#66,#C6,#00
db #38,#6C,#38,#76,#DC,#CC,#76,#00, #18,#18,#30,#00,#00,#00,#00,#00, #0C,#18,#30,#30,#30,#18,#0C,#00, #30,#18,#0C,#0C,#0C,#18,#30,#00, #00,#66,#3C,#FF,#3C,#66,#00,#00, #00,#18,#18,#7E,#18,#18,#00,#00
db #00,#00,#00,#00,#00,#18,#18,#30, #00,#00,#00,#7E,#00,#00,#00,#00, #00,#00,#00,#00,#00,#18,#18,#00, #06,#0C,#18,#30,#60,#C0,#80,#00, #38,#6C,#C6,#D6,#C6,#6C,#38,#00, #18,#38,#18,#18,#18,#18,#7E,#00
db #7C,#C6,#06,#1C,#30,#66,#FE,#00, #7C,#C6,#06,#3C,#06,#C6,#7C,#00, #1C,#3C,#6C,#CC,#FE,#0C,#1E,#00, #FE,#C0,#C0,#FC,#06,#C6,#7C,#00, #38,#60,#C0,#FC,#C6,#C6,#7C,#00, #FE,#C6,#0C,#18,#30,#30,#30,#00
db #7C,#C6,#C6,#7C,#C6,#C6,#7C,#00, #7C,#C6,#C6,#7E,#06,#C6,#7C,#00, #00,#00,#18,#18,#00,#18,#18,#00, #00,#00,#18,#18,#00,#18,#18,#30, #0C,#18,#30,#60,#30,#18,#0C,#00, #00,#00,#7E,#00,#00,#7E,#00,#00
db #60,#30,#18,#0C,#18,#30,#60,#00, #7C,#C6,#0C,#18,#18,#00,#18,#00, #7C,#C6,#DE,#DE,#DE,#C0,#78,#00, #38,#6C,#C6,#FE,#C6,#C6,#C6,#00, #FC,#66,#66,#7C,#66,#66,#FC,#00, #3C,#66,#C0,#C0,#C0,#66,#3C,#00
db #F8,#6C,#66,#66,#66,#6C,#F8,#00, #FE,#62,#68,#78,#68,#62,#FE,#00, #FE,#62,#68,#78,#68,#60,#F0,#00, #3C,#66,#C0,#C0,#CE,#66,#3A,#00, #C6,#C6,#C6,#FE,#C6,#C6,#C6,#00, #3C,#18,#18,#18,#18,#18,#3C,#00
db #1E,#0C,#0C,#0C,#CC,#CC,#78,#00, #E6,#66,#6C,#78,#6C,#66,#E6,#00, #F0,#60,#60,#60,#62,#66,#FE,#00, #C6,#EE,#FE,#FE,#D6,#C6,#C6,#00, #C6,#E6,#F6,#DE,#CE,#C6,#C6,#00, #7C,#C6,#C6,#C6,#C6,#C6,#7C,#00
db #FC,#66,#66,#7C,#60,#60,#F0,#00, #7C,#C6,#C6,#C6,#C6,#CE,#7C,#0E, #FC,#66,#66,#7C,#6C,#66,#E6,#00, #3C,#66,#30,#18,#0C,#66,#3C,#00, #7E,#7E,#5A,#18,#18,#18,#3C,#00, #66,#66,#66,#66,#66,#66,#3C,#00
db #C6,#C6,#C6,#C6,#C6,#6C,#38,#00, #C6,#C6,#C6,#D6,#D6,#FE,#6C,#00, #C6,#C6,#6C,#38,#6C,#C6,#C6,#00, #66,#66,#66,#3C,#18,#18,#3C,#00, #FE,#C6,#8C,#18,#32,#66,#FE,#00, #3C,#30,#30,#30,#30,#30,#3C,#00
db #C0,#60,#30,#18,#0C,#06,#02,#00, #3C,#0C,#0C,#0C,#0C,#0C,#3C,#00, #10,#38,#6C,#C6,#00,#00,#00,#00, #00,#00,#00,#00,#00,#00,#00,#FF, #30,#18,#0C,#00,#00,#00,#00,#00, #00,#00,#78,#0C,#7C,#CC,#76,#00
db #E0,#60,#7C,#66,#66,#66,#DC,#00, #00,#00,#7C,#C6,#C0,#C6,#7C,#00, #1C,#0C,#7C,#CC,#CC,#CC,#76,#00, #00,#00,#7C,#C6,#FE,#C0,#7C,#00, #3C,#66,#60,#F8,#60,#60,#F8,#00, #00,#00,#76,#CC,#CC,#7C,#0C,#F8
db #E0,#60,#6C,#76,#66,#66,#E6,#00, #18,#00,#38,#18,#18,#18,#3C,#00, #06,#00,#06,#06,#06,#66,#66,#3C, #E0,#60,#66,#6C,#78,#6C,#E6,#00, #38,#18,#18,#18,#18,#18,#3C,#00, #00,#00,#EC,#FE,#D6,#D6,#D6,#00
db #00,#00,#DC,#66,#66,#66,#66,#00, #00,#00,#7C,#C6,#C6,#C6,#7C,#00, #00,#00,#DC,#66,#66,#7C,#60,#F0, #00,#00,#76,#CC,#CC,#7C,#0C,#1E, #00,#00,#DC,#76,#60,#60,#F0,#00, #00,#00,#7E,#C0,#7C,#06,#FC,#00
db #30,#30,#FC,#30,#30,#36,#1C,#00, #00,#00,#CC,#CC,#CC,#CC,#76,#00, #00,#00,#C6,#C6,#C6,#6C,#38,#00, #00,#00,#C6,#D6,#D6,#FE,#6C,#00, #00,#00,#C6,#6C,#38,#6C,#C6,#00, #00,#00,#C6,#C6,#C6,#7E,#06,#FC
db #00,#00,#7E,#4C,#18,#32,#7E,#00, #0E,#18,#18,#70,#18,#18,#0E,#00, #18,#18,#18,#18,#18,#18,#18,#00, #70,#18,#18,#0E,#18,#18,#70,#00, #76,#DC,#00,#00,#00,#00,#00,#00, #00,#00,#00,#00,#00,#00,#00,#00
ds 128*8


;### NXTINI -> init screen (copy font)
nxtini  ei
        ld hl,#c000
        ld de,#c001
        ld (hl),l
        ld bc,80*32*2-1
        ldir
nxtini1 ld hl,nxtfnt        ;copy font original
        ld bc,256*8
        push hl
        ldir
        pop hl
        ld bc,256*8
nxtini2 dec bc
        ld a,(hl)           ;copy font inverted
        inc hl
        bit 2,c
        jr nz,nxtini3
        cpl
nxtini3 ld (de),a
        inc de
        ld a,c
        or b
        jr nz,nxtini2
        ret

;### NXTALL -> copy whole text to screen
nxtall  ld hl,scrmap
        ei
        ld de,160*3+#c000
        xor a
        ld ixl,25
nxtall1 ld bc,80*256+255
nxtall2 ldi
        ld (de),a
        inc de
        djnz nxtall2
        inc hl
        dec ixl
        jr nz,nxtall1
        ret

;### NXTCUR -> sets or removes cursor
;### Input      DE=adr, IYL=flag (0=off, 1=on)
nxtcur  ei
        inc de
        ld a,iyl
        ld (de),a
        ret

;### NXTPLT -> NXT fullscreen textoutput
;### Input      (scrbuf)=text, IYL=length, DE=screenadr
;### Destroyed  AF,BC,DE,HL,IX,IY
nxtplt  ld hl,scrbuf
        ei
        xor a
nxtplt1 ldi
        ld (de),a
        inc de
nxtplt0 db 0
        dec iyl
        jr nz,nxtplt1
        ret

endif

        db 0        ;virtual desktop
fulbuf  ds 16*2+2   ;mode, col0, col1, col2, col3

;### Config data
cfg_beg

;### Text-Bildschirm
if computer_mode=2
scrxln  db 80
scryln  db 25
scrpap  db 1
scrpen  db 0
elseif computer_mode=4
scrxln  db 80
scryln  db 25
scrpap  db 1
scrpen  db 8
elseif computer_mode=6
scrxln  db 80
scryln  db 25
scrpap  db 1
scrpen  db 8
else
scrxln  db 60
scryln  db 20
scrpap  db 1
scrpen  db 0
endif
scrbrd  db 2

cfg_end

;### Verschiedenes
prgmsginf1 db "SymShell",0
prgmsginf2 db " Version ",shvs_maj,".",shvs_min," (Build "
read "..\..\..\SRC-Main\build.asm"
           db "pdt)",0
prgmsginf3 db " Copyright <c> 2024 SymbiosiS",0

prgmsgwpf1 db "Wrong platform! This is SymShell",0
prgmsgwpf2 db "for the "
if computer_mode=0
                       db "AMSTRAD CPC.",0
elseif computer_mode=1
                       db "MSX2/2+/TURBOR.",0
elseif computer_mode=2
                       db "AMSTRAD PCW JOYCE.",0
elseif computer_mode=3
                       db "ENTERPRISE 64/128.",0
elseif computer_mode=4
                       db "SYMBOS VM.",0
elseif computer_mode=5
                       db "AMSTRAD NC1x0/200.",0
elseif computer_mode=6
                       db "ZX SPECTRUM NEXT.",0
endif
prgmsgwpf3 db "Please replace cmd.exe .",0

prgwintit   db "SymShell",0
configtit   db "Properties",0

prgtxtok    db "Ok",0
prgtxtcnc   db "Cancel",0
prgtxtyes   db "Yes",0
prgtxtno    db "No",0

;### Menues
prgwinmentx1 db "File",0
prgwinmen1tx1 db "Run...",0
prgwinmen1tx2 db "Properties",0
prgwinmen1tx3 db "Quit",0

prgwinmentx2 db "?",0
prgwinmen2tx1 db "Index",0
prgwinmen2tx2 db "About SymShell...",0

;### Config
configtxt0  db "Size and position"
configtxt00 db 0
configtxt1  db "Colours",0
configtxt2  db "Options",0

configtxt3  db "Width",0
configtxt4  db "Height",0
configtxt7  db "Text",0
configtxt8  db "Background",0
configtxt9  db "Border",0

configtxta  db "Preview",0
configtxtb  db "A:\SymbOS>dir *.exe",0
configtxtc  db "Fullscreen (Alt+Return)",0
configtxtd  db "Use always 80x25 in fullscreen",0
configtxte  db "Selection",0

coltxt00    db "Pale yellow",0
coltxt01    db "Black",0
coltxt02    db "Orange",0
coltxt03    db "Red",0
coltxt04    db "Pale cyan",0
coltxt05    db "Blue",0
coltxt06    db "Pale blue",0
coltxt07    db "Brgt blue",0
coltxt08    db "White",0
coltxt09    db "Green",0
coltxt10    db "Brgt green",0
coltxt11    db "Brgt magenta",0
coltxt12    db "Brgt yellow",0
coltxt13    db "Grey",0
coltxt14    db "Pink",0
coltxt15    db "Brgt red",0

scrbuf  ds max_xlen+1
scrcur  db " ",0    ;Cursor

smlfnt  db 6,32         ;Font
db 4,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#40,#40,#40,#00,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#A0,#A0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#A0,#E0,#A0,#E0,#A0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#60,#C0,#E0,#60,#C0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#A0,#20,#40,#80,#A0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#C0,#A0,#50,#A0,#50,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#20,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#20,#40,#40,#40,#20,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#40,#20,#20,#20,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#A0,#40,#E0,#40,#A0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#40,#40,#E0,#40,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#00,#00,#00,#20,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#00,#E0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#00,#00,#00,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#20,#20,#40,#80,#80,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#40,#A0,#A0,#A0,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#40,#C0,#40,#40,#E0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#C0,#20,#40,#80,#E0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#C0,#20,#40,#20,#C0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#80,#A0,#E0,#20,#20,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#E0,#80,#C0,#20,#C0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#60,#80,#C0,#A0,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#E0,#20,#40,#40,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#40,#A0,#40,#A0,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#40,#A0,#60,#20,#C0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#00,#40,#00,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#00,#40,#00,#40,#80,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#20,#40,#80,#40,#20,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#E0,#00,#E0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#80,#40,#20,#40,#80,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#C0,#20,#40,#00,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#60,#A0,#A0,#80,#60,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#40,#A0,#E0,#A0,#A0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#C0,#A0,#C0,#A0,#C0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#60,#80,#80,#80,#60,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#C0,#A0,#A0,#A0,#C0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#E0,#80,#C0,#80,#E0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#E0,#80,#C0,#80,#80,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#60,#80,#A0,#A0,#60,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#A0,#A0,#E0,#A0,#A0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#E0,#40,#40,#40,#E0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#E0,#20,#20,#A0,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#A0,#A0,#C0,#A0,#A0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#80,#80,#80,#80,#E0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#A0,#E0,#A0,#A0,#A0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#C0,#A0,#A0,#A0,#A0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#40,#A0,#A0,#A0,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#C0,#A0,#C0,#80,#80,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#40,#A0,#A0,#C0,#20,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#C0,#A0,#C0,#A0,#A0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#60,#80,#40,#20,#C0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#E0,#40,#40,#40,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#A0,#A0,#A0,#A0,#60,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#A0,#A0,#A0,#40,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#A0,#A0,#A0,#E0,#A0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#A0,#A0,#40,#A0,#A0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#A0,#40,#40,#40,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#E0,#20,#40,#80,#E0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#C0,#80,#80,#80,#C0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#80,#80,#40,#20,#20,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#C0,#40,#40,#40,#C0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#40,#A0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#00,#00,#00,#00,#F0,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#40,#20,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#60,#A0,#A0,#60,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#80,#C0,#A0,#A0,#C0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#60,#80,#80,#60,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#20,#60,#A0,#A0,#60,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#40,#E0,#80,#60,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#20,#40,#60,#40,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#40,#A0,#60,#20,#C0,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#80,#C0,#A0,#A0,#A0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#40,#00,#40,#40,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#40,#00,#40,#40,#40,#80,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#80,#A0,#C0,#A0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#40,#40,#40,#40,#20,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#A0,#E0,#A0,#A0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#40,#A0,#A0,#A0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#40,#A0,#A0,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#C0,#A0,#C0,#80,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#60,#A0,#60,#20,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#A0,#C0,#80,#80,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#60,#C0,#20,#C0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#40,#60,#40,#40,#20,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#A0,#A0,#A0,#60,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#A0,#A0,#40,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#A0,#A0,#E0,#A0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#A0,#40,#40,#A0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#A0,#40,#40,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#E0,#40,#80,#E0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#60,#40,#80,#40,#60,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#40,#40,#40,#40,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#C0,#40,#20,#40,#C0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#60,#C0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#40,#A0,#A0,#E0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#60,#80,#80,#60,#20,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#A0,#00,#A0,#60,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#10,#40,#E0,#80,#60,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#E0,#00,#60,#A0,#60,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#A0,#00,#60,#A0,#60,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#80,#00,#60,#A0,#60,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#60,#00,#60,#A0,#60,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#00,#60,#80,#60,#20,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#E0,#40,#E0,#80,#60,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#A0,#40,#E0,#80,#60,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#80,#40,#E0,#80,#60,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#A0,#00,#40,#40,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#E0,#00,#40,#40,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#80,#00,#40,#40,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#A0,#40,#A0,#E0,#A0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#C0,#40,#A0,#E0,#A0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#20,#E0,#C0,#80,#E0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#E0,#60,#C0,#E0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#60,#C0,#E0,#C0,#E0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#E0,#00,#40,#A0,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#A0,#00,#40,#A0,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#80,#00,#40,#A0,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#E0,#00,#A0,#60,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#80,#00,#A0,#60,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#A0,#00,#A0,#40,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#A0,#40,#A0,#A0,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#A0,#00,#A0,#A0,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#40,#60,#80,#80,#60,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#20,#40,#E0,#40,#E0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#A0,#40,#E0,#40,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#C0,#E0,#C0,#A0,#A0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#20,#40,#E0,#40,#80,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#20,#00,#60,#A0,#60,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#20,#00,#40,#40,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#20,#00,#40,#A0,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#20,#00,#A0,#60,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#C0,#00,#40,#A0,#A0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#C0,#00,#C0,#A0,#A0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#40,#C0,#00,#C0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#C0,#C0,#00,#C0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#40,#00,#40,#80,#E0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#00,#E0,#80,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#00,#E0,#20,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#A0,#40,#80,#60,#20,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#A0,#40,#80,#20,#60,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#40,#00,#40,#E0,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#60,#C0,#60,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#A0,#40,#E0,#40,#A0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#80,#20,#80,#20,#80,#20,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#A0,#50,#A0,#50,#A0,#50,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#D0,#70,#D0,#70,#D0,#70,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#40,#40,#40,#40,#40,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#40,#40,#C0,#40,#40,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#40,#40,#C0,#C0,#40,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#60,#60,#E0,#60,#60,#60,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#00,#E0,#60,#60,#60,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#00,#C0,#C0,#40,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#60,#60,#E0,#E0,#60,#60,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#60,#60,#60,#60,#60,#60,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#00,#E0,#E0,#60,#60,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#60,#60,#E0,#E0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#60,#60,#E0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#40,#40,#C0,#C0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#00,#C0,#40,#40,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#40,#40,#70,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#40,#40,#F0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#00,#F0,#40,#40,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#40,#40,#70,#40,#40,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#00,#F0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#40,#40,#F0,#40,#40,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#40,#40,#70,#70,#40,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#60,#60,#70,#60,#60,#60,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#60,#60,#70,#70,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#00,#70,#70,#60,#60,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#60,#60,#F0,#F0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#00,#F0,#F0,#60,#60,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#60,#60,#70,#70,#60,#60,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#00,#F0,#F0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#60,#60,#F0,#F0,#60,#60,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#40,#40,#F0,#F0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#60,#60,#F0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#00,#F0,#F0,#40,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#00,#F0,#60,#60,#60,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#60,#60,#70,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#40,#40,#70,#70,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#00,#70,#70,#40,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#00,#70,#60,#60,#60,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#60,#60,#F0,#60,#60,#60,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#40,#40,#F0,#F0,#40,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#40,#40,#C0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#00,#70,#40,#40,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#F0,#F0,#F0,#F0,#F0,#F0,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#00,#00,#F0,#F0,#F0,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#C0,#C0,#C0,#C0,#C0,#C0,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#30,#30,#30,#30,#30,#30,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#F0,#F0,#F0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#70,#A0,#A0,#70,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#40,#A0,#C0,#A0,#A0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#E0,#A0,#80,#80,#80,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#E0,#A0,#A0,#A0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#E0,#80,#40,#80,#E0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#60,#C0,#A0,#A0,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#A0,#A0,#C0,#40,#80,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#60,#C0,#40,#40,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#E0,#40,#A0,#40,#E0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#40,#A0,#E0,#A0,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#40,#A0,#A0,#40,#A0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#60,#80,#60,#A0,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#60,#D0,#B0,#60,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#10,#60,#B0,#D0,#60,#80,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#60,#80,#E0,#80,#60,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#40,#A0,#A0,#A0,#A0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#E0,#00,#E0,#00,#E0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#40,#E0,#40,#00,#E0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#40,#20,#40,#00,#60,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#20,#40,#20,#00,#60,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#40,#A0,#80,#80,#80,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#20,#20,#20,#A0,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#40,#00,#E0,#00,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#60,#A0,#00,#60,#A0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#40,#A0,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#00,#00,#C0,#C0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#00,#00,#C0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#60,#50,#40,#C0,#40,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#C0,#A0,#A0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#C0,#40,#60,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#C0,#C0,#C0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db 4,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00

scrmap  db 0    ;##!!letzter Label!!##


;==============================================================================
;### TRANSFER-TEIL ############################################################
;==============================================================================

prgtrnbeg

;### 16col icon
prgicn16c db 12,24,24:dw $+7:dw $+4,12*24:db 5
db #66,#66,#66,#66,#66,#66,#66,#66,#66,#66,#66,#66,#65,#05,#55,#55,#55,#55,#55,#55,#55,#55,#60,#66,#60,#00,#5F,#5F,#F5,#FF,#F5,#F5,#55,#55,#06,#06,#60,#50,#55,#55,#55,#55,#55,#55,#55,#55,#60,#66
db #66,#66,#66,#66,#66,#66,#66,#66,#66,#66,#66,#66,#6D,#DD,#DD,#DD,#DD,#DD,#DD,#DD,#DD,#DD,#DD,#D6,#6D,#11,#11,#11,#11,#11,#11,#11,#11,#11,#11,#D6,#6D,#11,#11,#11,#11,#11,#11,#11,#11,#11,#11,#D6
db #6D,#11,#11,#11,#11,#11,#11,#11,#11,#11,#11,#D6,#6D,#11,#11,#11,#11,#11,#11,#11,#11,#11,#11,#D6,#6D,#11,#AA,#AA,#11,#11,#1A,#11,#11,#11,#11,#D6,#6D,#1A,#A1,#1A,#A1,#11,#1A,#11,#1A,#11,#11,#D6
db #6D,#1A,#A1,#1A,#A1,#AA,#1A,#A1,#1A,#A1,#11,#D6,#6D,#1A,#AA,#AA,#A1,#AA,#11,#A1,#11,#AA,#11,#D6,#6D,#1A,#A1,#1A,#A1,#11,#11,#AA,#11,#AA,#11,#D6,#6D,#1A,#A1,#1A,#A1,#AA,#11,#1A,#1A,#A1,#11,#D6
db #6D,#1A,#A1,#1A,#A1,#AA,#11,#1A,#1A,#11,#11,#D6,#6D,#11,#11,#11,#11,#11,#11,#11,#11,#11,#11,#D6,#6D,#11,#11,#11,#11,#11,#11,#11,#11,#11,#11,#D6,#6D,#11,#11,#11,#11,#11,#11,#11,#11,#11,#11,#D6
db #6D,#11,#11,#11,#11,#11,#11,#11,#11,#11,#11,#D6,#6D,#11,#11,#11,#11,#11,#11,#11,#11,#11,#11,#D6,#6D,#DD,#DD,#DD,#DD,#DD,#DD,#DD,#DD,#DD,#DD,#D6,#66,#66,#66,#66,#66,#66,#66,#66,#66,#66,#66,#66

;### PRGPRZS -> Stack für Programm-Prozess
        ds 128
prgstk  ds 6*2
        dw prgprz
prgprzn db 0
prgmsgb ds 14

;### INFO-/ERROR-FENSTER ######################################################

prgmsginf  dw prgmsginf1,4*1+2,prgmsginf2,4*1+2,prgmsginf3,4*1+2,prgicnbig
prgmsgwpf  dw prgmsgwpf1,4*1+2,prgmsgwpf2,4*1+2,prgmsgwpf3,4*1+2

;### HAUPT-FENSTER ############################################################

prgwindat dw #3501,0,10,10,244,124,0,6,244,124+12,244,124,244,124,prgicnsml,prgwintit,0,prgwinmen,prgwingrp,0,0:ds 136+14

prgwinmen  dw 2, 1+4,prgwinmentx1,prgwinmen1,0, 1+4,prgwinmentx2,prgwinmen2,0
prgwinmen1 dw 4, 1,prgwinmen1tx1,00,0, 1,prgwinmen1tx2,cfgset,0, 1+8,0,0,0, 1,prgwinmen1tx3,prgend,0
prgwinmen2 dw 3, 1,prgwinmen2tx1,hlpopn,0, 1+8,0,0,0, 1,prgwinmen2tx2,prginf,0

prgwintxl equ max_ylen-25

prgwingrp db 28+prgwintxl,0:dw prgwinobj,0,0,0,0,0,0
prgwinobj
dw     00,255*256+00,1+128          ,0,0,1000,1000,0    ;00=Hintergrund
dw     00,255*256+02,128            ,0,6, 244, 124,0    ;01=Rahmen
dw     00,255*256+05,6*00+prgwinlin,2,6*00+8,320,06,0   ;02=Textzeile 00
dw     00,255*256+05,6*01+prgwinlin,2,6*01+8,320,06,0   ;03=Textzeile 01
dw     00,255*256+05,6*02+prgwinlin,2,6*02+8,320,06,0   ;04=Textzeile 02
dw     00,255*256+05,6*03+prgwinlin,2,6*03+8,320,06,0   ;05=Textzeile 03
dw     00,255*256+05,6*04+prgwinlin,2,6*04+8,320,06,0   ;06=Textzeile 04
dw     00,255*256+05,6*05+prgwinlin,2,6*05+8,320,06,0   ;07=Textzeile 05
dw     00,255*256+05,6*06+prgwinlin,2,6*06+8,320,06,0   ;08=Textzeile 06
dw     00,255*256+05,6*07+prgwinlin,2,6*07+8,320,06,0   ;09=Textzeile 07
dw     00,255*256+05,6*08+prgwinlin,2,6*08+8,320,06,0   ;10=Textzeile 08
dw     00,255*256+05,6*09+prgwinlin,2,6*09+8,320,06,0   ;11=Textzeile 09
dw     00,255*256+05,6*10+prgwinlin,2,6*10+8,320,06,0   ;12=Textzeile 10
dw     00,255*256+05,6*11+prgwinlin,2,6*11+8,320,06,0   ;13=Textzeile 11
dw     00,255*256+05,6*12+prgwinlin,2,6*12+8,320,06,0   ;14=Textzeile 12
dw     00,255*256+05,6*13+prgwinlin,2,6*13+8,320,06,0   ;15=Textzeile 13
dw     00,255*256+05,6*14+prgwinlin,2,6*14+8,320,06,0   ;16=Textzeile 14
dw     00,255*256+05,6*15+prgwinlin,2,6*15+8,320,06,0   ;17=Textzeile 15
dw     00,255*256+05,6*16+prgwinlin,2,6*16+8,320,06,0   ;18=Textzeile 16
dw     00,255*256+05,6*17+prgwinlin,2,6*17+8,320,06,0   ;19=Textzeile 17
dw     00,255*256+05,6*18+prgwinlin,2,6*18+8,320,06,0   ;20=Textzeile 18
dw     00,255*256+05,6*19+prgwinlin,2,6*19+8,320,06,0   ;21=Textzeile 19
dw     00,255*256+05,6*20+prgwinlin,2,6*20+8,320,06,0   ;22=Textzeile 20
dw     00,255*256+05,6*21+prgwinlin,2,6*21+8,320,06,0   ;23=Textzeile 21
dw     00,255*256+05,6*22+prgwinlin,2,6*22+8,320,06,0   ;24=Textzeile 22
dw     00,255*256+05,6*23+prgwinlin,2,6*23+8,320,06,0   ;25=Textzeile 23
dw     00,255*256+05,6*24+prgwinlin,2,6*24+8,320,06,0   ;26=Textzeile 24
if max_ylen=50
dw     00,255*256+05,6*25+prgwinlin,2,6*25+8,320,06,0   ;27=Textzeile 25
dw     00,255*256+05,6*26+prgwinlin,2,6*26+8,320,06,0   ;28=Textzeile 26
dw     00,255*256+05,6*27+prgwinlin,2,6*27+8,320,06,0   ;29=Textzeile 27
dw     00,255*256+05,6*28+prgwinlin,2,6*28+8,320,06,0   ;30=Textzeile 28
dw     00,255*256+05,6*29+prgwinlin,2,6*29+8,320,06,0   ;31=Textzeile 29
dw     00,255*256+05,6*30+prgwinlin,2,6*30+8,320,06,0   ;32=Textzeile 30
dw     00,255*256+05,6*31+prgwinlin,2,6*31+8,320,06,0   ;33=Textzeile 31
dw     00,255*256+05,6*32+prgwinlin,2,6*32+8,320,06,0   ;34=Textzeile 32
dw     00,255*256+05,6*33+prgwinlin,2,6*33+8,320,06,0   ;35=Textzeile 33
dw     00,255*256+05,6*34+prgwinlin,2,6*34+8,320,06,0   ;36=Textzeile 34
dw     00,255*256+05,6*35+prgwinlin,2,6*35+8,320,06,0   ;37=Textzeile 35
dw     00,255*256+05,6*36+prgwinlin,2,6*36+8,320,06,0   ;38=Textzeile 36
dw     00,255*256+05,6*37+prgwinlin,2,6*37+8,320,06,0   ;39=Textzeile 37
dw     00,255*256+05,6*38+prgwinlin,2,6*38+8,320,06,0   ;40=Textzeile 38
dw     00,255*256+05,6*39+prgwinlin,2,6*39+8,320,06,0   ;41=Textzeile 39
dw     00,255*256+05,6*40+prgwinlin,2,6*40+8,320,06,0   ;42=Textzeile 40
dw     00,255*256+05,6*41+prgwinlin,2,6*41+8,320,06,0   ;43=Textzeile 41
dw     00,255*256+05,6*42+prgwinlin,2,6*42+8,320,06,0   ;44=Textzeile 42
dw     00,255*256+05,6*43+prgwinlin,2,6*43+8,320,06,0   ;45=Textzeile 43
dw     00,255*256+05,6*44+prgwinlin,2,6*44+8,320,06,0   ;46=Textzeile 44
dw     00,255*256+05,6*45+prgwinlin,2,6*45+8,320,06,0   ;47=Textzeile 45
dw     00,255*256+05,6*46+prgwinlin,2,6*46+8,320,06,0   ;48=Textzeile 46
dw     00,255*256+05,6*47+prgwinlin,2,6*47+8,320,06,0   ;49=Textzeile 47
dw     00,255*256+05,6*48+prgwinlin,2,6*48+8,320,06,0   ;50=Textzeile 48
dw     00,255*256+05,6*49+prgwinlin,2,6*49+8,320,06,0   ;51=Textzeile 49
endif
prgwinobj0
dw     00,255*256+64,     prgwincur1,   2,   8,4,6,0    ;27=Cursor An
dw     00,255*256+05,     prgwinbuf,00,00,320,6,0       ;28=Update-Zeile
dw     00,255*256+00,1             ,00,00,  1,1,0       ;29=Clear-Kasten
dw     00,255*256+00,3             ,0,006,  244,1,0     ;30=Scroll-Korrigierer
dw     00,255*256+00,1             ,1,007,  242,1,0     ;31=Scroll-Korrigierer
dw     00,255*256+00,1             ,1,012,  242,1,0     ;32=Scroll-Korrigierer
dw     00,255*256+00,3             ,0,123+6,244,1,0     ;33=Scroll-Korrigierer
dw     00,255*256+00,1             ,1,122+6,242,1,0     ;34=Scroll-Korrigierer
dw     00,255*256+00,1             ,1,123,  242,1,0     ;35=Scroll-Korrigierer
dw     00,255*256+05,     prgwincur0,00+2,00+8,4,6,0    ;36=Cursor Aus

prgwincur0  dw scrcur,256*128,smlfnt
prgwincur1  dw scrcur,256*128,smlfnt
prgwinbuf   dw scrbuf,256*128,smlfnt
prgwinlin   ds max_ylen*6

;### CONFIG FENSTER ###########################################################

configwin   dw #1401,4+16,079,013,160,151,0,0,160,151,160,151,160,151,0,configtit,0,0,configgrp,0,0:ds 136+14
configgrp   db 27,0:dw configdat,0,0,256*03+02,0,0,00
configdat
dw      00,         0,2,          0,0,1000,1000,0       ;00=Hintergrund
dw cfgset1,255*256+16,prgtxtok,   59,135, 48,12,0       ;01="Ok"    -Button
dw diacnc ,255*256+16,prgtxtcnc, 109,135, 48,12,0       ;02="Cancel"-Button
dw      00,255*256+ 3,configdsc0, 00, 01,160,30,0       ;03=Rahmen "Size and Position"
dw      00,255*256+ 1,configdsc3, 08, 13, 40, 8,0       ;04=Beschreibung "Width"
dw      00,255*256+ 1,configdsc4, 78, 13, 40, 8,0       ;05=Beschreibung "Height"
dw      00,255*256+32,configinp0, 40, 11, 20,12,0       ;06=Input Xlen
dw      00,255*256+32,configinp1,110, 11, 20,12,0       ;07=Input Ylen
dw      00,255*256+ 3,configdsc1, 00, 30,160,70,0       ;08=Rahmen "Colours"
dw      00,255*256+ 1,configdsc7, 08, 40, 60, 8,0       ;09=Beschreibung "Text"
dw      00,255*256+ 1,configdsc8, 08, 50, 60, 8,0       ;10=Beschreibung "Hintergrund"
dw      00,255*256+ 1,configdsc9, 08, 60, 60, 8,0       ;11=Beschreibung "Rahmen"
dw cfgset3,255*256+18,configrad7b,62, 40, 21, 8,0       ;12=Radiobutton "Text"
dw cfgset3,255*256+18,configrad7a,62, 50, 21, 8,0       ;13=Radiobutton "Hintergrund"
dw cfgset3,255*256+18,configrad7c,62, 60, 21, 8,0       ;14=Radiobutton "Rahmen"
configdat0
dw      00,255*256+2, 256*17,     69, 50, 14, 8,0       ;15=Fläche "Hintergrund"
dw      00,255*256+2, 256*17,     69, 40, 14, 8,0       ;16=Fläche "Text"
dw      00,255*256+2, 256*17,     69, 60, 14, 8,0       ;17=Fläche "Rahmen"

dw      00,255*256+1, configdsce, 92, 40, 60, 8,0       ;18=Beschreibung "Selection"
dw cfgseth,255*256+42,colselobj,  92, 50, 60,10,0       ;19=Colour-List
dw      00,255*256+1, configdsca, 08, 74, 60, 8,0       ;20=Beschreibung "Preview"
configdat1
dw      00,255*256+ 2,256*17+64+128,62,72,90,20,0       ;21=Fläche Preview
dw      00,255*256+ 2,128,        63, 73, 88,18,0       ;22=Rahmen Preview
dw      00,255*256+ 5,configdscb, 65, 78, 60, 8,0       ;23=Text   Preview
dw      00,255*256+ 3,configdsc2, 00, 99,160,36,0       ;24=Rahmen "Options"
dw      00,255*256+17,configchk1, 08,109,144, 8,0       ;25=Checkbox "Fullscreen"
dw      00,255*256+17,configchk2, 08,119,144, 8,0       ;26=Checkbox "FS mit 80x25"


configdsc0  dw configtxt0,2+4
configdsc1  dw configtxt1,2+4
configdsc2  dw configtxt2,2+4
configdsc3  dw configtxt3,2+4
configdsc4  dw configtxt4,2+4
configdsc7  dw configtxt7,2+4
configdsc8  dw configtxt8,2+4
configdsc9  dw configtxt9,2+4
configdsca  dw configtxta,2+4
configdscb  dw configtxtb,128*256,smlfnt
configdsce  dw configtxte,2+4

configinp0  dw configbuf0,0,0,0,0,3,0
configbuf0  ds 4
configinp1  dw configbuf1,0,0,0,0,2,0
configbuf1  ds 3

configrad7a dw configobj7,configtxt00,256*0+2+4,configkrd7
configrad7b dw configobj7,configtxt00,256*1+2+4,configkrd7
configrad7c dw configobj7,configtxt00,256*2+2+4,configkrd7
configkrd7  ds 4
configobj7  db 0

colselobj   dw 16,0,colsellst,0,1,colselrow,0,1
colselrow   dw 0,56,0,0
colsellst   dw 00,coltxt00, 01,coltxt01, 02,coltxt02, 03,coltxt03, 04,coltxt04, 05,coltxt05, 06,coltxt06, 07,coltxt07
            dw 08,coltxt08, 09,coltxt09, 10,coltxt10, 11,coltxt11, 12,coltxt12, 13,coltxt13, 14,coltxt14, 15,coltxt15

configchk1  dw configful,configtxtc,2+4
configful   db 0
configchk2  dw configfsz,configtxtd,2+4
configfsz   db 0

;### DIREKTE TEXT-AUSGABE #####################################################

if computer_mode=0
;(IX+0)=Bank, (IX+1/2)=Adresse, (IX+3/4)=Stack, IY,DE werden weitergegeben
mftdat1 db 0:dw mftout
mftdat2 db 0:dw mftclr
mftdat3 db 0:dw mftinv
mftdat4 db 0:dw mftfll
elseif computer_mode=3
;(IX+0)=Bank, (IX+1/2)=Adresse, (IX+3/4)=Stack, IY,DE werden weitergegeben
mftdat1 db 0:dw mftout
mftdat2 db 0:dw mftclr
mftdat3 db 0:dw mftinv
mftdat4 db 0:dw mftfll
mftdat5 db 0:dw mftini
mftdat6 db 0:dw mftofs
mftdat7 db 0:dw mftcol
elseif computer_mode=5
;(IX+0)=Bank, (IX+1/2)=Adresse, (IX+3/4)=Stack, IY,DE werden weitergegeben
mftdat1 db 0:dw nctout
mftdat2 db 0:dw mftclr
mftdat3 db 0:dw mftinv
mftdat4 db 0:dw mftsru
mftdat5 db 0:dw mftsrd
elseif computer_mode=6
;(IX+0)=Bank, (IX+1/2)=Adresse, (IX+3/4)=Stack, IY,DE werden weitergegeben
mftdat1 db 0:dw nxtini
mftdat2 db 0:dw nxtall
mftdat3 db 0:dw nxtcur
mftdat4 db 0:dw nxtplt
endif

cfgsf2flg   db 0    ;Hardware -> Flag, ob SYMBiFACE vorhanden (+1=Maus, +2=RTC, +4=IDE, +8=GFX9000)
cfgdskvir   db 0    ;virtual desktop (0=no virtual desktop, Bit[0-3] -> X-resolution, 1=512, 2=1000, Bit[4-7] -> Y-resolution, not yet defined)
cfgicnanz   db 4    ;Desktop  -> Anzahl Icons
cfgmenanz   db 1    ;Desktop  -> Anzahl Startmenu-Programm-Einträge
cfglstanz   db 0    ;Desktop  -> Anzahl Taskleisten-Shortcuts
cfgcpctyp   db 0    ;Hardware -> CPC-Typ (0=464, 1=664, 2=6128, 3=464Plus, 4=6128Plus +16=WinCPC, +48=TurboCPC)

;### Directory-Buffer
dirbufmem   db 0    ;##!!letzter Label!!##

prgtrnend

relocate_table
relocate_end
