			#include<p18F4550.inc>

innerloop	set	0x00
outerloop	set	0x01
loop_cnt1	set	0x02
loop_cnt2	set	0x03
loop_cnt3	set	0x04
loop_cnt4	set	0x05
hold		set	0x10
boom		set	0x11
			
			org 0x00
			goto start
			org 0x08
			retfie
			org 0x18
			retfie

;***************************************
;Subroutine for SOUND
;***************************************

bunyi		BSF		PORTC, 2, A
			CALL	DELAY0.125
			BCF		PORTC, 2, A
			CALL	DELAY0.125
			RETURN

bunyi2		BSF		PORTC, 2, A
			CALL	DELAY
			BCF		PORTC, 2, A
			CALL	DELAY
			RETURN

bunyi3		BSF		PORTC, 2, A
			CALL	DELAY5
			CALL	DELAY5
			BCF		PORTC, 2, A
			CALL	DELAY
			RETURN

;***************************************
;Subroutine for 7 segment display sequence
;***************************************

show9		MOVLW	D'9'
			MOVFF	WREG, PORTD
			CALL	bunyi2
			CLRF	PORTD, A
			RETURN
show8		MOVLW	D'8'
			MOVFF	WREG, PORTD
			CALL	bunyi2
			CLRF	PORTD, A
			RETURN
show7		MOVLW	D'7'
			MOVFF	WREG, PORTD
			CALL	bunyi2
			CLRF	PORTD, A
			RETURN
show6		MOVLW	D'6'
			MOVFF	WREG, PORTD
			CALL	bunyi2
			CLRF	PORTD, A
			RETURN
show5		MOVLW	D'5'
			MOVFF	WREG, PORTD
			CALL	bunyi2
			CLRF	PORTD, A
			RETURN
show4		MOVLW	D'4'
			MOVFF	WREG, PORTD
			CALL	bunyi2
			CLRF	PORTD, A
			RETURN
show3		MOVLW	D'3'
			MOVFF	WREG, PORTD
			CALL	bunyi2
			CLRF	PORTD, A
			RETURN
show2		MOVLW	D'2'
			MOVFF	WREG, PORTD
			CALL	bunyi2
			CLRF	PORTD, A
			RETURN
show1		MOVLW	D'1'
			MOVFF	WREG, PORTD
			CALL	bunyi2
			CLRF	PORTD, A
			RETURN
offLED		CALL	launch
up			BTFSC	PORTB, 2, A
			BRA		up
			CALL	INCREMENT
			RETURN

;************************************************
;Subroutine for Launch
;************************************************

launch		MOVLW	0x05
			MOVWF	boom, A
			BSF		PORTC, 2, A
loop		SETF	PORTD, A
			CALL	DELAY
			CLRF	PORTD, A
			CALL	DELAY
			DECFSZ	boom, F, A
			BRA		loop
			BCF		PORTC, 2, A
			RETURN

;************************************************
;Subroutine for Count Rocket
;************************************************

INCREMENT	INCF	hold, F, A
			MOVFF	hold, PORTD
			CALL	bunyi2
			CLRF	PORTD, A
			RETURN

;************************************************
;Subroutine for LED moving
;************************************************

SETright	BSF		PORTD, 7, A
			CALL	bunyi
			RRNCF	PORTD, F, A
			BSF		PORTD, 7, A
			CALL	bunyi
			RETURN

right		RRNCF	PORTD, F, A
			CALL	bunyi
			RRNCF	PORTD, F, A
			CALL	bunyi
			RRNCF	PORTD, F, A
			CALL	bunyi
			RRNCF	PORTD, F, A
			CALL	bunyi
			RRNCF	PORTD, F, A
			CALL	bunyi
			RETURN

CLRleft		BCF		PORTD, 0, A
			RRNCF	PORTD, F, A
			CALL	bunyi
			BCF		PORTD, 0, A
			RRNCF	PORTD, F, A
			CALL	bunyi
			RETURN

SETleft		BSF		PORTD, 0, A
			CALL	bunyi
			RLNCF	PORTD, F, A
			BSF		PORTD, 0, A
			CALL	bunyi
			RETURN

left		RLNCF	PORTD, F, A
			CALL	bunyi
			RLNCF	PORTD, F, A
			CALL	bunyi
			RLNCF	PORTD, F, A
			CALL	bunyi
			RLNCF	PORTD, F, A
			CALL	bunyi
			RLNCF	PORTD, F, A
			CALL	bunyi
			RETURN

