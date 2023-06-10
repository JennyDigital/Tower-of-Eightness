; Blobplot by Jennifer Gunn
;

; Constants
;
; All Constand Numbers are denoted as follows:-
;	CU16 for Unsigned Int16
;	CI16 for Signed Int16
;	CU8 for Unsigned Int8
;	CI8 for Signed Int8
;	Cb for bit. (Used for flags, masking etc)
;
;
BLOB_ModeSet_Cb		= @00000001
BLOB_ModeClr_Cb		= @00000010
BLOB_ModeInv_Cb		= @00000100
BLOB_ModeXRev_Cb	= @00001000
BLOB_ModeYRev_Cb	= @00010000
BLOB_StMaskBit_Cb	= @10000000

BLOB_ModePlot_CU8	= 5
BLOB_ModeUnplot_CU8	= 6


; Memory Bounds
;
BLOB_MemStart	= $420
BLOB_Mem_Limit	= $430


; Variable Memory-allocations.
;
; All variables are denoted as follows.
;	U8 for Unsigned Int8
;	I8 for Signed Int8
;	U16 for Unsigned Int16
;	I16 for Signed Int16
;
;
BLOB_Mode_U8		= BLOB_MemStart
BLOB_X_U8		= BLOB_Mode_U8 		+ 1
BLOB_CurrBlob_X_U8	= BLOB_X_U8		+ 1
BLOB_Y_U8		= BLOB_CurrBlob_X_U8	+ 1
BLOB_CurrBlob_Y_U8	= BLOB_Y_U8		+ 1
BLOB_BaseAddr_U16	= BLOB_CurrBlob_Y_U8	+ 1
BLOB_CurrBlob_U8	= BLOB_BaseAddr_U16	+ 2
BLOB_XoffsetV_I8	= BLOB_CurrBlob_U8	+ 1
BLOB_YoffsetV_I8	= BLOB_XoffsetV_I8	+ 1
BLOB_MaskBit_U8		= BLOB_YoffsetV_I8	+ 1

BLOB_MemEnd		= BLOB_MaskBit_U8


; ZP Variable, (TOE_MemptrLo=$E7)
;
BLOB_OffsetAddr_U16	= TOE_MemptrLo			; Re-using ToE MemprtLow/High

  .IF[ BLOB_MemEnd>BLOB_Mem_Limit ]
    .ERROR "Memory bounds exceeded in Blobplot.asm"
  .ENDIF
  

; Plot BLOB_CurrBlob_U8 at BLOB_X_U8 by BLOB_Y_U8
;
; Option bits determine mirroring, inverse, clearing and setting rules.
;
; Rules of the game, set up the variables before calling.

BLOB_Plot				; Entry point for plotting.

  LDA #1				; Set XY dir initial values.
  STA BLOB_XoffsetV_I8
  STA BLOB_YoffsetV_I8
   
  LDA BLOB_X_U8				; Transfer Blob co-ords to working co-ords
  STA BLOB_CurrBlob_X_U8
  LDA BLOB_Y_U8
  STA BLOB_CurrBlob_Y_U8
  

  LDA #0				; Set Offset to zero.
  STA BLOB_OffsetAddr_U16
  STA BLOB_OffsetAddr_U16 + 1


; Calculate our initial blob address
;  
  LDY BLOB_CurrBlob_U8			; Setup our loop for mul8.
					; ...and yes, there are other methods, so sue me. (Not literally)
BLOB_Mul8_L

  CPY #0				; Loop whilst blobcount (Y) > 0
  BEQ BLOB_AddOffset_B
  
  LDA #8				; Perform Mul8 of Y 
  CLC
  ADC BLOB_OffsetAddr_U16
  STA BLOB_OffsetAddr_U16
  LDA #0
  ADC BLOB_OffsetAddr_U16 + 1
  STA BLOB_OffsetAddr_U16 + 1
  DEY
  BRA BLOB_Mul8_L

