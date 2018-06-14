; Duncan's TPB Card driver
;
; This card is based on a 6522 VIA chip.


; Register addresses

TPB_base        = $C020
TPB_reg_b       = TPB_base
TPB_reg_a       = TPB_base+1
TPB_ddr_b	    = TPB_base+2
TPB_ddr_a       = TPB_base+3
TPB_pcr         = TPB_base+$C
TPB_ifr         = TPB_base+$D


; LPT Control Bits

TPB_LPT_stb_b   = @00000010
TPB_LPT_ack_b   = @00000001
TPB_ACK_CA1_b   = @00000010
TPB_CA1_pe_b    = @00000001


; TPB Bus Control Bits

TPB_BUS_clkout  = @00010000
TPB_BUS_clkin   = @01000000
TPB_BUS_datout  = @00100000
TPB_BUS_datin   = @10000000
TPB_BUS_reset   = @00001000
TPB_BUS_atn     = @00000100


; Memory allocations

TPB_worksp      = $5F2            ; Start of TPB card memory allocation
TPB_curr_dev    = TPB_worksp      ; Currently selected TPB devce ID
TPB_dev_type    = TPB_worksp+1    ; Device class of selected device
TPB_last_rd     = TPB_worksp+2    ; last byte read from TPB device
TPB_status      = TPB_worksp+3    ; Status word from TPB engine (subject to change)
TPB_BUS_tmr     = TPB_worksp+4    ; Bus countdown timer.  This ensures fewer hangs.
TPB_BUS_lim     = TPB_worksp+5    ; Bus countdown timer limit. (Reload value).



; Initialisation Routine

TPB_PbInitial   = TPB_LPT_stb_b | TPB_BUS_reset
TPB_PbOutputs   = TPB_LPT_stb_b | TPB_BUS_reset | TPB_BUS_clkout | TPB_BUS_datout


TPB_INIT
  LDA #0                          ; Set our registers to defaults
  STA TPB_reg_a
  LDA #TPB_PbInitial
  STA TPB_reg_b
  
  LDA #$FF
  STA TPB_ddr_a                   ; Setup port a as outputs to our LPT
  LDA #TPB_PbOutputs
  STA TPB_ddr_b                   ; Setup port B for both LPT and TPB initial state.
  LDA #TPB_CA1_pe_b               ; Configure for positive edge interrupt trigger.
  STA TPB_pcr                     ; on CA1
  RTS
  

; TPB LPT Write.
; *================================*
; *                                *
; *  ENTRY: A=char                 *
; *  EXIT: As found                *
; *                                *
; **********************************

TPB_LPT_write

  PHP                             ; Save Register States
  PHA
  
  JSR STB_ack_wait                ; Wait until Ack=1
  
  JSR TPB_delay
  
  STA TPB_reg_a                   ; Write the char to output
  
  JSR TPB_delay
  
  LDA TPB_reg_b                   ; Set the strobe bit low (Active)
  AND #~TPB_LPT_stb_b             ; and only the strobe bit.
  STA TPB_reg_b
  
  JSR TPB_delay
  
  LDA TPB_reg_b                   ; Now we return the strobe bit to it's
  ORA #TPB_LPT_stb_b              ; 'idle' state.
  STA TPB_reg_b
  
  PLA
  PLP
  RTS
  
  
STB_ack_wait
  PHA
  
TPB_w_loop
  LDA TPB_ifr                     ; Check IFR for interrupt flag on CB1 set
  AND #TPB_ACK_CA1_b
  BEQ TPB_w_loop                  ; Until they match
  
  PLA
  RTS
  
TPB_delay
  PHA
  
  LDA #15
  SEC
  
TPB_delay_loop
  SBC #1
  BNE TPB_delay_loop
  
  PLA
  RTS
