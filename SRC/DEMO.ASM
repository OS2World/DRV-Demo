              PAGE      60,131
;
;旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;�                                                                           �
;� Generic Device Device Driver                                              �
;�                                                                           �
;읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;
              .seq                         ;    Use segments in order listed
              .286c                        ;    Must use 286 mode if OS/2
              TITLE     Demo Device Driver
;
;旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;�                  ATTRIBUTE EQUATES                                        �
;읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;
CHR           equ       8000H              ;    Bit set if character device
IDC           equ       4000H              ;    Inter DD communications enabled
NIBM          equ       2000H              ;    Bit set if NON-IBM Block Format
SHAR          equ       1000H              ;    Set to support shrd dev. access
RM            equ       0800H              ;    Set if Removable Media (Blk)
OPN           equ       0800H              ;    Set if Device Open/Close (Char)
OS2           equ       0080H              ;    OS/2 Function Level DD
CLK           equ       0008H              ;    Clock Device
NUL           equ       0004H              ;    Null Device
SCR           equ       0002H              ;    Std Output Device (SCREEN)
KBD           equ       0001H              ;    Std Input Device (KEYBOARD)
;
;旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;�                  EXTERNAL DECLARATIONS                                    �
;읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;
              EXTRN     _strategy_c:near
;
;旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;�                  DATA SEGMENT                                             �
;읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;
; Device Driver Header must be the first item in the DATA group
;
; Automatic Data Grouping
DGROUP        GROUP     NULL,_DATA,CONST,_BSS,LAST_D,FAR_BSS

; Automatic Code Grouping
CGROUP        GROUP     MAINSEG,END_TEXT,_TEXT
;
NULL          SEGMENT   WORD PUBLIC 'BEGDATA'
              public    header
;             public    __acrtused
              public    _devhlp
;
header        dd        -1                 ; Pointer to next dd header
attrib        dw        OS2+CHR+OPN        ; OS/2 Dev,
                                           ; Char. Device,
                                           ; Open/Close,
                                           ; No IDC support

              dw        _strategy          ; Point to Strategy Routine
              dw        0                  ; No IDC
              db        '$DEMO   '         ; Name Field (Must be 8 bytes)
              dq        (0)                ; Reserved for OS/2
              PAGE
_devhlp       dd        ?                  ; DevHlp entry, recv'd on Init Call
;
;__acrtused    dw        0                  ; C .OBJ files want one.  They never
                                           ; use it.
;
;旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;� These next empty segments are here to let the .seq command above work like�
;� we want.  We want it to put segment LAST_D at the end of the data group.  �
;� We do this by saying .seq which says to group them as encountered.  Then  �
;� we tell it which ones to group together by using the GROUP command.  Then �
;� we put in empty ones for it to encounter.  These have the same names and  �
;� attributes as the segments the C compiler will produce.  After we have    �
;� shown the assembler and linker all the C procuced segments, we show him   �
;� our end of segment marker (LAST_D).  The linker will put all segments with�
;� the same name and attributes together and in the order we specify here.   �
;�                                                                           �
;� We then do the same thing with the code segments.  The GROUP command tells�
;� which segments to group together, and the order they appear here is the   �
;� order they will appear in the .SYS file.                                  �
;�                                                                           �
;� The final 'trick' is to specify the object file from this source file     �
;� first when linking.  My method is to put ALL others in a library, and just�
;� specify this module's .OBJ file in the linker Automatic Response File     �
;� (.ARF).                                                                   �
;�                                                                           �
;읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;
NULL          ENDS
_DATA         SEGMENT   WORD PUBLIC 'DATA'
_DATA         ENDS
CONST         SEGMENT   WORD PUBLIC 'CONST'
CONST         ENDS
FAR_BSS       SEGMENT   WORD PUBLIC 'FAR_BSS'
FAR_BSS       ENDS
_BSS          SEGMENT   WORD PUBLIC 'BSS'
_BSS          ENDS
;
;旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;� The next segment MUST be the last data segment to appear.  It marks the   �
;� end of the data segment, allowing INIT to calculate how big it is, and    �
;� free the rest.                                                            �
;읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;
LAST_D        SEGMENT   WORD PUBLIC 'LAST_DATA'
              public    _last_d
_last_d       equ       $                       ; Marks the end of the data
LAST_D        ENDS
              PAGE
;
;旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;�                  CODE SEGMENT                                             �
;읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;
MAINSEG       SEGMENT   WORD PUBLIC 'CODE'
;
              ASSUME    CS:MAINSEG, DS:DGROUP, ES:nothing
              public    _strategy
              public    __chkstk
;
;旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;� The STRATEGY Entry Point.  (ta da)  It pushes the pointer to the request  �
;� packet and calls the Strategy routine written in C. This lets the C       �
;� function see the pointer as a parameter passed in the usual manner.       �
;읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;
_strategy     PROC      FAR
;
              push      es
              push      bx
              call      _strategy_c           ; call C strategy routine
              pop       bx
              pop       es
              ret
;
_strategy     ENDP
;
;
              PAGE
;
;旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;� This is a replacement for the C compiler's stack checking routine.  It    �
;� is declared as external by the compiler, but it should never be called    �
;� as we compile with all stack probes removed.  If, however, it should get  �
;� called, it allocates the local variables like the compiler's __chkstk,    �
;� without generating an error if the stack is not big enough.               �
;읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;
__chkstk      proc      far
              pop       cx
              pop       dx
              mov       bx,sp
              sub       bx,ax
              mov       sp,bx
              push      dx
              push      cx
              ret
__chkstk      endp
;
MAINSEG       ENDS
;
_TEXT         SEGMENT   WORD PUBLIC 'CODE'
_TEXT         ends
;旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;� The next segment marks the end of the code to be kept.  The C compiler    �
;� will call all its segments _TEXT, so they will be combined with this one  �
;� Our discardable segments will be tacked on after END_TEXT, and will be    �
;� discarded after INIT is done.                                             �
;읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
;
END_TEXT      SEGMENT   WORD PUBLIC 'CODE'
              public    _last_c
_last_c       equ       $
END_TEXT      ends
;
INITSEG       SEGMENT   WORD PUBLIC 'CODE'
INITSEG       ends
;
              END
