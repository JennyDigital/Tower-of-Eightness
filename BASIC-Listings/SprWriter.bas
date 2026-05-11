10 REM Sprite File Writer
20 :
30 DOKE $85,$9000 : CLEAR : REM Reserve space
40 :
50 p=$9000 : REM Starting address
60 pc = p :  REM Current address
70 fl = 0 :  REM File length to save
80 :
90 REM Read in section
100 :
110 DO
120 READ v: IF v<0 THEN GOTO 150
130 POKE pc,v
140 INC pc,fl
150 LOOP WHILE v>0
160 INPUT "Filename:";s$
170 SAVE s$ p,fl
180 IF s$="" THEN PRINT "Can't save null name" : GOTO 160
190 END
