; Extra functions for EhBASIC


; Variables for use in Extra functions.

V_XTRA_BASE   = $A10

V_XTRA_PlotMode  = V_XTRA_BASE
V_XTRA_Xcoord    = V_XTRA_PlotMode + 1
V_XTRA_Ycoord    = V_XTRA_Xcoord   + 1


; Function to set the cursor location.

XTRA_LOCATE_F

  JSR LAB_EVNM					; evaluate expression and check is numeric,
						; else do type mismatch
  JSR LAB_F2FX					; save integer part of FAC1 in temporary integer
  
  LDA #14					; Set our column
  JSR V_OUTP  
  LDA   Itempl
  jsr V_OUTP
  
  JSR   LAB_1C01				; scan for "," , else do syntax error then warm start
 
  JSR LAB_EVNM					; evaluate expression and check is numeric,
						; else do type mismatch
  JSR LAB_F2FX					; save integer part of FAC1 in temporary integer
  
  LDA #15					; Set our row
  JSR V_OUTP  
  LDA   Itempl
  jsr V_OUTP
  
  RTS


; Function to PLOT or UNPLOT a pixel
  
XTRA_PLOT_F

  LDA #5					; Start with plot mode
  STA V_XTRA_PlotMode
  
  JSR LAB_EVNM					; evaluate expression and check is numeric,
						; else do type mismatch
  JSR LAB_F2FX					; save integer part of FAC1 in temporary integer
  
  LDA Itempl					; Get our plot/unplot value

  BIT #1
  BNE XTRA_NOT_Plotting_B
  
  LDA #6					; Set for unplot mode.
  STA V_XTRA_PlotMode
 
XTRA_NOT_Plotting_B
  
  
  JSR   LAB_1C01				; scan for "," , else do syntax error then warm start
 
  JSR   LAB_EVNM				; evaluate expression and check is numeric,
						; else do type mismatch
  JSR   LAB_F2FX				; save integer part of FAC1 in temporary integer
  
  LDA Itempl					; Save our X coordinate
  STA V_XTRA_Xcoord
  
  JSR   LAB_1C01				; scan for "," , else do syntax error then warm start
 
  JSR   LAB_EVNM				; evaluate expression and check is numeric,
						; else do type mismatch
  JSR   LAB_F2FX				; save integer part of FAC1 in temporary integer
  
  LDA Itempl					; Save our Y coordinate
  STA V_XTRA_Ycoord

; Function to actually PLOT/UNPLOT.
XTRA_SystemPlot_F
  LDA V_XTRA_PlotMode				; Write our plot command
  JSR V_OUTP
    
  LDA V_XTRA_Xcoord				; Write our X co-ordinate
  jsr V_OUTP
  
  LDA V_XTRA_Ycoord				; Write our Y co-ordinate
  JSR V_OUTP
  
  RTS