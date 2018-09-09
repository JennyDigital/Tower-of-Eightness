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

TPB_BUS_clkout  = @00010000       ; Clock line output (Port B, out)
TPB_BUS_clkin   = @01000000       ; Clock line readback (Port B, in)
TPB_BUS_datout  = @00100000       ; Data line output (Port B, out)
TPB_BUS_datin   = @10000000       ; Data line readback (Port B, in)
TPB_BUS_reset   = @00001000       ; Reset (Port B, out) resets all devices on the bus.
TPB_BUS_atn     = @00000100       ; ATN signal (Port B, in) indicated a peripheral needs attention.


; TPB Configuration parameters

TPB_BUS_lim_c   = 255             ; Number of samples before giving up on device
TPB_BUS_dev_max = 15              ; Highest device address permitted, host being 0.

; *****************************************************************************
; *                           TABLE 1: BLOCK TYPES                            *
; *                           --------------------                            *
; * 1.  Command Block (Always the same size 4 bytes at current).              *
; * 2.  Response Block (Same size as the command block).                      *
; * 3.  Data Block.  Upto 65535 bytes. It is not reccomended to go that big,  *
; *     you would touch registers that way!                                   *
; * 4.  Broadcast Block (4 bytes long).                                       *
; *                                                                           *
; *****************************************************************************

TPB_BLK_cmd        = 1
TPB_BLK_rsp        = 2
TPB_BLK_dat        = 3
TPB_BLK_brd        = 4


; Memory allocations

TPB_worksp         = $5F2                 ; Start of TPB card memory allocation
TPB_curr_dev       = TPB_worksp           ; Currently selected TPB devce ID
TPB_dev_type       = TPB_worksp+1         ; Device class of selected device
TPB_last_rd        = TPB_worksp+2         ; last byte read from TPB device
TPB_BUS_status     = TPB_worksp+3         ; Status word from TPB engine (subject to change)
TPB_BUS_tries      = TPB_worksp+4         ; Bus device counter.  This ensures fewer hangs.
TPB_BUS_lim        = TPB_worksp+5         ; Bus countdown timer limit. (Reload value).
TPB_BUS_blk_lenlo  = TPB_worksp+6         ; Length of block in or out
TPB_BUS_blk_lenhi  = TPB_worksp+7         ; Length of block in or out
TPB_BUS_blk_len    = TPB_BUS_blk_lenlo    ; Convenience pointer to TPB_BUS_blk_lenlo
TPB_BUS_blk_stlo   = TPB_worksp+8         ; Start address low byte of block
TPB_BUS_blk_sthi   = TPB_worksp+9         ; Start address high byte of block
TPB_BUS_blk_st     = TPB_BUS_blk_stlo     ; Convenience pointer to TPB_BUS_BLK_stlo
TPB_BUS_blk_type   = TPB_worksp+$A        ; Type of block transfer. See table 1
TPB_Temp1          = $E2                  ; Temporary memory location 1
TPB_Temp2          = $E3                  ; Temporary memory location 2
TPB_Temp3          = $E4                  ; Temporary memory location 3

; 3 spaces remain between the system variables and the buffer block.
; This means we end up with $5FD to $5FF unused.

; Last TPB workspace allocation @ $5FC before buffers.


; TPB Command Codes

PRESENCE           = 0                  ; Check for device presence by ID
ATN_CHK            = 1                  ; Check if device is asserting ATN
REQ_DEV_TYPE       = 2                  ; Request device type-code.
CTRL_BLK_WR        = 3                  ; Write to control block
CTRL_BLK_RD        = 4                  ; Read from control block
BUFF_BLK_WR        = 5                  ; Write to device buffer
BUFF_BLK_RD        = 6                  ; Read from device buffer
BUFF_PROCESS       = 7                  ; Process buffer contents
STREAM_OUT         = 8                  ; Stream out (each char requires an ACK or NACK after)
STREAM_IN          = 9                  ; Stream in (for each char in, you must send an ACK or NACK)


; ACK and NACK codes

TPB_ACK            = $F1                ; Acknowledge code (Continuance signal)
TPB_NACK           = $F5                ; Not Acknoledge code. (Terminator)


