; Tape Interface Functions for ToE Tape and Joystick interface.

; Compatible with versions 1 and 1.1 of the interface as of 30/12/2020


; Tape interface bitfield definitions

TAPE_out		= @10000000			; This is the bit to toggle for tape writing.
TAPE_in			= @01000000			; This is the bit to sample for tape reading.
JOYSTICK_bits		= @00111111			; These bits are used by the joystick interface.
JOYSTICK_sel		= @00000001			; 0 selects Joystick 0, 1 selects joystick 2. Easy.

TAPE_Stat_overrun	= @00000001			; Stop bit was a one!
TAPE_Stat_par_err	= @00000010			; Parity error.  It remains to be seen if this gets implemented.
TAPE_Stat_RXFull	= @00000100			; Byte received
TAPE_Stat_Escape	= @00001000			; Indication that the escape key has been pressed

TAPE_BlockIn_Complete	= @00000001
TAPE_BlockIn_Escape	= @00000010
TAPE_BlockIn_Error	= @00000100

TAPE_Verify_Good	= @00000001
TAPE_Verify_Escape	= @00000010
TAPE_Verify_Error	= @00000100

; Tape interface port addresses

TAPE_IOBASE		= $C040				; Base address for our tape port.  This is normally set to whatever the GPIO card is.
TAPE_IOP		= TAPE_IOBASE			; We are currently using PORT B on the user port card for IO.
TAPE_DDRB		= TAPE_IOBASE + 2


; Tape system storage zeropage addresses
TAPE_temp		= $E4				; Let's use one of the zero page addresses
TAPE_BlockLo		= $E5
TAPE_BlockHi		= $E6

; Tape timing values.

; Please note that all this is subject to changes as and when needed because I'm in uncharted territory
; and don't quite know what I'm doing yet.


C_TAPE_Phasetime	= 8				; How long to wait between phases.  Bigger is slower
C_TAPE_Sample_Offset	= 20				; How far is the middle of the bit. Note: timing errors will cause this to stretch
C_TAPE_Bitlength	= 54				; How many passes for a full bit
C_TAPE_bitcycles	= 8				; Number of cycles to a bit
C_TAPE_BitsPerFrame	= 10				; Total number of bits per frame including start and stop bits.
C_TAPE_LeaderByte	= $AA				; Leader byte
C_TAPE_EndOfLeaderByte  = $55				; End of leader signal byte
C_TAPE_Interblock_pause = 45000				; How long between blocks to wait before starting the next one.

TAPE_Leader_Bytes	= 100				; Set leader length in bits.

; File type constants

C_TAPE_FType_BASIC	= 0				; BASIC program
C_TAPE_FType_BINARY	= 1				; Binary Data
C_TAPE_FType_TEXT	= 2				; Pure text.  NOTE: Good for merging snippets of code.


; System variables for tape routines.


; +================================+
; !                                !
; ! TAPE SPACE FROM $900 TO $AFF   !
; !                                !
; !                                !
; !                                !
; +================================+

TAPE_RAM_Start			= $900				; Base address of the tape filing system main memory

V_TAPE_BlockSize		= TAPE_RAM_Start		; 2 Byte address for block size
TAPE_temp2			= TAPE_RAM_Start + 2		; Second temporary store for tape functions.
TAPE_temp3			= TAPE_RAM_Start + 3		; Third temporary store for tape functions.
TAPE_temp4			= TAPE_RAM_Start + 4		; Fourth temporary store for tape functions.
TAPE_LineUptime			= TAPE_RAM_Start + 5		; How many passes of the superloop the line has been up.
TAPE_Demod_Status		= TAPE_RAM_Start + 6		; Demodulated bit status.
TAPE_Demod_Last			= TAPE_RAM_Start + 7		; Our previous demod status.  Used for edge detection etc.
TAPE_StartDet			= TAPE_RAM_Start + 8		; Start bit detected is 1, 0 otherwise
TAPE_RX_Status			= TAPE_RAM_Start + 9		; Receive engine status bitfield.
TAPE_BitsToDecode		= TAPE_RAM_Start + 10		; Bit countdown counter when decoding
TAPE_ByteReceived		= TAPE_RAM_Start + 11		; Last byte received
TAPE_Sample_Position		= TAPE_RAM_Start + 12		; Countdown timer for bit engine sample synchronization
TAPE_BlockIn_Status		= TAPE_RAM_Start + 13		; Status register for the F_TAPE_BlockIn function.

TAPE_Header_Buffer		= TAPE_BlockIn_Status + 1	; This is where the tape header data starts
TAPE_FileType			= TAPE_Header_Buffer		; This is the file type ID goes. 0 is for BASIC, otherwise ignored by LOAD.
TAPE_FileSizeLo			= TAPE_FileType + 1		; Low byte of the file size
TAPE_FileSizeHi			= TAPE_FileSizeLo + 1		; High byte of the file size
TAPE_LoadAddrLo			= TAPE_FileSizeHi + 1		; Low byte of the file load address
TAPE_LoadAddrHi			= TAPE_LoadAddrLo + 1		; High byte of the file load address
TAPE_FileName			= TAPE_LoadAddrHi + 1		; Null terminated filename field 17 bytes long.
TAPE_ChecksumLo			= TAPE_FileName + 17		; Checksum Low byte
TAPE_ChecksumHi			= TAPE_ChecksumLo + 1		; Checksum High byte
TAPE_Header_End			= TAPE_Header_Buffer + 31	; End of header space.

