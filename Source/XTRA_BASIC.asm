; Extra functions for TowerBASIC, a derivative of EhBASIC.
;

; Plot configuration bits
;

XTRA_CFG_silent_b	= @00000001
XTRA_CFG_capped_b	= @00000010
XTRA_CFG_NoChecks_b	= @00000100

; Variables for use in Extra functions.

XTRA_Start		= $A10
XTRA_Limit		= $A1F

V_XTRA_PlotMode		= XTRA_Start
V_XTRA_Xcoord		= V_XTRA_PlotMode    + 1
V_XTRA_Ycoord		= V_XTRA_Xcoord      + 1
V_XTRA_PlotPattern	= V_XTRA_Ycoord      + 1	; Not yet used. Future feature provision.
V_XTRA_Config		= V_XTRA_PlotPattern + 1

; Variables for the LINE command

V_LINE_x1		= V_XTRA_Config      + 1
V_LINE_y1		= V_LINE_x1          + 1
V_LINE_x2		= V_LINE_y1          + 1
V_LINE_y2		= V_LINE_x2          + 1
V_LINE_dx		= V_LINE_y2          + 1
V_LINE_dy		= V_LINE_dx          + 1
V_LINE_sx		= V_LINE_dy          + 1
V_LINE_sy		= V_LINE_sx          + 1
V_LINE_errL		= V_LINE_sy          + 1
V_LINE_errH		= V_LINE_errL        + 1
V_LINE_PlotMode		= V_LINE_errH        + 1

XTRA_End		= V_LINE_PlotMode


  .IF [ XTRA_End>XTRA_Limit ]
    .ERROR "Memory overrun in ToE_Mon.asm"
  .ENDIF


; Options for default plot mode are as follows:-
;  
;  XTRA_CFG_silent_b
;  XTRA_CFG_capped_b
;  XTRA_CFG_NoChecks_b
;
; Set as required.
;
XTRA_DefaultPlot_C = XTRA_CFG_silent_b


XTRA_NextParam
  JSR LAB_1C01
XTRA_EVNM_F2FX
  JSR LAB_EVNM
  JMP LAB_F2FX


; Function to set the cursor location.

XTRA_LOCATE_F

  JSR XTRA_EVNM_F2FX
  
  LDA #14						; Set our column
  JSR V_OUTP  
  LDA Itempl
  jsr V_OUTP
  
  JSR XTRA_NextParam
  
  LDA #15						; Set our row
  JSR V_OUTP  
  LDA Itempl
  jsr V_OUTP
  
  RTS


; Function to PLOT or UNPLOT a pixel
  
XTRA_PLOT_F

  LDA #5						; Start with plot mode
  STA V_XTRA_PlotMode
  
  JSR XTRA_EVNM_F2FX
  
  LDA Itempl						; Get our plot/unplot value

  CMP #2						; Handle special bit pattern case
  BNE XTRA_NOT_Pattern_B
  
  LDA V_XTRA_PlotPattern
  CMP #$80						; Push bit 7 into the Carry flag
  ROL							; Rotate left: bits shift, Carry goes to b0
  STA V_XTRA_PlotPattern
  BIT #1
  BEQ XTRA_SetUnplotting				; Unplot if clear
  BRA XTRA_StartPlot_B					; Otherwise plot
  
XTRA_NOT_Pattern_B
  LDA Itempl
  BIT #1						; Use bit to decide if we are plotting or not on this pass.
  BEQ XTRA_SetUnplotting				; Unplot if 0, otherwise plot
  
  LDA #5						; Plotting case
  BRA XTRA_StartPlot_B
  
XTRA_SetUnplotting
  LDA #6						; Unplotting case
  STA V_XTRA_PlotMode
 
XTRA_StartPlot_B
  JSR XTRA_NextParam
  
  LDA Itempl						; Save our X coordinate
  STA V_XTRA_Xcoord
  
  JSR XTRA_NextParam
  
  LDA Itempl						; Save our Y coordinate
  STA V_XTRA_Ycoord


; Function to actually PLOT/UNPLOT.
;
XTRA_SystemPlot_F

  LDA V_XTRA_Config					; Skip all bounds checks. This is a speed thing.
  BIT #XTRA_CFG_NoChecks_b
  BNE XTRA_PLOT_NoChecks_B
  
  BIT #XTRA_CFG_capped_b				; Either cap PLOTs within bounds or not.
  BEQ XTRA_Plot_NoCap_B

  LDA V_XTRA_Xcoord					; Bounds check the X coordinate.
  CLC
  ADC #[255-159]
  BCC XTRA_PLOT_Xgood_B

  LDA #159						; ...adjusting as necessary.
  STA V_XTRA_Xcoord

XTRA_PLOT_Xgood_B
  
  LDA V_XTRA_Ycoord  					; Bounds check the Y coordinate.
  CLC
  ADC #[255-99]
  BCC XTRA_PLOT_Ygood_B

  LDA #99						; ...adjusting as necessary.
  STA V_XTRA_Ycoord

