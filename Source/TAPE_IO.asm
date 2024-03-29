; Tape Interface Functions for ToE Tape and Joystick interface.

; Compatible with versions 1 and 1.1 of the interface as of 30/12/2020

; Amendments and additions since 3/6/2023
;
; Firstly, I must apologise.  I have not been logging all my changes well and therefore breakage could take
; longer to identify.  It is with this in mind that this in-code log has been created.
;
; 3/6/2023:	Added the ability to execute a binary upon LOADing.  It is the users responsibility to ensure
;		it will operate correctly at the loaded address, either through making it relocatable or by
;		loading it at an appropriate address.  Execution starts at the load address and there is now a
;		new configuration bit associated for preventing execution of !binary files upon LOADing.
;		
;		This new configuration bit is called TAPE_AutoEXEC_En and is on by default.
;
; 4/6/2023:	Adjusted the system by which LOAD, VERIFY and CAT escape such that the currently selected input
;		stream escapes it.  Timings in the F_TAPE_GetByte routine are so ridiculously critical that it
;		has to be done by adjusting a vector in RAM.  This implies that getbyte and putbyte operations
;		need to be handled by a hardware timer/counter for better and more reliable operation.
;
;		THIS IS BECOMING AN URGENT CHANGE.
;
; 5/6/2023:	Added initial support for ccflag to prevent unwanted Breaks
;		Break from a BASIC LOAD now also performs a NEW.
; 6/6/2023:	Changed a function label to better reflect its use cases. Was TAPE_BlockIn_EscHandler
; 			but is now TAPE_BlockIO_EscHandler.
; 7/6/2023:	Tape errors for Binary files now report line numbers if LOADed from within a running program.



; Tape interface hardware bitfield definitions

TAPE_out		= @10000000			; This is the bit to toggle for tape writing.
TAPE_in			= @01000000			; This is the bit to sample for tape reading.
JOYSTICK_bits		= @00111111			; These bits are used by the joystick interface.
JOYSTICK_sel		= @00000001			; 0 selects Joystick 0, 1 selects joystick 2. Easy.


; Tape engine status bitfield definitions

TAPE_Stat_overrun	= @00000001			; Stop bit was a one!
TAPE_Stat_par_err	= @00000010			; Parity error.  It remains to be seen if this gets implemented.
TAPE_Stat_RXFull	= @00000100			; Byte received
TAPE_Stat_Escape	= @00001000			; Indication that the escape key has been pressed

TAPE_BlockIn_Complete	= @00000001			; Indication bit of BlockIn transfer finishing successfully.
TAPE_BlockIn_Escape	= @00000010			; Indication bit of a break in loading of a block
TAPE_BlockIn_Error	= @00000100			; Indication bit of an error occuring whilst BlockIn operated.

TAPE_Verify_Good	= @00000001			; Signals successful verification
TAPE_Verify_Escape	= @00000010			; Signals escape from verification
TAPE_Verify_Error	= @00000100			; Signals an error was detected.


; TowerTAPE filing system configuration bitfield definitions.
; These are bits within the V_TAPE_Config variable.

TAPE_ParityMode		= @00000001
TAPE_AutoRUN_En		= @00000010
TAPE_AutoEXEC_En	= @00000100


; CCflag bit constant
;
C_CCflag_bit		= @00000001


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
; ! TAPE SPACE FROM $900 TO $9FF   !
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
TAPE_HeaderID			= TAPE_Header_Buffer		; Just stores 'HEAD'.  Used to identify headers from other stuff.
TAPE_FileType			= TAPE_HeaderID + 4		; This is the file type ID goes. 0 is for BASIC, otherwise ignored by LOAD.
TAPE_FileSizeLo			= TAPE_FileType + 1		; Low byte of the file size
TAPE_FileSizeHi			= TAPE_FileSizeLo + 1		; High byte of the file size
TAPE_LoadAddrLo			= TAPE_FileSizeHi + 1		; Low byte of the file load address
TAPE_LoadAddrHi			= TAPE_LoadAddrLo + 1		; High byte of the file load address
TAPE_FileName			= TAPE_LoadAddrHi + 1		; Null terminated filename field 17 bytes long.
TAPE_ChecksumLo			= TAPE_FileName + C_TAPE_Fname_BufferSize	; Checksum Low byte
TAPE_ChecksumHi			= TAPE_ChecksumLo + 1		; Checksum High byte
TAPE_Header_End			= TAPE_ChecksumHi		; End of header space

TAPE_CS_AccLo			= TAPE_Header_End + 1		; Tape checksum Accumulator low byte
TAPE_CS_AccHi			= TAPE_CS_AccLo + 1		; Tape checksum Accumulator high byte

V_TAPE_Phasetime		= TAPE_CS_AccHi + 1		; Tape phasetime variable
V_TAPE_Sample_Offset		= V_TAPE_Phasetime + 1		; Sample offset variable
V_TAPE_Bitlength		= V_TAPE_Sample_Offset + 1	; How long a bit is in passes variable
V_TAPE_bitcycles		= V_TAPE_Bitlength + 1		; Number of cycles to a bit variable

