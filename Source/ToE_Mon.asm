
; Tower of Eightness OS
;
; 4/6/2023	Remove badly considered tape streaming feature from stream IO support.
;		Added a vector AY_Init_vec ($FFCC) for initialising the AY-3-8912 for the user.
;		Added a vector F_TAPE_SetKbd_vec ($FFBA) so that routines that directly call F_TAPE_GetByte can
;			break out from the correct input stream.  This wouldn't be needed had the tape routines
;			not been extremely timing critical.
; 5/6/2023	Added assembly switch for memory size question en/dis.
; 6/6/2023	Moved the Countdown timer memory start address to $A4A
;		Added some clearer configuration options.
;		Slightly tidied some code and comments.
;		Cleared the Countdown timer Command to IRQH_Service_CMD upon deactivation leaving it ready for
;			next triggering.
;		Moved the check on the countdown timer reaching zero to after the decrement to ensure it can't
;			be mistriggered by rapid reloading.
;		Added an optional Call vector to any address from the Counter.
;		Added a new Variable CTR_Options with two control bits:-
;			CTR_Reload_En	(b0)
;			CTR_vec_En	(b1)
;		See documentation for further details.
; 7/6/2023	Added some more IRQ Masking to tape routines to limit disruption caused by delays.
;			It would however be better if the tape routines took over the entire IRQ system and used
;			it to drive a much more stable set of loops.
;		Added the ability of CLS to set the current font attribute and for subsequent CLSs to remember it.
; 8/6/2023	Added bounds checking to many of the areas of RAM in use across most of the .asm files.
;		Corrected a few documentation bugs.
;		Changed the NMI and IRQ code so that it has redirectable vectors for TOTAL control.
; 10/6/2023	Spent some time optimising the ANSI_write function to make printint a little faster.
;		Started nearly from scratch with LPT and TPB support.  Basically, there's only the LPT stuff left
;			and that has been tweaked.
;		There is now an embedded BLOB plotting routine, though it remains to be seen if it has a place in ROM.
;			There is therefore, no vector for BLOB_Plot yet.
; 18/6/2023	Found and fixed a bug with SOUND in AY_DRIVER.asm which prevented noise from being controlled properly.
;		Removed BlobPlot from the ROM and placed it as a loadable resource.  It's relocatable code anyway.
; 24/6/2023	Added bounds checking to the PLOT command to prevent screen corruption associated with out-of-bounds PLOTs.
;		Added three new control bits for PLOTting:-
;			XTRA_CFG_silent_b   (b0).  Setting this means out of bounds PLOTs are ignored.
;			XTRA_CFG_capped_b   (b1).  Setting this means plots are restricted to 159 by 99 max.
;			XTRA_CFG_NoChecks_b (b2).  Setting this overrides the checks.
;		Fixed a bug where the NMI vector high byte was being stored to ROM.  Incorrect label used.
;


ROMSTART = $C100

; Configuration section.
;
MEMCHECK	= 0			; Options:	0 For no 'Memory size?'
					;		1 for 'Memory size?'
OUTSEL_DEFAULT	= ANSI_out_sw		;
					; Options:	ANSI_out_sw		: Prints to the ANSI video out
					;		ACIA1_out_sw		: Prints to ACIA1
					;		ACIA2_out_sw		: Prints to ACIA2
					;		TPB_Cen_out_sw		: Prints to Centronics
					;
					;		...These can be ORed together.
					;
INSEL_DEFAULT	= OS_input_ACIA1	; Choose only one of these Options:
					;
					; 		OS_input_ACIA1
					;		OS_input_ACIA2
					;________________________________________________________________________
C_DEFAULT_FONT	= @00000011		; B7     ! B6     ! B5     ! B4     ! B3     ! B2     ! B1     ! B0     !
					;------------------------------------------------------------------------
					;         !        !        !       !        ! DOUBLE !        !   80   !
					; GFX     ! SPARE  ! SPARE  ! SPARE ! SPARE  ! HEIGHT ! BOLD   ! COLUMN !
					;_________!________!________!_______!________!________!________!________!

					

  .include "basic_ToE.asm"
  
;IRQ_vec		= IRQH_ProcessIRQs		; IRQ code vector
;NMI_vec		= IRQ_vec+$0A           	; NMI code vector


; TowerOS System variables

MON_sysvars_base  	= $5E0			; Base address of the reserved base memory
MON_sysvars_lim		= $5EF			; Upper bound of reserved memory for this module.

