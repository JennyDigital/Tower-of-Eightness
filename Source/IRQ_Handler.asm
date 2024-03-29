; IRQ Manager.
;
; Interrupt request handling and masking on per device basis.


; System constants

IRQH_Version_C		= 1					; Version 0 (Pre-release)


; IRQ Handler command codes
;
IRQH_Service_CMD	= 0					; Request IRQ Service
IRQH_Shutdown_CMD	= 1					; Shutdown IRQ gracefully
IRQH_Reset_CMD		= 2					; Reset the IRQ handler.


; IRQ Memory table.  Space Allocated $A20-$A49.  Used $A20-$A45.  Remaining: 4.
;
IRQH_Table_Base		= $A20 					; Beginning of IRQ Handler Memory.
IRQH_Table_lim		= $A49

IRQH_CallList		= IRQH_Table_Base			; All sixteen bytes for eight addresses.
IRQH_CallReg		= IRQH_CallList + 16			; Two bytes containing an address being transferred.
IRQH_ClaimsList		= IRQH_CallReg + 2			; Byte with list of calls that returned and IRQ Claim
IRQH_MaskByte		= IRQH_ClaimsList + 1			; Byte containing IRQ Table entry mask bits. IRQ entry LSb is IRQ entry 0.
IRQH_WorkingMask	= IRQH_MaskByte + 1			; Walking bit for masking and setting purposes.
IRQH_CurrentEntry	= IRQH_WorkingMask + 1			; Pointer for IRQ Table entries.
IRQH_CMD_Table		= IRQH_CurrentEntry + 1			; Table of IRQ handler commands with parameter space.  16 bytes.
IRQ_TableEnd		= IRQH_CMD_Table + 15			; Last address of IRQ Table



IRQH_zero_range_C	= IRQH_CurrentEntry+17-IRQH_CallReg	; Amount to zero after IRQH_CallList.

; Bounds checking.
;
  .IF [ IRQ_TableEnd>IRQH_Table_lim ]
    .ERROR "Memory overrun in IRQ_Handler.asm"
  .ENDIF




; IRQ Handler Initialisation Call
;
IRQH_Handler_Init_F
  SEI						; Disable IRQ's so we don't break anything already happening.
  
  LDA #<IRQH_Null_F				; Put the null IRQ Function address into IRQ_CallReg
  STA IRQH_CallReg
  LDA #>IRQH_Null_F
  STA IRQH_CallReg + 1
  
  LDA #7					; Point at the last table entry
  TAY						; and preserve it in Y.

IRQH_FillTable_L
  JSR IRQH_SetIRQ_F				; Iterate copy to whole table setting each entry to IRQH_Null_F
						; as a guard measure in case an unused entry is accidentaly enabled.
  TYA
  SEC
  SBC #1
  TAY
  
  BCS IRQH_FillTable_L
  
  LDA #0					; Clear rest of the IRQ Handler's structure.
  LDX #0
  
IRQH_FillRemaining_L
  LDA #IRQH_Service_CMD
  STA IRQH_CallReg,X
  INX
  
  
  CPX #IRQH_zero_range_C			; Repeat until the table is zerod.
  BNE IRQH_FillRemaining_L
  
  RTS						; Return to caller.
  
  
; IRQ Null function

IRQH_Null_F
  LDA IRQH_WorkingMask				; Get our Working position
  
  EOR #$FF					; Unset our Claim bit.
  AND IRQH_ClaimsList
  STA IRQH_ClaimsList
  
  RTS
  
  
  
; Enable/Disable Functions.
; -------------------------

; Function to atomically add an IRQ to the IRQ Table.
;
; A=Table Entry to set. IRQ_CallReg contains the pointer to the IRQ service function call entry point.
;
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
;
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
; --------------------
;
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