V_TAPE_Verify_Status		= V_TAPE_bitcycles + 1		; Status register for the F_TAPE_Verify function.
V_TAPE_Fname_Buffer		= V_TAPE_Verify_Status + 1	; Filename Buffer for null terminated filename.
V_TAPE_LOADSAVE_Type		= V_TAPE_Fname_Buffer + 18	; LOAD or SAVE type being currently handled.
V_TAPE_Address_Buff		= V_TAPE_LOADSAVE_Type + 1	; Address for LOAD and SAVE operations.
V_TAPE_Size_Buff		= V_TAPE_Address_Buff + 2	; Temporary store of how big the file is.
V_TAPE_Config			= V_TAPE_Size_Buff + 2		; TowerTAPE file system configuratuon bits.
TAPE_KBD_vec			= V_TAPE_Config + 1		; Keyboard checking vector (must be in ram)

TAPE_RAM_end			= TAPE_KBD_vec + 2

; Some more handy constants

C_TAPE_Fname_BufferSize		= 17
C_TAPE_Fname_BuffEnd		= V_TAPE_Fname_Buffer + C_TAPE_Fname_BufferSize 
C_TAPE_HeaderSize		= TAPE_Header_End - TAPE_Header_Buffer + 1


;  .IF [ TAPE_RAM_end>TAPE_RAM_Start ]
;    .ERROR "Memory overrun in TAPE_IO.asm"
;  .ENDIF


; Next is $948.

; +-------------------------------------------------------------------------------------------+
; +                                                                                           +
; +                              TAPE FILING SYSTEM MESSAGE STRINGS.                          +
; +                                                                                           +
; +-------------------------------------------------------------------------------------------+


TMSG_init_msg						; Filing System initialisation string.
 
  .BYTE $0C,1,$18,$03,$0D,$0A
  .BYTE "TowerTAPE Filing System "
  .BYTE "V2.58",$0D,$0A,$0D,$0A,$00


TMSG_Break
  
  .BYTE $D,$A,$A
  .BYTE "Break",$D,$A,0
  
TMSG_Ready

  .BYTE "Ready",$D,$A,0
  
  
TMSG_Saving

  .BYTE $D,$A
  .BYTE "Saving ",0
  
  
TMSG_Searching

  .BYTE $D,$A
  .BYTE "Searching...",$D,$A,$A,0


TMSG_Found
  .BYTE "Found ",0 

TMSG_Loading

  .BYTE $D,$A
  .BYTE "Loading...",$D,$A,0
  
TMSG_Verifying

  .BYTE $D,$A
  .BYTE "Verifying...",$D,$A,0
  
TMSG_Verified

  .BYTE $D,$A
  .BYTE "Verified OK.",$D,$A,0
  
TMSG_VerifyError

  .BYTE $D,$A
  .BYTE "Verify Error.",$D,$A,0

TMSG_TapeError

  .BYTE $D,$A
  .BYTE "Tape loading Error",0
  
  
TMSG_HeaderError  

  .BYTE $D,$A
  .BYTE "Header error. Retrying.",$D,$A,0

TMSG_NewPerformed

  .BYTE $D,$A
  .BYTE "NEW performed.",$D,$A,$A,0
  
  
TMSG_TypeBASIC

  .BYTE "BASIC:  ",0
  
TMSG_TypeBINARY

  .BYTE "Binary: ",0
  
TMSG_TypeTEXT

  .BYTE "Text:   ",0
  
TMSG_TypeOTHER
  .BYTE "Other:  ",0
  


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
  
  LDA #TAPE_AutoRUN_En | TAPE_AutoEXEC_En		; Set our default to allow autorun BASIC & execute binaries upon load.
  STA V_TAPE_Config

  LDA #<TMSG_init_msg
  STA TOE_MemptrLo
  LDA #>TMSG_init_msg
  STA TOE_MemptrHi
  JSR TOE_PrintStr_vec
  
TAPE_msg_done
  RTS
    

  


;*****************************************************************************************
;**                                                                                     **
;**                                                                                     **
;**          Helper and high level functions for tape loading and saving.               **
;**                                                                                     **
;**                                                                                     **
;*****************************************************************************************


; Compares the filename in the buffer to the one in the header and returns C=1 on equality, otherwise C=0
;

F_TAPE_CompareFileNames
  LDY #0						; Setup our index
  
  LDA V_TAPE_Fname_Buffer				; Short circuit to match on null filename specified.
  CMP #0
  BEQ TAPE_CompareByte_Match_B
  
TAPE_CompareByte_L
  LDA V_TAPE_Fname_Buffer,Y				; Get our byte to compare

  CMP TAPE_FileName,Y					; Branch on mismatch.
  BNE TAPE_CompareMismatch_B
  
  TYA							; Decrement index and branch when done
  INY
  CMP #16
  BEQ TAPE_CompareByte_Match_B
  BRA TAPE_CompareByte_L
  
TAPE_CompareByte_Match_B				; Signal match and exit
  SEC
  RTS 
  
TAPE_CompareMismatch_B
  CLC							; Signal mismatch and exit
  RTS

; Just prints 'Found ', followed by the filename.  That's all.

F_TAPE_PrintFound
  LDA #<TMSG_Found					; Print 'Found '
  STA TOE_MemptrLo
  LDA #>TMSG_Found 
  STA TOE_MemptrHi
  JSR TOE_PrintStr_vec
  

  LDA TAPE_FileType					; Check and print BASIC if necessary.
  CMP #C_TAPE_FType_BASIC
  BNE TAPE_Skip_RepBASIC_B
  
  LDA #<TMSG_TypeBASIC
  STA TOE_MemptrLo
  LDA #>TMSG_TypeBASIC
  STA TOE_MemptrHi
  JSR TOE_PrintStr_vec
  
  BRA TAPE_DoPrintFname_B
   
