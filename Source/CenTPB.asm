; Jennifer's Centronics (and later TPB) Card driver
;
; This card is based on a 6522 VIA chip.
;
; TPB is having a serious rethink RN!


; Register addresses
;
CEN_base		= $C020
CEN_Reg_B		= CEN_base
CEN_Reg_A		= CEN_base+1
CEN_DDR_B		= CEN_base+2
CEN_DDR_A		= CEN_base+3
CEN_PCR			= CEN_base+$C
CEN_ifr			= CEN_base+$D


; LPT Control Bits
;
CEN_LPT_Stb_B		= @00000010
CEN_LPT_Ack_B		= @00000001
CEN_ACK_CA1_B		= @00000010
CEN_CA1_PE_B		= @00000001


CEN_Mem_Start		= $600
CEN_Mem_End		= CEN_Mem_Start

CEN_Men_Lim		= $610

  .IF [ CEN_Mem_End>CEN_Men_Lim ]
    .ERROR "Memory overrun in CenTPB.asm"
  .ENDIF


CEN_PbInitial		= CEN_LPT_Stb_B
CEN_PbOutputs		= CEN_LPT_Stb_B


CEN_INIT
;  This first part initialises the on-card 6522 VIA pins for both features.

  LDA #0                          ; Set our registers to defaults
  STA CEN_Reg_A
  LDA #CEN_PbInitial
  STA CEN_Reg_B
  
  LDA #$FF
  STA CEN_DDR_A                   ; Setup port A as outputs to our LPT
  LDA #CEN_PbOutputs
  STA CEN_DDR_B                   ; Setup port B for LPT initial state.

  RTS



; Centronics Write Function.
; *================================*
; *                                *
; *  ENTRY: A=char                 *
; *  EXIT: As found                *
; *                                *
; **********************************

CEN_LPT_write

  PHP						; Save Register States
  PHX						; Save X for later.
  PHA
  
  JSR CEN_Delay
  
  STA CEN_Reg_A					; Write the char to output
  
  JSR CEN_Delay
  
  LDA CEN_Reg_B					; Set the strobe bit low (Active)
  AND #~CEN_LPT_Stb_B				; and only the strobe bit.
  STA CEN_Reg_B
  
  JSR CEN_Delay
  
  LDA CEN_Reg_B					; Now we return the strobe bit to it's
  ORA #CEN_LPT_Stb_B				; 'idle' state.
  STA CEN_Reg_B
  
  PLA						; Tidy up after ourselves.
  PLX
  PLP
  
  RTS						; Return contol to the caller.

  
CEN_Delay

  LDX #8
  
CEN_Delay_L
  DEX
  BNE CEN_Delay_L
  
  RTS