TPB_BUS_RAMBASE    = $600
TPB_Dev_table      = TPB_BUS_RAMBASE                     ; Start of the TPB bus device table.
TPB_BUS_IO_buff    = TPB_Dev_table + TPB_BUS_dev_max + 1 ; Page of buffer for TPB transfers
TPB_BUFFER         = $700                                ; Block transfers go here. Max 1 page.


; Control Block Structure and Location.

TPB_ctrl_blk       = TPB_BUS_IO_buff
DEV_ID             = TPB_ctrl_blk
DEV_BLK_TYPE       = TPB_ctrl_blk + 1
DEV_CMD_RSP        = TPB_ctrl_blk + 2
CHECKSUM           = TPB_ctrl_blk + 3

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
  
  
; TPB Check ATN state.
; *******************************************************
; *                                                     *
; *  ENTRY:                                             *
; *  EXIT: A, P, carry is set when asserted, otherwise  *
; *           cleared.                                  *
; *                                                     *
; *******************************************************


TPB_Check_ATN
  LDA TPB_reg_b                   ; Check if ATN is asserted
  AND #TPB_BUS_atn
  SEC
  BEQ ATN_asserted                ; Skip clearing C if ATN is asserted.
  CLC                             ; Carry is cleared as ATN isn't asserted.
ATN_asserted
  RTS 
                   

; TPB Transmit Command
; ****************************************************
; *                                                  *
; *  ENTRY:                                          *
; *  EXIT:  A, X, Y, P affected                      *
; *                                                  *
; ****************************************************


TPB_Tx_CMD
  LDA #<DEV_ID                   ; Setup pointers and transmit control block.
  STA TPB_BUS_blk_stlo
  LDA #>DEV_ID
  STA TPB_BUS_blk_sthi
  LDA #4
  STA TPB_BUS_blk_lenlo
  LDA #0
  STA TPB_BUS_blk_lenhi
  
  JSR TPB_tx_block
  
  RTS


; TPB Attention Signal handler with wait.
; ****************************************************
; *                                                  *
; *  ENTRY:                                          *
; *  EXIT:  A,X,P                                    *
; *         C=0 ATN line not asserted or timeout.    *
; *         C=1 ATN line asserted                    *
; *                                                  *
; ****************************************************

TPB_WaitATN
  LDX #TPB_BUS_lim_c                ; Set number of tries
  
TPB_WaitATN_try
  JSR TPB_delay                     ; Wait and check
  JSR TPB_Check_ATN
  BCS FinWaitATN
  DEX                               ; Reduce counter and try again
  BNE TPB_WaitATN_try
  CLC  
FinWaitATN
  RTS


; TPB DEVICE_PRESENCE handler (Currently broken)
; ****************************************************
; *                                                  *
; *  ENTRY: A=ID                                     *
; *  EXIT:  TPB_BUS_IO_buff= reply block             *
; *         C=0 (No device or block fail),           *
; *         C=1 Success.                             *
; *                                                  *
; ****************************************************


; Setup Command Block

TPB_Dev_Presence
  ; Command Setup
  STA DEV_ID                     ; Store device ID
  LDA #TPB_BLK_cmd
  STA DEV_BLK_TYPE
  LDA #PRESENCE                  ; Command: PRESENCE check.
  STA DEV_CMD_RSP  
  JSR TPB_calc_ctrl_csum         ; Calculate checksum
  ; Command Issue
  JSR TPB_Tx_CMD                 ; Transmit Command
  ; Process Outcome
  JSR TPB_WaitATN                ; Wait for Attention signal
  BCC PRESENCE_NoRESP            ; If no device then skip RESP fetch

  LDA #<DEV_ID                   ; Setup pointers for RESP block.
  STA TPB_BUS_blk_stlo
  LDA #>DEV_ID
  STA TPB_BUS_blk_sthi
  LDA #4
  STA TPB_BUS_blk_lenlo
  LDA #0
  STA TPB_BUS_blk_lenhi
  
  JSR TPB_rx_block               ; Get RESPonse block
  
  BCC PRESENCE_NoRESP            ; If failed or no response fall through.
  
  CLC                            ; Calculate Checksum
  LDA DEV_ID
  ADC DEV_BLK_TYPE
  ADC DEV_CMD_RSP
  
  CMP CHECKSUM                   ; Compare with received checksum
  BNE PRESENCE_NoRESP            ; Signal appropriately with the carry bit.
  SEC
  RTS                            ; Return with positive response
  
