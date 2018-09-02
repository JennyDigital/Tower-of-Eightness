10 REM Prime calculator
20 :
25 PRINT CHR$(12);CHR$($18);CHR$(3); : WIDTH 80,10
30 INPUT "Starting value:";start
40 IF start<2 THEN GOTO 30
50 INPUT "Maximum limit to check:"; limit
60 IF limit<start THEN GOTO 50
70 INPUT "Hardcopy required";yn$: IF UCASE$(yn$)="Y" THEN BITSET $5E0,2
80 PRINT "Prime Numbers Between ";start;" and ";limit;"."+CHR$(13)+CHR$(10)
90 FOR cn=start TO limit
100 hn = 0
110 po = 1
120 FOR dn = ( cn - 1 ) TO 2 STEP -1
130 IF cn/dn = INT( cn/dn ) THEN GOSUB 500
140 NEXT dn
150 IF po = 1 THEN PRINT cn,
160 NEXT cn
170 PRINT:PRINT "Finished!"
180 BITCLR $5E0,2
190 END
497 :
498 REM not prime handler
499 :
500 dn = 1
510 po = 0
520 RETURN

