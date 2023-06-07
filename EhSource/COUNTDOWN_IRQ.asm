; Countdown IRQ by Jennifer Gunn.
;
; Introduction:
;
; Adds a system countdown timer.  This is to be driven from the timer on the first GPIO card.  This is also the one that
; is used by the TowerTAPE interface and filing system.
;
; This defaults to 40000 counts including the 0 giving us a 10ms delay at 4MHz, and may be changed in software provided
; that one programs for an atomic operation or stops operation first.  The system uses a free running mode 
;


; Variables
;
; Start: $A4A.  End $A52. Size 9.
CTR_V_Start		= $A4A
CTR_V			= CTR_V_Start			; This is our counter variable base address.
CTR_RELOAD_V		= CTR_V 	   + 2		; This is the value the counter will be reloaded with if enabled.
CTR_PERIOD_V		= CTR_RELOAD_V 	   + 2		; This is the interval between counts in PHI2 ticks
CTR_External_vec	= CTR_PERIOD_V	   + 2		; External call vector when enabled.
CTR_Options		= CTR_External_vec + 2		; Bitfield containing enable bits for the following:-
							;	CTR_Reload_En	b0
							;	CTR_vec_En	b1
CTR_V_End		= CTR_Options


; Control bits
;
CTR_Reload_En		= @00000001			; Counter Reload enable bit.
CTR_vec_En		= @00000010			; Counter external vector enable bit.
							; WARNING! ^^ SET YOUR VECTOR FIRST!

; Constants
;
TIM_DELAY_C		= 39999		; This is the value we are going to use to set the timer. 10ms @4MHz


; Hardware register constants
;
TIM_T1L				= TAPE_IOBASE + 4
TIM_T1H				= TAPE_IOBASE + 5

TIM_ACR				= TAPE_IOBASE + $B
TIM_IFR				= TAPE_IOBASE + $D
TIM_IER				= TAPE_IOBASE + $E


; Hardware bits constants
;
TIM_IFR_IRQ_FLAG		= @10000000
TIM_IFR_TIM1_FLAG		= @01000000

TIM_ACR_T1_DIS			= @00000000	; Timer 1 disabled
TIM_ACR_T1_CONT			= @01000000	; Timer 1 continuous interrupts
TIM_ACR_T1_TIMED		= @10000000	; Timer 1 Timed interrupt with each reload
TIM_ACR_T1_CONT_SQW_OUT		= @11000000	; Timer 1 Continuous interrupts with square wave output at PB7

TIM_IER_SET			= @10000000	; Specify the setting of an interrupt
TIM_IER_CLR			= @00000000	; Specify the clearing of an interrupt
TIM_IER_TIM1			= @01000000	; Bit for timer 1.


INIT_COUNTDOWN_IRQ
  
  PHP						; Add our interrupt guard so bad things don't happen.
  SEI
    
  ORA IRQH_MaskByte				; Mark our IRQ as active.
  STA IRQH_MaskByte
  
;  LDA CTR_RELOAD_V				; Load timer reload value to our counter variable.
;  STA CTR_V
;  LDA CTR_RELOAD_V+1
;  STA CTR_V + 1
  
  LDA TIM_ACR
  ORA #TIM_IFR_TIM1_FLAG			; Load Auxilliary Control Register with continuous interrupts on
  						; T1 with latching.
  STA TIM_ACR
  
  LDA TIM_IER				; Start our interrupts running.
  ORA #TIM_IER_SET | TIM_IER_TIM1
  STA TIM_IER
  
  JSR TIM_Update_T1_F
  
  PLP						; Restore our IRQ status.

  RTS
  
  

COUNTDOWN_IRQ

  LDA IRQH_CMD_Table,X				; Process command shutdown command when asked.
  CMP #IRQH_Shutdown_CMD
  BEQ COUNTDOWN_IRQ_SHUTDOWN
  
  LDA TIM_IFR					; Check whether this is our interrupt to claim
  AND #TIM_IFR_IRQ_FLAG | TIM_IFR_TIM1_FLAG
  CMP #TIM_IFR_IRQ_FLAG | TIM_IFR_TIM1_FLAG
  
  BNE TIM_NOT_OUR_IRQ_B				; Branch politely if it isn't ours.

  SEC						; Update our countdown counter.
  LDA CTR_V
  SBC #1
  STA CTR_V
  LDA CTR_V + 1
  SBC #0
  STA CTR_V + 1
  
  LDA TIM_T1L					; Read to this register to clear the interrupt.
  
  LDA CTR_V					; When we reach zero, shutdown.
  ORA CTR_V + 1
  
  BEQ CTR_Ext_vec_Chk
  
CTR_NoShutdown  
  LDA IRQH_WorkingMask				; Set our claims bit.
  ORA IRQH_ClaimsList
  STA IRQH_ClaimsList

TIM_NOT_OUR_IRQ_B
  RTS

CTR_Ext_vec_Chk					; Check if we want to service an external vector.
  LDA CTR_Options
  BIT #CTR_vec_En
  BEQ CTR_IRQ_ReloadChk				; ...skipping if not to Checking the reload vector.

; External vector branch.
;
; ...If only the 6502 had a JSR (a)!  
  LDA #>[CTR_IRQ_ReloadChk-1]			; Store our return address on the stack then jump
  PHA						; to the external vector.
  LDA #<[CTR_IRQ_ReloadChk-1]
  PHA  
  JMP (CTR_External_vec)
  
CTR_IRQ_ReloadChk						; IRQ Handler done
  LDA CTR_Options
  BIT #CTR_Reload_En
  BEQ COUNTDOWN_IRQ_SHUTDOWN
  
  LDA CTR_RELOAD_V				; Load timer reload value to our counter variable.
  STA CTR_V
  LDA CTR_RELOAD_V+1
  STA CTR_V + 1  

  BRA CTR_NoShutdown  
  
    
COUNTDOWN_IRQ_SHUTDOWN

  LDA TIM_T1L					; Read this register to clear the interrupt

  LDA TIM_ACR					; Disable Timer 1
  AND #@00111111				; only affecting our specific hardware
  STA TIM_ACR
  
  LDA #TIM_IFR_TIM1_FLAG			; Disable Our interrupt
  STA TIM_IER
  
  LDA IRQH_WorkingMask				; Unset our IRQ from the handler disabling further processing.
  EOR #$FF
  AND IRQH_MaskByte
  STA IRQH_MaskByte
  
  LDA #IRQH_Service_CMD				; Reset our CMD register to Service for the next time.
  STA IRQH_CMD_Table,X
  
  LDA IRQH_WorkingMask				; Set our claims bit.
  ORA IRQH_ClaimsList
  STA IRQH_ClaimsList
    
  RTS						; IRQ Handler done.
  
  
  
TIM_Update_T1_F

  PHP						; Save IRQ state and disable interrupts
  SEI
  
  LDA CTR_PERIOD_V				; Load timer
  STA TIM_T1L
  LDA CTR_PERIOD_V + 1
  STA TIM_T1H					; Count commences from here (if running)
  
  PLP						; Restore IRQ status
  
  RTS