PRESENCE_NoRESP
  CLC
  RTS                            ; ...Else return negative.


; TPB Attention handler (Needs work, do not use)
; ****************************************************
; *                                                  *
; *  ENTRY:                                          *
; *  EXIT:                                           *
; *                                                  *
; *                                                  *
; *                                                  *
; ****************************************************

TPB_ATN_handler
  
  LDY #0
ATN_next                          ; Work our way through the device table
  LDA TPB_Dev_table,Y           
  
  BEQ TPB_EOT                     ; Check for end of table marker (0).
                                  ; Initialise our control block for attention check
  STA DEV_ID                      ; Store device ID.
  TYA
  PHA                             ; Stack our table pointer for later.
  LDA #TPB_BLK_cmd
  STA DEV_BLK_TYPE
  LDA #ATN_CHK
  STA DEV_CMD_RSP
  
  JSR TPB_calc_ctrl_csum
  
  JSR TPB_Tx_CMD                  ; Transmit Command
  
  JSR TPB_tx_block
  
  ;JSR TPB_ctrl_rd
  
  PLA                             ; Get our id table pointer back.
  TAY
  INY                             ; Advance to next table entry  
  JMP ATN_next
TPB_EOT
  RTS
  
TPB_calc_ctrl_csum
  CLC
  LDA #0                          ; Calculate and store checksum for block.
  ADC DEV_ID
  ADC DEV_BLK_TYPE
  ADC DEV_CMD_RSP
  STA CHECKSUM
  RTS
 
 
; TPB transmit byte
; *================================*
; *                                *
; *  ENTRY: A=byte                 *
; *  EXIT: Affects X, P            *
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


; Clock line Pulse function
; **********************************
; *                                *
; *   ENTRY: None                  *
; *   EXIT: A,P Affected           *
; *   USES: TPB_delay              *
; *                                *
; **********************************

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


; TPB recieve byte
; *======================================*
; *                                      *
; *  ENTRY:                              *
; *  EXIT: Affects A,X,Y,P               *
; *        A = byte                      *
; *        C = 1 Sucess, 0 Fail          *
; *                                      *
; *======================================*

TPB_rx_byte                       ; Read one byte
  LDA #0                          ; This is our starting value
  STA TPB_Temp3                   ; Keep it safe in Temp3
  
  LDA TPB_reg_b                   ; Signal start bit required.
  ORA #TPB_BUS_clkout             ; Set the clock line output
  STA TPB_reg_b
  
  CLC
  LDY #TPB_BUS_lim_c              ; Load our limit (preventing bus hangs)
TPB_chk_databit
  JSR TPB_delay                   ; Small delay.  This may change later.
  LDA TPB_reg_b
  AND #TPB_BUS_datin
  BEQ TPB_sbit_asserted
  
  DEY                             ; Check for timeout & branch if still waiting.
  BNE TPB_chk_databit
  
TPB_rx_fail
  LDA TPB_reg_b                   ; Clear clock line output
  AND #~TPB_BUS_clkout
  STA TPB_reg_b
  JSR TPB_delay                   ; ...and include a small delay

  LDA #0                          ; We timed out so let's signal that
  CLC
  RTS
  
TPB_sbit_asserted
  LDA TPB_reg_b                   ; Clear clock line output
  AND #~TPB_BUS_clkout
  STA TPB_reg_b
  JSR TPB_delay                   ; ...and include a small delay
  

  LDX #8                          ; Receive and store 8 bits.