XTRA_PLOT_Ygood_B

XTRA_Plot_NoCap_B

  LDA V_XTRA_Xcoord
  
  CLC							; Bounds check the X coordinate.
  ADC #[255-159]
  BCS XTRA_PLOT_OutOfBounds
  
  LDA V_XTRA_Ycoord
  							; Bounds check the Y coordinate.
  ADC #[255-99]
  BCS XTRA_PLOT_OutOfBounds
  
XTRA_PLOT_NoChecks_B
  
  LDA V_XTRA_PlotMode					; Write our plot command
  JSR V_OUTP
    
  LDA V_XTRA_Xcoord					; Write our X co-ordinate
  JSR V_OUTP
  
  LDA V_XTRA_Ycoord					; Write our Y co-ordinate
  JSR V_OUTP

XTRA_EndPlot  
  RTS

XTRA_PLOT_OutOfBounds

  LDA V_XTRA_Config					; Handle the silent case of out of bounds when
  BIT #XTRA_CFG_silent_b				; capping and unchecked aren't set.
  BNE XTRA_EndPlot

  JMP LAB_FCER
  

; Function to draw a line from (x1,y1) to (x2,y2)

XTRA_LINE_F

  LDA #XTRA_DefaultPlot_C
  STA V_XTRA_Config
  LDA #1
  STA V_LINE_PlotMode

  JSR XTRA_EVNM_F2FX
  LDA Itempl
  STA V_LINE_x1

  JSR XTRA_NextParam
  LDA Itempl
  STA V_LINE_y1

  JSR XTRA_NextParam
  LDA Itempl
  STA V_LINE_x2

  JSR XTRA_NextParam
  LDA Itempl
  STA V_LINE_y2

  LDY #0
  LDA (Bpntrl),Y
  CMP #$2C
  BNE XTRA_LINE_NoMode

  JSR LAB_IGBY
  JSR XTRA_EVNM_F2FX
  LDA Itempl
  STA V_LINE_PlotMode
  BRA XTRA_LINE_ModeSet

XTRA_LINE_NoMode
  LDA #1
  STA V_LINE_PlotMode

XTRA_LINE_ModeSet
  LDA V_LINE_PlotMode
  CMP #2
  BEQ XTRA_LINE_AfterMode
  CMP #1
  BNE XTRA_LINE_SetUnplot
  LDA #5
  BRA XTRA_LINE_SetPlotMode
XTRA_LINE_SetUnplot
  LDA #6
XTRA_LINE_SetPlotMode
  STA V_XTRA_PlotMode
  BRA XTRA_LINE_AfterMode

XTRA_LINE_AfterMode

  LDA V_LINE_x2
  SEC
  SBC V_LINE_x1
  BCS XTRA_LINE_dx_pos
  EOR #$FF
  ADC #1
  LDX #$FF
  .byte $2C
XTRA_LINE_dx_pos
  LDX #1
  STA V_LINE_dx
  STX V_LINE_sx

  LDA V_LINE_y2
  SEC
  SBC V_LINE_y1
  BCS XTRA_LINE_dy_pos
  EOR #$FF
  ADC #1
  LDX #$FF
  .byte $2C
XTRA_LINE_dy_pos
  LDX #1
  STA V_LINE_dy
  STX V_LINE_sy

  LDA V_LINE_dx
  CMP V_LINE_dy
  BCS XTRA_LINE_not_steep

  LDA V_LINE_dy
  LSR
  STA V_LINE_errL
  LDA #0
  STA V_LINE_errH

XTRA_LINE_steep_loop
  LDA V_LINE_x1
  STA V_XTRA_Xcoord
  LDA V_LINE_y1
  STA V_XTRA_Ycoord
  JSR XTRA_LINE_PlotPixel_F

  LDA V_LINE_y1
  CMP V_LINE_y2
  BNE XTRA_LINE_steep_cont
  JMP XTRA_LINE_done
XTRA_LINE_steep_cont

  CLC
  LDA V_LINE_y1
  ADC V_LINE_sy
  STA V_LINE_y1

  SEC
  LDA V_LINE_errL
  SBC V_LINE_dx
  STA V_LINE_errL
  LDA V_LINE_errH
  SBC #0
  STA V_LINE_errH
  BPL XTRA_LINE_steep_loop

  CLC
  LDA V_LINE_x1
  ADC V_LINE_sx
  STA V_LINE_x1

  CLC
  LDA V_LINE_errL
  ADC V_LINE_dy
  STA V_LINE_errL
  LDA V_LINE_errH
  ADC #0
  STA V_LINE_errH

  JMP XTRA_LINE_steep_loop

XTRA_LINE_not_steep
  LDA V_LINE_dx
  LSR
  STA V_LINE_errL
  LDA #0
  STA V_LINE_errH