BLOB_AddOffset_B
  
  LDA BLOB_BaseAddr_U16			; Add the low byte
  CLC
  ADC BLOB_OffsetAddr_U16
  STA BLOB_OffsetAddr_U16
  
  LDA BLOB_BaseAddr_U16 + 1		; And now the high byte. Yummy!
  ADC BLOB_OffsetAddr_U16 + 1
  STA BLOB_OffsetAddr_U16 + 1
 
  
; Set our offset values according to the relavent bits.
;  
  LDA BLOB_Mode_U8			; Adjust offsetting values according to options
  BIT #BLOB_ModeXRev_Cb
  BEQ BLOB_X_NoMirror
  
  LDA #$FF				; Set Y offset to -1
  STA BLOB_XoffsetV_I8
  
  
BLOB_X_NoMirror

  LDA BLOB_Mode_U8			; Adjust offsetting values according to options
  BIT #BLOB_ModeYRev_Cb
  BEQ BLOB_Y_NoMirror

  LDA #$FF				; Set Y offset to -1
  STA BLOB_YoffsetV_I8
  
BLOB_Y_NoMirror
  
; Now PLOT our BLOB!!
;  
  LDY #0				; Set up our Y byte index.

BLOB_NextY_B

  LDA #BLOB_StMaskBit_Cb		; Reset the mask bit.
  STA BLOB_MaskBit_U8
  
  LDA (BLOB_OffsetAddr_U16),Y		; Get the byte we are working on.

  TAX					; Save it in X for now.
  
  LDA BLOB_Mode_U8			; Check if we chose to invert it.
  BIT #BLOB_ModeInv_Cb
  BEQ BLOB_NextBit_B 			; ...or skip inverting.
    
  TXA					; Invert our byte.
  EOR #$FF
  TAX	

BLOB_NextBit_B				; X Bit loop re-enters here.

  TXA					; Get the byte of pixels to work with.
  
  BIT BLOB_MaskBit_U8			; Plot/Unplot branch select.
  BNE BLOB_Plot_B

; Unplot path
;
  LDA BLOB_Mode_U8
  BIT #BLOB_ModeClr_Cb			; Blob Unplot switch.
  BEQ BLOB_NoAction_B

  LDA #BLOB_ModeUnplot_CU8		; Set our un-plot command and go do it.
  BRA BLOB_DoANSI_B

; Plot path
;  
BLOB_Plot_B
  LDA BLOB_Mode_U8			; Blob Plot switch. 
  BIT #BLOB_ModeSet_Cb
  BEQ BLOB_NoAction_B
  
  LDA #BLOB_ModePlot_CU8		; Set our plot command.

BLOB_DoANSI_B

  JSR ANSI_write			; Write our plot/unplot command.
    
  LDA BLOB_CurrBlob_X_U8		; Write our X co-ordinate.
  JSR ANSI_write
  
  LDA BLOB_CurrBlob_Y_U8		; Write our Y co-ordinate.
  JSR ANSI_write  
  
  
BLOB_NoAction_B

  LDA BLOB_MaskBit_U8			; Update our bit position.
  LSR
  STA BLOB_MaskBit_U8
  
  LDA BLOB_CurrBlob_X_U8		; Update X co-ordnintate.
  CLC
  ADC BLOB_XoffsetV_I8
  STA BLOB_CurrBlob_X_U8

  LDA BLOB_MaskBit_U8			; Keep going until we loose the bit.
  CMP #0
  BNE BLOB_NextBit_B
  
  LDA BLOB_X_U8				; Reset X co-ordinate
  STA BLOB_CurrBlob_X_U8
  
  LDA BLOB_CurrBlob_Y_U8		; Update Y co-ordnintate.
  CLC
  ADC BLOB_YoffsetV_I8
  STA BLOB_CurrBlob_Y_U8
  
  INY					; Move onto the next byte until we've done 8
  CPY #8
  BNE BLOB_NextY_B

  RTS					; END