TPB_rcv_nextbit  
  JSR TPB_Takebit
  ROL TPB_Temp3                   ; Push our sampled bit into our output.

  DEX
  BNE TPB_rcv_nextbit
  
  JSR TPB_Takebit                 ; Receive the stop bit.  
  BCS TPB_rx_fail
  
  LDA TPB_Temp3                   ; Retrieve our finished byte
  SEC                             ; and signal that we were successful
  RTS
  
TPB_Takebit  
  JSR TPB_pulseclk                ; Sample the bus and set or clear carry as required.
  LDA TPB_reg_b
  AND #TPB_BUS_datin
  CLC
  BNE TPB_skip_setbit
  SEC
TPB_skip_setbit
  RTS
  

; TPB transmit block
; *==================================================*
; *                                                  *
; *  ENTRY: TPB_BUS_blk_lenlo = length of block (LO) *
; *         TPB_BUS_blk_lenhi = length of block (HI) *
; *                                                  *
; *         TPB_BUS_blk_st  = start of block         *
; *                                                  *
; *  EXIT:  TPB_BUS_blk_len = unchanged              *
; *         TPB_BUS_blk_st  = st+len                 *
; *         A,X,Y,P all affected.                    *
; *                                                  *
; *                                                  *
; *==================================================*

TPB_tx_block
  LDA TPB_BUS_blk_stlo             ; Copy block address to temp1/2
  STA TPB_Temp1
  LDA TPB_BUS_blk_sthi
  STA TPB_Temp2
  
TPB_BUS_tx_next                    ; Transmitter inside loop
  LDA TPB_BUS_blk_lenlo            ; Finish when TPB_blk_len(lo and hi) = 0
  ORA TPB_BUS_blk_lenhi
  BEQ TPB_tx_block_done
  
  LDY #0                           ; Get and transmit byte.
  LDA (TPB_Temp1),Y
  JSR TPB_tx_byte

  LDA TPB_BUS_blk_lenlo            ; Decrement our length counter
  SEC
  SBC #1
  STA TPB_BUS_blk_lenlo
  LDA TPB_BUS_blk_lenhi
  SBC #0
  STA TPB_BUS_blk_lenhi
  
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
 

 ; TPB receive block
; *==================================================*
; *                                                  *
; *  ENTRY: TPB_BUS_blk_lenlo = length of block (LO) *
; *         TPB_BUS_blk_lenhi = length of block (HI) *
; *                                                  *
; *         TPB_BUS_blk_st  = start of block         *
; *                                                  *
; *  EXIT:  TPB_BUS_blk_len = unchanged              *
; *         TPB_BUS_blk_st  = st+len                 *
; *         Temp1, Temp2 Corrupted                   *
; *         A,X,Y,P all affected.                    *
; *         C=0 Fail, C=1 Success                    *
; *                                                  *
; *==================================================*
 
TPB_rx_block
  LDA TPB_BUS_blk_stlo             ; Copy block address to temp1/2
  STA TPB_Temp1
  LDA TPB_BUS_blk_sthi
  STA TPB_Temp2
  
TPB_BUS_rx_next
  LDA TPB_BUS_blk_lenlo            ; While block length > 0.
  ORA TPB_BUS_blk_lenhi
  BEQ TPB_rx_block_done
  
  JSR TPB_rx_byte                  ; Get byte.
  
  BCS TPB_rx_continue              ; Continue unless TPB_rx_byte signals failiure.
  RTS
  
TPB_rx_continue
  LDY #0                           
  STA (TPB_Temp1),Y                ; Store our successfully received byte.
  
  LDA TPB_BUS_blk_lenlo            ; Decrement our length counter
  SEC
  SBC #1
  STA TPB_BUS_blk_lenlo
  LDA TPB_BUS_blk_lenhi
  SBC #0
  STA TPB_BUS_blk_lenhi
  
  CLC                              ; Increment TPB_BUS_blk_len copy in TPB_Temp1/2
  LDA TPB_Temp1
  ADC #1
  STA TPB_Temp1
  LDA TPB_Temp2
  ADC #0
  STA TPB_Temp2
  
  JMP TPB_BUS_rx_next
  
TPB_rx_block_done
  SEC
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

; *****************************************************************
;
;                       END OF TPBCARD.asm
;
; *****************************************************************
