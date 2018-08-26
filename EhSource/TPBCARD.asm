; Duncan's TPB Card driver
;
; This card is based on a 6522 VIA chip.


; Register addresses

TPB_base        = $C020
TPB_reg_b       = TPB_base
TPB_reg_a       = TPB_base+1
TPB_ddr_b       = TPB_base+2
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


; TPB Configuration parameters

TPB_CMD_len     = 16              ; Length of control block
TPB_BUS_lim_c   = 255             ; Number of samples before giving up on device


; *****************************************************************************
; *                           TABLE 1: BLOCK TYPES                            *
; *                           --------------------                            *
; * 1.  Command Block (Always the same size (as yet unspecified)).            *
; * 2.  Response Block (Same size as the command block).                      *
; * 3.  Data Block.  Upto 256 bytes.                                          *
; * 4.  Broadcast Block (4 bytes long).                                       *
; *                                                                           *
; *****************************************************************************

TPB_BLK_cmd      = 1
TPB_BLK_rsp      = 2
TPB_BLK_dat      = 3
TPB_BLK_brd      = 4


; Memory allocations

TPB_worksp       = $5F2            ; Start of TPB card memory allocation
TPB_curr_dev     = TPB_worksp      ; Currently selected TPB devce ID
TPB_dev_type     = TPB_worksp+1    ; Device class of selected device
TPB_last_rd      = TPB_worksp+2    ; last byte read from TPB device
TPB_BUS_status   = TPB_worksp+3    ; Status word from TPB engine (subject to change)
TPB_BUS_tries    = TPB_worksp+4    ; Bus device counter.  This ensures fewer hangs.
TPB_BUS_lim      = TPB_worksp+5    ; Bus countdown timer limit. (Reload value).
TPB_BUS_blk_len  = TPB_worksp+6    ; Length of block in or out
TPB_BUS_blk_stlo = TPB_worksp+7    ; Start address low byte of block
TPB_BUS_blk_sthi = TPB_worksp+8    ; Start address high byte of block
TPB_BUS_blk_type = TPB_worksp+9    ; Type of block transfer. See table 1
TPB_Temp1        = $E2             ; Temporary memory location 1
TPB_Temp2        = $E3             ; Temporary memory location 2
; 4 spaces remain between the system variables and the buffer block.

; Last TPB workspace allocation @ $5FA before buffers.

TPB_BUS_IO_buff  = $600            ; Page of buffer for TPB transfers


; Initialisation Routine

TPB_PbInitial   = TPB_LPT_stb_b | TPB_BUS_reset
TPB_PbOutputs   = TPB_LPT_stb_b | TPB_BUS_reset | TPB_BUS_clkout | TPB_BUS_datout


TPB_INIT
;  This first part initialises the on-card 6522 VIA pins for both features.

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
  
  ;  This second part initialises the Tower Peripheral Bus engine.
  
  LDA #0
  STA TPB_BUS_status              ; Set the bus to listening.

  LDA #TPB_BUS_lim_c
  STA TPB_BUS_lim                 ; Set the bus response tries limit (variable for latency)
  RTS


; TPB transmit block
; *==================================================*
; *                                                  *
; *  ENTRY: TPB_BUS_blk_len = length of block        *
; *         TPB_BUS_blk_st  = start of block         *
; *                                                  *
; *  EXIT:  TPB_BUS_blk_len = unchanged              *
; *         TPB_BUS_blk_st  = st+len                 *
; *                                                  *
; *                                                  *
; *                                                  *
; *==================================================*

TPB_tx_block
  
  LDA TPB_BUS_blk_stlo             ; Copy block address to temp1/2
  STA TPB_Temp1
  LDA TPB_BUS_blk_sthi
  STA TPB_Temp2
  
TPB_BUS_tx_next                    ; Transmitter inside loop
  LDA TPB_BUS_blk_len              ; Finish when TPB_blk_len = 0
  BEQ TPB_tx_block_done
  
  LDY #0                           ; Get and transmit byte.
  LDA (TPB_Temp1),Y
  JSR TPB_tx_byte

  DEC TPB_BUS_blk_len              ; Decrement our counter
  
  CLC                              ; Increment TPB_BUS_blk_len copy in TPB_Temp1/2
  LDA TPB_Temp1
  ADC #1
  STA TPB_Temp1
  LDA TPB_Temp2
  ADC #0
  STA TPB_Temp2
  
  JSR TPB_delay                    ; Add a little delay between bytes.
  JSR TPB_delay                    ; thereby allowing the receiver to do something useful.
  JSR TPB_delay
  
  JMP TPB_BUS_tx_next
  
TPB_tx_block_done
  RTS
  

; TPB transmit byte
; *================================*
; *                                *
; *  ENTRY: A=byte                 *
; *                                *
; *                                *
; *================================*

TPB_tx_byte
  LDX #10                   ; 1 start bit, 8 data bits and 1 stop bit.
  SEC                       ; We want a start bit.
  PHA
TPB_bit_out  
  BCC TPB_out_zero          ; Determine whether a 1 or 0 to be sent.
 
  
; output 1 on TPB data
  LDA TPB_reg_b
  ORA #TPB_BUS_datout
  STA TPB_reg_b
  NOP                       ; This NOP compensates for the branch timing.
  JSR TPB_pulseclk
  
  JMP TPB_shiftbit
  
  
; output 0 on TPB data  
TPB_out_zero
  LDA TPB_reg_b
  AND #~TPB_BUS_datout
  STA TPB_reg_b
  JSR TPB_pulseclk 
  
  JMP TPB_shiftbit


TPB_pulseclk  
  LDA TPB_reg_b
  ORA #TPB_BUS_clkout       ; Set the clock line output
  STA TPB_reg_b
  
  JSR TPB_delay

  LDA TPB_reg_b
  AND #~TPB_BUS_clkout      ; Clear the clock line output
  STA TPB_reg_b
  
  JSR TPB_delay
  RTS
  
    
TPB_shiftbit  
  DEX
  BEQ TPB_wr_done
  PLA
  ASL
  PHA
  JMP TPB_bit_out
  
TPB_wr_done
  PLA
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
 
 
; Delay routine for TPB, there are better ways but this will do for now.
  
TPB_delay
  PHA
  
  LDA #6
  SEC
  
TPB_delay_loop
  SBC #1
  BNE TPB_delay_loop
  
  PLA
  RTS
