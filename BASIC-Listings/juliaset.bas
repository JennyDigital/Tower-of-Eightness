1 zoom = 35
5 BITCLR $5E0,0: PRINT CHR$(12);
10 creal=-0.8
20 cimag=0.156
30 FOR v=-48 TO 48
40 FOR h=-78 TO 78
50 x=h/(zoom*2)
60 y=v/zoom
70 FOR i=1 TO 50
80 zreal=x*x-y*y+creal
90 zimag=x*y*2+cimag
100 IF zreal*zreal>1000 THEN GOTO 150
110 x=zreal
120 y=zimag
130 NEXT i
140 px=h+79: py=v+49: GOSUB 4000
145 IF px<0 OR py<0 THEN 165
150 NEXT h
160 NEXT v
165 BITSET $5E0,0
170 END
3997 :
3998 REM Plot
3999 :
4000 PRINT CHR$(5);CHR$(px);CHR$(py);
4010 RETURN