TAPE_Skip_RepBASIC_B

  LDA TAPE_FileType					; Check and print BINARY if necessary.
  CMP #C_TAPE_FType_BINARY
  BNE TAPE_Skip_RepBinary_B
  
  LDA #<TMSG_TypeBINARY
  STA TOE_MemptrLo
  LDA #>TMSG_TypeBINARY
  STA TOE_MemptrHi
  JSR TOE_PrintStr_vec
  
  BRA TAPE_DoPrintFname_B
  
TAPE_Skip_RepBinary_B

  LDA TAPE_FileType					; Check and print TEXT if necessary.
  CMP #C_TAPE_FType_TEXT
  BNE TAPE_Skip_RepText_B
  
  LDA #<TMSG_TypeTEXT
  STA TOE_MemptrLo
  LDA #>TMSG_TypeTEXT
  STA TOE_MemptrHi
  JSR TOE_PrintStr_vec

  BRA TAPE_DoPrintFname_B
  
TAPE_Skip_RepText_B

  LDA #<TMSG_TypeOTHER
  STA TOE_MemptrLo
  LDA #>TMSG_TypeOTHER
  STA TOE_MemptrHi
  JSR TOE_PrintStr_vec

TAPE_DoPrintFname_B
  JSR F_TAPE_PrintFname_in_Header			; Print our filename.
  JSR   LAB_CRLF					; print CR/LF. 
  RTS


F_TAPE_PrintStart
  LDA TAPE_LoadAddrHi
  JSR MON_PrintHexByte
  LDA TAPE_LoadAddrLo
  JSR MON_PrintHexByte
  RTS

F_TAPE_PrintSize
  LDA TAPE_FileSizeHi
  JSR MON_PrintHexByte
  LDA TAPE_FileSizeLo
  JSR MON_PrintHexByte
  RTS
  

  
  

; Write HEAD to the header ID field.  Yes, it's primitive but it really is the easiest way.
;  
F_TAPE_WriteHeaderID
  LDA #'H'
  STA TAPE_HeaderID
  LDA #'E'
  STA TAPE_HeaderID + 1
  LDA #'A'
  STA TAPE_HeaderID + 2
  LDA #'D'
  STA TAPE_HeaderID + 3
  RTS


; Check to see if our header block IS a header block.
;
F_TAPE_CheckHeaderID
  LDA TAPE_HeaderID
  CMP #'H'
  BNE TAPE_NotAHeader_B
  
  LDA TAPE_HeaderID + 1
  CMP #'E'
  BNE TAPE_NotAHeader_B
  
  LDA TAPE_HeaderID + 2
  CMP #'A'
  BNE TAPE_NotAHeader_B
  
  LDA TAPE_HeaderID + 3
  CMP #'D'
  BNE TAPE_NotAHeader_B
  
  SEC					; Is a confirmed header
  RTS
  
TAPE_NotAHeader_B  
  CLC					; Is not a header or is a bad header.
  RTS
  

; Fill out V_TAPE_Fname_buffer with filename.
; TOE_MemptrLo and Hi contain the address bytes for the source.  A contains the length.
; This function also null terminates the string.

F_TAPE_Fill_Fname
  LDY #0						; Clear our index so we point to the start of the string.
  
  CMP #0						; Handle null string swiftly
  BEQ TAPE_Fill_Null_L
  
  TAX							; Set up our byte counter
  
TAPE_Fill_Fname_L					; Fill_Fname loop start
  LDA (TOE_MemptrLo),Y					; Get our byte
  STA V_TAPE_Fname_Buffer,Y				; Save our byte in our buffer.

  INY							; Increment our index
  DEX							; Decrement our counter
  TXA
  BNE TAPE_Fill_Fname_L					; Repeat while counter not zero

TAPE_Fill_Null_L					; At this point, we're putting the null characters in
  LDA #0
  
  STA V_TAPE_Fname_Buffer,Y
  TYA
  INY
  CMP #C_TAPE_Fname_BufferSize-1
  BNE TAPE_Fill_Null_L
  
  RTS							; End of F_TAPE_Fill_Fname routine.
  
  
; Copies V_TAPE_Fname_Buffer to the header
  
F_TAPE_Fname_Buf_to_Header
  LDY #0						; Set our index

TAPE_Fname_Buf_to_Header_L

  LDA V_TAPE_Fname_Buffer,Y				; Get our first byte
  STA TAPE_FileName,Y					; And transfer it to the header.
  
  INY							; Increment and repeat until done.
  CMP #0
  BNE TAPE_Fname_Buf_to_Header_L
  
TAPE_Fname_BlankRest_B					; Fill out rest of header with zero's for checksum purposes.
  LDA #0
  STA TAPE_FileName,Y
  TYA
  CMP #C_TAPE_Fname_BufferSize
  BEQ TAPE_Done_BlankRest_B
  INY
  BRA TAPE_Fname_BlankRest_B
  
TAPE_Done_BlankRest_B
  RTS							; Done


; Get filename from command line into buffer.  Also handle errors.  This may not be the final thing.

F_TAPE_GetName
  JSR LAB_EVEX						; evaluate string
  JSR LAB_EVST						; test it is a string
  STA TAPE_temp2					; Store our string length for later
  
  LDA Dtypef						; Find out if it is a string and error if it isn't.  $FF=Str, $0=Numeric
  BEQ TAPE_SYN_ERR
  
  LDA TAPE_temp2					; Recover our string length
  SEC
  SBC #17
  BMI TAPE_NameToBuffer_B
  BRA TAPE_LEN_ERR