os_outsel		= MON_sysvars_base	; output selection variable
os_infilt		= os_outsel+1		; Filter switches for character input filtering.
os_insel		= os_infilt+1		; Input source for BASIC inputs.
MON_CurrAttr		= os_insel + 1		; Current Font Attribute
IRQ_User_vec		= MON_CurrAttr +1
NMI_User_vec		= IRQ_User_vec + 2
ToE_mon_vars_end	= NMI_User_vec + 1


  .IF [ ToE_mon_vars_end>MON_sysvars_lim ]
    .ERROR "Memory overrun in ToE_Mon.asm"
  .ENDIF



TOE_MemptrLo  = $E7				; General purpose memory pointer low byte
TOE_MemptrHi  = $E8				; General purpose memory pointer high byte


; OS Bit Definitions

ACIA1_out_sw	= @00000001
ANSI_out_sw	= @00000010
CEN_LPT_out_sw	= @00000100
ACIA2_out_sw	= @00001000
OS_input_ACIA1  = @00000001
OS_input_ACIA2  = @00001000


; now the code. This sets up the vectors, interrupt code,
; and waits for the user to select [C]old or [W]arm start.
;
; Also, during the running phase, the extra OS features are hosted here.

  .ROM_AREA ROMSTART,$FFFF
 
  *= $EA00                              ; Give ourselves room for the OS. Formerly F000
  .INCLUDE "ACIA.asm"
  .INCLUDE "ANSICARD.asm"
;  .INCLUDE "TPBCARD.asm"
  .INCLUDE "CenTPB.asm"
  .INCLUDE "TAPE_IO.asm"
  .INCLUDE "AY_DRIVER.asm"
  .INCLUDE "IRQ_Handler.asm"
  .INCLUDE "COUNTDOWN_IRQ.asm"
  .INCLUDE "XTRA_BASIC.asm"             ; Extra's for EhBASIC.
  .INCLUDE "I2C_Lib.asm"		; I2C Support
  .INCLUDE "SPI_Lib.asm"


; NMI_vec points here.

NMI_vec_dummy
  RTI


; RES_vec points here.

RES_vec
  SEI					; Ensure IRQ's are turned off.
  CLD					; clear decimal mode
  LDX #$FF				; empty stack
  TXS					; set the stack


  ; put the IRQ and MNI code in RAM so that it can be changed
  ;
  LDA #<IRQH_ProcessIRQs
  STA IRQ_User_vec
  LDA #>IRQH_ProcessIRQs
  STA IRQ_User_vec + 1

  LDA #<NMI_vec_dummy
  STA NMI_User_vec
  LDA #>IRQH_ProcessIRQs
  STA NMI_User_vec + 1


; Set up system timing function
;
  JSR IRQH_Handler_Init_vec		; Initialise the IRQ Handler

  LDA #<COUNTDOWN_IRQ			; Put the test IRQ address into the table at IRQ Location 0
  STA IRQH_CallReg
  LDA #>COUNTDOWN_IRQ
  STA IRQH_CallReg + 1
  LDA #0
  JSR IRQH_SetIRQ_vec
   
  CLI					; Enable IRQs globally.

  JSR CEN_Delay
  
  LDA #OUTSEL_DEFAULT			; Set our default output options. See config section at the top

  STA os_outsel				; Save our preference of output option.
  LDA #LF_filt_sw1
  STA os_infilt				; Switch on $A filtering on the ACIA.
  
  LDA #INSEL_DEFAULT			; Specify input source as ACIA1
  STA os_insel
  
  LDA #C_DEFAULT_FONT			; Set is our default screen attribute at bootup time
  STA MON_CurrAttr

  LDA #XTRA_DefaultPlot_C		; Set up the PLOT configuration.
  STA V_XTRA_Config

  
; Set up TowerBASIC vectors, copy them to page 2

  LDY #END_CODE-LAB_vec			; set index/count
LAB_stlp
  LDA LAB_vec-1,Y			; get byte from interrupt code
  STA VEC_IN-1,Y			; save to RAM
  DEY					; decrement index/count
  BNE LAB_stlp				; loop if more to do

  
; Initialise system components

  JSR INI_ACIA_SYS			; Init ACIAs. We currently need ACIA1 for the keyboard at startup.
  JSR ANSI_init_vec			; Initialise the ANSI text video card.
  JSR CEN_TPB_init_vec			; Init Centronics TPB card.
  JSR AY_Init_vec			; Initialise the AY sound system.
  JSR TAPE_init_vec			; Initialise TowerTAPE filing system.
  
    
; now do the signon message

  LDY #0
LAB_signon

  LDA LAB_mess,Y                      ; get byte from sign on message
  BEQ LAB_nokey                       ; exit loop if done

  JSR V_OUTP                          ; output character
  INY                                 ; increment index
  BNE LAB_signon                      ; loop, branch always

