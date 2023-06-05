; Jennifer's 6551 ACIA Library
;

; This is the configuration section for the ACIA.
;
; Make changes to setup here.
;
ACIA_CTRL_IDLE   = ACIA_WL8 | ACIA_RCS_BRG | ACIA_9600 | ACIA_TIC_10
ACIA_CTRL_LISTEN = ACIA_WL8 | ACIA_RCS_BRG | ACIA_9600 | ACIA_TIC_00 
ACIA_CMD_SETUP   = ACIA_PMC_DIS | ACIA_PME_DIS | ACIA_REM_OFF | ACIA_TIC_10 | ACIA_INT_DIS | ACIA_DTR_RDY

; ACIA1 Registers

ACIA1_base     = $C010                 ; Change as needed later.
ACIA1_tx       = ACIA1_base
ACIA1_rx       = ACIA1_base
ACIA1_sts      = ACIA1_base + 1
ACIA1_cmd      = ACIA1_base + 2
ACIA1_ctrl     = ACIA1_base + 3


; ACIA2 Registers

ACIA2_base     = $C014                 ; Change as needed later.
ACIA2_tx       = ACIA2_base
ACIA2_rx       = ACIA2_base
ACIA2_sts      = ACIA2_base + 1
ACIA2_cmd      = ACIA2_base + 2
ACIA2_ctrl     = ACIA2_base + 3



; ACIA Speeds

ACIA_16x            = @0000
ACIA_50             = @0001
ACIA_75             = @0010
ACIA_109p92         = @0011
ACIA_134p51         = @0100
ACIA_150            = @0101
ACIA_300            = @0110
ACIA_600            = @0111
ACIA_1200           = @1000
ACIA_1800           = @1001
ACIA_2400           = @1010
ACIA_3600           = @1011
ACIA_4800           = @1100
ACIA_7200           = @1101
ACIA_9600           = @1110
ACIA_19200          = @1111


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

ACIA_RCS_EXT	    = @00000000
ACIA_RCS_BRG	    = @00010000


; Status Flags

ACIA_PER	    = @00000001
ACIA_FER	    = @00000010
ACIA_OVR	    = @00000100
ACIA_RBF	    = @00001000
ACIA_TXE	    = @00010000
ACIA_DCD	    = @00100000
ACIA_DSR	    = @01000000
ACIA_INT	    = @10000000


; Filter Switch

LF_filt_sw1	    = @00000001
LF_filt_sw2	    = @00000010

; Baud rate registers
ACIA_vars_base  = ToE_mon_vars_end + 1
ACIA1_cfg_cmd   = ACIA_vars_base
ACIA1_cfg_ctrl  = ACIA1_cfg_cmd   + 1
ACIA2_cfg_cmd   = ACIA1_cfg_ctrl  + 1
ACIA2_cfg_ctrl  = ACIA2_cfg_cmd   + 1
ACIA_vars_end   = ACIA2_cfg_ctrl



; Tower of Eightness Specific serial routines.

INI_ACIA_SYS
  LDA #ACIA_CTRL_LISTEN
  STA ACIA1_cfg_ctrl
  STA ACIA2_cfg_ctrl
  LDA #ACIA_CMD_SETUP
  STA ACIA1_cfg_cmd
  STA ACIA2_cfg_cmd
  JSR INI_ACIA1
  JSR INI_ACIA2
  RTS

	
INI_ACIA1                               ; As required for a 6551 ACIA
  LDA ACIA1_cfg_cmd
  STA ACIA1_cmd                         ; Set the command reg for specified baud rate
  LDA ACIA1_cfg_ctrl
  STA ACIA1_ctrl                        ; Set the control reg for correct operation
  JSR ACIA1in                           ; Swallow the first byte (experimental fix) 
  
  
INI_ACIA2                               ; As required for a 6551 ACIA
  LDA ACIA2_cfg_cmd
  STA ACIA2_cmd                         ; Set the command reg for specified baud rate
  LDA ACIA2_cfg_ctrl
  STA ACIA2_ctrl                        ; Set the control reg for correct operation
  JSR ACIA2in                           ; Swallow the first byte (experimental fix)
  RTS


; byte out to 6551 ACIA1

ACIA1out
  PHP                                   ; Save registers as we aren't allowed to change them
  PHA
	
  STA ACIA1_tx                          ; write to ACIA TX buffer
  LDA #ACIA_TXE

ACIA1_wr_wait
  BIT ACIA1_sts
  BEQ ACIA1_wr_wait                     ; Wait until written.
	
  PLA                                   ; Restore registers. We're all good.
  PLP
	
  RTS                                   ; Done... Hopefully.
  
  
  
; byte out to 6551 ACIA2

ACIA2out
  PHP                                   ; Save registers as we aren't allowed to change them
  PHA
	
  STA ACIA2_tx                          ; write to ACIA TX buffer
  LDA #ACIA_TXE

ACIA2_wr_wait
  BIT ACIA2_sts
  BEQ ACIA2_wr_wait                     ; Wait until written.
	
  PLA                                   ; Restore registers. We're all good.
  PLP
	
  RTS                                   ; Done... Hopefully.


; byte in from 6551 ACIA 1

ACIA1in
  LDA #ACIA_RBF
  BIT ACIA1_sts				; do we have a byte?		2
  BEQ LAB_nobyw				; branch if no byte waiting	4

  LDA ACIA1_rx				; Get byte sent.		4
  SEC					; flag byte received		2
  
  PHA					;				3
  LDA #LF_filt_sw1			;				2
  BIT os_infilt				;				4
  BEQ filter_inp			;				4
  PLA					;				4
  RTS					;				6 +
  					;			      -----
					;			       35 cycles
					;			      -----	


; byte in from 6551 ACIA 2
  
ACIA2in
  LDA #ACIA_RBF
  BIT ACIA2_sts				; do we have a byte?
  BEQ LAB_nobyw				; branch if no byte waiting

  LDA ACIA2_rx				; Get byte sent.
  SEC					; flag byte received
  
  PHA
  LDA #LF_filt_sw2
  BIT os_infilt
  BEQ filter_inp
  PLA
  RTS

; Byte filter feature.  Applicable to both ACIAs.


filter_inp  
  PLA
  CMP #$A
  BEQ LAB_nobyw
  SEC
  RTS
  
LAB_nobyw
  LDA #0
  CLC
  RTS                             ; flag no byte received
