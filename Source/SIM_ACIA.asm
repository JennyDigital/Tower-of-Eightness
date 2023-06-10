; Jenny's 6551 ACIA Library
;

; ACIA Registers

ACIA_base     = $C030                 ; Change as needed later.
ACIA_tx       = ACIA_base + 1
ACIA_rx       = ACIA_base + 4


; Tower of Eightness Specific serial routines.
	
INI_ACIA                          ; As required for a 6551 ACIA
  RTS	


; byte out to 6551 ACIA

ACIAout
  PHP                             ; Save registers as we aren't allowed to change them
  PHA
	
  STA ACIA_tx                     ; write to ACIA TX buffer
  PLA                             ; Restore registers. We're all good.
  PLP
  RTS                             ; Done... Hopefully.


; byte in from 6551 ACIA

ACIAin
  LDA ACIA_rx                     ; Get byte sent.
  BEQ LAB_nobyw                   ; branch if no byte waiting
  SEC                             ; flag byte received
  RTS
  
LAB_nobyw
  CLC
  RTS                             ; flag no byte received
