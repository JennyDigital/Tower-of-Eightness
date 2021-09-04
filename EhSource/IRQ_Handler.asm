; IRQ Manager.
;
; Interrupt request handling and masking on per device basis.


; System constants.  Presently only one exists.

IRQH_Version_C		= 0				; Version 0 (Pre-release)


; IRQ Memory table
;
IRQH_Table_Base		= $A20 				; Beginning of IRQ Handler Memory.
IRQH_CallList		= IRQH_Table_Base		; All sixteen bytes for eight addresses.
IRQH_CallReg		= IRQH_CallList + 16		; Two bytes containing an address being transferred.
IRQH_ClaimsList		= IRQH_CallReg + 2		; Byte with list of calls that returned and IRQ Claim
IRQH_MaskByte		= IRQH_ClaimsList + 1		; Byte containing IRQ Table entry mask bits. IRQ entry LSb is IRQ entry 0.
IRQH_WorkingMask	= IRQH_MaskByte + 1		; Walking bit for masking and setting purposes.
IRQH_CurrentEntry	= IRQH_WorkingMask + 1		; Pointer for IRQ Table entries.

; Table current size is 21 bytes.


; IRQ Handler Initialisation Call

IRQH_Handler_Init_F
  SEI						; Disable IRQ's so we don't break anything already happening.
  
  LDA #<IRQH_Null_F				; Put the null IRQ Function address into IRQ_CallReg
  STA IRQH_CallReg
  LDA #>IRQH_Null_F
  STA IRQH_CallReg + 1
  
  LDA #7					; Point at the last table entry
  TAY

IRQH_FillTable_L
  JSR IRQH_SetIRQ_F				; Iterate copy to whole table
  
  TYA
  SEC
  SBC #1
  TAY
  
  BCS IRQH_FillTable_L
  
  LDA #0					; Clear rest of the IRQ Handler's structure.
  STA IRQH_ClaimsList
  STA IRQH_MaskByte
  STA IRQH_WorkingMask
  STA IRQH_CurrentEntry
  
  RTS						; Return to caller.
  
  
; IRQ Null function

IRQH_Null_F
  LDA IRQH_WorkingMask				; Get our Working position
  
  EOR #$FF					; Unset our Claim bit.
  AND IRQH_ClaimsList
  STA IRQH_ClaimsList
  
  RTS
  

; Function to atomically add an IRQ to the IRQ Table.

IRQH_SetIRQ_F

  PHP						; Assure atomic
  SEI
  
  ASL						; Multiply our pointer by two as the table uses words not bytes.
  
  TAX						; Transfer our table reference to index X
  
  LDA IRQH_CallReg				; Get our call low-byte
  STA IRQH_CallList,X				; Store our low byte
  
  LDA IRQH_CallReg + 1				; Get our call high-byte
  INX
  STA IRQH_CallList,X				; Store our high byte.
  
  PLP						; End atomic operation
  RTS
  
  
; Function to atomically clear an IRQ from the table

IRQH_ClrIRQ_F
  PHP						; Assure atomic
  SEI

  ASL						; Multiply our pointer by two
  TAX						; and place it in X

  LDA #<IRQH_Null_F				; Transfer our Null function address to the table
  STA IRQH_CallList,X
  LDA #>IRQH_Null_F
  INX
  STA IRQH_CallList,X
  
  PLP						; End atomic operation
  RTS
  
  
; IRQ Handler function.

IRQH_ProcessIRQs
  PHA						; Save processor registers
  PHX
  PHY
  
  CLD						; We have no idea what mode the processor was in when this was called so let's clear it.
  
  LDA IRQH_MaskByte				; Get IRQ mask
  BEQ IRQH_FinishIRQs_B				; and quit early if all disabled.
  
  LDA #1					; Put 1 into our working mask
  STA IRQH_WorkingMask				

  LDX #0					; Start with X at table entry 0
  
IRQH_CheckCall_B  
  LDA IRQH_MaskByte				; Check if we need to call that table entry or not
  AND IRQH_WorkingMask
  BEQ IRQH_SkipCall_B
  

  LDA #>IRQH_Return_B				; Place our return address-1 on the stack for the ensuing RTS (which adds 1)
  PHA
  LDA #<IRQH_Return_B
  PHA
  
  JMP (IRQH_CallList,X)				; Make the call, including the table offset
  
IRQH_Return_B					; Since the 65C02 won't JSR to our chosen address, this is the return address
  NOP						; non executed packer.  It's cheaper than the arithmetic approach.

IRQH_SkipCall_B
  INC IRQH_CurrentEntry				; Advance to the next table entry
  INX
  INX
  
  TXA						; Have we processed them all?
  CMP #16					; If so, we shall go to the finish-line.
  BEQ IRQH_FinishIRQs_B
  
  CLC						; Move our working mask to the next IRQ
  ROL IRQH_WorkingMask
  
  BRA IRQH_CheckCall_B				; Check the next call.
  
IRQH_FinishIRQs_B
  PLY						; Retrieve processor registers
  PLX
  PLA
  
  RTI
  
  
; Function to return table base address and version number.
; Used for keeping programs compatible over generational changes.

IRQH_SystemReport_F

  LDA #IRQH_Version_C
  LDX #<IRQH_Table_Base
  LDY #>IRQH_Table_Base
  RTS