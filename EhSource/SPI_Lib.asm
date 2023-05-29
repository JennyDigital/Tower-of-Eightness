; SPI Driver by Jennifer Gunn
;

; SPI System variables
;
SPI_Struct		= $400					; Base address of SPI data structure below.

SPI_In			= SPI_Struct				; Byte received by the SPI subsystem
SPI_Out			= SPI_In + 1				; Byte to be transmitted by the SPI subsystem
SPI_Mode		= SPI_Out + 1				; SPI mode.  See table 1 below.
SPI_SS_Pin		= SPI_Mode + 1				; Slave select pin.  Must be just one bit in the byte.
SPI_SS_Act		= SPI_SS_Pin + 1			; Active Level of SS pin.
SPI_MOSI_Pin		= SPI_SS_Act+ 1				; Master Out, Slave In pin.  This pin outputs the bits.
SPI_MISO_Pin		= SPI_MOSI_Pin + 1			; Master In, Slave Out pin.  This pin reads the slave bits.
SPI_SCK_Pin		= SPI_MISO_Pin +1			; Serial clock output pin. Without clocks, most of us wouldn't exist!
SPI_Temp		= SPI_SCK_Pin + 1			; Temporary store for internal operations.


; SPI Mode bitfields
;
SPI_CPOL_bit		= @00000010
SPI_CPHA_bit		= @00000001


; SPI constants.
;
SPI_CPHA0		= @00000000				; Clock phase 0: Out on previous clock trailing, in after leading edge.
SPI_CPHA1		= @00000001				; Clock phase 1: Out on leading edge, in after trailing.
SPI_CPOL0		= @00000000				; Clock polarity 0: Positive logic.
SPI_CPOL1		= @00000010				; Clock polarity 1: Negative logic.

SPI_MODE0		= SPI_CPHA0 | SPI_CPOL0			; Official modes for SPI, to help those that would like it.
SPI_MODE1		= SPI_CPHA1 | SPI_CPOL0
SPI_MODE2		= SPI_CPHA0 | SPI_CPOL1
SPI_MODE3		= SPI_CPHA1 | SPI_CPOL1


SPI_SCK_Pin_C		= @00000100				; Default SPI clock pin.
SPI_MOSI_Pin_C		= @00001000				; This pin and the following two are chosen so as not to
SPI_MISO_Pin_C		= @00010000				; clash with the I2C engine by default.
SPI_SS_Pin_C		= @00100000				; Default Slave Select pin.
SPI_SS_Pin_Act_C	= 0					; SS pin polarity active low.
SPI_DDRPORT_C		= $C043					; Port A DDR register on first GPIO card.
SPI_IOP_C		= $C041					; ORA on first GPIO card,
SPI_Mode_C		= SPI_MODE0				; Clock phase mode 0, Clock polarity 0. Good for eg: 74HC595.
SPI_SS_Pin_ActLo_C	= 1					; Slave Select Active Low
SPI_SS_Pin_ActHi_C	= 0					; Slave Select Active High



; Setup SPI port. Do NOT call this until your structure is set up correctly.
;
SPI_Init_F
  JSR SPI_SetBusDDR_F
  JSR SPI_BusIdle_F
  
  RTS
  

; Init the SPI Structure with default values from the above constants.
;
SPI_Struct_Init_F
  LDA #SPI_MOSI_Pin_C
  STA SPI_MOSI_Pin
  LDA #SPI_MISO_Pin_C
  STA SPI_MISO_Pin
  LDA #SPI_SS_Pin_C
  STA SPI_SS_Pin
  LDA #SPI_SCK_Pin_C
  STA SPI_SCK_Pin
  LDA #SPI_Mode_C
  STA SPI_Mode
  LDA #SPI_SS_Pin_ActLo_C
  STA SPI_SS_Act
  LDA #0
  STA SPI_In
  STA SPI_Out
  
  RTS


SPI_SetBusDDR_F
  LDA SPI_DDRPORT_C						; Get current state

  ORA SPI_MOSI_Pin						; Set MOSI, SCK and SS out, but MISO to input
  ORA SPI_SS_Pin
  ORA SPI_SCK_Pin
  STA SPI_DDRPORT_C
  
  LDA SPI_MISO_Pin
  EOR #$FF
  AND SPI_DDRPORT_C
  STA SPI_DDRPORT_C						; Store it.  Our pin directions are now set.

  RTS


