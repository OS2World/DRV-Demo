#make file for Demo DD
src=.\src
lst=.\lst
obj=.\obj
msg=.\msg
lib=.
h=.\src
optmain=/Fc$(lst)\$(*F).cod /c /NTMAINSEG /W3 /Gs /Alfw /Od /Zp /Fo$(obj)\$(*F).obj >$(msg)\$(*F).msg
optsize=/Fc$(lst)\$(*F).cod /c /NTMAINSEG /W3 /Gs /Alfw /Os /Zp /Fo$(obj)\$(*F).obj >$(msg)\$(*F).msg
optkeep=/Fc$(lst)\$(*F).cod /c /NTKEEPSEG /W3 /Gs /Alfw /Od /Zp /Fo$(obj)\$(*F).obj >$(msg)\$(*F).msg
optinit=/Fc$(lst)\$(*F).cod /c /NTINITSEG /W3 /Gs /Alfw /Od /Zp /Fo$(obj)\$(*F).obj >$(msg)\$(*F).msg
hfiles=$(h)\externs.h $(h)\const.h $(h)\struc.h $(h)\demo.h

demo.sys : $(lib)\demo.lib
   link @demo.arf > $(msg)\link.lst
   copy demo.dll demo.sys
   erase demo.dll

$(lib)\demo.lib : demo.arf                        \
                            $(obj)\ASMUTILS.OBJ  \
                            $(obj)\BADCMD.OBJ    \
                            $(obj)\brkpoint.obj  \
                            $(obj)\DDUTILS.OBJ   \
                            $(obj)\DEVHLP.OBJ    \
                            $(obj)\GDTMEM.OBJ    \
                            $(obj)\INIT.OBJ      \
                            $(obj)\LOCK.OBJ      \
                            $(obj)\LDTMEM.OBJ    \
                            $(obj)\PRTMSG.OBJ    \
                            $(obj)\demo.OBJ      \
                            $(obj)\STRATEGY.OBJ  \
                            demo.MSG;

$(obj)\gdtmem.obj : $(src)\gdtmem.c $(hfiles)
   cl $(optkeep) $(src)\$(*F).c
   lib $(lib)\demo-+$(obj)\$(*F);

$(obj)\lock.obj : $(src)\lock.c $(hfiles)
   cl $(optkeep) $(src)\$(*F).c
   lib $(lib)\demo-+$(obj)\$(*F);

$(obj)\ldtmem.obj : $(src)\ldtmem.c $(hfiles)
   cl $(optkeep) $(src)\$(*F).c
   lib $(lib)\demo-+$(obj)\$(*F);

$(obj)\init.obj : $(src)\init.c $(hfiles)
   cl $(optinit) $(src)\$(*F).c
   lib $(lib)\demo-+$(obj)\$(*F);

$(obj)\badcmd.obj : $(src)\badcmd.c $(hfiles)
   cl $(optkeep) $(src)\$(*F).c
   lib $(lib)\demo-+$(obj)\$(*F);

$(obj)\strategy.obj : $(src)\strategy.c $(hfiles)
   cl $(optmain) $(src)\$(*F).c
   lib $(lib)\demo-+$(obj)\$(*F);

$(obj)\ddutils.obj : $(src)\ddutils.c $(hfiles)
   cl $(optmain) $(src)\$(*F).c
   lib $(lib)\demo-+$(obj)\$(*F);

$(obj)\prtmsg.obj : $(src)\prtmsg.c $(hfiles) $(src)\version.h
   cl $(optinit) $(src)\$(*F).c
   lib $(lib)\demo-+$(obj)\$(*F);

$(obj)\asmutils.obj : $(src)\asmutils.asm
   masm $(src)\$(*F),$(obj)\$(*F).obj,$(lst)\$(*F).lst > $(msg)\$(*F).msg;
   lib $(lib)\demo-+$(obj)\$(*F);

$(obj)\brkpoint.obj : $(src)\brkpoint.asm
   masm $(src)\$(*F),$(obj)\$(*F).obj,$(lst)\$(*F).lst > $(msg)\$(*F).msg;
   lib $(lib)\demo-+$(obj)\$(*F);

$(obj)\devhlp.obj : $(src)\devhlp.asm
   masm $(src)\$(*F),$(obj)\$(*F).obj,$(lst)\$(*F).lst > $(msg)\$(*F).msg;
   lib $(lib)\demo-+$(obj)\$(*F);

$(obj)\demo.obj : $(src)\demo.asm
   masm $(src)\demo,$(obj)\demo.obj,$(lst)\demo.lst > $(msg)\$(*F).msg;

demo.msg : demo.txt
   mkmsgf demo.txt demo.msg

