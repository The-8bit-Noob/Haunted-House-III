   10 REM ******************************
   20 REM *   THE HAUNTED HOUSE III    *
   30 REM *  This Version Is For The   *
   40 REM *      **Agon Light2**       *
   50 REM *     WRITTEN FOR MODE 8     *
   60 REM *      BY STEVE LOVEJOY      *
   70 REM *            2024            *
   80 REM ******************************
   90 :
  100 REM Haunted House was originally
  110 REM written by Jenny Tylor and
  120 REM Les Howarth for Usborne Books.
  130 REM It was a type-in listing from
  140 REM back in the 1980's.
  150 REM I've Ported it to the agon light2
  160 REM plus pimped it up with graphics etc.
  170 REM I still want to add soud effects.
  180 :
  190 REM Main Setup
  200 MB%=&40000 : REM Memory Bank &40000.
  210 DIM Graphics 1024 : REM Array for pixels.
  220 DIM TheMap%(14,14) : REM i=x,j=y.
  230 MyMaps$="/haunted3/maps" : REM maps directory.
  240 Map$="57" : REM DEFAULT Map start point.
  250 TilesPack$="/haunted3/tiles" : REM changes for your custom tiles directory.
  260 MapName$=(MyMaps$ + "/" + Map$  + ".map") : REM maps file paths & names.
  270 XSIZE%=11:YSIZE%=6:XIMP%=0:YIMP%=0:x%=112:y%=96:p%=0:custom%=0:decks%=6 : REM Vars.
  280 VDU 23,27,16 : REM Clear all sprite data.
  290 PROC_Vars
  300 :
  310 PROC_LoadChars
  320 PROC_InitScreen
  330 PROC_LoadBitmaps
  340 PROC_TitleSplash
  350 :
  360 GAMEOVER=FALSE
  370 REPEAT
  380   PROC_OfferInstructions
  390   CLS
  400   PROC_MainLoop
  410 UNTIL GAMEOVER=TRUE
  430 PROC_TitleSplash
  440 END : REM END Main Setup
  450 :
  460 DEF PROC_MainLoop
  470 :
  480 nvbs%=29:nobs%=36:get%=18
  490 PROCinit
  500 :
  510 VDU 26,30,23,1,0 : REM RESET VP to whole screen : REM haunted house loop here
  520 CLS
  530 PROC_DrawHud
  535 PROC_DrawRoom
  540 VDU 28,LT%,3,28,1 : REM SET text VP
  550 CLS
  560 COLOUR ColIntYellow%
  570 PRINT "You are "; : PRINT loc$(rm%)
  580 VDU 26,30,23,1,0 : REM RESET VP to whole screen,
  590 :
  600 Map$ = STR$(rm%) : REM IF rm%=41 AND route$(49)="SW" THEN Map$ = STR$(64)
  610 PROC_LoadMap(Map$) : REM load map
  620 PROC_ShowMap(24,35,24) : REM show map
  630 COLOUR ColIntGreen%
  635 PRINT TAB(RT%,1);"Score"
  640 PRINT TAB(LT%+4,19);"Current Exits:"
  650 COLOUR ColIntYellow%
  660 PRINT TAB(LT%+19,19);"";
  670 FOR I=1 TO LEN(route$(rm%))
  680   PRINT MID$(route$(rm%),I,1);",";
  690 NEXT I
  700 VDU 127 : REM backspace
  710 COLOUR ColIntGreen%
  720 PRINT TAB(RT%,3);"RuckSacK"
  730 :
  740 COLOUR ColIntYellow%
  750 FOR I=1 TO get% : REM display collected items in rucksack.
  760   IF cy%(I)=1 THEN PRINT TAB(RT%,4+(I)) obj$(I)
  770 NEXT I
  780 score%=0 : REM GET score
  790 FOR I=1 TO get%
  800   IF cy%(I)=1 THEN score%=score%+1
  810 NEXT I
  820 COLOUR ColIntYellow%
  825 PRINT TAB(RT%+6,1);"";score% : REM PRINT score
  830 COLOUR ColIntGreen%
  832 VDU 28,LT%,27,28,22 : REM SET text VP
  833 CLS
  835 PRINT TAB(LT%);msge$ : msge$="What"
  840 PRINT TAB(LT%);"What will You do now"
  850 PRINT : FOR I=1 TO get%
  860   IF loc%(I)=rm% AND flag%(I)=0 THEN PRINT TAB(LT%);"You can see a ";obj$(I);" here";
  870 NEXT I
  875 COLOUR ColIntYellow%
  880 PRINT TAB(LT%);""; : INPUT in$
  890 vb$="" : n$="" : vb%=0 : ob%=0
  900 FOR I=1 TO LEN(in$)
  910   IF MID$(in$,I,1)=" " AND vb$="" THEN vb$=LEFT$(in$,I-1)
  920   IF MID$(in$,I+1,1)<>" " AND vb$<>"" THEN n$=MID$(in$,I+1,LEN(in$)-1) : I=LEN(in$)
  930 NEXT I
  940 IF n$="" vb$=in$
  950 FOR I=1 TO nvbs%
  960   IF vb$=vb$(I) THEN vb%=I
  970 NEXT I
  980 FOR I=1 TO nobs%
  990   IF LEFT$(n$,3)=gob$(I) THEN ob%=I
 1000 NEXT I
 1010 IF n$>"" AND ob%=0 THEN msge$="That is silly!"
 1020 IF vb%=0 vb%=vb%+1
 1030 IF n$="" msge$="-"
 1040 IF vb%>nvbs% AND ob%>0 msge$="You cannot '"+in$+"'"
 1050 IF vb%>nvbs% AND ob%=0 msge$="You do not make sense!"
 1060 IF vb%<nvbs% AND ob%>0 AND cy%(ob%)=0 msge$="You do not have '"+n$+"'"
 1070 IF flag%(26)=1 AND rm%=13 AND RND(3)<>3 AND vb%<>21 msge$="VAMPIRE BATS ATTACKING!" : GOTO 510 : REM SOUND2,-15,30,153
 1080 IF rm%=44 AND RND(2)=1 AND flag%(24)<>1 flag%(27)=1
 1090 IF vb%=1 PROChelp
 1100 IF vb%=2 PROCrucksack
 1110 IF vb%=3 PROCmove
 1120 IF vb%=4 PROCmove
 1130 IF vb%=5 PROCmove
 1140 IF vb%=6 PROCmove
 1150 IF vb%=7 PROCmove
 1160 IF vb%=8 PROCmove
 1170 IF vb%=9 PROCmove
 1180 IF vb%=10 PROCtake
 1190 IF vb%=11 PROCtake
 1200 IF vb%=12 PROCopen
 1210 IF vb%=13 PROCexam
 1220 IF vb%=14 PROCread
 1230 IF vb%=15 PROCsay
 1240 IF vb%=16 PROCdig
 1250 IF vb%=17 PROCswing
 1260 IF vb%=18 PROCclimb
 1270 IF vb%=19 PROClight
 1280 IF vb%=20 PROCsnuff
 1290 IF vb%=21 PROCspray
 1300 IF vb%=22 PROCuse
 1310 IF vb%=23 PROCunlock
 1320 IF vb%=24 PROCleave
 1330 IF vb%=25 PROCscore
 1340 IF vb%=26 PROCsave
 1350 IF vb%=27 PROCload
 1360 IF vb%=28 PROCquit
 1370 IF vb%=29 PROChint
 1380 GOTO 510 : REM loop back to start of haunted code.
 1390 :
 1400 DEF PROChelp
 1410 VDU 28,LT%,27,28,22 : REM SET text VP
 1420 CLS
 1430 COLOUR ColIntGreen% : PRINT "Words I know: "
 1440 COLOUR ColIntYellow% : PRINT "";
 1450 FOR I=1 TO nvbs%
 1460   PRINT vb$(I);",";
 1470 NEXT I
 1480 msge$="" : PRINT
 1490 PROCcyon
 1500 ENDPROC : REM END help
 1510 :
 1520 DEF PROCrucksack
 1530 VDU 28,LT%,27,28,22 : REM SET text VP
 1540 CLS
 1550 COLOUR ColIntGreen% : PRINT "RuckSacK: "
 1560 COLOUR ColIntYellow% : PRINT "";
 1570 FOR I=1 TO get%
 1580   IF cy%(I)=1 PRINT obj$(I);",";
 1590 NEXT I
 1600 msge$="" : PRINT
 1610 PROCcyon
 1620 ENDPROC : REM END rucksack
 1630 :
 1640 DEF PROCmove
 1650 dir%=0
 1660 IF ob%=0 dir%=vb%-3
 1670 IF ob%=19 dir%=1
 1680 IF ob%=20 dir%=2
 1690 IF ob%=21 dir%=3
 1700 IF ob%=22 dir%=4
 1710 IF ob%=23 dir%=5
 1720 IF ob%=24 dir%=6
 1730 IF rm%=20 AND dir%=5 dir%=1
 1740 IF rm%=20 AND dir%=6 dir%=3
 1750 IF rm%=22 AND dir%=6 dir%=2
 1760 IF rm%=22 AND dir%=5 dir%=3
 1770 IF rm%=36 AND dir%=6 dir%=1
 1780 IF rm%=36 AND dir%=5 dir%=2
 1790 IF flag%(14)=1 msge$="Crash! You fell out of the tree!" : flag%(14)=0 : GAMEOVER=TRUE : ENDPROC
 1800 IF flag%(27)=1 AND rm%=52 msge$="Ghosts will not let you move!" : ENDPROC
 1810 IF rm%=45 AND cy%(1)=1 AND flag%(34)=0 THEN msge$="A magical barrier appeared." : ENDPROC
 1820 IF (rm%=18 AND flag%(0)=0) AND (dir%=1 OR dir%=4) msge$="It is too dark to move, you need a light." : ENDPROC
 1830 IF rm%=54 AND cy%(15)<>1 msge$="You are stuck! Better luck next time." : PROCcyon : GAMEOVER=TRUE
 1840 IF cy%(15)=1 AND NOT(rm%=53 OR rm%=54 OR rm%=55 OR rm%=47) msge$="You cannot carry a boat!" : ENDPROC
 1850 IF (rm%>26 AND rm%<30) AND flag%(0)=0 msge$="It is too dark to move" : ENDPROC
 1860 flag%(35)=0 : RL=LEN(route$(rm%))
 1870 FOR I=1 TO RL
 1880   dir$=MID$(route$(rm%),I,1)
 1890   IF (dir$="N" AND dir%=1 AND flag%(35)=0) rm%=rm%-8 : flag%(35)=1
 1900   IF (dir$="S" AND dir%=2 AND flag%(35)=0) rm%=rm%+8 : flag%(35)=1
 1910   IF (dir$="W" AND dir%=3 AND flag%(35)=0) rm%=rm%-1 : flag%(35)=1
 1920   IF (dir$="E" AND dir%=4 AND flag%(35)=0) rm%=rm%+1 : flag%(35)=1
 1930 NEXT I
 1940 msge$="Ready"
 1950 IF flag%(35)=0 msge$="You cannot go that way!"
 1960 IF dir%<1 msge$="Go where?"
 1970 IF rm%=41 AND flag%(23)=1 route$(49)="W" : msge$="The door slams shut!" : flag%(23)=0 : REM SOUND3,-15,20,90
 1980 ENDPROC : REM END move
 1990 :
 2000 DEF PROCtake
 2010 IF ob%>get% msge$="You cannot get "+n$ : ENDPROC
 2020 IF loc%(ob%)<>rm% msge$="It is not here"
 2030 IF ob%<>0 msge$="WHAT "+n$+"?"
 2040 IF cy%(ob%)=1 msge$="You already have it"
 2050 IFob%>0 AND loc%(ob%)=rm% AND flag%(ob%)=0 cy%(ob%)=1 : loc%(ob%)=65 : msge$="You now have it."
 2060 ENDPROC : REM END take
 2070 :
 2080 DEF PROCopen
 2090 IF rm%=43 AND (ob%=28 OR ob%=29) flag%(17)=0 : msge$="The drawer is now open"
 2100 IF rm%=28 AND ob%=25 msge$="It is locked"
 2110 IF rm%=38 AND ob%=32 msge$="It is now open" : flag%(2)=0
 2120 ENDPROC : REM END open
 2130 :
 2140 DEF PROCexam
 2150 IF ob%=10 msge$="It needs batteries"
 2160 IF ob%=30 flag%(18)=0 : msge$="Something falls out the     pocket."
 2170 IF ob%=31 msge$="That's disgusting!"
 2180 IF (ob%=28 OR ob%=29) msge$="There is a drawer"
 2190 IF ob%=33 OR ob%=5 PROCread
 2200 IF rm%=43 AND ob%=35 msge$="There is something beyond....."
 2210 IF ob%=32 PROCopen
 2220 ENDPROC : REM END exam
 2230 :
 2240 DEF PROCread
 2250 IF rm%=42 AND ob%=33 msge$="They are demonic works"
 2260 IF (ob%=3 OR ob%=36) AND cy%(3)=1 AND flag%(34)=0 msge$="It says: Use this word with  care.. AGON"
 2270 IF cy%(5)=1 AND ob%=5 msge$="The writing is in a strange  language"
 2280 ENDPROC : REM END read
 2290 :
 2300 DEF PROCsay
 2310 msge$="Ready  '"+n$+"'"
 2320 IF cy%(3)=1 AND ob%=34 THEN msge$="You feel faint and close   your eyes. When you open them something magical has happened." : IF rm%<>45 THEN rm%=RND(63)
 2330 IF cy%(3)=1 AND ob%=34 AND rm%=45 THEN flag%(34)=1
 2340 ENDPROC : REM END say
 2350 :
 2360 DEF PROCdig
 2370 IF cy%(12)=1 msge$="You made a lovely little hole!"
 2380 IF cy%(12)=1 AND rm%=30 msge$="You have dug the bars out" : loc$(rm%)="There is a hole in the wall" : route$(rm%)="NSE"
 2390 ENDPROC : REM END dig
 2400 :
 2410 DEF PROCswing
 2420 IF cy%(14)<>1 AND rm%=7 msge$="This is no time to play games!"
 2430 IF ob%=14 AND cy%(14)=1 msge$="You swung it"
 2440 IF ob%=13 AND cy%(13)=1 msge$="Whoooosshhh!"
 2450 IF ob%=13 AND cy%(13)=1 AND rm%=43 route$(rm%)="WN" : loc$(rm%)="in a study with a secret room  connected" : msge$="You have broken the wall"
 2460 ENDPROC : REM END swing
 2470 :
 2480 DEF PROCclimb
 2490 IF ob%=14 AND cy%(14)=1 msge$="It is not attached to anything!"
 2500 IF ob%=14 AND cy%(14)<>1 AND rm%=7 AND flag%(14)=0 msge$="You see thick forest and a    cliff to the south" : flag%(14)=1 : ENDPROC
 2510 IF ob%=14 AND cy%(14)<>1 AND rm%=7 AND flag%(14)=1 msge$="Going down!" : flag%(14)=0
 2520 ENDPROC : REM END climb
 2530 :
 2540 DEF PROClight
 2550 IF ob%=17 AND cy%(17)=1 AND cy%(8)=0 msge$="It will burn your hands!"
 2560 IF ob%=17 AND cy%(17)=1 AND cy%(9)=0 msge$="You have nothing to light it with!"
 2570 IF ob%=17 AND cy%(17)=1 AND cy%(9)=1 AND cy%(8)=1 msge$="It casts a flickering light" : flag%(0)=1
 2580 ENDPROC : REM END light
 2590 :
 2600 DEF PROCsnuff
 2610 IF flag%(0)=1 flag%(0)=0 : msge$="Your candle is out"
 2620 ENDPROC : REM END snuff
 2630 :
 2640 DEF PROCspray
 2650 IF ob%=26 AND cy%(16)=1 msge$="Hissssss"
 2660 IF ob%=26 AND cy%(16)=1 flag%(26)=0 : msge$="Pfffft! Got them!"
 2670 ENDPROC : REM END spray
 2680 :
 2690 DEF PROCuse
 2700 IF ob%=10 AND cy%(10)=1 AND cy%(11)=1 msge$="It is switched on" : flag%(24)=1
 2710 IF flag%(27)=1 AND flag%(24)=1 msge$="Whizzzz! You vacuumed the ghosts up!" : flag%(27)=0
 2720 ENDPROC : REM END use
 2730 :
 2740 DEF PROCunlock
 2750 IF rm%=43 AND(ob%=27 OR ob%=28) PROCopen
 2760 IF rm%=28 AND ob%=25 AND flag%(25)=0 AND cy%(18)=1 flag%(25)=1 : route$(rm%)="SEW" : loc$(rm%)="by a huge open door" : msge$="The key turns!"
 2770 ENDPROC : REM END unlock
 2780 :
 2790 DEF PROCleave
 2800 IF cy%(ob%)=1 cy%(ob%)=0 : loc%(ob%)=rm% : msge$="Done"
 2810 ENDPROC : REM END leave
 2820 :
 2830 DEF PROCscore
 2832 VDU 28,LT%,27,28,22 : REM SET text VP
 2834 CLS
 2840 score%=0
 2850 FOR I=1 TO get%
 2860   IF cy%(I)=1 score%=score%+1
 2870 NEXTI
 2880 IF score%=17 AND cy%(15)<>1 AND rm%<>57 PRINT "You have everything" : PRINT "Return to the gate for your final score":
 2890 IF score%=17 AND rm%=57 PRINT "DOUBLE SCORE FOR REACHING HERE!" : score%=score%*2 : PRINT score% : PROCcyon : ENDPROC
 2900 PRINT "Your score is ";score% : PROCcyon : IF score%>18 PRINT "Well done! You have finished the game" :
 2910 ENDPROC : REM END score
 2920 :
 2930 DEF PROCcyon
 2940 VDU 26,30,23,1,0 : REM RESET VP to whole screen,
 2950 COLOUR ColIntGreen%
 2960 PRINT TAB(LT%,28);""; : INPUT "Press Enter to Continue" in$
 2970 ENDPROC : REM END carry on
 2980 :
 2990 DEF PROCinit
 3000 DIM route$(63),loc$(63),obj$(nobs%),vb$(nvbs%),gob$(nobs%)
 3010 DIM cy%(nobs%),loc%(get%),flag%(nobs%)
 3020 DATA 46,38,35,50,13,18,28,42,10,25,26,4,2,7,47,60,43,32
 3030 FOR I=1 TO get%
 3040   READ loc%(I)
 3050 NEXT I
 3060 DATA HELP,RUCKSACK,GO,N,S,W,E,U,D,GET,TAKE,OPEN,EXAMINE,READ,SAY
 3070 DATA DIG,SWING,CLIMB,LIGHT,OFF,SPRAY,USE,UNLOCK,LEAVE,SCORE,SAVE,LOAD,QUIT,HINT
 3080 FOR I=1 TO nvbs%
 3090   READ vb$(I)
 3100 NEXT I
 3110 DATA SE,WE,WE,SWE,WE,WE,SWE,WS
 3120 DATA NS,SE,WE,NW,SE,W,NE,NSW
 3130 DATA NS,NS,SE,WE,NWUD,SE,WSUD,NS
 3140 DATA N,NS,NSE,WE,WE,NSW,NS,NS
 3150 DATA S,NSE,NSW,S,NSUD,N,N,NS
 3160 DATA NE,NW,NE,W,NSE,WE,W,NS
 3170 DATA SE,NSW,E,WE,NW,S,SW,NW
 3180 DATA NE,NWE,WE,WE,WE,NWE,NWE,W
 3190 FOR I=0 TO 63
 3200   READ route$(I)
 3210 NEXT I
 3220 DATA in a Dark Corner,in an Overgrown      Garden,by a Large Woodpile,in a Yard Littered   with Rubbish
 3230 DATA in a Weedpatch,in a Forest,in a Thicker part of the Forest,by the Blasted Tree
 3240 DATA by the corner of House,at the Entrance to   the Kitchen,in the Kitchen with a Grimy looking Cooker,in the Scullery
 3250 DATA in a Room Thick with Dust,in the Rear Turret Room,in a Clearing,on an Old Footpath
 3260 DATA by the Side of the House,at the Back of the Hallway,in a Dark Alcove,in a Small Dark Room
 3270 DATA at the Bottom of a   Spiral Staircase,in a Wide Passage,On a set of Slippery Steps,On a Cliff Top
 3280 DATA near a Crumbling wall,in a Gloomy Passage,in a Short Corridor,in an Impressive Hallway
 3290 DATA in a Hall by a Thick      Wooden Door. The Door is Locked,in the Trophy Room,in a Cellar with a Barred    Window,on a Cliff Path
 3300 DATA in a Cupboard with a Coat hanging up,in the Front Hall,in the Sitting Room,in a Secret Room
 3310 DATA on some Steep Marble  Stairs,in the Dining Room,in a Deep Cellar with a Closed Coffin,on a Cliff Path
 3320 DATA in a Closet,in the Front Lobby,in a Library full of Evil   Books,in the Study with a Desk and a Hole in Wall
 3330 DATA in a Weird Cobwebbed Room,in an Ice Cold Chamber,in a very Spooky Room,on a Cliff Path. Careful    there is a Marsh Close by
 3340 DATA on a Rubbish Strewn Verandah,on the Front Porch,in the Front Tower,in a Sloping Corridoor
 3350 DATA in the Upper Gallery,in a Marsh by a Wall,in a Marsh,on a Soggy Path
 3360 DATA by the Twisted       Railings,by the Main Iron    gate - It seems Open,by some Old Railings,beneath the Front   Tower
 3370 DATA by some Debris from a  Crumbling Wall,by some Fallen       Brickwork,by a Rotting Stone   Arch,on a Crumbling Clifftop
 3380 FOR I=0 TO 63
 3390   READ loc$(I)
 3400 NEXT I
 3410 DATA "painting","ring","spells","goblet","scroll","coins","statue","glove"
 3420 DATA "matches","vacuum","battery","shovel","axe","rope","boat","aerosol","candle","key"
 3430 DATA NORTH,SOUTH,WEST,EAST,UP,DOWN
 3440 DATA DOOR,BATS,GHOSTS,DRAWER,DESK,COAT,RUBBISH
 3450 DATA COFFIN,BOOKS,AGON,WALL,SPELLS
 3460 DATA PAI,RIN,MAG,GOB,SCR,COI,STA,GLO,MAT,VAC,BAT,SHO,AXE,ROP,BOA,AER,CAN,KEY,NOR,SOU,WES,EAS,UP,DOW,DOO,VBT,GHO,DRA,DES,COA,RUB,COF,BOO,AGO,WAL,SPE
 3470 FOR I=1 TO  nobs%
 3480   READ obj$(I)
 3490 NEXT I
 3500 FOR I=1 TO  nobs%
 3510   READ gob$(I)
 3520 NEXT I
 3530 flag%(18)=1:flag%(17)=1:flag%(2)=1:flag%(26)=1:flag%(28)=1:flag%(23)=1 : rm%=57 : msge$="Ready"
 3540 ENDPROC : REM END init
 3550 :
 3560 DEF PROCsave
 3570 PRINT TAB(LT%,27);""; : INPUT "Confirm SAVE",Y$
 3580 IF LEFT$(Y$,1)<>"Y" THEN 3570
 3590 PRINT TAB(LT%,27);""; : INPUT "Filename",file$
 3600 PRINT TAB(LT%,27);""; : PRINT "Saving. Please wait..."
 3610 X=OPENOUT file$
 3620 PRINT#X,rm%
 3630 FOR I=1 TO get% : PRINT#X,loc%(I) : NEXT
 3640 FOR I=0 TO 63 : PRINT#X,loc$(I) : NEXT
 3650 FOR I=0 TO 63 : PRINT#X,route$(I) : NEXT
 3660 FOR I=1 TO nobs% : PRINT#X,cy%(I) : NEXT
 3670 FOR I=1 TO nobs% : PRINT#X,flag%(I) : NEXT
 3680 CLOSE#X
 3690 ENDPROC : REM END save
 3700 :
 3710 DEF PROCload
 3720 PRINT TAB(LT%,27);""; : INPUT "Are You Ready To LOAD",Y$
 3730 IF LEFT$(Y$,1)<>"Y" THEN 3720
 3740 PRINT TAB(LT%,27);""; : INPUT "Filename",file$
 3750 PRINT TAB(LT%,27);""; : PRINT "Loading. Please wait...."
 3760 X=OPENUP file$
 3770 INPUT#X,rm%
 3780 FOR I=1 TO get%:INPUT#X,loc%(I) : NEXT
 3790 FOR I=0TO 63 : INPUT#X,loc$(I) : NEXT
 3800 FOR I=0TO 63 : INPUT#X,route$(I) : NEXT
 3810 FOR I=1 TO nobs%:INPUT#X,cy%(I) : NEXT
 3820 FOR I=1 TO nobs%:INPUT#X,flag%(I) : NEXT
 3830 CLOSE#X
 3840 ENDPROC : REM END load
 3850 :
 3860 DEF PROCquit
 3864 VDU 28,LT%,26,28,22 : REM SET text VP
 3866 CLS
 3890 PRINT TAB(LT%);""; : INPUT "Type 'SAVE' OR QUIT: " in$
 3900 IF in$="SAVE" PROCsave
 3910 IF in$="QUIT" THEN PROC_EndGame
 3920 ENDPROC : REM END quit
 3930 :
 3940 DEF PROCprint(mess$,colour%)
 3950 VDU 28,LT%,26,28,22 : REM SET text VP
 3960 CLS
 3970 COLOUR colour%
 4060 PRINT mess$
 4070 ENDPROC : REM END print
 4120 :
 4130 DEF PROChint
 4140 IF rm%=13 PROCprint("Have you got the 'Vampire Bat SPRAY' An AEROSOL Can?",ColIntYellow%) : PROCcyon : ENDPROC
 4150 IF rm%=30 PROCprint("If you have the SHOVEL, use it to DIG the Window.",ColIntYellow%) : PROCcyon : ENDPROC
 4160 IF rm%=32 PROCprint("EXAMINE the COAT.",ColIntYellow) : PROCcyon : ENDPROC
 4170 IF rm%=35 PROCprint("Try to READ the BOOK.",ColIntYellow%) : PROCcyon : ENDPROC
 4180 IF rm%=38 PROCprint("Have a look in the COFFIN.",ColIntYellow%) : PROCcyon : ENDPROC
 4190 IF rm%=39 PROCprint("EXAMINE the DESK.",ColIntYellow%) : PROCcyon : ENDPROC
 4200 IF rm%=19 PROCprint("Wear the GLOVE",ColIntYellow%) : PROCcyon : ENDPROC
 4210 IF rm%=45 PROCprint("Do you know the Magic Word? If not, you might as well QUIT!",ColIntYellow%) : PROCcyon : ENDPROC
 4220 IF rm%=43 PROCprint("Have you got the AXE?",ColIntYellow%) : PROCcyon : ENDPROC
 4230 IF rm%=52 PROCprint("Use the VACUUM cleaner on GHOSTS. You may need the BATTERY.",ColIntYellow%) : PROCcyon : ENDPROC
 4240 IF rm%=49 PROCprint("Make sure you have one thing before you go in.",ColIntYellow%) : PROCcyon : ENDPROC
 4250 PROCprint("There is not much I can help you with here, Sorry!",ColIntYellow%) : PROCcyon : ENDPROC
 4260 ENDPROC : REM END proc hint.
 4270 :
 4280 ENDPROC : REM END main loop
 4290 :
 4300 REM ASK Y/N QUESTION. DOES THE USER SAY YES?
 4310 DEF FN_DO_I_HEAR_YES
 4320 LOCAL ANSWER, KEY%
 4330 ANSWER = FALSE
 4340 KEY% = -1
 4350 REPEAT
 4360   KEY%=INKEY(10000)
 4370 UNTIL KEY% <> -1 AND (KEY% = ASC("Y")) OR (KEY% = ASC("y") OR KEY% = ASC("N")) OR (KEY% = ASC("n"))
 4380 IF (KEY% = ASC("Y")) OR (KEY% = ASC("y")) THEN ANSWER = TRUE
 4390 = ANSWER
 4400 REM END FN do i hear a yes.
 4410 :
 4420 DEF PROC_InitScreen : REM init screen.
 4430 MODE mode%
 4440 COLOUR ColIntRed%
 4450 CLS
 4460 CLG
 4470 PROC_HideCursor
 4480 ENDPROC : REM END init screen
 4490 :
 4500 DEF PROC_HideCursor : REM Hide Cursor
 4510 VDU 23,1,0;0;0;0;
 4520 ENDPROC
 4530 :
 4540 DEF PROC_ShowCursor : REM Show Cursor
 4550 VDU 23,1,1;0;0;0;
 4560 ENDPROC
 4570 :
 4580 DEF PROC_TitleSplash : REM Title Splash
 4590 CLS
 4600 PRINT : PRINT : COLOUR ColIntRed%
 4610 PROC_DrawHaunted(13,8) : REM DRAW HAUNTED
 4620 PROC_DrawHouse(15,11) : REM DRAW HOUSE
 4630 COLOUR ColIntGreen%
 4640 PRINT "                                     "
 4650 PRINT "                                     "
 4660 PRINT "                                     "
 4670 PRINT "                                     "
 4680 PRINT TAB(LT%+8,16)"A Text Adventure Game   "
 4690 PRINT TAB(LT%+8,18)"   Haunted House III    "
 4700 PRINT TAB(LT%+8,20)"  For The Agon Light2   "
 4710 PRINT TAB(LT%+8,22)"By Steve Lovejoy (2024) "
 4720 ANYKEY%=INKEY(2000)
 4730 CLS
 4740 ENDPROC : REM END Title Splash
 4750 :
 4760 DEF PROC_OfferInstructions : REM Offer Instructions
 4770 COLOUR ColIntGreen%
 4780 PRINT TAB(LT%+4,15)" Do You Want Instructions (Y-N)";
 4790 LOCAL ANSWER
 4800 ANSWER = FALSE
 4810 ANSWER = FN_DO_I_HEAR_YES
 4820 IF ANSWER = TRUE THEN PROC_Instructions
 4830 CLS
 4840 ENDPROC : REM END Offer Instructions
 4850 :
 4860 DEF PROC_Instructions : REM Instructions
 4870 CLS
 4880 PROC_DrawHaunted(13,1)
 4890 PROC_DrawHouse(15,4)
 4900 COLOUR ColIntGreen%
 4910 PRINT TAB(LT%);""
 4920 PRINT TAB(LT%);""
 4930 PRINT TAB(LT%);"This is a text adventure game set in"
 4940 PRINT TAB(LT%);"and around an old spooky haunted"
 4950 PRINT TAB(LT%);"house. The object of the game is to"
 4960 PRINT TAB(LT%);"move through the house and it's"
 4970 PRINT TAB(LT%);"grounds and pick up all the hidden"
 4980 PRINT TAB(LT%);"objects along the way."
 4990 PRINT TAB(LT%);"You will need all objects to gain"
 5000 PRINT TAB(LT%);"access to all area's and rooms."
 5010 PRINT TAB(LT%);"Good Luck.... You'll need it...."
 5020 PRINT TAB(LT%);" "
 5030 COLOUR ColIntYellow%
 5040 PRINT TAB(LT%);"You Score By Collecting Items."
 5050 PRINT TAB(LT%);"Type HELP For A List Of Commands."
 5060 PRINT TAB(LT%);"N,E,S,W Are One-Key Short-Cuts."
 5070 PRINT TAB(LT%);"If you want to save the game to "
 5080 PRINT TAB(LT%);"continue later, type SAVE."
 5090 PRINT TAB(LT%);"If you want a hint when you are stuck"
 5100 PRINT TAB(LT%);"type HINT."
 5110 COLOUR ColIntGreen%
 5120 PRINT TAB(LT%,27);"(Press Any Key To Enter The Horror)"
 5130 PROC_HideCursor
 5140 REPEAT
 5150   ANYKEY%=INKEY(5000)
 5160 UNTIL ANYKEY% <> -1
 5170 CLS
 5180 ENDPROC : REM END Instructions
 5190 :
 5200 DEF PROC_LoadChars : REM Load Chars
 5210 REM ASSIGN H to CHRS.
 5220 VDU 23,201,0,56,56,56,56,56,57,59
 5230 VDU 23,202,0,28,28,28,28,28,252,252
 5240 VDU 23,203,57,56,56,56,56,56,56,48
 5250 VDU 23,204,252,60,28,28,28,28,28,12
 5260 REM ASSIGN A to CHARS.
 5270 VDU 23,205,0,1,1,3,3,7,7,7
 5280 VDU 23,206,0,128,128,128,192,192,224,224
 5290 VDU 23,207,15,14,14,30,30,28,60,56
 5300 VDU 23,208,96,112,112,240,248,60,28,30
 5310 REM ASSIGN U to CHARS.
 5320 VDU 23,209,0,16,56,56,56,56,56,56
 5330 VDU 23,210,0,8,28,28,28,28,28,28
 5340 VDU 23,211,56,56,56,56,56,60,60,30
 5350 VDU 23,212,28,28,28,28,28,60,60,120
 5360 REM ASSIGN N to CHARS.
 5370 VDU 23,213,0,24,24,28,30,62,63,63
 5380 VDU 23,214,0,8,28,28,28,28,28,156
 5390 VDU 23,215,63,59,57,56,56,56,56,56
 5400 VDU 23,216,252,252,252,252,124,124,60,28
 5410 REM ASSIGN T to CHARS.
 5420 VDU 23,217,0,24,57,113,3,3,3,3
 5430 VDU 23,218,0,244,248,252,192,192,192,192
 5440 VDU 23,219,3,3,3,3,3,3,3,3
 5450 VDU 23,220,192,192,192,192,192,192,192,192
 5460 REM ASSIGN E to CHARS.
 5470 VDU 23,221,0,12,30,30,30,30,30,30
 5480 VDU 23,222,0,124,124,24,0,0,56,124
 5490 VDU 23,223,30,30,30,30,30,30,30,30
 5500 VDU 23,224,56,0,0,0,0,56,124,56
 5510 REM ASSIGN D to CHARS.
 5520 VDU 23,225,0,48,57,56,56,56,56,56
 5530 VDU 23,226,0,192,224,240,60,28,28,28
 5540 VDU 23,227,56,56,56,56,56,56,56,48
 5550 VDU 23,228,28,28,28,60,252,248,240,192
 5560 REM ASSIGN O to CHARS.
 5570 VDU 23,229,0,2,6,15,30,60,56,120
 5580 VDU 23,230,0,96,96,120,124,28,30,14
 5590 VDU 23,231,120,120,120,120,56,60,30,14
 5600 VDU 23,232,14,14,14,30,30,60,120,112
 5610 REM ASSIGN S to CHARS.
 5620 VDU 23,233,0,7,15,31,63,62,60,31
 5630 VDU 23,234,0,16,188,28,30,12,0,128
 5640 VDU 23,235,15,3,0,0,56,56,60,30
 5650 VDU 23,236,240,248,124,60,60,120,240,224
 5660 REM HUD CHARS.
 5670 :
 5680 ENDPROC : REM END Load Chars.
 5690 :
 5700 DEF PROC_Vars : REM Vars
 5710 REM colours.
 5720 ColBlack% = 0
 5730 ColRed% = 1
 5740 ColGreen% = 2
 5750 ColYellow% = 3
 5760 ColBlue% = 4
 5770 ColMagenta% = 5
 5780 ColCyan% = 6
 5790 ColWhite% = 7
 5800 ColIntRed% = 9
 5810 ColIntGreen% = 10
 5820 ColIntYellow% = 11
 5830 ColIntBlue% = 12
 5840 ColIntMagenta% = 13
 5850 ColIntCyan% = 14
 5860 ColIntWhite% = 15
 5870 TextCol
 5870 mode% = 8
 5880 RT% = 31 : LT% = 1 : T1X = 0 : T1Y = 0 : T2X = 0 : T2Y = 0 : REM SET right text margin.
 5890 SW% = 1279 : SH% = 1023 : VSPLITX% = 962 : HSPLITY% = 320 : REM screen width & height in graphical units.
 5900 :
 5910 :
 5920 ENDPROC : REM END VARS.
 5930 :
 5940 REM HANDLE ERROR (which includes the escape key)
 5950 VDU 23,1,1;0;0;0;
 5960 PROC_RestoreOriginals
 5970 REPORT
 5980 PRINT" at line ";ERL
 5990 :
 6000 DEF PROC_DrawHaunted(T1X,T1Y)  : REM DRAW haunted
 6010 REM DISPLAY H (2x2) CHARS.
 6020 COLOUR ColIntRed%
 6030 PRINT TAB(T1X,T1Y);CHR$(201);CHR$(202)
 6040 PRINT TAB(T1X,T1Y+1);CHR$(203);CHR$(204)
 6050 REM DISPLAY A (2x2) CHARS.
 6060 PRINT TAB(T1X+2,T1Y);CHR$(205);CHR$(206)
 6070 PRINT TAB(T1X+2,T1Y+1);CHR$(207);CHR$(208)
 6080 REM DISPLAY U (2x2) CHARS.:PRINT TAB(0,3)CHR$(243);
 6090 PRINT TAB(T1X+4,T1Y);CHR$(209);CHR$(210)
 6100 PRINT TAB(T1X+4,T1Y+1);CHR$(211);CHR$(212)
 6110 REM DISPLAY N (2x2) CHARS.
 6120 PRINT TAB(T1X+6,T1Y);CHR$(213);CHR$(214)
 6130 PRINT TAB(T1X+6,T1Y+1);CHR$(215);CHR$(216)
 6140 REM DISPLAY T (2x2) CHARS.
 6150 PRINT TAB(T1X+8,T1Y);CHR$(217);CHR$(218)
 6160 PRINT TAB(T1X+8,T1Y+1);CHR$(219);CHR$(220)
 6170 REM DISPLAY E (2x2) CHARS.
 6180 PRINT TAB(T1X+10,T1Y);CHR$(221);CHR$(222)
 6190 PRINT TAB(T1X+10,T1Y+1);CHR$(223);CHR$(224)
 6200 REM DISPLAY D (2x2) CHARS.
 6210 PRINT TAB(T1X+12,T1Y);CHR$(225);CHR$(226)
 6220 PRINT TAB(T1X+12,T1Y+1);CHR$(227);CHR$(228)
 6230 ENDPROC : REM END DRAW_HAUNTED
 6240 :
 6250 DEF PROC_DrawHouse(T2X,T2Y) : REM DRAW house
 6260 REM DISPLAY H (2x2) CHARS.
 6270 COLOUR ColIntRed%
 6280 PRINT TAB(T2X,T2Y);CHR$(201);CHR$(202)
 6290 PRINT TAB(T2X,T2Y+1);CHR$(203);CHR$(204)
 6300 REM DISPLAY O (2x2) CHARS.
 6310 PRINT TAB(T2X+2,T2Y);CHR$(229);CHR$(230)
 6320 PRINT TAB(T2X+2,T2Y+1);CHR$(231);CHR$(232)
 6330 REM DISPLAY U (2x2) CHARS.
 6340 PRINT TAB(T2X+4,T2Y);CHR$(209);CHR$(210)
 6350 PRINT TAB(T2X+4,T2Y+1);CHR$(211);CHR$(212)
 6360 REM DISPLAY S (2x2) CHARS.
 6370 PRINT TAB(T2X+6,T2Y);CHR$(233);CHR$(234)
 6380 PRINT TAB(T2X+6,T2Y+1);CHR$(235);CHR$(236)
 6390 REM DISPLAY E (2x2) CHARS.
 6400 PRINT TAB(T2X+8,T2Y);CHR$(221);CHR$(222)
 6410 PRINT TAB(T2X+8,T2Y+1);CHR$(223);CHR$(224)
 6420 ENDPROC : REM END DRAW_HOUSE
 6430 :
 6440 DEF PROC_DrawHud : REM DRAW HUD
 6450 VDU 18,0,ColIntRed% : VDU 26
 6460 MOVE 0,0 : DRAW 0,SH% : MOVE 1,0 : DRAW 1,SH% : MOVE 2,0 : DRAW 2,SH% : REM left border
 6470 MOVE 0,0 : DRAW SW%,0 : MOVE 0,1 : DRAW SW%,1 : MOVE 0,2 : DRAW SW%,2 : REM bottom border
 6480 MOVE SW%,0 : DRAW SW%,SH% : MOVE SW%-1,1 : DRAW SW%-1,SH% : MOVE SW%-2,2 : DRAW SW%-2,SH% : REM right border
 6490 MOVE 0,SH% : DRAW SW%,SH% : MOVE 0,SH%-1 : DRAW SW%,SH%-1 : MOVE 0,SH%-2 : DRAW SW%,SH%-2 : REM top border
 6500 MOVE VSPLITX%,0 : DRAW VSPLITX%,SH% : MOVE VSPLITX%-1,0 : DRAW VSPLITX%-1,SH% : MOVE VSPLITX%-2,0 : DRAW VSPLITX%-2,SH% : REM vertical split
 6510 MOVE 0,HSPLITY% : DRAW VSPLITX%,HSPLITY% : MOVE 0,HSPLITY%-1 : DRAW VSPLITX%,HSPLITY%-1 : MOVE 0,HSPLITY%-2 : DRAW VSPLITX%,HSPLITY%-2 : REM horizontal split
 6520 :
 6530 REM ENDPROC : REM END DRAW HUD
 6540 :
 6550 DEF PROC_DrawRoom
 6560 VDU 24,40;420;800;910;
 6570 ENDPROC
 6580 :
 6590 DEF PROC_LoadBitmaps : REM LOAD bitmaps.
 6600 REM PROC_LoadBitmap("0","0",0,16,16) : REM LOAD the white square dir 0
 6610 REM PROC_LoadBitmap("0","1",1,16,16) : REM LOAD THE black tile dir 0.
 6620 PRINT TAB(11,15);"Loading Scary Bits"
 6630 FOR R%=1 TO decks%
 6640   FOR L%=0 TO 9
 6650     p%=R%*10:p%=p%+L% : REM Populate empty slots
 6660     PROC_LoadBitmap(STR$(R%),STR$(L%),p%,16,16) : REM directory, filename, sprite number
 6670     PP$ = STR$(p% - 10)
 6680     DD$ = STR$(decks% * 10)
 6690     PRINT TAB(17,18);"" + PP$ + "/" + DD$
 6700   NEXT
 6710 NEXT
 6720 ENDPROC
 6730 :
 6740 DEF PROC_LoadBitmap(D$,F$,N%,W%,H%) : REM Load bitmap.
 6750 REM IF N%=9 THEN PRINT TAB(19,18);"  "
 6760 OSCLI("LOAD " + TilesPack$ + "/" + D$ + "/" + F$ + ".rgb" + " " + STR$(MB%+Graphics))
 6770 VDU 23,27,0,N% : REM select sprite n (equating to buffer ID numbered 64000+n).
 6780 VDU 23,27,1,W%;H%; : REM load colour DATA into current sprite.
 6790 FOR I%=0 TO (W%*H%*4)-1 STEP 4 : REM loop 16x16x4 each pixel r,g,b,a
 6800   r% = ?(Graphics+I%+0) : REM Red DATA.
 6810   g% = ?(Graphics+I%+1) : REM Green DATA.
 6820   b% = ?(Graphics+I%+2) : REM Blue DATA.
 6830   a% = ?(Graphics+I%+3) : REM Alpha (transparency)
 6840   VDU r%, g%, b%, a%
 6850 NEXT
 6860 ENDPROC
 6870 :
 6880 DEF PROC_ShowMap(XLOC%,YLOC%,XSLOC%)
 6890 REM outputs each map location and moves 16 pixels to next. End of each line resets location
 6900 REM LOCAL XLOC%=0:YLOC%=0
 6910 FOR j=0TOYSIZE%
 6920   FOR i=0TOXSIZE%
 6930     g%=TheMap%(i,j)
 6940     VDU 23,27,0,g% : REM select the specified bitmap
 6950     VDU 23,27,3,XLOC%;YLOC%; : REM displays the bitmap
 6960     XLOC%=XLOC%+16 :REM update the X location to move to the right
 6970     IF i=11 THEN YLOC%=YLOC%+16:XLOC%=XSLOC% :REM at end of row move to start next line and down
 6980   NEXT
 6990 NEXT
 7000 ENDPROC
 7010 :
 7020 DEF PROC_LoadMap(Map$)
 7030 fnum=OPENIN (MyMaps$ + "/" + Map$  + ".map")
 7040 IF fnum=0 THEN PRINTTAB(LT%,27);"Filename NOT loaded" : GOTO 7140
 7050 INPUT#fnum,XIMP% :REM Read X map size
 7060 INPUT#fnum,YIMP% :REM Read Y map size
 7070 INPUT#fnum,decks% :REM load the number of decks in use
 7080 INPUT#fnum,custom% :REM read number of custom tile slots
 7090 FOR j=0TOYIMP% :REM read map based on defined size
 7100   FOR i=0TOXIMP%
 7110     INPUT#fnum,TheMap%(i,j)  : REM save to map
 7120   NEXT
 7130 NEXT
 7140 CLOSE#fnum
 7150 ENDPROC
 7160 :
 7500 DEF PROC_EndGame
 7510 MODE8
 7520 COLOUR ColIntWhite%
 7530 COLOUR ColBlue%+128
 7540 CLS
 7550 PRINT"Agon Ready"
 7560 NEW
 7570 END
 7600 ENDPROC : REM END end game.
 7610 :
