
; Tower of Eightness OS


  .include "basic_ToE.asm"
; put the IRQ and MNI code in RAM so that it can be changed

IRQ_vec       = VEC_SV+2              ; IRQ code vector
NMI_vec       = IRQ_vec+$0A           ; NMI code vector


; OS System variables live here

MON_sysvars   = $5E0                  ; base address of the 16 bytes of memory reserved
os_outsel     = MON_sysvars           ; output selection variable


; OS Bit Definitions

ACIA_out_sw   = @00000001
ANSI_out_sw   = @00000010
TPB_out_sw    = @00000100


; now the code. This sets up the vectors, interrupt code,
; and waits for the user to select [C]old or [W]arm start.
;
; Also, during the running phase, the extra OS features are hosted here.

  .ROM_AREA $C100,$FFFF
  
  *= $FD00                            ; Give ourselves 3 pages for the OS.
  .INCLUDE "ACIA.asm"
  .INCLUDE "ANSICARD.asm"
  .INCLUDE "TPBCARD.asm"
;  .INCLUDE "SIM_ACIA.asm"
; reset vector points here

RES_vec
  CLD                                 ; clear decimal mode
  LDX #$FF                            ; empty stack
  TXS                                 ; set the stack

  JSR TPB_delay
  
  LDA #ANSI_out_sw                    ; Set our default output options
  STA os_outsel                       ; to the ANSI card only.
  
  JSR INI_ACIA                        ; Init ACIA
  JSR ANSI_init_vec
  JSR TPB_init_vec                    ; Init Tower Peripheral Bus


; set up vectors and interrupt code, copy them to page 2

  LDY #END_CODE-LAB_vec               ; set index/count
LAB_stlp
  LDA LAB_vec-1,Y                     ; get byte from interrupt code
  STA VEC_IN-1,Y                      ; save to RAM
  DEY                                 ; decrement index/count
  BNE LAB_stlp                        ; loop if more to do


; now do the signon message, Y = $00 here

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


         ; flag no byte received
no_load                               ; empty load vector for EhBASIC
no_save                               ; empty save vector for EhBASIC
  RTS

; EhBASIC vector tables

LAB_vec
  .word ACIAin                        ; byte in from ACIA
  .word WR_char                       ; byte out to ACIA
  .word no_load                       ; null load vector for EhBASIC
  .word no_save                       ; null save vector for EhBASIC

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
  PHA
   
  LDA #ACIA_out_sw
  BIT os_outsel
  BEQ no_ACIA
  PLA
  JSR ACIAout                         ; Print to ACIA
  
  PHA
no_ACIA
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
  
  PLP
  RTS
  
no_TPB_LPT
  PLA
  PLP
  RTS

END_CODE

LAB_mess
                                      ; sign on string

  .byte $0C,$18,$02,$0D,$0A,"Tower of Eightness OS 23.7.2018.1",$0D,$0A,$0D,$0A
  .byte $0D,$0A,"6502 EhBASIC [C]old/[W]arm ?",$00

  *= $FFD0
ANSI_init_vec
  JMP ANSI_INIT
ANSI_write_vec
  JMP ANSI_write
TPB_init_vec
  JMP TPB_INIT
TPB_LPT_write_vec
  JMP TPB_LPT_write

; system vectors

  *= $FFFA

  .word NMI_vec                ; NMI vector
  .word RES_vec                ; RESET vector
  .word IRQ_vec                ; IRQ vector