TAPE_CS_AccLo			= TAPE_Header_End + 1		; Tape checksum Accumulator low byte
TAPE_CS_AccHi			= TAPE_CS_AccLo + 1		; Tape checksum Accumulator high byte

V_TAPE_Phasetime		= TAPE_CS_AccHi + 1		; Tape phasetime variable
V_TAPE_Sample_Offset		= V_TAPE_Phasetime + 1		; Sample offset variable
V_TAPE_Bitlength		= V_TAPE_Sample_Offset + 1	; How long a bit is in passes variable
V_TAPE_bitcycles		= V_TAPE_Bitlength + 1		; Number of cycles to a bit variable

V_TAPE_Verify_Status		= V_TAPE_bitcycles + 1		; Status register for the F_TAPE_Verify function.







; Next is $934.

; +-------------------------------------------------------------------------------------------+
; +                                                                                           +
; +                              TAPE FILING SYSTEM MESSAGE STRINGS.                          +
; +                                                                                           +
; +-------------------------------------------------------------------------------------------+


TMSG_init_msg						; Filing System initialisation string.
 
  .BYTE $0C,1,$18,$03,$0D,$0A
  .BYTE "TowerTAPE Filing System",$0D,$0A
  .BYTE "V1.2",$0D,$0A,$0D,$0A,$00
  

TMSG_Ready

  .BYTE $D,$A
  .BYTE "Ready",$D,$A,0
  
  
TMSG_Saving

  .BYTE $D,$A
  .BYTE "Saving...",$D,$A,0
  
  
TMSG_Searching

  .BYTE $D,$A
  .BYTE "Searching...",$D,$A,0


TMSG_Loading

  .BYTE $D,$A
  .BYTE "Loading.",$D,$A,0
  
TMSG_Verifying

  .BYTE $D,$A
  .BYTE "Verifying.",$D,$A,0
  
TMSG_Verified

  .BYTE $D,$A
  .BYTE "Verified OK.",$D,$A,0
  
TMSG_VerifyError

  .BYTE $D,$A
  .BYTE "Verify Error",$D,$A,0

TMSG_TapeError

  .BYTE $D,$A
  .BYTE "Tape loading error.",$D,$A,0
  
TMSG_HeaderError  

  .BYTE $D,$A
  .BYTE "Header error. Retrying.",$D,$A,0



; +-------------------------------------------------------------------------------------------------+
; +                                                                                                 +
; +                        Functions for tape loading and saving start here.                        +
; +                        =================================================                        +
; +                                                                                                 +
; +                                                                                                 +
; +-------------------------------------------------------------------------------------------------+


;*****************************************************************************************
;**                                                                                     **
;**                                                                                     **
;**                HOUSEKEEPING AND INITIALISATION FUNCTIONS GO HERE.                   **
;**                                                                                     **
;**                                                                                     **
;*****************************************************************************************

F_TAPE_Init
  LDA #TAPE_out | JOYSTICK_sel				; Setup tape and joystick 6522 DDR Bits.
  STA TAPE_DDRB

  LDY #0						; Setup our index to the start of the string
  
L_TAPE_init_msg  
  LDA TMSG_init_msg,Y					; Get the character
  BEQ TAPE_msg_done					; Break out of the loop when we're done.
  
  JSR V_OUTP						; output character
  
  INY							; Do the next character
  JMP L_TAPE_init_msg

TAPE_msg_done  
  RTS
    

  


;*****************************************************************************************
;**                                                                                     **
;**                                                                                     **
;**          Helper and high level functions for tape loading and saving.               **
;**                                                                                     **
;**                                                                                     **
;*****************************************************************************************

F_TAPE_Getname						; Purpose, to get a filename for the tape header.

  RTS							; TODO:- Write this function.