XTRA_LINE_flat_loop
  LDA V_LINE_x1
  STA V_XTRA_Xcoord
  LDA V_LINE_y1
  STA V_XTRA_Ycoord
  JSR XTRA_LINE_PlotPixel_F

  LDA V_LINE_x1
  CMP V_LINE_x2
  BEQ XTRA_LINE_done

  CLC
  LDA V_LINE_x1
  ADC V_LINE_sx
  STA V_LINE_x1

  SEC
  LDA V_LINE_errL
  SBC V_LINE_dy
  STA V_LINE_errL
  LDA V_LINE_errH
  SBC #0
  STA V_LINE_errH
  BPL XTRA_LINE_flat_loop

  CLC
  LDA V_LINE_y1
  ADC V_LINE_sy
  STA V_LINE_y1

  CLC
  LDA V_LINE_errL
  ADC V_LINE_dx
  STA V_LINE_errL
  LDA V_LINE_errH
  ADC #0
  STA V_LINE_errH

  JMP XTRA_LINE_flat_loop

XTRA_LINE_done
  RTS


; Plot a pixel during LINE command, handling mode 2 (bit pattern)
;
XTRA_LINE_PlotPixel_F
  LDA V_LINE_PlotMode
  CMP #2
  BEQ XTRA_LINE_PatternPlot
  JMP XTRA_SystemPlot_F

XTRA_LINE_PatternPlot
  LDA V_XTRA_PlotPattern
  CMP #$80
  ROL
  STA V_XTRA_PlotPattern
  BIT #1
  BEQ XTRA_LINE_PatUnplot
  LDA #5
  BRA XTRA_LINE_PatStore

XTRA_LINE_PatUnplot
  LDA #6

XTRA_LINE_PatStore
  STA V_XTRA_PlotMode
  JMP XTRA_SystemPlot_F


; BASIC Commands for SPI.

I2C_Start_BAS
  JMP I2C_Start

I2C_Stop_BAS
  JMP I2C_Stop
  
I2C_Out_BAS						; This is a *function* as it returns ACK/NAK

  JSR   LAB_F2FX	                                ; save integer part of FAC1 in temporary integer
  LDX Itempl
  
  STX I2C_Byte						; Place it in the I2C Engine for transmission
  JSR I2C_Out						; Send it
  	
  LDA I2C_Status					; Get our relevant status bits
  AND #I2C_STA_NAK | I2C_STA_Timeout
  

  TAY							; Copy status byte to Y
  JMP LAB_1FD0	                        	        ; convert Y to byte in FAC1 and return


I2C_In_BAS						; This is a *function* as it returns ACK/NAK

  JSR   LAB_F2FX                     		        ; save integer part of FAC1 in temporary integer
  
  LDA I2C_Status					; Transfer our ACK/NAK to the status register.
  AND #~I2C_STA_NAK
  STA I2C_Status
  LDA Itempl
  AND #I2C_STA_NAK
  ORA I2C_Status
  STA I2C_Status
  
  JSR I2C_In						; Get our byte
  
  LDA I2C_Byte
  

  TAY							; Copy status byte to Y
  JMP   LAB_1FD0                                	; convert Y to byte in FAC1 and return


; PRINT # channel handler
; Syntax: PRINT #n,<expression>
; Temporarily sets os_outsel to the value of n, then restores it
; after printing completes (successful or otherwise).

XTRA_PRINT_N_F
  JSR   LAB_IGBY          ; consume #, get next byte
  JSR   LAB_EVEX          ; evaluate n
  JSR   LAB_F2FX          ; convert to integer in Itempl

  LDA   os_outsel
  PHA                     ; save old os_outsel on stack
  LDA   Itempl
  STA   os_outsel         ; set new os_outsel

  JSR   LAB_GBYT          ; get byte after n (don't advance)
  CMP   #','              ; must be comma
  BNE   XTRA_PRINT_N_ERR

  ; Stack: [os_outsel, orig_ret_high, orig_ret_low]
  ; Push restore routine address on top so PRINT's RTS returns there.
  ; RTS adds 1 to popped address, so push actual address (not addr-1)
  ; and pad with a leading NOP to absorb the +1.
  LDA   #>XTRA_PRINT_N_RET
  PHA
  LDA   #<XTRA_PRINT_N_RET
  PHA

  ; Stack: [restore_low, restore_high, os_outsel, orig_ret_high, orig_ret_low]

  JSR   LAB_IGBY          ; consume comma, get next byte
  JMP   LAB_1831          ; continue normal PRINT processing

XTRA_PRINT_N_ERR
  PLA                     ; pop saved os_outsel
  STA   os_outsel         ; restore it
  JMP   LAB_1910          ; syntax error

XTRA_PRINT_N_RET
  NOP                     ; absorb the +1 from RTS
  PLA                     ; pop saved os_outsel
  STA   os_outsel         ; restore it
  RTS                     ; return to original caller