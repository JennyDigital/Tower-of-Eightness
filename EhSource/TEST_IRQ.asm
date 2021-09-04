; Test IRQ.  The job of this IRQ handler besides prooving the system works is to
; Add a free-running system counter.  This is to be driven from the timer on the GPIO card.


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

INIT_TEST_IRQ

  LDA #0				; Initialise our counter to 0
  STA CTR_V
  STA CTR_V + 1
  
  
  LDA #<TIM_DELAY_C			; Load timer value to our variable
  STA CTR_LOAD_VAL_V
  LDA #>TIM_DELAY_C + 1
  STA CTR_LOAD_VAL_V + 1
  
  LDA #@01000001				; Load Auxilliary Control Register with continuous interrupts on T1 with latching
  STA TIM_ACR
  
  LDA #@11000000
  STA TIM_IER
  
  JSR TIM_Update_T1_F

  RTS
  

TEST_IRQ

  CLC
  LDA CTR_V
  ADC #1
  STA CTR_V
  LDA CTR_V + 1
  ADC #0
  STA CTR_V + 1
  
  LDA TIM_T1L

  RTS
  
  
TIM_Update_T1_F

  PHP					; Save IRQ state and disable interrupts
  SEI
  
  LDA CTR_LOAD_VAL_V			; Load timer
  STA TIM_T1L
  LDA CTR_LOAD_VAL_V + 1
  STA TIM_T1H				; Count commences from here (if running)
  
  PLP					; Restore IRQ status
  
  RTS