F_TAPE_SAVE_BASIC
  
  LDA #<TMSG_Saving					; Tell the user that we are saving.
  STA TOE_MemptrLo
  LDA #>TMSG_Saving
  STA TOE_MemptrHi
  JSR TOE_PrintStr_vec

  JSR F_TAPE_GetBASIC_Size				; Start by measuring our program
  
  LDA V_TAPE_BlockSize					; Save our program size to the header
  STA TAPE_FileSizeLo
  LDA V_TAPE_BlockSize + 1
  STA TAPE_FileSizeHi
  
  LDA #<Ram_base					; Get our starting pointer for calculating our checksum loaded.
  STA TAPE_BlockLo
  LDA #>Ram_base
  STA TAPE_BlockHi
  
  JSR F_TAPE_CalcChecksum				; Get our checksum value

  LDA TAPE_CS_AccLo					; Store our calculated Checksum
  STA TAPE_ChecksumLo
  LDA TAPE_CS_AccHi
  STA TAPE_ChecksumHi
  
  LDA #<Ram_base					; Include the start of basic to the load address in the header
  STA TAPE_LoadAddrLo
  LDA #>Ram_base
  STA TAPE_LoadAddrHi
  
  LDA #C_TAPE_FType_BASIC				; Setup the file type in the header to BASIC
  STA TAPE_FileType
  
  LDA #<TAPE_Header_Buffer				; Setup our block pointer to the start of the header
  STA TAPE_BlockLo
  LDA #>TAPE_Header_Buffer
  STA TAPE_BlockHi
  
  LDA #0						; Load our blocksize with the size of our header buffer
  STA V_TAPE_BlockSize + 1
  LDA #TAPE_Header_End - TAPE_Header_Buffer
  STA V_TAPE_BlockSize
  
  JSR F_TAPE_Getname
  
  JSR F_TAPE_BlockOut					; Write our block to tape
  
  LDX #<C_TAPE_Interblock_pause				; Wait a little before writing the actual program data block.
  LDY #>C_TAPE_Interblock_pause
  JSR F_TAPE_Pause
  
  LDA TAPE_LoadAddrLo					; Transfer our start address to our Block pointer
  STA TAPE_BlockLo
  LDA TAPE_LoadAddrHi
  STA TAPE_BlockHi
  
  LDA TAPE_FileSizeLo					; Setup our blocksize counter
  STA V_TAPE_BlockSize
  LDA TAPE_FileSizeHi
  STA V_TAPE_BlockSize + 1
  
  JSR F_TAPE_BlockOut					; Write our file
    
  RTS							; We're done for now.
  
  

; Tape VERIFY routine.
; --------------------

F_TAPE_VERIFY_BASIC

 LDA #<TAPE_Header_Buffer				; Point to start of header buffer
  STA TAPE_BlockLo
  LDA #>TAPE_Header_Buffer
  STA TAPE_BlockHi
  
  LDA #TAPE_Header_End - TAPE_Header_Buffer		; Specify how big our header is.
  STA V_TAPE_BlockSize
  LDA #0
  STA V_TAPE_BlockSize + 1
  
  LDA #<TMSG_Searching					; Tell the user that we are searching.
  STA TOE_MemptrLo
  LDA #>TMSG_Searching
  STA TOE_MemptrHi
  JSR TOE_PrintStr_vec
  
  JSR F_TAPE_BlockIn					; Load the header block.

  LDA TAPE_BlockIn_Status				; Branch on non load conditions
  CMP #TAPE_Verify_Escape
  BEQ TAPE_BlockIn_EscHandler				; If escaping jump to the escape handler
  CMP #TAPE_Verify_Error
  BNE TAPE_BASIC_Verify_Stage

  LDA #<TMSG_HeaderError				; Tell the user of the header error and retry
  STA TOE_MemptrLo
  LDA #>TMSG_HeaderError
  STA TOE_MemptrHi
  JSR TOE_PrintStr_vec
  
  JMP F_TAPE_VERIFY_BASIC				; Keep coming back until the header is read valid or the user presses escape
  
TAPE_BASIC_Verify_Stage

  JSR F_TAPE_GetBASIC_Size				; Put our BASIC program size into V_TAPE_BlockSize.

  LDA TAPE_FileSizeLo					; Check our file is the same size as our stored program.
  CMP V_TAPE_BlockSize
  BNE TAPE_Verify_Error_B
  LDA TAPE_FileSizeHi
  CMP V_TAPE_BlockSize + 1
  BNE TAPE_Verify_Error_B
   
  LDA TAPE_FileSizeLo					; Tell the system how big the file to verify is.
  STA V_TAPE_BlockSize
  LDA TAPE_FileSizeHi
  STA V_TAPE_BlockSize + 1
  
  LDA #<Ram_base					; Tell the system where to start verifying the BASIC program,
  STA TAPE_BlockLo					; this should point to Ram_base.
  LDA #>Ram_base
  STA TAPE_BlockHi
  
  LDA #<TMSG_Verifying					; Tell the user that we are verifying.
  STA TOE_MemptrLo
  LDA #>TMSG_Verifying
  STA TOE_MemptrHi
  JSR TOE_PrintStr_vec 
    
  JSR F_TAPE_VerifyBlock				; Verify the BASIC program.

  LDA V_TAPE_Verify_Status				; Branch on non load conditions
  CMP #TAPE_Verify_Escape
  BEQ TAPE_BlockIn_EscHandler				; If escaping jump to the escape handler
  
  CMP #TAPE_Verify_Error				; Check if verify passed or not.
  BNE TAPE_BASIC_Verify_OK
  
TAPE_Verify_Error_B  
  LDA #<TMSG_VerifyError				; Inform the user of the verification error.
  STA TOE_MemptrLo
  LDA #>TMSG_VerifyError
  STA TOE_MemptrHi
  JSR TOE_PrintStr_vec
  RTS
  
