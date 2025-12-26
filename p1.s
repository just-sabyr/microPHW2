; Define Register Addresses - for SysTick Handler Interupt correct setup
STCTRL   EQU 0xE000E010
STRELOAD EQU 0xE000E014
STCVR    EQU 0xE000E018


;---------------------------
; Vector Table
;---------------------------
	EXTERN _stack_top				; import from .sct

    AREA RESET, DATA, READONLY
    DCD _stack_top                 ; Stack pointer (defined in the linker script)
    DCD Reset_Handler               ; Reset handler
    DCD SysTick_Handler             ; SysTick handler



;---------------------------
; Main Code
;---------------------------
	AREA brush_stroker, CODE, READONLY			; Code Area
	ENTRY										; Entry point
	ALIGN 4										; 32 bit aligned - safely
	THUMB										; THUMB-1 Only since Cortext M0

Reset_Handler
    LDR R0, =__main                 ; Load address of __main
    BX R0                           ; Branch to __main

__main FUNCTION
    EXPORT __main
    ; Initialize variables or perform basic operations
    MOVS R0, #5                    ; Example: Load 5 into R0
    MOVS R1, #10                   ; Example: Load 10 into R1
    ADDS R2, R0, R1                ; Example: Add R0 and R1, store in R2
    BL Timer_Init                  ; Call Timer_Init
    BX LR                          ; Return - SysTick Handler should work automatically no need to loop any code
    ENDP

;---------------------------
; SysTick Handler
;---------------------------
SysTick_Handler FUNCTION
	EXPORT SysTick_Handler
	; TODO: Other parts

	BX LR ; Return 
	
	ENDFUNC


;---------------------------
; Timer Init 
;---------------------------
Timer_Init
	EXPORT Timer_Init
	LDR R0, =STCTRL
	MOVS R1, #0
	STR R1, [R0]								; 1. Disable SysTick
	
	LDR R1, =9999999							; 10 MHz - 1
	STR R1, [R0, #4]							; 2. Set STRELOAD (offset 0x4)
	
	MOVS R1, #0
	STR R1, [R0, #8]							; 3. Clear STCVR (offset 0x8)
	
	MOVS R1, #7									; 2, 1, 0
	STR R1, [R0]								; 4. Enable (ClockSource, TickInt, Enable)
	BX LR										; Return 
	
	

;---------------------------
;Shorter Example
;---------------------------
    AREA myData, DATA, READONLY ; Define a read only data section
arr    	DCD 0xA8, 0x14, 0x24, 0x32, 0x02, 0xFF

    AREA myDataRW, DATA, READWRITE ; Define a read write data section
varx    DCD 0 
vary    DCD 0
varc	DCB 0
vari	DCD 0
varb	DCD 0


	END
