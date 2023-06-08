; I2C (Inter Integrated Circuit) Bus Engine.
;

; Special considerations for this I2C implementation.
; ---------------------------------------------------
;
; 1) I2C is a MSb first protocol.
; 2) We are not implementing a slave mode here.
; 3) Multi-master support will *maybe* be added later. Will it be practical?
; 4) We ain't gonna be particularly fast, that's for sure.


; Port addresses addresses
;
I2C_DDR		= $C043
I2C_PORT	= $C041


; Memory Allocations
;
I2C_RAMBase	= $5D0				; NOT the Final location.
I2C_Lim		= $5DF				; Upper bound of RAM permitted for this module.

I2C_Status	= I2C_RAMBase
I2C_Byte	= I2C_Status+1
I2C_Timeout_V	= I2C_Byte + 1			; 16-bit timeout counter variable.
I2C_RAMend	= I2C_Timeout_V + 1		; 


; Bounds checking.
;
  .IF [ I2C_RAMend>I2C_Lim ]
    .ERROR "Memory overrun in I2C_Lib.asm"
  .ENDIF


; I2C State machine bitfield
;
I2C_STA_NAK	= @00000001
I2C_STA_Timeout	= @00000010
I2C_STA_Rd_nWr	= @00000100
I2C_STA_Master	= @00001000


; Pin Bit spec
;
I2C_SDA_Pin	= @00000001
I2C_SCL_Pin	= @00000010


; I2C handy constants
;
I2C_Timeout_C	= $4FF				; Attempts to make before timeout
I2C_Float	= 1
I2C_Assert	= 0				; Note that any non zero vslue will float, which we will exploit.



; ----------------------------------------------
; ********  I2C Pin driving functions.  ********
; ----------------------------------------------
;

I2C_SetSDA
  BNE I2C_SDA_Float
  
; Asserting case
  LDA #I2C_SDA_Pin
  ORA I2C_DDR
  STA I2C_DDR
  RTS
  
; Floating case
I2C_SDA_Float
  LDA #~I2C_SDA_Pin
  AND I2C_DDR
  STA I2C_DDR
  RTS  



I2C_SetSCL
  BNE I2C_SCL_Float
  
; Asserting case
  LDA #I2C_SCL_Pin
  ORA I2C_DDR
  STA I2C_DDR
  RTS
  
; Floating case
I2C_SCL_Float
  LDA #~I2C_SCL_Pin
  AND I2C_DDR
  STA I2C_DDR
  RTS



; ---------------------------------------------
; ********    Pin reading functions    ********
; ---------------------------------------------
;


; Wait for SCL Release and return when done or timed out.
;
; This is done to support clock-stretching, which is not very useful at these speeds but... who knows!?
;
I2C_WaitSCL_Release
  PHX
  PHY
  LDX #<I2C_Timeout_V			; Setup our timeout attempt counter low
  LDY #>I2C_Timeout_V			; ...and high.
  

  LDA #I2C_SCL_Pin			; Check if SCL has been released
  
I2C_WaitSCL_retry_L
  BIT I2C_PORT
  BNE I2C_SCL_Freed			; Are you free, Are you free!?
  
  DEX
  BNE I2C_WaitSCL_retry_L		; Repeat until we reach 0 or the line is freed
  DEY
  BNE I2C_WaitSCL_retry_L
  
  LDA I2C_Status			; Update status bit to reflect line timeout.
  ORA #I2C_STA_Timeout
  STA I2C_Status
  PLY
  PLX
  RTS

I2C_SCL_Freed
  LDA I2C_Status			; Update status bit to reflect line freed.
  AND #~I2C_STA_Timeout
  STA I2C_Status
  PLY
  PLX
  RTS
  
  
I2C_GetSDA
  LDA I2C_PORT
  AND #I2C_SDA_Pin
  RTS
  


; ---------------------------------------------
; ********       Bus Functions.        ********
; ---------------------------------------------

I2C_Init

; Set initial timeout variable

  LDA #<I2C_Timeout_C
  STA I2C_Timeout_V
  LDA #>I2C_Timeout_C
  STA I2C_Timeout_V+1


