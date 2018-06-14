; Duncan's 6551 ACIA Library
;

; This is the configuration section for the ACIA.
;
; Make changes to setup here.
;
ACIA_CTRL_IDLE = ACIA_WL8 | ACIA_RCS_BRG | ACIA_9600 | ACIA_TIC_10
ACIA_CTRL_LISTEN = ACIA_WL8 | ACIA_RCS_BRG | ACIA_9600 | ACIA_TIC_00
ACIA_CMD_SETUP  = ACIA_PMC_DIS | ACIA_PME_DIS | ACIA_REM_OFF | ACIA_TIC_10 | ACIA_INT_DIS | ACIA_DTR_RDY


; ACIA Registers

ACIA_base     = $C010                 ; Change as needed later.
ACIA_tx       = ACIA_base
ACIA_rx       = ACIA_base
ACIA_sts      = ACIA_base + 1
ACIA_cmd      = ACIA_base + 2
ACIA_ctrl     = ACIA_base + 3


; ACIA Speeds

ACIA_16x      = 0
ACIA_50       = @0001
ACIA_75       = @0010
ACIA_109p92   = @0011
ACIA_134p51   = @0100
ACIA_150      = @0101
ACIA_300      = @0110
ACIA_600      = @0111
ACIA_1200     = @1000
ACIA_1800     = @1001
ACIA_2400     = @1010
ACIA_3600     = @1011
ACIA_4800     = @1100
ACIA_7200     = @1101
ACIA_9600     = @1110
ACIA_19200    = @1111


; ACIA Word lengths

ACIA_WL8            = @00000000
ACIA_WL7            = @00100000
ACIA_WL6            = @01000000
ACIA_WL5            = @01100000


; ACIA Command bits

ACIA_PMC_ODD        = @00000000        ; Parity Mode Control bits
ACIA_PMC_EVN        = @01000000
ACIA_PMC_DIS        = @10000000

ACIA_PME_DIS        = @00000000        ; Parity Mode Enable bit
ACIA_PME_ENA        = @00100000

ACIA_REM_OFF        = @00000000        ; Receiver Echo Mode bit
ACIA_REM_ON         = @00010000

ACIA_TIC_00         = @00000000        ; RTSB High, Transmit Int disabled
ACIA_TIC_01         = @00000100        ; RTSB Low, Transmit Int enabled
ACIA_TIC_10         = @00001000        ; RTSB Low, Transmit Int disabled
ACIA_TIC_11         = @00001100        ; RTSB Low, Transmit Int disabled & Transmit break on TxD
ACIA_INT_DIS        = @00000010
ACIA_INT_ENA        = @00000000
ACIA_DTR_NRDY       = @00000000
ACIA_DTR_RDY        = @00000001


; ACIA Clock Source

ACIA_RCS_EXT  = @00000000
ACIA_RCS_BRG  = @00010000


; Status Flags

ACIA_PER      = @00000001
ACIA_FER      = @00000010
ACIA_OVR      = @00000100
ACIA_RBF      = @00001000
ACIA_TXE      = @00010000
ACIA_DCD      = @00100000
ACIA_DSR      = @01000000
ACIA_INT      = @10000000


; Tower of Eightness Specific serial routines.
	
INI_ACIA                          ; As required for a 6551 ACIA
  LDA #ACIA_CMD_SETUP
  STA ACIA_cmd                    ; Set the command reg for specified baud rate
  LDA #ACIA_CTRL_LISTEN
  STA ACIA_ctrl                   ; Set the control reg for correct operation
  RTS	


; byte out to 6551 ACIA

ACIAout
  PHP                             ; Save registers as we aren't allowed to change them
  PHA
	
  STA ACIA_tx                     ; write to ACIA TX buffer
  LDA #ACIA_TXE

ACIA_wr_wait
  BIT ACIA_sts
  BEQ ACIA_wr_wait                ; Wait until written.
	
  PLA                             ; Restore registers. We're all good.
  PLP
	
  RTS                             ; Done... Hopefully.


; byte in from 6551 ACIA

ACIAin
  LDA #ACIA_RBF
  BIT ACIA_sts                    ; do we have a byte?
  BEQ LAB_nobyw                   ; branch if no byte waiting

  LDA ACIA_rx                     ; Get byte sent.
  SEC                             ; flag byte received
  RTS
  
LAB_nobyw
  LDA #0
  CLC
  RTS                             ; flag no byte received
