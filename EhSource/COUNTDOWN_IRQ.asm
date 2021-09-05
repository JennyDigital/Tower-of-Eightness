; Countdown IRQ.

; Adds a system countdown timer.  This is to be driven from the timer on the GPIO card.


; Variables

CTR_V			= $A50		; This is our counter variable base address.
CTR_LOAD_VAL_V		= $A52		; This is the interval between counts in PHI2 ticks


; Constants

TIM_DELAY_C		= 39999		; This is the value we are going to use to set the timer. 10ms @4MHz


; Hardware constants

TIM_T1L			= TAPE_IOBASE + 4
TIM_T1H			= TAPE_IOBASE + 5

TIM_ACR			= TAPE_IOBASE + $B
TIM_IFR			= TAPE_IOBASE + $D
TIM_IER			= TAPE_IOBASE + $E

IFR_IRQ_FLAG		= @10000000
IFR_TIM1_FLAG		= @01000000


INIT_COUNTDOWN_IRQ
  
  PHP					; Add our interrupt guard
  SEI
  
  ORA IRQH_MaskByte			; Mark our IRQ as active.
  STA IRQH_MaskByte
  
  LDA #<TIM_DELAY_C			; Load timer value to our variable
  STA CTR_LOAD_VAL_V
  LDA #>TIM_DELAY_C
  STA CTR_LOAD_VAL_V + 1
  
  LDA TIM_ACR
  ORA #@01000000			; Load Auxilliary Control Register with continuous interrupts on T1 with latching
  STA TIM_ACR
  
  LDA TIM_IER				; Start our interrupts running
  ORA #@11000000
  STA TIM_IER
  
  JSR TIM_Update_T1_F
  
  PLP					; Restore our IRQ status

  RTS
  
  

COUNTDOWN_IRQ

  LDA IRQH_CMD_Table,X			; Process command shutdown command when asked.
  CMP #IRQH_Shutdown_CMD
  BEQ COUNTDOWN_IRQ_SHUTDOWN
  
  LDA TIM_IFR				; Check whether this is our interrupt to claim
  AND #IFR_IRQ_FLAG | IFR_TIM1_FLAG
  CMP #IFR_IRQ_FLAG | IFR_TIM1_FLAG
  
  BNE TIM_NOT_OUR_IRQ_B			; Branch politely if it isn't ours.
  
  LDA CTR_V				; When we reach zero, shutdown.
  ORA CTR_V + 1
  BEQ COUNTDOWN_IRQ_SHUTDOWN

  SEC					; Update our countdown counter.
  LDA CTR_V
  SBC #1
  STA CTR_V
  LDA CTR_V + 1
  SBC #0
  STA CTR_V + 1
  
  LDA TIM_T1L				; Read to this register to clear the interrupt.
  
  LDA IRQH_WorkingMask			; Set our claims bit.
  ORA IRQH_ClaimsList
  STA IRQH_ClaimsList

TIM_NOT_OUR_IRQ_B
  RTS					; IRQ Handler done

    
COUNTDOWN_IRQ_SHUTDOWN

  LDA TIM_T1L				; Read this register to clear the interrupt

  LDA TIM_ACR				; Disable Timer 1
  AND #@00111111			; only affecting our specific hardware
  STA TIM_ACR
  
  LDA #IFR_TIM1_FLAG			; Disable Our interrupt
  STA TIM_IER
  
  LDA IRQH_WorkingMask			; Unset our IRQ from the handler
  EOR #$FF
  AND IRQH_MaskByte
  STA IRQH_MaskByte
    
  RTS					; IRQ Handler done.
  
  
  
TIM_Update_T1_F

  PHP					; Save IRQ state and disable interrupts
  SEI
  
  LDA CTR_LOAD_VAL_V			; Load timer
  STA TIM_T1L
  LDA CTR_LOAD_VAL_V + 1
  STA TIM_T1H				; Count commences from here (if running)
  
  PLP					; Restore IRQ status
  
  RTS