;  Set initial state of port

  LDA #I2C_Float
  JSR I2C_SetSCL
  
  LDA #I2C_Float
  JSR I2C_SetSDA
    
  LDA I2C_PORT
  AND #~[I2C_SDA_Pin | I2C_SCL_Pin]
  STA I2C_PORT


; Set initial status register value
  
  LDA #I2C_STA_Master
  STA I2C_Status


; Clear engine state
  
  LDA #0
  STA I2C_Byte

  RTS


; I2C Bus commands

I2C_Start

  LDA #I2C_Assert
  JSR I2C_SetSDA
  
  LDA #I2C_Assert
  JSR I2C_SetSCL
  
  RTS

  
I2C_Stop

  LDA #I2C_Float
  JSR I2C_SetSCL

  ; JSR I2C_WaitSCL_Release ; I don't think we need this line.
  
  LDA #I2C_Float
  JSR I2C_SetSDA


  RTS

  
I2C_Out
  LDY #$80			; Set our bit mask


; ** This part sends out the 8 bit word MSb first. **

I2C_Out_L
  LDA #I2C_Assert		; Transmit selected bit
  JSR I2C_SetSCL		; Clock line low first

  TYA
  AND I2C_Byte			; Set data bit appropriately
  JSR I2C_SetSDA
  
  LDA #I2C_Float		; Latch it to slave
  JSR I2C_SetSCL
  
  TYA				; Proceed to next bit until zero
  ROR
  TAY
  BNE I2C_Out_L


; ** This part handles the ACK or NAK appropriately **
  
  LDA #I2C_Assert		; ACK/NAK clock pulse low
  JSR I2C_SetSCL
  
  LDA #I2C_Float		; Float SDA so the slave can pull it for ACK
  JSR I2C_SetSDA
  
  LDA #I2C_Float		; ACK/NAK clock pulse high with stretching
  JSR I2C_SetSCL   
  JSR I2C_WaitSCL_Release
  
  JSR I2C_GetSDA		; Read ACK/NAK state
  
  BEQ I2C_Out_ACKin		; Set the status word accordingly.
  
  LDA #I2C_STA_NAK		; Case NAK
  ORA I2C_Status
  STA I2C_Status
  BRA I2C_FinishWrite
  
I2C_Out_ACKin			; Case ACK
  LDA #~I2C_STA_NAK
  AND I2C_Status
  STA I2C_Status
  
I2C_FinishWrite
  LDA #I2C_Assert		; Finish clock cycle for ACK/NAK
  JSR I2C_SetSCL
  
  LDA #I2C_Float		; Float SDA or we can't do a repeat start FINDME
  JSR I2C_SetSDA  
  RTS
    
I2C_WriteFail  
  JSR I2C_Stop
  RTS
  
  
I2C_In

  LDA #I2C_Float		; Ensure the SDA line is floating.
  JSR I2C_SetSDA
  
  LDY #$80			; Setup initial state
  LDA #0
  STA I2C_Byte

I2C_In_L

  LDA #I2C_Assert		; Start clock pulse
  JSR I2C_SetSCL  
  LDA #I2C_Float		; Finish clock pulse
  JSR I2C_SetSCL  
  JSR I2C_GetSDA		; Get bit
  BEQ I2C_In_SkipSet
  
  TYA				; Set relevant bit of I2C_Byte to 1
  ORA I2C_Byte
  STA I2C_Byte

I2C_In_SkipSet
  
  TYA				; Move walking one across
  LSR
  TAY

  BNE I2C_In_L			; Keep reading until all bits read
  
  LDA #I2C_Assert
  JSR I2C_SetSCL
  
  LDA #I2C_STA_NAK		; Check whether to send ACK or NAK
  BIT I2C_Status
  BNE I2C_In_SendNAK
  
  LDA #I2C_Assert		; Set for ACK
  JSR I2C_SetSDA
  
I2C_In_SendNAK
  LDA #I2C_Float		; Send ACK/NAK
  JSR I2C_SetSCL
  LDA #I2C_Assert
  JSR I2C_SetSCL

  LDA #I2C_Float		; Restore SDA to floating. 
  JSR I2C_SetSDA
  RTS
  