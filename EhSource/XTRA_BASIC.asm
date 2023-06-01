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


; BASIC CommandS for SPI.

I2C_Start_BAS
  JMP I2C_Start

I2C_Stop_BAS
  JMP I2C_Stop
  
I2C_Out_BAS					; This is a *function* as it returns ACK/NAK

  JSR   LAB_F2FX                                ; save integer part of FAC1 in temporary integer
  LDX Itempl
  
  STX I2C_Byte					; Place it in the I2C Engine for transmission
  JSR I2C_Out					; Send it
  
  LDA I2C_Status				; Get our relevant status bits
  AND #I2C_STA_NAK | I2C_STA_Timeout
  

  TAY						; Copy status byte to Y
  JMP   LAB_1FD0                                ; convert Y to byte in FAC1 and return


I2C_In_BAS					; This is a *function* as it returns ACK/NAK

  JSR   LAB_F2FX                                ; save integer part of FAC1 in temporary integer
  
  LDA I2C_Status				; Transfer our ACK/NAK to the status register.
  AND #~I2C_STA_NAK
  STA I2C_Status
  LDA Itempl
  AND #I2C_STA_NAK
  ORA I2C_Status
  STA I2C_Status
  
  JSR I2C_In					; Get our byte
  
  LDA I2C_Byte
  

  TAY						; Copy status byte to Y
  JMP   LAB_1FD0                                ; convert Y to byte in FAC1 and return

  
  