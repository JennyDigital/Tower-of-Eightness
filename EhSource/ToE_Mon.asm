
; Tower of Eightness OS


  .include "basic_ToE.asm"
; put the IRQ and MNI code in RAM so that it can be changed

; IRQ_vec	= VEC_SV+2              ; Previous IRQ code vector
IRQ_vec		= IRQH_ProcessIRQs	; IRQ code vector
NMI_vec		= IRQ_vec+$0A           ; NMI code vector


; OS System variables live here

MON_sysvars   = $5E0			; base address of the 16 bytes of memory reserved
os_outsel     = MON_sysvars		; output selection variable
os_infilt     = os_outsel+1		; Filter switches for character input filtering.

TOE_MemptrLo  = $E7			; General purpose memory pointer low byte
TOE_MemptrHi  = $E8			; General purpose memory pointer high byte


; OS Bit Definitions

ACIA1_out_sw	= @00000001
ANSI_out_sw	= @00000010
TPB_out_sw	= @00000100
ACIA2_out_sw	= @00001000
TAPE_out_sw	= @00010000


; now the code. This sets up the vectors, interrupt code,
; and waits for the user to select [C]old or [W]arm start.
;
; Also, during the running phase, the extra OS features are hosted here.

  .ROM_AREA $C100,$FFFF
  
  *= $F000                            ; Give ourselves room for the OS.
  .INCLUDE "ACIA.asm"
  .INCLUDE "ANSICARD.asm"
  .INCLUDE "TPBCARD.asm"
  .INCLUDE "TAPE_IO.asm"
  .INCLUDE "AY_DRIVER.asm"
  .INCLUDE "IRQ_Handler.asm"
  .INCLUDE "COUNTDOWN_IRQ.asm"


; reset vector points here

RES_vec
  SEI					; Ensure IRQ's are turned off.
  CLD					; clear decimal mode
  LDX #$FF				; empty stack
  TXS					; set the stack


; Set up system timing function

  JSR IRQH_Handler_Init_vec		; Initialise the IRQ Handler

  LDA #<COUNTDOWN_IRQ			; Put the test IRQ address into the table at IRQ Location 0
  STA IRQH_CallReg
  LDA #>COUNTDOWN_IRQ
  STA IRQH_CallReg + 1
  LDA #0
  JSR IRQH_SetIRQ_vec
   
  CLI					; Enable IRQs globally.

  JSR TPB_delay
  
  LDA #ANSI_out_sw                    ; Set our default output options for ANSI output mode.
;  LDA #ACIA_out_sw                   ; Set our default output options for ACIA output mode.
  STA os_outsel                       ; to the ANSI card only.
  LDA #LF_filt_sw1
  STA os_infilt                       ; Switch on $A filtering on the ACIA.
  
  JSR INI_ACIA1                       ; Init ACIA1. We currently need this for the keyboard.
  JSR INI_ACIA2                       ; Init ACIA2. Just in case.
  JSR ANSI_init_vec                   ; Initialise the ANSI text video card.
  JSR TPB_init_vec                    ; Init Tower Peripheral Bus
  JSR AY_Init                         ; Initialise the AY sound system.
  
; set up vectors and interrupt code, copy them to page 2

  LDY #END_CODE-LAB_vec               ; set index/count
LAB_stlp
  LDA LAB_vec-1,Y                     ; get byte from interrupt code
  STA VEC_IN-1,Y                      ; save to RAM
  DEY                                 ; decrement index/count
  BNE LAB_stlp                        ; loop if more to do

  
; Initialise filing system

  JSR TAPE_init_vec                   ; Initialise TowerTAPE filing system.
    
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


; EhBASIC vector tables

LAB_vec
  .word ACIA1in                       ; byte in from ACIA1
  .word WR_char                       ; byte out to ACIA1
  .word TAPE_LOAD_BASIC_vec           ; null load vector for EhBASIC
  .word TAPE_SAVE_BASIC_vec           ; save vector for EhBASIC
  .word TAPE_VERIFY_BASIC_vec         ; verify vector for EhBASIC
  

; EhBASIC IRQ support