TAPE_LEN_ERR  
  LDX #$24 ;ERR_BF					; Issue a Bad filename Error
  JSR LAB_XERR
  RTS							; Does LAB_XERR really return??
  
TAPE_SYN_ERR
; Syntax Error output
  LDX #$2 ;ERR_SN					; Issue a Syntax Error.  
  JSR LAB_XERR
  RTS							; Does LAB_XERR really return??							

TAPE_NameToBuffer_B

  STX TOE_MemptrLo					; Copy our String to the 
  STY TOE_MemptrHi					; TOE_Memptr contains starting location
  LDA TAPE_temp2					; and A contains size.
  JSR F_TAPE_Fill_Fname
  RTS


; Print Filename in header

F_TAPE_PrintFname_in_Header

  JSR F_TAPE_PrintStart
  LDA #' '
  JSR V_OUTP
  JSR F_TAPE_PrintSize
  LDA #' '
  JSR V_OUTP
  
  LDA #34
  JSR V_OUTP
  LDA #<TAPE_FileName					; Print our Filename in the header space
  STA TOE_MemptrLo
  LDA #>TAPE_FileName 
  STA TOE_MemptrHi
  JSR TOE_PrintStr_vec
  LDA #34
  JSR V_OUTP

  
  RTS
  

; Saves A BASIC program or binary block.  Meant to be called from within BASIC
;

F_TAPE_SAVE_BASIC

  JSR F_TAPE_GetName					; Get the filename from the command stream
  JSR F_TAPE_Fname_Buf_to_Header			; and put it in the header.
  
  JSR F_TAPE_WriteHeaderID				; Include the Header ID 'HEAD'

  LDA #C_TAPE_FType_BASIC				; Initially set the type to BASIC.  Depending on following params, this may get changed.
  STA V_TAPE_LOADSAVE_Type
  
  LDA #<Ram_base					; Store the BASIC load address to our buffer too.
  STA V_TAPE_Address_Buff				; This also might get changed.
  LDA #>Ram_base
  STA V_TAPE_Address_Buff + 1
  
  JSR F_TAPE_GetBASIC_Size				; Find out how big our BASIC program is.
  
  LDA V_TAPE_BlockSize					; Transfer it to the size buffer.
  STA V_TAPE_Size_Buff
  LDA V_TAPE_BlockSize + 1
  STA V_TAPE_Size_Buff + 1
  
  
  
  JSR LAB_GBYT						; Find out if we have extra parameters or not,
  							; firstly checking if we have a null.
  BEQ B_TAPE_SAVE_BASIC					; If we have null, we can continue as SAVEing BASIC otherwise it's binary.
  
; BINARY case.

B_TAPE_SAVE_BINARY
  JSR LAB_EVNM						; evaluate expression and check is numeric,
							; else do type mismatch
  JSR LAB_F2FX						; save integer part of FAC1 in temporary integer

  JSR LAB_1C01						; scan for "," , else do syntax error then warm start
      							
  LDA Itempl						; save our specified base address
  STA V_TAPE_Address_Buff
  LDA   Itemph
  STA V_TAPE_Address_Buff + 1
  
  JSR LAB_EVNM						; Get and store our binary file size
  							; If this parameter is missing you will get a Syntax Error.
  JSR LAB_F2FX						; save integer part of FAC1 in temporary integer
  
  JSR LAB_GBYT						; Loose the comma ready for the next paramter.
  							; This may not be necessary or right.
  
  LDA Itempl						; Replace the size in the buffer with the one from BASIC
  STA V_TAPE_Size_Buff
  LDA Itemph
  STA V_TAPE_Size_Buff + 1
  
  LDA #C_TAPE_FType_BINARY				; Set the type to BINARY
  STA V_TAPE_LOADSAVE_Type
  
  ; NOTE:- By this point, the address and size buffers should contain correct parameters alongside the file type info.
  
  
; Now do the SAVE

; By this point the Address and size are stored in their relevant buffers.

B_TAPE_SAVE_BASIC

  LDA #<TMSG_Saving					; Tell the user that we are saving.
  STA TOE_MemptrLo
  LDA #>TMSG_Saving
  STA TOE_MemptrHi
  JSR TOE_PrintStr_vec