TAPE_BASIC_Verify_OK
  LDA #<TMSG_Verified					; Inform the user of verification success.
  STA TOE_MemptrLo
  LDA #>TMSG_Verified
  STA TOE_MemptrHi
  JSR TOE_PrintStr_vec

TAPE_BASIC_Verify_Done  
  RTS
  






; Tape LOADing routine.
; ---------------------

TAPE_BlockIn_LoadErr
  LDA #<TMSG_TapeError					; Tell the user that we are have encountered an error.
  STA TOE_MemptrLo
  LDA #>TMSG_TapeError
  STA TOE_MemptrHi
  JSR TOE_PrintStr_vec
  RTS
TAPE_BlockIn_EscHandler
  LDA #<LAB_BMSG					; Tell the user that we are have pressed Escape.
  STA TOE_MemptrLo
  LDA #>LAB_BMSG
  STA TOE_MemptrHi
  JSR TOE_PrintStr_vec
  RTS
  
  
;To load BASIC call here.
  
F_TAPE_LOAD_BASIC

  LDA #<TAPE_Header_Buffer				; Point to start of header buffer
  STA TAPE_BlockLo
  LDA #>TAPE_Header_Buffer
  STA TAPE_BlockHi
  
  LDA #TAPE_Header_End - TAPE_Header_Buffer		; Specify how big our header is.
  STA V_TAPE_BlockSize
  LDA #0
  STA V_TAPE_BlockSize + 1
  
  LDA #<TMSG_Searching					; Tell the user that we are searching.
  STA TOE_MemptrLo
  LDA #>TMSG_Searching
  STA TOE_MemptrHi
  JSR TOE_PrintStr_vec

  JSR F_TAPE_BlockIn					; Load the header block.

  LDA TAPE_BlockIn_Status				; Branch on non load conditions
  CMP #TAPE_BlockIn_Escape
  BEQ TAPE_BlockIn_EscHandler				; If escaping jump to the escape handler
  CMP #TAPE_BlockIn_Error
  BNE TAPE_BASIC_Load_Stage

  LDA #<TMSG_HeaderError				; Tell the user of the header error and retry
  STA TOE_MemptrLo
  LDA #>TMSG_HeaderError
  STA TOE_MemptrHi
  JSR TOE_PrintStr_vec
  JMP F_TAPE_LOAD_BASIC
  

TAPE_BASIC_Load_Stage   
  LDA TAPE_FileSizeLo					; Tell the system how big the file to load is.
  STA V_TAPE_BlockSize
  LDA TAPE_FileSizeHi
  STA V_TAPE_BlockSize + 1
  
  LDA #<Ram_base					; Tell the system where to load the BASIC program. This should point to Ram_base
  STA TAPE_BlockLo
  LDA #>Ram_base
  STA TAPE_BlockHi
  
  LDA #<TMSG_Loading					; Tell the user that we are loading.
  STA TOE_MemptrLo
  LDA #>TMSG_Loading
  STA TOE_MemptrHi
  JSR TOE_PrintStr_vec
  
  JSR F_TAPE_BlockIn					; Load the BASIC program.
  
  LDA TAPE_BlockIn_Status				; Branch on non load conditions
  CMP #TAPE_BlockIn_Escape
  BEQ TAPE_BlockIn_EscHandler				; If escaping jump to the escape handler
  
  CMP #TAPE_BlockIn_Complete
  BEQ TAPE_BASIC_LoadingDone

  LDA #<TMSG_HeaderError				; Tell the user of the header error and retry
  STA TOE_MemptrLo
  LDA #>TMSG_HeaderError
  STA TOE_MemptrHi
  JSR TOE_PrintStr_vec
  JMP TAPE_BlockIn_LoadErr
  
TAPE_BASIC_LoadingDone  
  LDA #<Ram_base					; Setup our pointer to the start of BASIC Program memory
  STA TAPE_BlockLo
  LDA #>Ram_base
  STA TAPE_BlockHi
  
  JSR F_TAPE_CalcChecksum				; Get our checksum value into TAPE_CS_Acc_Lo and Hi
  
  LDA TAPE_ChecksumLo					; First we check the low byte.
  CMP TAPE_CS_AccLo
  BNE TAPE_CS_Fail
  
  LDA TAPE_ChecksumHi					; And then if necessary, we check the high byte.
  CMP TAPE_CS_AccHi
  BNE TAPE_CS_Fail

  LDA #<TMSG_Ready					; Inform the user they are back in immediate mode.
  STA TOE_MemptrLo
  LDA #>TMSG_Ready
  STA TOE_MemptrHi
  JSR TOE_PrintStr_vec

TAPE_BASICload_exit

  LDA TAPE_BlockLo					; Return the system to a useable state
  STA Svarl
  STA Sarryl
  STA Earryl
  LDA TAPE_BlockHi
  STA Svarh
  STA Sarryh
  STA Earryh
  JMP LAB_1319						; Tidy up system.
  
