; AY-3-891x Register Driver
;
; By Jennifer Gunn.


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

AY_bit_nIOB		= @10000000
AY_bit_nIOA		= @01000000
AY_bit_nNOISE_C		= @00100000
AY_bit_nNOISE_B		= @00010000
AY_bit_nNOISE_A		= @00001000
AY_bit_nTONE_C		= @00000100
AY_bit_nTONE_B		= @00000010
AY_bit_nTONE_A		= @00000001
AY_AllOff		= @11111111


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


;AY SOUND command bits

AY_NoiseChBit_b		= @00000100
AY_SoundChBits_b	= @00000011
AY_NoiseAndChBits	= @00000111


; AY Soundcard memory allocations.

AY_Memstart		= $A00				; Beginning of AY driver memory allocations
AY_Mem_limit		= $A0F				; Last permitted memory location.

AY_Reg			= AY_Memstart
AY_Data			= AY_Reg             + 1	; 16-bit reg for purposes of including double register accesses.
AY_Mask			= AY_Data            + 2	; Used for managing which channels are enabled/disabled
AY_Channel		= AY_Mask            + 1	; Store of channel data for the TowerBASIC SOUND command.
AY_Period		= AY_Channel         + 1	; Stores the period data for the TowerBASIC SOUND command.
AY_Volume		= AY_Period          + 2	; Stores the Volume value for the SOUND command.
AY_Envelope_Period	= AY_Volume          + 1	; Store of period data for the TowerBASIC ENVELOPE command.
AY_Envelope_Mode 	= AY_Envelope_Period + 2	; Stores the mode parameter for the TowerBASIC ENVELOPE command.

AY_Mem_end		= AY_Envelope_Mode		; The calculated last byte consumed.


  .IF [ AY_Mem_end>AY_Mem_limit ]
    .ERROR "Memory overrun in AY_DRIVER.asm"
  .ENDIF


; AY_Initialisation routine.
;
AY_Init
  LDA #0
  STA AY_CTRLPORT				; Let's make our control port inactive first.
  LDA #AY_CTRL_dir
  STA AY_DDR_CTRL  

  LDX #$F					; Clear all the registers.
AY_Init_Loop

  LDA #0
  JSR AY_wr_to_reg
  DEX
  BNE AY_Init_Loop

  LDA #AY_NOT_ENABLE
  JSR AY_wr_to_reg

  LDA #AY_AllOff				; Set all our enable bits to disabled. Blissful quiet!
  STA AY_Mask
  LDX #AY_NOT_ENABLE
  JSR AY_wr_to_reg
    
  RTS


; Channel enable function.
;
AY_EnableCh
  AND #AY_NoiseAndChBits			; Get our channel selection, this includes noise.
  
  TAX						; Put our shift counter in X.
  LDA #1					; and set our enable bit to 1.
  
  CLC
AY_Enable_L					; Loop while X > 0.
  CPX #0
  BEQ AY_Enable_B				; including 0 times for channel A (0).
  
  DEX						; Moving the 0.
  ASL
  BRA AY_Enable_L

AY_Enable_B
  EOR #$FF					; Make sure our enable bit is 0.
  AND AY_Mask
  STA AY_Mask
  
  LDX #AY_NOT_ENABLE
  JSR AY_wr_to_reg
  RTS
  
  
; Channel disable function.

AY_DisableCh
  AND #AY_NoiseAndChBits			; Get our channel selection, this includes noise.
  
  TAX						; Put our shift counter in X.
  LDA #1					; and set our enable bit to 1.
  
  CLC
AY_Disable_L					; Loop while X > 0.
  CPX #0
  BEQ AY_Disable_B				; including 0 times for channel A (0).
  
  DEX						; Moving the 0.
  ASL
  BRA AY_Disable_L

AY_Disable_B
  ORA AY_Mask
  STA AY_Mask
  
  LDX #AY_NOT_ENABLE
  JSR AY_wr_to_reg
  RTS



; AY register read-write primitives
; ---------------------------------
;
; Writes the register address to the AY
;
; Takes A as the register parameter. Corrupts A
;
AY_wr_reg
  STA AY_DATAPORT	; Place our register value on the AY bus.
  
  LDA #AY_DATA_out
  STA AY_DDR_DATA	; And ensure the bus is an output.
  
  LDA #AY_LAT_ADDR	; Latch our data to the AY.
  STA AY_CTRLPORT
  
  LDA #AY_INACK		; And ensure out bus goes inactive again.
  STA AY_CTRLPORT
  RTS


; Writes data to the currently selected register.
;
; Takes A as the register parameter. Corrupts A
;
AY_wr_data
  STA AY_DATAPORT		; Place our data on the AY bus.

  LDA #AY_DATA_out
  STA AY_DDR_DATA
    
  LDA #AY_WRITE
  STA AY_CTRLPORT

  LDA #AY_INACK			; And ensure the bus is an output.
  STA AY_CTRLPORT
  RTS


; Read register.
;
; Corrupts Y, returns the result in A.
;
AY_rd_data
  LDA #AY_DATA_in		; Make our bus an input so that the AY can drive it.
  STA AY_DDR_DATA
  
  LDA #AY_READ			; Set our AY to output it's register contents.
  STA AY_CTRLPORT
  
  LDA AY_DATAPORT		; Grab those contents and put them in Y.
  TAY
  
  LDA #AY_INACK			; Put our AY but back inactive.
  STA AY_CTRLPORT
  
  TYA				; Put our result back into A.
  
  RTS				; Were finished.
  
  
