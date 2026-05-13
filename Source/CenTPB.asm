; Jennifer's Centronics (and later TPB) Card driver
;
; This card is based on a 6522 VIA chip.
;
; TPB is having a serious rethink RN!


; Initial states for port B
;
CEN_PB_Initial		= CEN_LPT_Stb_B
CEN_PB_Outputs		= TPB_BUS_ClkOut | TPB_BUS_DatOut | TPB_BUS_AtnOut | TPB_BUS_Select | CEN_LPT_Stb_B


; Register addresses
;
CEN_base		= $C020
CEN_Reg_B		= CEN_base
CEN_Reg_A		= CEN_base + $01
CEN_DDR_B		= CEN_base + $02
CEN_DDR_A		= CEN_base + $03
CEN_T1C_L		= CEN_base + $04
CEN_T1C_H		= CEN_base + $05
CEN_T1L_L		= CEN_base + $06
CEN_T1L_H		= CEN_base + $07
CEN_T2C_L		= CEN_base + $08
CEN_T2C_H		= CEN_base + $09
CEN_SR			= CEN_base + $0A
CEN_ACR			= CEN_base + $0B
CEN_PCR			= CEN_base + $0C
CEN_IFR			= CEN_base + $0D
CEN_IER			= CEN_base + $0E
CEN_Reg_B_NoHShake	= CEN_base + $0F


; Bits for registers used on the 6522
;
CEN_ACR_nIRQ_PULSE_B	= @00100000
CEN_IFR_T2_TIMEOUT_B	= @00100000



  
; LPT Control Bits
;
CEN_LPT_Stb_B		= @00000010
CEN_LPT_Ack_B		= @00000001
CEN_ACK_CA1_B		= @00000010
CEN_CA1_PE_B		= @00000001


CEN_Mem_Start		= $600
CEN_Mem_End		= CEN_Mem_Start

CEN_Mem_Lim		= $610


 .IF [ CEN_Mem_End>CEN_Mem_Lim ]
    .ERROR "Memory overrun in CenTPB.asm Centronics Module"
  .ENDIF


; Shared code.
;-------------

CEN_TPB_INIT
;  This first part initialises the on-card 6522 VIA pins for both features.

  LDA #0                          ; Set our registers to defaults
  STA CEN_Reg_A
  LDA #CEN_PB_Initial
  STA CEN_Reg_B
  
  LDA #$FF
  STA CEN_DDR_A                   ; Setup port A as outputs to our LPT
  
  LDA #CEN_PB_Outputs
  STA CEN_DDR_B                   ; Setup port B for LPT and TPB initial state.
  
  LDA #CEN_CA1_PE_B               ; Configure for positive edge interrupt trigger.
  STA CEN_PCR                     ; on CA1

  RTS

  
CEN_CODE_Start

; Centronics Write Function.
; *================================*
; *                                *
; *  ENTRY: A=char                 *
; *  EXIT: As found                *
; *                                *
; **********************************

CEN_LPT_write

  PHP						; Save Register States
  PHA

  STA CEN_Reg_A					; Write the char to output

  LDA CEN_Reg_B					; Strobe the data into the printer.
  AND #~CEN_LPT_Stb_B				; low (active)...
  STA CEN_Reg_B
  ORA #CEN_LPT_Stb_B				; ...then back to idle.
  STA CEN_Reg_B

  JSR STB_Ack_Wait				; Wait for ACK from the peripheral.

  PLA						; Tidy up after ourselves.
  PLP

  RTS						; Return control to the caller.

  
CEN_Delay
  LDX #6
CEN_Delay_L
  DEX
  BNE CEN_Delay_L
  RTS


STB_Ack_Wait
STB_Wait_L
  LDA CEN_IFR					; Check IFR for interrupt flag on CB1 set
  AND #CEN_ACK_CA1_B
  BEQ STB_Wait_L				; Until they match,
  RTS
  
CEN_CODE_End



TPB_Mem_Start		= $600
TPB_Mem_End		= CEN_Mem_Start

TPB_Mem_Lim		= $610


 .IF [ TPB_Mem_End>TPB_Mem_Lim ]
    .ERROR "Memory overrun in CenTPB.asm TPB Module."
  .ENDIF


TPB_CODE_Start

; TPB Bus Control Bits

TPB_BUS_ClkOut  = @00010000			; Clock line output (Port B, out)
TPB_BUS_ClkIn   = @01000000			; Clock line readback (Port B, in)
TPB_BUS_DatOut  = @00100000			; Data line output (Port B, out)
TPB_BUS_DatIn   = @10000000			; Data line readback (Port B, in)
TPB_BUS_Select  = @00001000			; TPB bus select (Port B, out) signals bus selection.
TPB_BUS_AtnIn   = @00000100			; ATN signal readback (Port B, in) indicates a peripheral needs attention or select signal
TPB_BUS_AtnOut  = @00000001			; ATN signal output.  When used, tells a device that the data is a select signal.


; TPB Check ATN state.
; *******************************************************
; *                                                     *
; *  ENTRY:                                             *
; *  EXIT: A, P, carry is set when asserted, otherwise  *
; *           cleared.                                  *
; *                                                     *
; *******************************************************


TPB_Check_ATN
  LDA CEN_Reg_B					; Check if ATN is asserted.
  AND #TPB_BUS_AtnIn
  CMP #1					; Carry set when asserted, cleared otherwise.
  RTS


; TPB transmit byte
; *================================*
; *                                *
; *  ENTRY: A=byte                 *
; *  EXIT: Affects A, X, Y, P      *
; *                                *
; *================================*

TPB_TX_Byte
  PHA						; Preserve our working registers
  PHY

  TAY						; Start by preserving A in Y
  LDX #8					; Set our counter for 8 data bits.

TPB_BitOut
  DEX
  BMI TPB_Done

  TYA						; Rotate MSb into carry.
  ROL
  TAY

  BCC TPB_OutZero

  LDA CEN_Reg_B					; Output 1 on TPB data.
  ORA #TPB_BUS_DatOut
  STA CEN_Reg_B
  NOP						; Compensates for the branch timing difference.
  BRA TPB_DoClk

TPB_OutZero
  LDA CEN_Reg_B					; Output 0 on TPB data.
  AND #~TPB_BUS_DatOut
  STA CEN_Reg_B

TPB_DoClk
  JSR TPB_PulseClk
  BRA TPB_BitOut

TPB_Done
  PLY						; Restore our working registers
  PLA
  RTS

; Clock line Pulse function
; **********************************
; *                                *
; *   ENTRY: None                  *
; *   EXIT: A,P Affected           *
; *   USES: TPB_delay              *
; *                                *
; **********************************

TPB_PulseClk
  LDA CEN_Reg_B
  ORA #TPB_BUS_ClkOut				; Set the clock line output.
  STA CEN_Reg_B
  JSR CEN_Delay

  AND #~TPB_BUS_ClkOut				; Clear the clock line output.
  STA CEN_Reg_B
  JSR CEN_Delay
  RTS

TPB_CODE_End