CLRright	BCF		PORTD, 7, A
			RLNCF	PORTD, F, A
			CALL	bunyi
			BCF		PORTD, 7, A
			RLNCF	PORTD, F, A
			CALL	bunyi
			RETURN
			
;************************************************
;Subroutine for Button KR
;************************************************

prob		BTFSS	PORTB, 1, A
			BRA		masalah
			RETURN

;************************************************
;Subroutine for Knight Rider
;************************************************

masalah		CLRF	hold, A
			BSF		PORTD, 7, A       
			CALL	bunyi
    		RRNCF	PORTD, F, A
			CALL	SETright
			CALL	right
			CALL	CLRleft
			RLNCF	PORTD, F, A
			CALL	SETleft
			CALL	left
			CALL	CLRright
			CLRF	PORTD, A
			BRA		prob

;***************************************
;Subroutine for 1sec delay
;***************************************

dup_nop		macro num
			variable i
i = 0
			while i < num
			nop
i += 1
			endw
			endm


DELAY		MOVLW	D'40'			;0.5sec delay subroutine for
			MOVWF	outerloop, A	;20MHz crystal frequency
AGAIN1		MOVLW	D'250'
			MOVWF	innerloop, A
AGAIN2		dup_nop	D'247'
			DECFSZ	innerloop, F, A
			BRA		AGAIN2
			DECFSZ	outerloop, F, A
			BRA		AGAIN1
			NOP
			RETURN

;************************************************
;Subroutine for 0.125sec delay
;************************************************

dup_nop1		macro kk
				variable i
i = 0
				while i < kk
				nop
i += 1 
				endw
				endm

DELAY0.125		MOVLW	D'5'			; 0.0625sec delay subroutine for 
				MOVWF	loop_cnt2, A	; 20MHz crystal frequency
AGAIN3			MOVLW	D'250'
				MOVWF	loop_cnt1, A 
AGAIN4			dup_nop1	D'247'
				DECFSZ	loop_cnt1, F, A
				BRA		AGAIN4
				DECFSZ	loop_cnt2, F, A
				BRA		AGAIN3 
				NOP
				RETURN

;***************************************
;Subroutine for 5sec delay
;***************************************

dup_nop2	macro num
			variable i
i = 0
			while i < num
			nop
i += 1
			endw
			endm


DELAY5		MOVLW	D'200'			;2.5sec delay subroutine for
			MOVWF	loop_cnt4, A	;20MHz crystal frequency
AGAIN5		MOVLW	D'250'
			MOVWF	loop_cnt3, A
AGAIN6		dup_nop	D'247'
			DECFSZ	loop_cnt3, F, A
			BRA		AGAIN6
			DECFSZ	loop_cnt4, F, A
			BRA		AGAIN5
			NOP
			RETURN

;***************************************
;My Main Program
;***************************************

start		SETF	TRISB, A
			CLRF	TRISE, A
			CLRF	TRISD, A
			BCF		TRISC, 2, A
			BCF		PORTC, 2, A
			CLRF	PORTD, A
			BSF		PORTE, 0, A
			CLRF	hold, A

check9		BTFSC	PORTB, 0, A
			BRA		check9
			CALL	show9
			CALL	prob
check8		BTFSC	PORTB, 0, A
			BRA		check9
			CALL	show8
			CALL	prob
check7		BTFSC	PORTB, 0, A
			BRA		check9
			CALL	show7
			CALL	prob
check6		BTFSC	PORTB, 0, A
			BRA		check9
			CALL	show6
			CALL	prob
check5		BTFSC	PORTB, 0, A
			BRA		check9
			CALL	show5
			CALL	prob
check4		BTFSC	PORTB, 0, A
			BRA		check9
			CALL	show4
			CALL	prob
check3		BTFSC	PORTB, 0, A
			BRA		check9
			CALL	show3
			CALL	prob
check2		BTFSC	PORTB, 0, A
			BRA		check9
			CALL	show2
			CALL	prob
check1		BTFSC	PORTB, 0, A
			BRA		check9
			CALL	show1
			CALL	prob
separate	BTFSC	PORTB, 0, A
			CLRF	PORTD, A
			CALL	offLED
			CALL	prob
			BRA		check9
			END