; Duncan's ANSI Video card library
;
; This card is based on a 6522 VIA chip.


; Register addresses

ANSI_base	= $C000
ANSI_reg_b	= ANSI_base
ANSI_reg_a	= ANSI_base+1
ANSI_ddr_b	= ANSI_base+2
ANSI_ddr_a	= ANSI_base+3

; Control Bits

ANSI_AVAIL	= @01000000
ANSI_ACK	= @10000000


; Memory allocations

ANSI_area	= $5F0
ANSI_LastACK	= ANSI_area
ANSI_LastAVL	= ANSI_area+1


; Initialisation Routine

ANSI_INIT
  LDA #12
  STA ANSI_reg_b
  LDA #ANSI_AVAIL
  STA ANSI_ddr_a
  LDA #$FF
  STA ANSI_ddr_b
  LDA ANSI_reg_a
  AND ANSI_ACK
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

  PHP			; Save Register States
  PHA
  
  JSR ANSI_wait		; Wait until AVAIL and ACK agree
  
  STA ANSI_reg_b	; Write the char to output
  LDA ANSI_LastAVL	; Flip and re-write avail bit to tell
  EOR #ANSI_AVAIL	; the ANSI processor of new data
  STA ANSI_reg_a
  STA ANSI_LastAVL
  
  PLA
  PLP
  RTS
  
ANSI_wait
  PHA
  
ANSI_w_loop
  LDA ANSI_reg_a	; Check ACK against AVAIL
  AND #ANSI_ACK
  LSR
  CMP ANSI_LastAVL
  BNE ANSI_w_loop	; Until they match
  
  PLA
  RTS