; Provide the necessary parameters for the F_TAPE_CalcChecksum to work
  
  LDA V_TAPE_Size_Buff					; Save our program size to the header and to V_TAPE_BlockSize
  STA TAPE_FileSizeLo
  STA V_TAPE_BlockSize
  LDA V_TAPE_Size_Buff + 1
  STA TAPE_FileSizeHi  
  STA V_TAPE_BlockSize + 1
  
  LDA V_TAPE_Address_Buff				; Get our starting pointer for calculating our checksum loaded.
  STA TAPE_BlockLo
  LDA V_TAPE_Address_Buff + 1
  STA TAPE_BlockHi
  
  JSR F_TAPE_CalcChecksum				; Get our checksum value

  LDA TAPE_CS_AccLo					; Store our calculated Checksum in the header structure.
  STA TAPE_ChecksumLo
  LDA TAPE_CS_AccHi
  STA TAPE_ChecksumHi
  
  LDA V_TAPE_Address_Buff				; Include the LOAD address in the header.  It remains to be seen how we establish
  STA TAPE_LoadAddrLo					; Load to SAVE'd address implied by the header.
  LDA V_TAPE_Address_Buff + 1
  STA TAPE_LoadAddrHi
  
  LDA V_TAPE_LOADSAVE_Type				; Setup the file type in the header too.
  STA TAPE_FileType

  JSR F_TAPE_PrintFname_in_Header			; Print our "Filename".  
  
  ; Setup for F_TAPE_BlockOut to write the header to tape and then write it out.
  
  LDA #<TAPE_Header_Buffer				; Setup our block pointer to the start of the header
  STA TAPE_BlockLo
  LDA #>TAPE_Header_Buffer
  STA TAPE_BlockHi
  
  LDA #<C_TAPE_HeaderSize				; Load our blocksize with the size of our header buffer
  STA V_TAPE_BlockSize
  LDA #>C_TAPE_HeaderSize
  STA V_TAPE_BlockSize + 1
  
  JSR F_TAPE_BlockOut					; Write our block to tape
  
  
  ; Include a decent pause between the header and the main block.
  
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
  
  JSR F_TAPE_GetName					; Get the filename string into our buffer

  ; Initial BASIC case.

  LDA #<Ram_base					; Store the BASIC load address to our buffer too.
  STA V_TAPE_Address_Buff				; This also might get changed.
  LDA #>Ram_base
  STA V_TAPE_Address_Buff + 1
  
  JSR F_TAPE_GetBASIC_Size				; Get our BASIC size.
  
  LDA V_TAPE_BlockSize					; Transfer it to the size buffer.
  STA V_TAPE_Size_Buff
  LDA V_TAPE_BlockSize + 1
  STA V_TAPE_Size_Buff + 1
  
  LDA #C_TAPE_FType_BASIC				; Set the type to BASIC
  STA V_TAPE_LOADSAVE_Type


  ; Identify if we are dealing with binary by it's extra parameters.
   
  JSR LAB_GBYT						; Find out if we have extra parameters or not,
  							; firstly checking if we have a null.
  BEQ TAPE_VERIFY_Searching_B				; If we have null, we can continue as SAVEing BASIC otherwise it's binary.
  
  ; BINARY case.
  
  JSR LAB_EVNM						; evaluate expression and check is numeric,
							; else do type mismatch
  JSR LAB_F2FX						; save integer part of FAC1 in temporary integer
    							
  LDA Itempl						; save our specified base address
  STA V_TAPE_Address_Buff
  LDA Itemph
  STA V_TAPE_Address_Buff + 1
  
  LDA #C_TAPE_FType_BINARY				; Set the type to BINARY
  STA V_TAPE_LOADSAVE_Type
  
  
  ; Now go verify!
  
TAPE_VERIFY_Searching_B

  LDA #<TMSG_Searching					; Tell the user that we are searching.
  STA TOE_MemptrLo
  LDA #>TMSG_Searching
  STA TOE_MemptrHi
  JSR TOE_PrintStr_vec

TAPE_VERIFY_Header_B

  LDA #<TAPE_Header_Buffer				; Point to start of header buffer
  STA TAPE_BlockLo
  LDA #>TAPE_Header_Buffer
  STA TAPE_BlockHi
  
  LDA #<C_TAPE_HeaderSize				; Specify how big our header is.
  STA V_TAPE_BlockSize
  LDA #>C_TAPE_HeaderSize
  STA V_TAPE_BlockSize + 1
  
  JSR F_TAPE_BlockIn					; Load the header block.
  
  CMP #TAPE_BlockIn_Escape
  BNE TAPE_BlockIn_EscNotPressed_B
  JMP TAPE_BlockIO_EscHandler				; If escaping jump to the escape handler

TAPE_BlockIn_EscNotPressed_B

  JSR F_TAPE_CheckHeaderID				; try again if not a valid header
  BCC TAPE_VERIFY_Header_B

  CMP #TAPE_Verify_Error
  BNE TAPE_VERIFY_Fname_Check

  LDA #<TMSG_HeaderError				; Tell the user of the header error and retry
  STA TOE_MemptrLo
  LDA #>TMSG_HeaderError
  STA TOE_MemptrHi
  JSR TOE_PrintStr_vec
  
  JMP TAPE_VERIFY_Header_B				; Keep coming back until the header is read valid or the user presses escape


TAPE_VERIFY_Fname_Check
  JSR F_TAPE_PrintFound
  
  JSR F_TAPE_CompareFileNames
  BCC TAPE_VERIFY_Header_B
  
  LDA TAPE_FileType					; We're only interested in verifying the right type of file.
  CMP V_TAPE_LOADSAVE_Type
  BNE TAPE_VERIFY_Header_B
  
TAPE_Verify_Stage

  LDA TAPE_FileSizeLo					; Put our file size into V_TAPE_BlockSize.
  STA V_TAPE_BlockSize
  LDA TAPE_FileSizeHi
  STA V_TAPE_BlockSize + 1

  LDA V_TAPE_LOADSAVE_Type
  CMP #C_TAPE_FType_BINARY
  
  BEQ B_TAPE_Verify_SkipBASIC_Sizing

  LDA V_TAPE_Size_Buff					; Put our measured BASIC size into V_TAPE_BlockSize
  STA V_TAPE_BlockSize
  LDA V_TAPE_Size_Buff + 1
  STA V_TAPE_BlockSize + 1

B_TAPE_Verify_SkipBASIC_Sizing

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
  
  LDA V_TAPE_Address_Buff				; Tell the system where to start verifying the data,
  STA TAPE_BlockLo					; this should point to Ram_base for BASIC or as specified for binary.
  LDA V_TAPE_Address_Buff + 1
  STA TAPE_BlockHi
  
  LDA #<TMSG_Verifying					; Tell the user that we are verifying.
  STA TOE_MemptrLo
  LDA #>TMSG_Verifying
  STA TOE_MemptrHi
  JSR TOE_PrintStr_vec 
    
  JSR F_TAPE_VerifyBlock				; Verify the data in memory against the block on tape.

  LDA V_TAPE_Verify_Status				; Check our status
  CMP #TAPE_Verify_Escape
  BNE TAPE_Skip_BlockIO_EscHandler			; If escaping jump to the escape handler
  JMP TAPE_BlockIO_EscHandler
  
