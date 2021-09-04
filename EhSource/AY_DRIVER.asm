; AY-3-891x Register Driver
;
; By Duncan Gunn.


; AY_6522 Registers

AY_6522_Base	 	=	$C0E0
AY_6522_ORB		=	AY_6522_Base
AY_6522_ORA		=	AY_6522_Base + $01
AY_6522_DDRB		=	AY_6522_Base + $02
AY_6522_DDRA		=	AY_6522_Base + $03
AY_6522_T1C_L		=	AY_6522_Base + $04
AY_6522_T1C_H		=	AY_6522_Base + $05
AY_6522_L1L_L		=	AY_6522_Base + $06
AY_6522_L1L_H		=	AY_6522_Base + $07
AY_6522_T2C_L		=	AY_6522_Base + $08
AY_6522_T2C_H		=	AY_6522_Base + $09
AY_6522_SR		=	AY_6522_Base + $0A
AY_6522_ACR		=	AY_6522_Base + $0B
AY_6522_PCR		=	AY_6522_Base + $0C
AY_6522_IFR		=	AY_6522_Base + $0D
AY_6522_IER		=	AY_6522_Base + $0E
AY_6522_ORA_IRA		=	AY_6522_Base + $0F


; AY_6522 HW Mappings.

AY_DATAPORT		=	AY_6522_ORB
AY_DDR_DATA		=	AY_6522_DDRB

AY_CTRLPORT		=	AY_6522_ORA
AY_DDR_CTRL		=	AY_6522_DDRA

AY_CTRL_bit_BC1		= 	@00000001
AY_CTRL_bit_BDIR	=	@00000010

AY_CTRL_dir		=	AY_CTRL_bit_BC1 | AY_CTRL_bit_BDIR	; Set relevant port bits as outputs
AY_DATA_out		=	$FF
AY_DATA_in		=	$0



; AY Registers

AY_CH_A_TP_FINE		= $0
AY_CH_A_TP_COARSE	= $1	; Bottom four bits only
AY_CH_B_TP_FINE		= $2
AY_CH_B_TP_COARSE	= $3	; Bottom four bits only
AY_CH_C_TP_FINE		= $4
AY_CH_C_TP_COARSE	= $5
AY_NOISE_PERIOD		= $6	; Bottom five bits only
AY_NOT_ENABLE		= $7	; Bitfield: See table 1 below
AY_CH_A_AMP		= $8	; M (Bit 5) when set uses the Envelope gen, otherwise B3-B0 sets the volume
AY_CH_B_AMP		= $9	; See channel A
AY_CH_C_AMP		= $A	; See channel A
AY_ENV_P_FINE		= $B	
AY_ENV_P_COARSE		= $C
AY_ENV_SH_CYC		= $D	; See table 2 below
AY_PORTA_REG		= $E	; Not implemented for the AY-3-8912
AY_PORTB_REG		= $F	; Not implemented for the AY-3-8912


; Table 1.  AY_NOT_ENABLE bitfield.
;
; +---------+-----------+-----------+
; | IN/nOUT |   nNOISE  |   nTONE   |
; +----+----+---+---+---+---+---+---+
; |IOB |IOA | C | B | A | C | B | A |
; +----+----+---+---+---+---+---+---+

AY_bit_nNOISE_C		= @00100000
AY_bit_nNOISE_B		= @00010000
AY_bit_nNOISE_A		= @00001000
AY_bit_nTONE_C		= @00000100
AY_bit_nTONE_B		= @00000010
AY_bit_nTONE_A		= @00000001


; Table 2.  Envelope shape/cycle bitfield.
;
; +--------+--------+--------+--------+--------+--------+--------+--------+
; |   B7   |   B6   |   B5   |   B4   |   B3   |   B2   |   B1   |   B0   |
; +--------+--------+--------+--------+--------+--------+--------+--------+
; |          B7-B4 Not used.          | Cont   | Attack | Alt    | Hold   |
; +--------+--------+--------+--------+--------+--------+--------+--------+
;
; CONTinue causes the pattern to cycle when set.
; Setting Attack makes the envelope counter count up, but when cleared causes a count down instead.
; Setting ALTernate causes the counter to reverse direction at the end of each cycle.
; Setting HOLD limits the envelope generator to one cycle

AY_bit_CONT		= @00001000
AY_bit_ATTACK		= @00000100
AY_bit_ALT		= @00000010
AY_bit_HOLD		= @00000001


; AY control modes

AY_INACK		= 0
AY_READ			= AY_CTRL_bit_BC1
AY_WRITE		= AY_CTRL_bit_BDIR
AY_LAT_ADDR		= AY_CTRL_bit_BC1 | AY_CTRL_bit_BDIR


; AY Soundcard memory allocations.

AY_Memstart		= $A00
AY_Reg			= AY_Memstart
AY_Data			= AY_Reg + 1


; AY_Initialisation routine.

AY_Init
  LDA #0
  STA AY_CTRLPORT	; Let's make our control port inactive first.
  LDA #AY_CTRL_dir
  STA AY_DDR_CTRL
  

  LDX #$F		; Clear all the registers
AY_Init_Loop

  LDA #0
  JSR AY_wr_to_reg
  DEX
  BNE AY_Init_Loop
  RTS
  

; AY register read-write primitives
;

; Writes the register address to the AY
;
; Takes A as the register parameter. Corrupts A
AY_wr_reg
  STA AY_DATAPORT	; Place our register value on the AY bus
  
  LDA #AY_DATA_out
  STA AY_DDR_DATA	; And ensure the bus is an output.
  
  LDA #AY_LAT_ADDR	; Latch our data to the AY
  STA AY_CTRLPORT
  ;NOP
  ;NOP
  LDA #AY_INACK		; And ensure out bus goes inactive again.
  STA AY_CTRLPORT
  RTS

; Writes data to the currently selected register
;
; Takes A as the register parameter. Corrupts A
AY_wr_data
  STA AY_DATAPORT	; Place our data on the AY bus

  LDA #AY_DATA_out
  STA AY_DDR_DATA
    
  LDA #AY_WRITE
  STA AY_CTRLPORT
  ;NOP
  ;NOP
  LDA #AY_INACK		; And ensure the bus is an output.
  STA AY_CTRLPORT
  RTS

; Read register		; Corrupts Y, returns the result in A.
AY_rd_data
  LDA #AY_DATA_in	; Make our bus an input so that the AY can drive it.
  STA AY_DDR_DATA
  
  LDA #AY_READ		; Set our AY to output it's register contents
  STA AY_CTRLPORT
  
  LDA AY_DATAPORT	; Grab those contents and put them in Y
  TAY
  
  LDA #AY_INACK		; Put our AY but back inactive.
  STA AY_CTRLPORT
  
  TYA			; Put our result back into A
  
  RTS			; Were finished.
  
  
; The 'All in one' function.
;
AY_wr_to_reg
  PHA
  TXA
  
  JSR AY_wr_reg
  PLA
  JSR AY_wr_data
  RTS
  

; For the users of BASIC, here's the easier read/write functions. 

AY_Userwrite
  LDA AY_Data
  LDX AY_Reg
  JSR AY_wr_to_reg
  RTS
  
AY_Userread
  LDA AY_Reg		; Select our register of interest.
  JSR AY_wr_reg
  
  JSR AY_rd_data	; Get the contents of the register of interest.
  STA AY_Data
  RTS