TAPE_CS_Fail
  LDA #<TMSG_TapeError					; Inform the user of their loading error.
  STA TOE_MemptrLo
  LDA #>TMSG_TapeError
  STA TOE_MemptrHi
  JSR TOE_PrintStr_vec
  BRA TAPE_BASICload_exit
  
  
F_TAPE_Pause

  NOP
  NOP
  NOP
  NOP
  NOP
  NOP
  NOP
  NOP
  
  DEX
  CPX #$FF
  BNE F_TAPE_Pause
  
  DEY
  CPY #0
  BNE F_TAPE_Pause
  
  RTS


F_TAPE_CalcChecksum

  LDX V_TAPE_BlockSize					; Set up our block counter
  LDY V_TAPE_BlockSize + 1
    
  LDA #0						; Clear the checksum accumulator
  STA TAPE_CS_AccLo
  STA TAPE_CS_AccHi

L_TAPE_CS_NEXT  
  LDA TAPE_CS_AccLo					; Add our byte to the checksum
  CLC
  ADC (TAPE_BlockLo)
  STA TAPE_CS_AccLo
  LDA TAPE_CS_AccHi
  ADC #0
  STA TAPE_CS_AccHi
  
  LDA TAPE_BlockLo					; Advance our pointer.
  CLC
  ADC #1
  STA TAPE_BlockLo
  LDA TAPE_BlockHi
  ADC #0
  STA TAPE_BlockHi
  
  DEX							; Repeat until 0
  CPX #$FF
  BNE CS_No_Y_update  
  DEY
CS_No_Y_update
  CPY #0
  BNE L_TAPE_CS_NEXT
  CPX #0
  BNE L_TAPE_CS_NEXT
  
  RTS


F_TAPE_GetBASIC_Size

  SEC
  LDA Svarl
  SBC #<Ram_base
  STA V_TAPE_BlockSize
  LDA Svarh
  SBC #>Ram_base
  STA V_TAPE_BlockSize + 1
  
  RTS


;*****************************************************************************************
;**                                                                                     **
;**                Timing and Synchronization functions go here.                        **
;**                ---------------------------------------------                        **
;**                                                                                     **
;*****************************************************************************************


; Wait for 50uS.  Note that JSR's cost 6 cycles

F_TAPE_Phasetime_pause
; Each pass takes 10 cycles unless across a page boundary then it's 11 for an error of 10%!!

; Also, we need to make up the loss of 12 Cycles in calling it and in theory also the variable loading
; at the time of the call.

; First we disregard 20 cycles, then we burn them at 10 cycles a pass.

  LDX #C_TAPE_Phasetime					; 2 Cycles
  DEX							; 2 Cycles saving 10
  DEX							; 2 Cycles saving 10
  NOP							; 2 Cycles
  NOP							; 2 Cycles
  NOP							; 2 Cycles
  NOP							; 2 Cycles
  
TAPE_Phasetime_loop
  DEX							; 2 Cycles
  NOP							; 2 Cycles
  NOP							; 2 Cycles
  NOP							; 2 Cycles
  BNE TAPE_Phasetime_loop				; 2 Cycles unless across pages.
  
  RTS							; 6 Cycles
  
  
  
  
;*****************************************************************************************
;**                                                                                     **
;**             Output Generating Functions.  Spoiler, It's all bitbashed!              **
;**             ----------------------------------------------------------              **
;**                                                                                     **
;*****************************************************************************************
  
    
;===============================================================================================
; TAPE Bit pulse generator  Takes the Z bit into consideration.


F_TAPE_BitGen

  LDY #C_TAPE_bitcycles					; Setup bitcycles loop
  
TAPE_bitcycles_loop
  PHA
  CMP #0
  BEQ TAPE_No_Pulse
  

  LDA #TAPE_out						; Set high phase
  STA TAPE_IOP
TAPE_No_Pulse
  JSR F_TAPE_Phasetime_pause				; Wait hightone time which is eight times phase time.
  JSR F_TAPE_Phasetime_pause				; This is so that the same loop can be used to capture the data for serial input
  JSR F_TAPE_Phasetime_pause
  JSR F_TAPE_Phasetime_pause
  JSR F_TAPE_Phasetime_pause
  JSR F_TAPE_Phasetime_pause
  JSR F_TAPE_Phasetime_pause
  JSR F_TAPE_Phasetime_pause
  

  

  LDA #0
  STA TAPE_IOP						; Set low phase
  JSR F_TAPE_Phasetime_pause				; Wait hightone time
  JSR F_TAPE_Phasetime_pause
  JSR F_TAPE_Phasetime_pause
  JSR F_TAPE_Phasetime_pause
  JSR F_TAPE_Phasetime_pause
  JSR F_TAPE_Phasetime_pause
  JSR F_TAPE_Phasetime_pause
  JSR F_TAPE_Phasetime_pause
  
  PLA
  DEY
  BNE TAPE_bitcycles_loop

  RTS
  
  
;===============================================================================================  
; Tape byte output routine LSb first.  Accumulator holds the current byte.

F_TAPE_ByteOut
  PHP								; Save and disable IRQ status.
  SEI
  
  PHA								; Generate start bit.
  LDA #1
  JSR F_TAPE_BitGen
  PLA

  LDX #8							; Set our bit counter for 8 bits.
  
