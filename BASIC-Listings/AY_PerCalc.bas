5 CLS
10 PRINT "AY Period calculator"
20 PRINT
30 PRINT "Enter clock frequency in MHz:";:INPUT clk
35 clk=clk*1E6
40 dn=16
45 CLS
50 INPUT "Desired frequency";f
60 :
70 REM calculating bit
80 :
90 pck=clk/dn : REM calculate period clock
100 pf=1*pck
110 PRINT
120 PRINT "Highest achievable frequency is";pf;"Hz"
130 PRINT
140 :
150 REM calculate period value
160 :
170 pv=pf/f
175 PRINT "Your specified clock is";clk/1E6;"MHz"
180 PRINT "Your period value";pv
185 PRINT "Your rounded period value";INT(pv+0.5)
190 PRINT:PRINT "Press any key to repeat"
200 GET K$
210 IF K$="" THEN 200
220 GOTO 45