TAPE_Skip_BlockIO_EscHandler  
  CMP #TAPE_Verify_Error				; Check if verify passed or not.
  BNE TAPE_Verify_OK
  
TAPE_Verify_Error_B  
  LDA #<TMSG_VerifyError				; Inform the user of the verification error.
  STA TOE_MemptrLo
  LDA #>TMSG_VerifyError
  STA TOE_MemptrHi
  JSR TOE_PrintStr_vec
  RTS
  
TAPE_Verify_OK
  LDA #<TMSG_Verified					; Inform the user of verification success.
  STA TOE_MemptrLo
  LDA #>TMSG_Verified
  STA TOE_MemptrHi
  JSR TOE_PrintStr_vec

TAPE_Verify_Done  
  RTS
  
F_TAPE_CAT

  LDA #<TMSG_Searching					; Tell the user that we are searching.
  STA TOE_MemptrLo
  LDA #>TMSG_Searching
  STA TOE_MemptrHi
  JSR TOE_PrintStr_vec

TAPE_CAT_Header_B

  LDA #<TAPE_Header_Buffer				; Point to start of header buffer
  STA TAPE_BlockLo
  LDA #>TAPE_Header_Buffer
  STA TAPE_BlockHi
  
  LDA #<C_TAPE_HeaderSize				; Specify how big our header is.
  STA V_TAPE_BlockSize
  LDA #>C_TAPE_HeaderSize
  STA V_TAPE_BlockSize + 1
  
  JSR F_TAPE_BlockIn
  CMP #TAPE_BlockIn_Escape
  BEQ TAPE_CAT_Exit_B
  
  JSR F_TAPE_CheckHeaderID				; try again if not a valid header
  BCC TAPE_CAT_Header_B

  CMP #TAPE_BlockIn_Error
  BNE TAPE_CAT_Fname_Report
  
  LDA #<TMSG_HeaderError				; Tell the user of the header error and retry
  STA TOE_MemptrLo
  LDA #>TMSG_HeaderError
  STA TOE_MemptrHi
  JSR TOE_PrintStr_vec
  
  BRA TAPE_CAT_Header_B
  

TAPE_CAT_Fname_Report
  JSR F_TAPE_PrintFound					; Tell the user what we found.
  BRA TAPE_CAT_Header_B
  
TAPE_CAT_Exit_B
  RTS


; Tape Reporting routines.
; ------------------------

TAPE_BlockIn_LoadErr
  LDA TAPE_FileType
  CMP #C_TAPE_FType_BASIC
  BNE B_TAPE_NoNew
  
  LDA #<TMSG_TapeError					; Handle BASIC case.
  STA TOE_MemptrLo
  LDA #>TMSG_TapeError
  STA TOE_MemptrHi
  JSR TOE_PrintStr_vec

  JSR LAB_CRLF
  JSR LAB_CRLF
  
  LDA #<TMSG_NewPerformed
  STA TOE_MemptrLo
  LDA #>TMSG_NewPerformed
  STA TOE_MemptrHi
  JSR TOE_PrintStr_vec
  
  JSR LAB_1269						; Perform New

B_TAPE_NoNew
  LDA #<TMSG_TapeError					; Inform the user of the tape error
  LDY #>TMSG_TapeError
  
  JMP LAB_1269						; Break and WARM Start.   
  
TAPE_BlockIO_EscHandler
  LDA #<TMSG_Break					; Tell the user that we are have pressed Escape.
  LDY #>TMSG_Break
  JMP LAB_1269

  
TAPE_BASICLOAD_EscHandler
  LDA #<LAB_BMSG					; Tell the user that we are have pressed Escape.
  STA TOE_MemptrLo
  LDA #>LAB_BMSG
  STA TOE_MemptrHi
  JSR TOE_PrintStr_vec
  
TAPE_NewMSG_WS  
  LDA #<TMSG_NewPerformed				; Tell the user that we are have pressed Escape.
  STA TOE_MemptrLo
  LDA #>TMSG_NewPerformed
  STA TOE_MemptrHi
  JSR TOE_PrintStr_vec

  JMP LAB_1463						; Perform a NEW and WARM start. 
  

  
;To BASIC 'LOAD' entry point.
  
F_TAPE_LOAD_BASIC
  
  JSR F_TAPE_GetName					; Get the filename string into our buffer
  
  LDA #C_TAPE_FType_BASIC				; Initially set the type to BASIC
  STA V_TAPE_LOADSAVE_Type
  
  LDA #<Ram_base					; Store the BASIC load address to our buffer too.
  STA V_TAPE_Address_Buff
  LDA #>Ram_base
  STA V_TAPE_Address_Buff + 1


  JSR LAB_GBYT						; Find out if we have extra parameters or not.
							; Firstly checking if we have a null.
  BEQ TAPE_LOAD_Header_B				; Since we have nothing, we can continue as LOADing BASIC
  

; Handle BINARY case.
  
  JSR LAB_EVNM						; evaluate expression and check is numeric,
							; else do type mismatch
  JSR LAB_F2FX						; save integer part of FAC1 in temporary integer
      							