SPI_BusIdle_F  
  LDA SPI_MOSI_Pin						; Put our SPI bus in idle.
  CLC
  JSR SPI_SetPins_F
  JSR SPI_Deassert_SS_F
  JSR SPI_Deassert_SCK_F

  RTS


; Sets the state of the pin(s) set in A. If carry then set pin(s), otherwise clear pin(s).
;
SPI_SetPins_F
  BCC SPI_ClrPin_B

SPI_MOSI_SetPin_B
  ORA SPI_IOP_C
  STA SPI_IOP_C
  
  RTS
  
SPI_ClrPin_B
  EOR #$FF
  AND SPI_IOP_C
  STA SPI_IOP_C
  
  RTS


; *****************************************
; 
; Assert Functions
;
; *****************************************
;
SPI_Assert_SS_F
  CLC
  LDA SPI_SS_Act
  BNE SPI_SS_Assert_Low_B
  SEC
  
SPI_SS_Assert_Low_B
  LDA SPI_SS_Pin
  JMP SPI_SetPins_F
  

SPI_Assert_SCK_F
  CLC
  LDA SPI_Mode
  BIT #SPI_CPOL_bit
  BNE SPI_SCK_Neg_B
  SEC
  
SPI_SCK_Neg_B
  LDA SPI_SCK_Pin
  JMP SPI_SetPins_F



; *****************************************
; 
; De-Assert Functions
;
; *****************************************
;
SPI_Deassert_SS_F
  SEC
  LDA SPI_SS_Act
  BNE SPI_SS_Deassert_Hi_B
  CLC
  
SPI_SS_Deassert_Hi_B
  LDA SPI_SS_Pin
  JMP SPI_SetPins_F
  

SPI_Deassert_SCK_F
  SEC
  LDA SPI_Mode
  BIT #SPI_CPOL_bit
  BNE SPI_SCK_Pos_B
  CLC
  
SPI_SCK_Pos_B
  LDA SPI_SCK_Pin
  JMP SPI_SetPins_F


; *************************
; 
;  Bit-Shift I/O Function.
;
; *************************
;
SPI_ShiftIn_MISO_F
  SEC
  LDA SPI_IOP_C
  BIT SPI_MISO_Pin
  BNE SPI_ShiftIn_B
  
  CLC
  
SPI_ShiftIn_B
  ROL SPI_In
  
  RTS

  
SPI_ShiftOut_MOSI_F
  LDA SPI_MOSI_Pin
  ROL SPI_Temp
  JMP SPI_SetPins_F
  

SPI_Xfer_F
  LDX #8							; Set up our counter for pushing bits.

  JSR SPI_BusIdle_F
  JSR SPI_Assert_SS_F

  LDA SPI_Out							; Get a working copy of our data to send
  STA SPI_Temp
  
  LDA SPI_Mode							; Adjust for whatever CPHA setting we have.
  BIT SPI_CPHA_bit
  BNE SPI_xfer_CPHA1


SPI_xfer_CPHA0							; This path puts data on the trailing edge of the previous clock,
								; and reads it after the leading edge of the current clock.								
  JSR SPI_ShiftOut_MOSI_F
  JSR SPI_Assert_SCK_F
  JSR SPI_ShiftIn_MISO_F
  JSR SPI_Deassert_SCK_F

  DEX
  BNE SPI_xfer_CPHA0
  
  JSR SPI_BusIdle_F

  RTS

  
SPI_xfer_CPHA1							; This path puts the data out just before the leading edge,
								; and reads it just after the trailing edge.
  JSR SPI_Assert_SCK_F
  JSR SPI_ShiftOut_MOSI_F
  JSR SPI_Deassert_SCK_F
  JSR SPI_ShiftIn_MISO_F
  
  DEX
  BNE SPI_xfer_CPHA1
  
  JSR SPI_BusIdle_F
    
  RTS



  

; Takes mode, mosi, miso, ss, and ss_act parameters and initialises the SPI subsystem.
; Out of range parameters will generate Function call errors.
  