TAPE_Nextbit
  PHA								; Save the byte for later use.
  PHX								; Save our counter
  
  AND #1							; Keep just the bit of interest.
  JSR F_TAPE_BitGen						; Output our bit.

  PLX								; Recover our counter
  PLA								; Recover our working byte out
  
  LSR								; Move on to the next bit
  DEX								; Decrement our counter
  
  BNE TAPE_Nextbit						; Keep going until completed.
  
  PHA								; Generate stop bit
  LDA #0
  JSR F_TAPE_BitGen
  LDA #0							; Generate first guard bit
  JSR F_TAPE_BitGen
  LDA #0							; Generate second guard bit
  JSR F_TAPE_BitGen
  LDA #0							; Generate third guard bit!
  JSR F_TAPE_BitGen
  LDA #0							; Generate fourth guard bit!
  JSR F_TAPE_BitGen
;  LDA #0							; Generate fifth guard bit!
;  JSR F_TAPE_BitGen
;  LDA #0							; Generate sixth guard bit!
;  JSR F_TAPE_BitGen
;  LDA #0							; Generate seventh guard bit!
;  JSR F_TAPE_BitGen
;  LDA #0							; Generate EIGHTH guard bit!
;  JSR F_TAPE_BitGen
  PLA
  
  PLP								; Restore IRQ status
  
  RTS


;===============================================================================================  
; Block output routine
;
; This requires the starting address and number of bytes output to operate.
; X contains the low byte of the count, Y contains the high byte and a two byte zero page variable
; holds the starting address, which is incremented as used.

F_TAPE_BlockOut

  JSR F_TAPE_Leader						; Generate block leader

  LDX V_TAPE_BlockSize						; Get the low byte of BlockStart
  LDY V_TAPE_BlockSize+1					; Get the high byte of BlockStart
  
L_TAPE_BlockOut
  
  LDA (TAPE_BlockLo)						; Get the byte to output to tape
  
  PHX
  PHY
  JSR F_TAPE_ByteOut						; Transmit the byte.
  PLY
  PLX
  
  LDA TAPE_BlockLo						; Increment our byte pointer
  CLC
  ADC #1
  STA TAPE_BlockLo
  LDA TAPE_BlockHi
  ADC #0
  STA TAPE_BlockHi

TAPE_BlockOut_DecCounter
  DEX
  CPX #$FF
  BNE TAPE_BlockOut_CheckZero_B
  DEY
  
TAPE_BlockOut_CheckZero_B
  CPY #0
  BNE L_TAPE_BlockOut
  CPX #0
  BNE L_TAPE_BlockOut

TAPE_BlockOut_Finish  
  RTS
  

;===============================================================================================  
; Tape leader_tone  

F_TAPE_Leader
  LDX #TAPE_Leader_Bytes				; Put the leader cycles low byte into X

TAPE_leader_lp
  PHX							; Save our cycle counter for later
  
  LDA #C_TAPE_LeaderByte
  JSR F_TAPE_ByteOut					; Send leader byte


  PLX							; Retrieve our counter

  DEX							; Decrement our counter
  BNE TAPE_leader_lp					; and loopback as necessary
  LDA #C_TAPE_EndOfLeaderByte
  JSR F_TAPE_ByteOut					; Send Terminating byte

  RTS


;*****************************************************************************************
;**                                                                                     **
;**              Input Generating Functions.  Spoiler, It's all bitbashed!              **
;**              ---------------------------------------------------------              **
;**                                                                                     **
;*****************************************************************************************


;===============================================================================================  
; Tape line status sampler, temporarily flipped  


F_TAPE_Sample_Tapeline
  LDA TAPE_IOP						; Get sample
  AND #TAPE_in
  
  BEQ TAPE_line_low					; Set or clear carry as needed.
  SEC
  RTS
  
TAPE_line_low
  CLC
  RTS


;===============================================================================================
; Pulse Decoding engine.  This is where deserialisation happens.

TAPE_PulseDecoder
  LDA TAPE_StartDet					; If the start bit has been detected
  BNE TAPE_SamplePos_Check				; Seek rising edge and end otherwise
  
  LDA TAPE_Demod_Status					; Detect rising edge
  BEQ TAPE_NotRising
  LDA TAPE_Demod_Last
  BNE TAPE_NotRising

  LDA #1						; Store rising edge signal
  STA TAPE_StartDet
  LDA #C_TAPE_Sample_Offset				; Start the counter for mid-bit
  STA TAPE_Sample_Position
  LDA #C_TAPE_BitsPerFrame
  STA TAPE_BitsToDecode

TAPE_NotRising
  RTS

TAPE_SamplePos_Check
  LDA #0						; Are we at the bit sample position
  CMP TAPE_Sample_Position
  BEQ TAPE_AtStartBit
  
  DEC TAPE_Sample_Position				; Decrement sample position end.
  RTS
  