; Setup for a binary LOAD
      							
  LDA Itempl						; save our specified base address
  STA V_TAPE_Address_Buff
  LDA Itemph
  STA V_TAPE_Address_Buff + 1
  
  LDA #C_TAPE_FType_BINARY				; Set the type to BINARY
  STA V_TAPE_LOADSAVE_Type


; Handle the Header

TAPE_LOAD_Header_B  

  LDA #<TMSG_Searching					; Tell the user that we are searching.
  STA TOE_MemptrLo
  LDA #>TMSG_Searching
  STA TOE_MemptrHi
  JSR TOE_PrintStr_vec

TAPE_LOAD_Header_Silent_B

  LDA #<TAPE_Header_Buffer				; Point to start of header buffer
  STA TAPE_BlockLo
  LDA #>TAPE_Header_Buffer
  STA TAPE_BlockHi
  
  LDA #<C_TAPE_HeaderSize				; Specify how big our header is.
  STA V_TAPE_BlockSize
  LDA #>C_TAPE_HeaderSize
  STA V_TAPE_BlockSize + 1

  JSR F_TAPE_BlockIn					; Load the header block.
  
  LDA TAPE_BlockIn_Status				; Branch on non load conditions
  CMP #TAPE_BlockIn_Escape
  BEQ TAPE_BlockIO_EscHandler				; If escaping jump to the escape handler
  
  JSR F_TAPE_CheckHeaderID				; try again if not a valid header
  BCC TAPE_LOAD_Header_Silent_B

  CMP #TAPE_BlockIn_Error
  BNE TAPE_BASLOAD_Fname_Check

  LDA #<TMSG_HeaderError				; Tell the user of the header error and retry
  STA TOE_MemptrLo
  LDA #>TMSG_HeaderError
  STA TOE_MemptrHi
  JSR TOE_PrintStr_vec
  JMP TAPE_LOAD_Header_B
  

TAPE_BASLOAD_Fname_Check
  JSR F_TAPE_PrintFound					; Tell the user what we found.
  
  JSR F_TAPE_CompareFileNames				; Check if our file is the right name
  BCC TAPE_LOAD_Header_B
  
  LDA TAPE_FileType					; We're only interested in loading the appropriate file type.
  CMP V_TAPE_LOADSAVE_Type
  BNE TAPE_LOAD_Header_B

TAPE_BASIC_Load_Stage
  LDA TAPE_FileSizeLo					; Tell the system how big the file to load is.
  STA V_TAPE_BlockSize
  LDA TAPE_FileSizeHi
  STA V_TAPE_BlockSize + 1
  
  LDA V_TAPE_Address_Buff				; Tell the system where to load to. This should point to Ram_base for BASIC
  STA TAPE_BlockLo
  LDA V_TAPE_Address_Buff + 1
  STA TAPE_BlockHi
  
  LDA #<TMSG_Loading					; Tell the user that we are loading.
  STA TOE_MemptrLo
  LDA #>TMSG_Loading
  STA TOE_MemptrHi
  JSR TOE_PrintStr_vec
  
  JSR F_TAPE_BlockIn					; Load the code block that follows
  
  LDA TAPE_BlockIn_Status				; Branch on non load conditions
  CMP #TAPE_BlockIn_Escape
  BNE TAPE_Skip_EscHandler_B
  LDA V_TAPE_LOADSAVE_Type
  CMP #C_TAPE_FType_BASIC
  BNE B_TAPE_NotBASIC_Brk

  JMP TAPE_BASICLOAD_EscHandler

B_TAPE_NotBASIC_Brk  
  JMP TAPE_BlockIO_EscHandler				; If escaping jump to the escape handler
  
TAPE_Skip_EscHandler_B  

  CMP #TAPE_BlockIn_Complete
  BEQ TAPE_BASIC_LoadingDone

  JMP TAPE_BlockIn_LoadErr
  
TAPE_BASIC_LoadingDone  
  LDA V_TAPE_Address_Buff				; Setup our pointer to the start of our LOADed memory
  STA TAPE_BlockLo
  LDA V_TAPE_Address_Buff + 1
  STA TAPE_BlockHi

  JSR F_TAPE_CalcChecksum				; Get our checksum value into TAPE_CS_Acc_Lo and Hi
  
  LDA TAPE_ChecksumLo					; First we check the low byte.
  CMP TAPE_CS_AccLo
  BNE TAPE_CS_Fail
  
  LDA TAPE_ChecksumHi					; And then if necessary, we check the high byte.
  CMP TAPE_CS_AccHi
  
  BNE TAPE_CS_Fail

TAPE_BASICload_exit

  LDA V_TAPE_LOADSAVE_Type
  CMP #C_TAPE_FType_BASIC
  BEQ B_Setup_NEWBASIC_Prog
  CMP #C_TAPE_FType_BINARY
  BEQ B_CheckBinary_Run
  RTS
  
B_Setup_NEWBASIC_Prog
    
  LDA TAPE_BlockLo					; Return the system to a useable state
  STA Svarl
  STA Sarryl
  STA Earryl
  LDA TAPE_BlockHi
  STA Svarh
  STA Sarryh
  STA Earryh

  LDA V_TAPE_Config					; Autorun only if set in V_TAPE_Config
  BIT #TAPE_AutoRUN_En
  BEQ B_TAPE_NoRun
  
  LDA TAPE_FileName					; Check to see if the RUN option is in the filename.
  CMP #'!'
  BNE B_TAPE_NoRun
  
  JMP LAB_1477						; Execute loaded code.
