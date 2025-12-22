; Line drawing routines.
;
LINE_Start		= $810
LINE_Limit		= $830

LINE_XO_u16		= LINE_Start		; X offset
LINE_YO_u16		= LINE_XO_u16  + 2	; Y offset
LINE_XD_u16		= LINE_YO_u16  + 2	; X difference
LINE_YD_u16		= LINE_XD_u16  + 2	; Y difference
LINE_X1_u16		= LINE_YD_u16  + 2	; X1 co-ordinate
LINE_Y1_u16		= LINE_X1_u16  + 2	; Y1 co-ordinate
LINE_X2_u16		= LINE_Y1_u16  + 2	; X2 co-ordinate
LINE_X_u16		= LINE_X2_u16  + 2	; Current X co-ordinate.
LINE_Y_u16		= LINE_X_u16   + 2	; Current Y co-ordinate.
LINE_Y2_u16		= LINE_Y_u16   + 2	; Y2 co-ordinate
LINE_Err_u16		= LINE_Y2_u16  + 2	; Error term for stepping.
LINE_YD2_u16		= LINE_Err_u16 + 2	; Error term adjustment value (2 * LINE_YD_u16)

LINE_End		= LINE_YD2_u16 + 1

  .IF [ LINE_End>LINE_Limit ]
    .ERROR "Memory overrun in LINE.asm"
  .ENDIF
  

; Takes two coordinates (X1,Y1 - X2,Y2) and plots the slope.

LINE_DrawLine

  JSR F_LINE_CalcOffsets			; Get offsets
  JSR F_LINE_CopyXD_ToErr			; Put a copy of XD into LINE_Err_u16
  JSR F_LINE_CopyX1Y1toXY			; Copy X1 to X and Y1 to Y.
  
  LDA LINE_X_u16				; Plot a pixel to X,Y.  Yes, this function takes an 8-bit unsigned
  STA V_XTRA_Xcoord				; integer, but bigger things are coming, I promise.
  LDA LINE_Y_u16
  STA V_XTRA_Ycoord
  JSR XTRA_SystemPlot_F
   
  RTS


F_LINE_CalcOffsets

  LDA LINE_X2_u16				; Calculate offsets.
  SEC
  SBC LINE_X1_u16
  STA LINE_XO_u16
  
  LDA LINE_X2_u16	+ 1
  SBC LINE_X1_u16	+ 1
  STA LINE_XO_u16	+ 1
  
  LDA LINE_Y2_u16
  SEC
  SBC LINE_Y1_u16
  STA LINE_YO_u16
  
  LDA LINE_Y2_u16	+ 1
  SBC LINE_Y1_u16	+ 1
  STA LINE_YO_u16	+ 1
  
  RTS
  

; Copy X1 to X and Y1 to Y
  
F_LINE_CopyX1Y1toXY

  LDA LINE_X1_u16
  STA LINE_X_u16
  LDA LINE_X1_u16	+ 1
  STA LINE_X_u16	+ 1
  
  LDA LINE_Y1_u16
  STA LINE_Y_u16
  LDA LINE_Y1_u16	+ 1
  STA LINE_Y_u16	+ 1
  
  RTS
  
  
F_LINE_CopyXD_ToErr

  LDA LINE_XD_u16
  STA LINE_Err_u16
  LDA LINE_XD_u16	+ 1
  STA LINE_Err_u16	+ 1
  
  RTS