TAPE_AtStartBit						; At start bit?
  LDA TAPE_BitsToDecode
  CMP #C_TAPE_BitsPerFrame
  BNE TAPE_AtStopBit
  
  LDA TAPE_Demod_Status					; Branch on start bit state.
  BNE TAPE_AdjustCountersStart
  
  LDA #0						; Path of invalid start bit.
  STA TAPE_StartDet					; Clear start condition
  STA TAPE_RX_Status					; and status register.
  RTS
  
TAPE_AdjustCountersStart
  LDA #C_TAPE_Bitlength					; Start the counter for the next bit to sample
  STA TAPE_Sample_Position
  DEC TAPE_BitsToDecode
  RTS
  
TAPE_AtStopBit						; Stop bit?
  LDA TAPE_BitsToDecode
  CMP #1
  BNE TAPE_AtDataBit

  LDA TAPE_Demod_Status
  BNE TAPE_Overrun
  
  LDA #0						; Clear Start detect bit
  STA TAPE_StartDet
  LDA #TAPE_Stat_RXFull					; Indicate byte received
  STA TAPE_RX_Status
  RTS
  
TAPE_Overrun
  LDA #0						; Clear Start detect bit
  STA TAPE_StartDet
  LDA #TAPE_Stat_overrun				; Indicate byte received
  STA TAPE_RX_Status
  RTS

TAPE_AtDataBit
  LDA TAPE_Demod_Status					; Shift our bit into the byte received LSb when not a stop bit
  ROR
  ROR TAPE_ByteReceived
  

  DEC TAPE_BitsToDecode					; Adjust counters accordingly
  LDA #C_TAPE_Bitlength
  STA TAPE_Sample_Position
 
  RTS
  
  


;*****************************************************************************************
;**                                                                                     **
;**           Tape Input Functions.  These are all hand calibrated so take care.        **
;**           ------------------------------------------------------------------        **
;**                                                                                     **
;*****************************************************************************************





F_TAPE_FindStart
  JSR F_TAPE_GetByte
  LDA TAPE_RX_Status
  
  CMP #TAPE_Stat_Escape						; Break on Escape condition
  BNE TAPE_LeaderNoBreak
  
  RTS
  
TAPE_LeaderNoBreak
  CMP #TAPE_Stat_overrun
  BEQ F_TAPE_FindStart
  
  LDA TAPE_ByteReceived
  CMP #C_TAPE_EndOfLeaderByte					; Keep trying until end of leader byte is received
  BNE F_TAPE_FindStart
  
  RTS




;===============================================================================================  
; Block read routine
;
; This requires the starting address and number of bytes output to operate.
; X contains the low byte of the count, Y contains the high byte and a two byte zero page variable
; holds the starting address, which is incremented as used.

F_TAPE_BlockIn

  JSR F_TAPE_FindStart						; Follow the leader signal
  
  LDA TAPE_RX_Status
  CMP #TAPE_Stat_Escape
  BEQ TAPE_BlockIn_Sig_Escape
  
  LDX V_TAPE_BlockSize						; Get the low byte of BlockStart
  LDY V_TAPE_BlockSize+1					; Get the high byte of BlockStart
  
  LDA #0							; Initialise BlockIn's status register
  STA TAPE_BlockIn_Status
  
L_TAPE_BlockIn

  PHX								; Get a byte from the tape interface
  PHY
  JSR F_TAPE_GetByte
  PLY
  PLX
  
  LDA TAPE_RX_Status						; failing gracefully upon bad events.
  CMP #TAPE_Stat_RXFull
  BEQ TAPE_BlockIn_Store
  
  CMP #TAPE_Stat_Escape
  BNE TAPE_BlockIn_CheckError
  
TAPE_BlockIn_Sig_Escape  
  LDA #TAPE_BlockIn_Escape
  STA TAPE_BlockIn_Status
  RTS								; Escape
  
TAPE_BlockIn_CheckError  
  LDA #TAPE_BlockIn_Error
  STA TAPE_BlockIn_Status
  RTS								; Failed  
  
TAPE_BlockIn_Store
  LDA TAPE_ByteReceived						; Store our received byte to our current pointer address.
  STA (TAPE_BlockLo)

  LDA TAPE_BlockLo						; Increment our byte pointer
  CLC
  ADC #1
  STA TAPE_BlockLo
  LDA TAPE_BlockHi
  ADC #0
  STA TAPE_BlockHi

TAPE_BlockIn_DecCounter
  DEX
  CPX #$FF
  BNE TAPE_CheckBlockInCounterZero_B
  DEY

TAPE_CheckBlockInCounterZero_B  
  CPY #0
  BNE L_TAPE_BlockIn
  CPX #0
  BNE L_TAPE_BlockIn

TAPE_BlockIn_Finish
  LDA #TAPE_BlockIn_Complete					; Indicate tast completion
  STA TAPE_BlockIn_Status
  RTS
  
 
; TODO:- The following appears to be dead-code, to be taken out soon. 
 
;TAPE_BytePumpIn							; Save the byte counter high byte  
;  JMP L_TAPE_BlockIn
  
