; Jennifers ANSI Video card library
;
; This card is based on a 6522 VIA chip.


; Register addresses

ANSI_base	= $C000
ANSI_reg_b	= ANSI_base
ANSI_reg_a	= ANSI_base+1
ANSI_ddr_b	= ANSI_base+2
ANSI_ddr_a	= ANSI_base+3

; Control Bits

ANSI_AVAIL_bit	= @01000000
ANSI_ACK_bit	= @10000000


; Memory allocations

ANSI_area	= $5F0
ANSI_LastACK	= ANSI_area
ANSI_LastAVL	= ANSI_LastACK + 1
ANSI_end	= ANSI_LastAVL


; Initialisation Routine

ANSI_INIT
  LDA #12
  STA ANSI_reg_b
  LDA #ANSI_AVAIL_bit
  STA ANSI_ddr_a
  LDA #$FF
  STA ANSI_ddr_b
  LDA ANSI_reg_a
  AND ANSI_ACK_bit
  STA ANSI_LastACK
  ASL
  STA ANSI_LastAVL
  ORA ANSI_LastACK
  STA ANSI_reg_a
  RTS
  

; ANSI Write.
; *================================*
; *                                *
; *  ENTRY: A=char                 *
; *  EXIT: As found                *
; *                                *
; **********************************

ANSI_write

; TEST CODE
;  RTS
; End TEST CODE
  
  PHP			; Save Register States				3
  PHX			;						3
  PHA			;						3
     
  TAX 			; Save our char in				2 = 11
  
ANSI_wait_L 
 
  LDA ANSI_reg_a	; Check ACK against AVAIL			4
  AND #ANSI_ACK_bit	;						4
  LSR			;						3
  CMP ANSI_LastAVL	;						4
  BNE ANSI_wait_L	; Until they match				2/3 whem taken
  
  STX ANSI_reg_b	; Write the char to output			4 = 21 +..loops
  
  LDA ANSI_LastAVL	; Flip and re-write avail bit to tell		4
  EOR #ANSI_AVAIL_bit	; the ANSI processor of new data		2
  STA ANSI_reg_a	;						4
  STA ANSI_LastAVL	;						4
  
  PLA			;						3
  PLX			;						3
  PLP			;						3
  
  RTS			;						6 = 29
  
  			;						11
  			;						21
  			;						29 = 61 - 12 = 49.
  			;						The jury is out if upsetting X and P matter.
 