LAB_nokey
  JSR V_INPT                          ; call scan input device
  BCC LAB_nokey                       ; loop if no key

  AND #$DF                            ; mask xx0x xxxx, ensure upper case
  CMP #'W'                            ; compare with [W]arm start
  BEQ LAB_dowarm                      ; branch if [W]arm start

  CMP #'C'                            ; compare with [C]old start.
  BNE LAB_signon                      ; loop if not [C]old start

  JMP LAB_COLD                        ; do EhBASIC cold start

LAB_dowarm
  JMP LAB_WARM                        ; do EhBASIC warm start


; EhBASIC vector table
;
LAB_vec
  .word RD_char                       ; byte in from Selected source
  .word WR_char                       ; byte out to ACIA1
  .word TAPE_LOAD_BASIC_vec           ; null load vector for EhBASIC
  .word TAPE_SAVE_BASIC_vec           ; save vector for EhBASIC
  .word TAPE_VERIFY_BASIC_vec         ; verify vector for EhBASIC
  .word TAPE_CAT_vec                  ; cat vector for EhBASIC


; ToE input BASIC stream support.

RD_char  

INSEL_Check_ACIA1
  LDA os_insel                        ; Handle ACIA1 selected
  BIT #OS_input_ACIA1
  BEQ INSEL_Check_ACIA2
  JMP ACIA1in

INSEL_Check_ACIA2
  LDA os_insel  
  BIT #OS_input_ACIA2                 ; Handle ACIA2 selected
  BEQ INSEL_ResetSource
  JMP ACIA2in

INSEL_ResetSource
  LDA #OS_input_ACIA1                 ; Reset source
  STA os_insel
  
  LDA #$C                             ; and send a ^C to interrupt program flow.
  SEC
  RTS
  

; OS output stream management support.

WR_char
  PHP                                 ; Save our registers in case we need 'em
  PHX
  PHY
  PHA
  PHA
   
  LDA #ACIA1_out_sw
  BIT os_outsel
  BEQ no_ACIA1
  PLA
  JSR ACIA1out                         ; Print to ACIA1

  PHA
no_ACIA1  
  LDA #ACIA2_out_sw
  BIT os_outsel
  BEQ no_ACIA2
  PLA
  JSR ACIA2out				; Print to ACIA2
  
  PHA
no_ACIA2
  LDA #ANSI_out_sw
  BIT os_outsel
  BEQ no_ANSI
  PLA
  JSR ANSI_write_vec			; Print to ANSI video card
    
  PHA
no_ANSI
  LDA #CEN_LPT_out_sw
  BIT os_outsel
  BEQ MON_EndWRITE_B
  PLA
  JSR CEN_LPT_write			; Print to LPT.
  
  BRA MON_EndWRITE_B2

MON_EndWRITE_B
  PLA					; Clean up stack including restoring P and return.
MON_EndWRITE_B2
  PLA
  PLY
  PLX
  PLP
  RTS

  
; Tower string printing routine.

TOE_PrintStr
  LDY #0					; Initialise loop index.
TOE_PrintStr_L
  LDA (TOE_MemptrLo),Y				; Print character.
  BEQ TOE_DonePrinting
  JSR V_OUTP
  INY
  BRA TOE_PrintStr_L

TOE_DonePrinting
  RTS
  
MON_CLS  
  JSR LAB_GBYT					; Find out if we have extra parameters or not.
  						; Firstly checking if we have a null.
  BNE MON_AttribCLS				; Since we have nothing, we can continue with defaults
  
  BRA MON_DefaultCLS				; Else perform default CLS

; Handle attrib case
;
MON_AttribCLS  
  JSR LAB_EVNM					; evaluate expression and check is numeric,
						; else do type mismatch
  JSR LAB_F2FX					; save integer part of FAC1 in temporary integer.
  LDA Itemph
  BNE CLS_FCER
  					
  LDA Itempl					; Get our specified attribute
  STA MON_CurrAttr
  
MON_DefaultCLS  
  LDA #24					; Sent font attribute code
  JSR V_OUTP
  
MON_CLS_B  
  LDA MON_CurrAttr				; Get the current font attribute and send it.
  JSR V_OUTP
  
  LDA #12					; Clear the screen to apply the attribute.
  JSR V_OUTP
  RTS
  
CLS_FCER  
  JMP LAB_FCER
  
; TOE Hex printing routine.
;  
MON_PrintHexByte
  TAX						; Save the source for later
  
  ROR						; Get only the top nybble.
  ROR
  ROR
  ROR
  AND #$F
  
  JSR B_PrintHexDig				; Print high digit
  TXA
  
  AND #$F					; Now print low digit
  JSR B_PrintHexDig
  RTS
  
B_PrintHexDig
  TAY
  LDA MON_HexDigits_T,Y
  JSR V_OUTP
  RTS
  
END_CODE

MON_HexDigits_T  
  .byte "0123456789ABCDEF"


