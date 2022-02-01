;Author: Joseph Martinez
;Class: EE 351
;Instructor: Dr. Wedeward
;Project 1: Part 1

IN R16, 0xFC
OUT DDRD, R16			;set PD[1:0] as inputs
IN R16, 0x06
OUT DDRB, R16			;set PB[5:0] as outputs

LDI R17, 0x00
LDI R22, 0xFF

D1:
	LDI R21, 0xFF
	RJMP DELAY500ms
D2:
	LDI R20, 0x9F
	RJMP DELAY500ms

LOOP:
	LDI ZH, HIGH(TRUTH)	;load high bits of TRUTH into ZH
	LDI ZL, LOW(TRUTH)	;load low bits of TRUTH into ZL
	IN R16, PIND		;load PD input into R16
	ANDI R16, 0x03		;clear bits [7:2]
	ADD ZL, R16			;add offset to Z
	ADC ZH, R17			;update ZH if carry occurs
	LPM R18, Z			;load Z value into PM
	;OUT PORTB, R18		;output result to PB
	RJMP SEQUENCE

SEQUENCE:
	LDI R19, R18
	CPI R19, 0b111111
	BREQ STOP
	LDI R19, R18		;copy output
	ANDI R19, 0b001100	
	OUT PORTB, R19		;turn on first sequence
	RCALL DELAY500ms	;delay
	LDI R19, R18
	ANDI R19, 0b011110	
	OUT PORTB, R19		;turn on second sequence	
	RCALL DELAY500ms	;delay
	LDI R19, R18
	ANDI R19, 0b111111
	OUT PORTB, R19		;turn on third sequence
	RCALL DELAY500ms	;delay
	OUT PORTB, 0b000000	;turn on final sequence
	RCALL DELAY500ms
	RJMP SEQUENCE		;cycle again

STOP:
	OUT PORTB, R18		;all LEDs on
	RCALL DELAY500ms	;delay
	CLZ					;clear Z flag
	RJMP SEQUENCE

DELAY500ms:				;half second delay
	DEC R20				;start decrementing
	BRNE DELAY500ms
	DEC R21
	BRNE D1
	DEC R22
	BRNE D2
	CLZ					;clear Z flag
	RET

TRUTH:					;look-up table
	.DB 0b000000, 0b111000, 0b000111, 0b111111