IRQ_CODE
  PHA                                 ; save A
  LDA IrqBase                         ; get the IRQ flag byte
  LSR                                 ; shift the set b7 to b6, and on down ...
  ORA IrqBase                         ; OR the original back in
  STA IrqBase                         ; save the new IRQ flag byte
  PLA                                 ; restore A
  RTI


; EhBASIC NMI support

NMI_CODE
  PHA                                 ; save A
  LDA NmiBase                         ; get the NMI flag byte
  LSR                                 ; shift the set b7 to b6, and on down ...
  ORA NmiBase                         ; OR the original back in
  STA NmiBase                         ; save the new NMI flag byte
  PLA                                 ; restore A
  RTI


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
  JSR ACIA2out                         ; Print to ACIA1
  
  PHA
no_ACIA2
  LDA #ANSI_out_sw
  BIT os_outsel
  BEQ no_ANSI
  PLA
  JSR ANSI_write_vec                  ; Print to ANSI video card
    
  PHA
no_ANSI
  LDA #TPB_out_sw
  BIT os_outsel
  BEQ no_TPB_LPT
  PLA
  JSR TPB_LPT_write_vec               ; Print to TPB LPT card

  PHA  
no_TPB_LPT                            ; "Print" to the TAPE interface
  LDA #TAPE_out_sw
  BIT os_outsel
  BEQ MON_EndWRITE_B                  ; Dont write to tape unless selected.
  PLA
  JSR TAPE_ByteOut_vec
  
  BRA MON_EndWRITE_B2

MON_EndWRITE_B
  PLA                                   ; Clean up stack including restoring P and return.
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
  
END_CODE

LAB_mess
                                      ; sign on string

  .byte "Tower of Eightness OS 31.10.2021.3",$0D,$0A,$0D,$0A
  .byte $0D,$0A,"6502 EhBASIC [C]old/[W]arm ?",$00


; ToE OS Vectors

  *= $FF60
; Stream output vector.  

TOE_PrintStr_vec
  JMP TOE_PrintStr         ; FF60

  
; ... existing vectors continue from here.

  *= $FF90

; ANSI Card vectors

ANSI_init_vec
  JMP ANSI_INIT            ; FF90
ANSI_write_vec
  JMP ANSI_write           ; FF93
  

; Tower Peripheral Bus vectors

TPB_init_vec
  JMP TPB_INIT             ; FF96
TPB_LPT_write_vec
  JMP TPB_LPT_write        ; FF99
TPB_tx_byte_vec
  JMP TPB_tx_byte          ; FF9C
TPB_tx_block_vec
  JMP TPB_tx_block         ; FF9F
TPB_ATN_handler_vec
  JMP TPB_ATN_handler      ; FFA2
TPB_rx_byte_vec  
  JMP TPB_rx_byte          ; FFA5
TPB_rx_block_vec
  JMP TPB_rx_block         ; FFA8
TPB_Dev_Presence_vec
  JMP TPB_Dev_Presence     ; FFAB
TPB_Req_Dev_Type_vec
  JMP TPB_Req_Dev_Type     ; FFAE
TPB_dev_select_vec
  JMP TPB_dev_select       ; FFB1
TPB_Ctrl_Blk_Wr_vec
  JMP TPB_Ctrl_Blk_Wr      ; FFB4
TPB_Ctrl_Blk_Rd_vec
  JMP TPB_Ctrl_Blk_Rd      ; FFB7


; TAPE subsystem vectors

TAPE_Leader_vec
  JMP F_TAPE_Leader        ; FFBA
TAPE_BlockOut_vec
  JMP F_TAPE_BlockOut      ; FFBD
TAPE_ByteOut_vec
  JMP F_TAPE_ByteOut       ; FFC0
TAPE_BlockIn_vec
  JMP F_TAPE_BlockIn       ; FFC3
TAPE_ByteIn_vec
  JMP F_TAPE_GetByte       ; FFC6
TAPE_init_vec
  JMP F_TAPE_Init          ; FFC9
TAPE_SAVE_BASIC_vec  
  JMP F_TAPE_SAVE_BASIC    ; FFCC
TAPE_LOAD_BASIC_vec  
  JMP F_TAPE_LOAD_BASIC    ; FFCF
TAPE_VERIFY_BASIC_vec
  JMP F_TAPE_VERIFY_BASIC  ; FFD2


; AY Soundcard vectors.
  
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