SPI_Init_BASIC

  JSR LAB_EVNM							; Get the SPI Mode
  JSR LAB_F2FX

  LDA #0							; Check if we are in range 0..3 or not.
  CMP Itemph
  BNE InitFCER  
  LDA Itempl
  AND #3
  CMP Itempl
  BNE InitFCER
  STA SPI_Mode

  JSR   LAB_1C01						; scan for "," , else do syntax error then warm start
  
  JSR LAB_EVNM							; Get the MOSI Pin
  JSR LAB_F2FX
  
  LDA #0							; Check if we are in range 0..7 or not.
  CMP Itemph
  BNE InitFCER  
  LDA Itempl
  AND #7
  CMP Itempl
  BNE InitFCER

  JSR SPI_PinNoToBit_F
  
  STA SPI_MOSI_Pin
  
  JSR   LAB_1C01						; scan for "," , else do syntax error then warm start

  JSR LAB_EVNM							; Get the MISO Pin
  JSR LAB_F2FX
  
  LDA #0							; Check if we are in range 0..7 or not.
  CMP Itemph
  BNE InitFCER  
  LDA Itempl
  AND #7
  CMP Itempl
  BNE InitFCER

  JSR SPI_PinNoToBit_F
  
  CMP SPI_MOSI_Pin						; Check for pin collisions.
  BEQ InitFCER
  
  STA SPI_MISO_Pin

  JSR   LAB_1C01						; scan for "," , else do syntax error then warm start

  BRA SPI_GetSCKPin_B


; This sits here to keep it in range.
InitFCER  
  JMP LAB_FCER


SPI_GetSCKPin_B    
  JSR LAB_EVNM							; Get the SCK Pin
  JSR LAB_F2FX
  
  LDA #0							; Check if we are in range 0..7 or not.
  CMP Itemph
  BNE InitFCER  
  LDA Itempl
  AND #7
  CMP Itempl
  BNE InitFCER

  JSR SPI_PinNoToBit_F
  
  CMP SPI_MOSI_Pin						; Check for pin collisions.
  BEQ InitFCER
  CMP SPI_MISO_Pin
  BEQ InitFCER
  
  STA SPI_SCK_Pin

  JSR   LAB_1C01						; scan for "," , else do syntax error then warm start
    
  JSR LAB_EVNM							; Get the SS Pin
  JSR LAB_F2FX
  
  LDA #0							; Check if we are in range 0..7 or not.
  CMP Itemph
  BNE InitFCER  
  LDA Itempl
  AND #7
  CMP Itempl
  BNE InitFCER

  JSR SPI_PinNoToBit_F
  
  CMP SPI_MOSI_Pin						; Check for pin collisions.
  BEQ InitFCER
  CMP SPI_MISO_Pin
  BEQ InitFCER
  CMP SPI_SCK_Pin
  BEQ InitFCER
  
  STA SPI_SS_Pin

  JSR   LAB_1C01						; scan for "," , else do syntax error then warm start
  
  JSR LAB_EVNM							; Get the SS Pin Active State
  JSR LAB_F2FX
  
  LDA #0							; Check if we are in range 0..1 or not.
  CMP Itemph
  BNE InitFCER  
  LDA Itempl
  AND #1
  CMP Itempl
  BNE InitFCER
  
  LDA #0
  STA SPI_In
  STA SPI_Out
  
  JSR SPI_Init_F
  RTS


; Sets a one in the specified bit position.
; Takes A 0..7 and moves a 1 up A to the specified position.
;
; Registers afffected: A, X, P

SPI_PinNoToBit_F
  TAX
  LDA #1

SPI_PinToBit_L
  CPX #0							; Loop while X!=0
  BEQ SPI_PinToBitDone_B
  ASL
  DEX
  BRA SPI_PinToBit_L
  
SPI_PinToBitDone_B
  RTS
  
  
  
SPI_Xfer_BASIC

  JSR LAB_F2FX							; Get our output value and put it in SPI_Out
  LDA Itemph
  BEQ SPI_XferSafe_B
  
  JMP LAB_FCER
  
SPI_XferSafe_B  
  LDA Itempl
  STA SPI_Out

  JSR SPI_Xfer_F						; Transmit out
  
  LDY SPI_In							; Copy recieved byte to Y
  JMP   LAB_1FD0                                		; convert Y to byte in FAC1 and return