; The 'All in one' function.  A contains the value, and X the register to write to.
;
AY_wr_to_reg
  PHA
  TXA
  
  JSR AY_wr_reg
  PLA
  JSR AY_wr_data
  RTS
  

; For the users of BASIC, here's the easier read/write functions. 
;
AY_Userwrite
  LDA AY_Data
  LDX AY_Reg
  JSR AY_wr_to_reg
  RTS
  
AY_Userread
  LDA AY_Reg				; Select our register of interest.
  JSR AY_wr_reg
  
  JSR AY_rd_data			; Get the contents of the register of interest.
  STA AY_Data
  RTS
  
AY_Userwrite_16
  LDA AY_Data
  LDX AY_Reg
  JSR AY_wr_to_reg
  INX
  LDA AY_Data + 1
  JSR AY_wr_to_reg
  RTS
  
AY_Userread_16
  LDA AY_Reg				; Select our register of interest.
  JSR AY_wr_reg
  
  JSR AY_rd_data			; Get the contents of the register of interest.
  STA AY_Data
  LDA AY_Reg				; Select our register of interest.

  SEC
  ADC #0
  
  JSR AY_wr_reg
  
  JSR AY_rd_data			; Get the contents of the register of interest.
  STA AY_Data + 1
  RTS
  


; *********************************************************************
;
;                       BASIC Extension commands
;
; *********************************************************************

; Sound command for BASIC
;
; Format: SOUND channel,period,vol
;
AY_SOUND

; Get channel.

  JSR LAB_EVNM					; evaluate expression and check is numeric,
						; else do type mismatch
  JSR LAB_F2FX					; save integer part of FAC1 in temporary integer
  
  LDA Itempl					; Get our channel parameter.
  STA AY_Channel				; And save them for the future.

  JSR LAB_1C01					; scan for "," , else do syntax error then warm start
  
  LDA AY_Channel				; Mug trap channel for over range values.
;  BIT #~[AY_NoiseChBit_b | AY_SoundChBits_b]
;  BNE AY_Parameter_FCER_B
  AND #$7F
  SEC
  SBC #6
  BPL AY_Parameter_FCER_B
    

; Get period.
;
  JSR LAB_EVNM					; evaluate expression and check is numeric,
						; else do type mismatch
  JSR LAB_F2FX					; save integer part of FAC1 in temporary integer
  
  LDA Itempl
  STA AY_Period
  LDA Itemph
  STA AY_Period + 1
  
  JSR LAB_1C01					; scan for "," , else do syntax error then warm start  
  
  
; Get volume
;  
  JSR LAB_EVNM					; evaluate expression and check is numeric,
						; else do type mismatch
  JSR LAB_F2FX					; save integer part of FAC1 in temporary integer
  
  LDA Itempl
  STA AY_Volume
  
  
; Enact upon sound parameters
;  
  LDA AY_Channel				; Set our period
  SEC
  SBC #3
  BMI AY_Snd_Tone_B
  
  LDX #AY_NOISE_PERIOD				; If our channel is between 3 and 5, set noise instead.

  LDA AY_Period					; First set our period.
  JSR AY_wr_to_reg
  
  BRA AY_SetVolAndCh_B
  
AY_Snd_Tone_B
  LDA AY_Channel				; Set period
  AND #AY_SoundChBits_b
  CLC
  ASL
  TAX
    
  LDA AY_Period
  JSR AY_wr_to_reg
  INX
  LDA AY_Period + 1
  JSR AY_wr_to_reg

AY_SetVolAndCh_B
  
  LDA AY_Channel				; Set our volume.

  SEC						; Check whether we are dealing with noise or tone.
  SBC #3
  BMI AY_ToneChVol_B
  
  BRA AY_DoVol_B

AY_ToneChVol_B

  LDA AY_Channel				; Put it back as we found it.
  
AY_DoVol_B

  CLC
  ADC #8
  TAX
  
  LDA AY_Volume
  JSR AY_wr_to_reg
  
  LDA AY_Channel				; Decide if we are enbling a channel or not.
  LDX AY_Volume
  CPX #0
  BNE AY_EnableCh_B
  
  JSR AY_DisableCh
  
  RTS
  
AY_EnableCh_B
  JSR AY_EnableCh
  RTS
 
AY_Parameter_FCER_B
  JMP LAB_FCER  
    

; ENVELOPE command.
;
; Format ENVELOPE period, mode  
;
AY_ENVELOPE

; Get period.

  JSR LAB_EVNM					; evaluate expression and check is numeric,
						; else do type mismatch
  JSR LAB_F2FX					; save integer part of FAC1 in temporary integer
  
  LDA Itempl
  STA AY_Envelope_Period
  LDA Itemph
  STA AY_Envelope_Period + 1
  
  JSR LAB_1C01					; scan for "," , else do syntax error then warm start

; Get mode
  
  JSR LAB_EVNM					; evaluate expression and check is numeric,
						; else do type mismatch
  JSR LAB_F2FX					; save integer part of FAC1 in temporary integer
  
  LDA Itempl
  STA AY_Envelope_Mode
  
  LDX #AY_ENV_P_FINE
  LDA AY_Envelope_Period
  JSR AY_wr_to_reg
  INX
  LDA AY_Envelope_Period + 1
  JSR AY_wr_to_reg
  
  LDA AY_Envelope_Mode
  LDX #AY_ENV_SH_CYC
  JSR AY_wr_to_reg
  RTS