LAB_mess
                                      ; sign on string

  .byte $0D,$0A,$B0,$B1,$B2,$DB," Tower of Eightness OS 24.6.2023.7 ",$DB,$B2,$B1,$B0,$0D,$0A,$0D,$0A
  .byte "[C]old/[W]arm?",$00

END_SOS

; IRQ Vectors
  *= $FF3C
IRQ_vec
  JMP (IRQ_User_vec)
NMI_vec
  JMP (NMI_User_vec)
  

; ACIA Vectors
  *= $FF42
ACIA_INI_SYS_vec
  JMP INI_ACIA_SYS         ; FF42
ACIA1_init_vec
  JMP INI_ACIA1            ; FF45
ACIA2_init_vec
  JMP INI_ACIA1            ; FF48
ACIA1out_vec
  JMP ACIA1out             ; FF4B
ACIA2out_vec
  JMP ACIA2out             ; FF4E
ACIA1in_vec
  JMP ACIA1in              ; FF51
ACIA2in_vec
  JMP ACIA2in              ; FF54

; ToE OS Vectors
  *= $FF57
SPI_Struct_Init_vec
  JMP SPI_Struct_Init_F    ; FF57
SPI_Init_vec
  JMP SPI_Init_F           ; FF5A
SPI_Xfer_vec
  JMP SPI_Xfer_F           ; FF5D


  *= $FF60
; Stream output vector.  

TOE_PrintStr_vec
  JMP TOE_PrintStr         ; FF60
  
  
; TAPE subsystem vectors

TAPE_Leader_vec
  JMP F_TAPE_Leader        ; FF63
TAPE_BlockOut_vec
  JMP F_TAPE_BlockOut      ; FF66
TAPE_ByteOut_vec
  JMP F_TAPE_ByteOut       ; FF69
TAPE_BlockIn_vec
  JMP F_TAPE_BlockIn       ; FF6C
TAPE_ByteIn_vec
  JMP F_TAPE_GetByte       ; FF6F
TAPE_init_vec
  JMP F_TAPE_Init          ; FF72
TAPE_CAT_vec  
  JMP F_TAPE_CAT           ; FF75
TAPE_SAVE_BASIC_vec
  JMP F_TAPE_SAVE_BASIC    ; FF78
TAPE_LOAD_BASIC_vec  
  JMP F_TAPE_LOAD_BASIC    ; FF7B
TAPE_VERIFY_BASIC_vec
  JMP F_TAPE_VERIFY_BASIC  ; FF7E


; I2C subsystem vectors

I2C_Init_vec               ; FF81
  JMP I2C_Init
I2C_Start_vec              ; FF84
  JMP I2C_Start
I2C_Stop_vec               ; FF87
  JMP I2C_Stop
I2C_Out_vec                ; FF8A
  JMP I2C_Out
I2C_In_vec                 ; FF8D
  JMP I2C_In
; No gap between this and the next lot.

; ANSI Card vectors

  *= $FF90

ANSI_init_vec
  JMP ANSI_INIT            ; FF90
ANSI_write_vec
  JMP ANSI_write           ; FF93
  

; Centronics/TPB vectors. Not many here RN, the fat has been trimmed

CEN_TPB_init_vec
  JMP CEN_TPB_INIT         ; FF96
CEN_LPT_write_vec
  JMP CEN_LPT_write        ; FF99

  

; Extra TAPE sytem vector
  *= $FFBA
TAPE_SetKbd_vec            ; FFBA
  JMP TAPE_SetKbd  

  *= $FFCC
; AY Soundcard vectors.

AY_Init_vec                ; FFCC
  JMP AY_Init
AY_Userwrite_16_vec        ; FFCF
  JMP AY_Userwrite_16
AY_Userread_16_vec         ; FFD2
  JMP AY_Userread_16
AY_Userwrite_vec           ; FFD5
  JMP AY_Userwrite
AY_Userread_vec            ; FFD8
  JMP AY_Userread


; IRQ Handler Subsystem vectors
  
IRQH_Handler_Init_vec	   ; FFDB
  JMP IRQH_Handler_Init_F
IRQH_SetIRQ_vec		   ; FFDE
  JMP IRQH_SetIRQ_F
IRQH_ClrIRQ_vec		   ; FFE1
  JMP IRQH_ClrIRQ_F
IRQH_SystemReport_vec	   ; FFE4
  JMP IRQH_SystemReport_F
  
; Timer System vectors

INIT_COUNTDOWN_IRQ_vec	   ; FFE7
  JMP INIT_COUNTDOWN_IRQ
  

; Processor hardware vectors.  These are fixed in hardware and cannot be moved.

  *= $FFFA

  .word NMI_vec                ; NMI vector
  .word RES_vec                ; RESET vector
  .word IRQ_vec                ; IRQ vector

