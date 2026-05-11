5 PRINT "Enter base address":INPUT os
10 FOR c=32 TO 128
20 CLS : PRINT c;" ";CHR$(c);
30 FOR l=0 TO 7
40 pm=128
50 byte=PEEK(os+((c-32)*8)+l)
60 FOR b=0 TO 7
70 IF (byte AND pm)<>0 THEN PLOT 1,b,l+8
80 pm=pm>>1
90 NEXT b
100 NEXT l
110 DO
120 GET K$
130 LOOP UNTIL K$<>""
140 NEXT c