;  RTS
   
  
F_TAPE_VerifyBlock

  JSR F_TAPE_FindStart						; Follow the leader signal
  
  LDA TAPE_RX_Status
  CMP #TAPE_Stat_Escape
  BEQ TAPE_Verify_Sig_Escape
  
  LDX V_TAPE_BlockSize						; Get the low byte of BlockStart
  LDY V_TAPE_BlockSize+1					; Get the high byte of BlockStart
  
  LDA #TAPE_Verify_Good						; Initialise Verify's status register
  STA V_TAPE_Verify_Status
  
L_TAPE_BlockVerify

  PHX								; Get a byte from the tape interface
  PHY
  JSR F_TAPE_GetByte
  PLY
  PLX
  
  LDA TAPE_RX_Status						; did we capture a good byte?
  CMP #TAPE_Stat_RXFull
  BEQ TAPE_Verify_Check
  
  CMP #TAPE_Stat_Escape						; Did we press escape?
  BNE TAPE_Verify_CheckError
  
TAPE_Verify_Sig_Escape  
  LDA #TAPE_Verify_Escape					; Signal that we pressed escape and return.
  STA V_TAPE_Verify_Status
  RTS
  
TAPE_Verify_CheckError						; Signal the encountered error and return.
  LDA #TAPE_Verify_Error
  STA V_TAPE_Verify_Status
  RTS  
  
TAPE_Verify_Check
  LDA TAPE_ByteReceived						; Compare our fectched byte with the one in BASIC memory.
  CMP (TAPE_BlockLo)
  BNE TAPE_Verify_CheckError					; Signal inconsistency as an error.
  
  LDA TAPE_BlockLo						; Increment our byte pointer
  CLC
  ADC #1
  STA TAPE_BlockLo
  LDA TAPE_BlockHi
  ADC #0
  STA TAPE_BlockHi

TAPE_Verify_DecCounter
  DEX
  CPX #$FF
  BNE TAPE_CheckCounterZero_B
  DEY
  
TAPE_CheckCounterZero_B
  CPY #0							; Check to see if we have done yet.
  BNE L_TAPE_BlockVerify
  CPX #0
  BNE L_TAPE_BlockVerify
  
TAPE_Verify_Finish
  LDA #TAPE_Verify_Good						; Indicate test completion
  STA V_TAPE_Verify_Status
  RTS














;===============================================================================================
; Byte Reader.

F_TAPE_GetByte

; First some initial housekeeping

  PHP							; Save and disable IRQ status
  SEI

  LDA #0
  STA TAPE_Demod_Status					; Start our bit demod with zero.
  STA TAPE_Demod_Last					; Set our initial demod status too.
  STA TAPE_LineUptime					; Set our initial uptime counter to zero.
  STA TAPE_RX_Status					; Clear our Status register
  
TAPE_pulselatch
  
  LDA TAPE_RX_Status
  BNE TAPE_ByteCaptured					; Check status for received byte.
  
  JSR ACIA1in						; Just in case the user needs to get out of this loop
  BCC TAPE_ContLoop					; Caught in a landsliiiide, no escape TO re-al-ih-teeeee!
  LDA #TAPE_Stat_Escape
  STA TAPE_RX_Status
  

TAPE_ByteCaptured
  PLP							; Restore IRQ status
  
  RTS							; Done


; Services that use the pulse decoded go here.

TAPE_ContLoop
  ; JSR TAPE_TestOutput					; Set our status
  JSR TAPE_PulseDecoder					; We gotta do something with these pulses right...?

  LDA TAPE_Demod_Status					; Update some variables
  STA TAPE_Demod_Last

; =-=-=-=-=-=-=-=-----------------=-=-=-=-=-=-=-=---------=-=-=-=-=-=-=-=-
;
; The actual pulse demodulation code starts here
;
; =-=-=-=-=-=-=-=-----------------=-=-=-=-=-=-=-=---------=-=-=-=-=-=-=-=-
  
  JSR F_TAPE_Phasetime_pause				; and delay for our respective looptime
  
  JSR F_TAPE_Sample_Tapeline				; Update status
  BCC TAPE_DontSet
  
  LDA #1
  STA TAPE_Demod_Status					; Set our line status to up
  LDA #10						; THIS WAS WORKING AT 7
  STA TAPE_LineUptime					; Reset our latch counter
  
TAPE_DontSet
  LDA TAPE_LineUptime
  BEQ TAPE_AtMinimum
  
  DEC TAPE_LineUptime
  JMP TAPE_pulselatch
    
TAPE_AtMinimum
  LDA #0						; Clear our line status
  STA TAPE_Demod_Status
  JMP TAPE_pulselatch







;#################################

; Test code here.

;#################################


; TAPE_TestOutput
;  LDA TAPE_StartDet
;  STA $C041
;  RTS



;  LDA TAPE_Sample_Position
;  BNE TAPE_Marker
;  LDA #1
;  STA $C041
;  RTS
;TAPE_Marker
;  LDA #0
  
;  LDA TAPE_Demod_Status

;  STA $C041

;  RTS
  