B_TAPE_NoRun

  LDA #<TMSG_Ready					; Tell the user that we are Ready.
  STA TOE_MemptrLo
  LDA #>TMSG_Ready
  STA TOE_MemptrHi
  JSR TOE_PrintStr_vec

  JMP LAB_1319						; Tidy up system.
  
TAPE_CS_Fail
  LDA V_TAPE_LOADSAVE_Type				; Is the Checksum for a BASIC program?
  CMP #C_TAPE_FType_BASIC
  BNE CS_Fail_NoNew_B  
  
  JMP LAB_1463						; Perform NEW as Corrupt BASIC is bad for business.
  
CS_Fail_NoNew_B
  LDA #<TMSG_TapeError					; Tell the user that we are have pressed Escape,
  LDY #>TMSG_TapeError					; and what line number if appropriate and warm start.
  JMP LAB_1269
  
B_CheckBinary_Run
  LDA V_TAPE_Config					; Autorun only if set in V_TAPE_Config
  BIT #TAPE_AutoEXEC_En  
  BEQ B_TAPE_NoBinExec
  
  LDA TAPE_FileName					; Check to see if the RUN option is in the filename.
  CMP #'!'
  BNE B_TAPE_NoBinExec
  
  JMP (V_TAPE_Address_Buff)				; Execute from start address.
  
B_TAPE_NoBinExec
  RTS
  
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


; Calculate the size of the BASIC program and store it in V_TAPE_BlockSize

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
  PHA
  JSR TAPE_SetKbd						; Set our initial keyboard scanning routine choice
  
  JSR TAPE_KBD_vec						; Just in case the user needs to get out of this loop
  
  BCC TAPE_ContByteOut						; Since we didn't receive a keypress, let's continue.
  EOR #3							; Ignore if not ^C
  BNE TAPE_ContByteOut
  
  PLA
  JMP TAPE_BlockIO_EscHandler					; Print Break and do a warm start

TAPE_ContByteOut
  PLA								; Retrieve out byte to transmit.
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
;  LDA #0							; Generate third guard bit!
;  JSR F_TAPE_BitGen
;  LDA #0							; Generate fourth guard bit!
;  JSR F_TAPE_BitGen

; FINDME GUARDBITS
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
  PHP								; Save P and disable interrupts
  SEI
  
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

  
TAPE_BlockOut_CheckZero_B
  CPY #0
  BNE B_TAPE_BlockOut_Decrement
  CPX #0
  BNE B_TAPE_BlockOut_Decrement

  PLP
  RTS

B_TAPE_BlockOut_Decrement
  DEX
  CPX #$FF
  BNE L_TAPE_BlockOut
  DEY
  BRA L_TAPE_BlockOut

  

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
  PHP								; Disable Interrupts
  SEI								; and save state

  JSR TAPE_SetKbd						; Set our initial keyboard scanning routine choice

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
  
TAPE_BlockIn_Sig_Escape						; Return escape
  LDA #TAPE_BlockIn_Escape
  STA TAPE_BlockIn_Status
  PLP
  RTS
  
TAPE_BlockIn_CheckError						; Return failed  
  LDA #TAPE_BlockIn_Error
  STA TAPE_BlockIn_Status
  PLP
  RTS  
  
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
  PLP
  RTS
   
  
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
  
  JSR TAPE_KBD_vec					; Just in case the user needs to get out of this loop
  
  BCC TAPE_ContLoop					; Caught in a landsliiiide, no escape TO re-al-ih-teeeee!
  EOR #$3
  BNE TAPE_ContLoop
  LDA #TAPE_Stat_Escape
  STA TAPE_RX_Status
  

TAPE_ByteCaptured
  PLP							; Restore IRQ status
  
  RTS							; Done


; Services that use the pulse decoded go here.

TAPE_ContLoop
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
  
TAPE_SetKbd
  LDA ccflag						; Get the current ccflag value and decide if we need to check
  BIT #C_CCflag_bit
  BEQ TAPE_SetKbd_B
  
  LDA #<F_TAPE_NoCC					; Set our vector to null check
  STA TAPE_KBD_vec+1
  LDA #>F_TAPE_NoCC
  STA TAPE_KBD_vec+2
  RTS

TAPE_SetKbd_B
  LDA #$4C						; Store JMP a in RAM
  STA TAPE_KBD_vec
  
  LDA os_insel						; Check if we have chosen ACIA1 and skip to ACIA2 check if not.
  BIT #OS_input_ACIA1
  BEQ TAPE_CheckACIA2
  
TAPE_SetACIA1						; Set our vector to ACIA1in
  LDA #<ACIA1in
  STA TAPE_KBD_vec+1
  LDA #>ACIA1in
  STA TAPE_KBD_vec+2
  RTS

TAPE_CheckACIA2						; Check if we have chosen ACIA2 and default to ACIA1 if not.
  LDA os_insel
  BIT #OS_input_ACIA2
  BEQ TAPE_SetACIA1
  
  LDA #<ACIA2in						; Set our vector to ACIA2in
  STA TAPE_KBD_vec+1
  LDA #>ACIA2in
  STA TAPE_KBD_vec+2
  RTS
  
F_TAPE_NoCC
;  PHX							; 			3
  LDX #3						;			2  = 5
TAPE_NoCC_L
  DEX							;			2
  CPX #0						;			2
  BNE TAPE_NoCC_L					;			3 then 2 7*2 + 8 = 23
  CLC							;			2 now at 30
  RTS							;			6 now at 33
  
  
  RTS							;			6

