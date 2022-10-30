;;; math.asm
;;; Mathematical operations
;;; NOTICE I've shamelessly adapted code from othe places.
	
;;; Adapted from http://z80-heaven.wikidot.com/advanced-math
mul8:
;;; Inputs:
;;;  H and E
;;; Outputs:
;;;  HL is the product
;;;  D is 0
;;;  A,E,B,C are preserved
	ld	d,0
	ld	l,d
	sla	h
	jr 	nc,$+3
	ld 	l,e
	add 	hl,hl
	jr 	nc,$+3
	add 	hl,de
	add 	hl,hl
	jr	nc,$+3
	add 	hl,de
	add 	hl,hl
	jr 	nc,$+3
	add 	hl,de
	add 	hl,hl
	jr 	nc,$+3
	add 	hl,de
	add 	hl,hl
	jr	nc,$+3
	add 	hl,de
	add 	hl,hl
	jr 	nc,$+3
	add 	hl,de
	add 	hl,hl
	ret 	nc
	add 	hl,de
	ret
	
;;; Adapted from https://github.com/Zeda/z80float/blob/master/common/mul16.z80
mul16:
;;; BC*DE --> DEHL
	ld	a,d
	ld	d,0
	ld	h,b
	ld	l,c
	add	a,a
	jr	c,Mul_BC_DE_DEHL_Bit14
	add	a,a
	jr	c,Mul_BC_DE_DEHL_Bit13
	add	a,a
	jr	c,Mul_BC_DE_DEHL_Bit12
	add	a,a
	jr	c,Mul_BC_DE_DEHL_Bit11
	add	a,a
	jr	c,Mul_BC_DE_DEHL_Bit10
	add	a,a
	jr	c,Mul_BC_DE_DEHL_Bit9
	add	a,a
	jr	c,Mul_BC_DE_DEHL_Bit8
	add	a,a
	jr	c,Mul_BC_DE_DEHL_Bit7
	ld	a,e
 	and	%11111110
	add	a,a
	jr	c,Mul_BC_DE_DEHL_Bit6
	add	a,a
	jr	c,Mul_BC_DE_DEHL_Bit5
	add	a,a
	jr	c,Mul_BC_DE_DEHL_Bit4
	add	a,a
	jr	c,Mul_BC_DE_DEHL_Bit3
	add	a,a
	jr	c,Mul_BC_DE_DEHL_Bit2
	add	a,a
	jr	c,Mul_BC_DE_DEHL_Bit1
	add	a,a
	jr	c,Mul_BC_DE_DEHL_Bit0
	rr	e
	ret	c
	ld	h,d
	ld	l,e
	ret

Mul_BC_DE_DEHL_Bit14:
	add	hl,hl
	adc	a,a
	jr	nc,Mul_BC_DE_DEHL_Bit13
	add	hl,bc
	adc	a,d
Mul_BC_DE_DEHL_Bit13:
	add	hl,hl
	adc	a,a
	jr	nc,Mul_BC_DE_DEHL_Bit12
	add	hl,bc
	adc	a,d
Mul_BC_DE_DEHL_Bit12:
	add	hl,hl
	adc	a,a
	jr	nc,Mul_BC_DE_DEHL_Bit11
	add	hl,bc
	adc	a,d
Mul_BC_DE_DEHL_Bit11:
	add	hl,hl
	adc	a,a
	jr	nc,Mul_BC_DE_DEHL_Bit10
	add	hl,bc
	adc	a,d
Mul_BC_DE_DEHL_Bit10:
	add	hl,hl
	adc	a,a
	jr	nc,Mul_BC_DE_DEHL_Bit9
	add	hl,bc
	adc	a,d
Mul_BC_DE_DEHL_Bit9:
	add	hl,hl
	adc	a,a
	jr	nc,Mul_BC_DE_DEHL_Bit8
	add	hl,bc
	adc	a,d
Mul_BC_DE_DEHL_Bit8:
	add	hl,hl
	adc	a,a
	jr	nc,Mul_BC_DE_DEHL_Bit7
	add	hl,bc
	adc	a,d
Mul_BC_DE_DEHL_Bit7:
	ld	d,a
	ld	a,e
	and	%11111110
	add	hl,hl
	adc	a,a
	jr	nc,Mul_BC_DE_DEHL_Bit6
	add	hl,bc
	adc	a,0
Mul_BC_DE_DEHL_Bit6:
	add	hl,hl
	adc	a,a
	jr	nc,Mul_BC_DE_DEHL_Bit5
	add	hl,bc
	adc	a,0
Mul_BC_DE_DEHL_Bit5:
	add	hl,hl
	adc	a,a
	jr	nc,Mul_BC_DE_DEHL_Bit4
	add	hl,bc
	adc	a,0
Mul_BC_DE_DEHL_Bit4:
	add	hl,hl
	adc	a,a
	jr	nc,Mul_BC_DE_DEHL_Bit3
	add	hl,bc
	adc	a,0
Mul_BC_DE_DEHL_Bit3:
	add	hl,hl
	adc	a,a
	jr	nc,Mul_BC_DE_DEHL_Bit2
	add	hl,bc
	adc	a,0
Mul_BC_DE_DEHL_Bit2:
	add	hl,hl
	adc	a,a
	jr	nc,Mul_BC_DE_DEHL_Bit1
	add	hl,bc
	adc	a,0
Mul_BC_DE_DEHL_Bit1:
	add	hl,hl
	adc	a,a
	jr	nc,Mul_BC_DE_DEHL_Bit0
	add	hl,bc
	adc	a,0
Mul_BC_DE_DEHL_Bit0:
	add	hl,hl
	adc	a,a
	jr	c,Mul_BC_DE_DEHL_FunkyCarry
	rr	e
	ld	e,a
	ret	nc
	add	hl,bc
	ret	nc
	inc	e
	ret	nz
	inc	d
	ret

Mul_BC_DE_DEHL_FunkyCarry:
	inc	d
	rr	e
	ld	e,a
	ret	nc
	add	hl,bc
	ret	nc
	inc	e
	ret


mulfixed8_8:
	push 	bc		; store current state
	call 	mulfixed8_8_unsafe
	pop 	bc		; restore status
	ret
	
;;; Adapted from http://z80-heaven.wikidot.com/advanced-math
mulfixed8_8_unsafe:
;;; Multiplies H.L by D.E, stores the result in H.L
;;; First, find out if the output is positive or negative
	ld a,h
	xor d	
	push af   ;sign bit is the result sign bit

;;; Now make sure the inputs are positive
	xor d     			; A now has the value of H, since I XORed it with D twice (cancelling)
	jp p,mulfixed8_8_lbl1   	; if Positive, don't negate
	xor a
	sub l
	ld l,a
	sbc a,a
	sub h
	ld h,a
mulfixed8_8_lbl1:
	bit 7,d
	jr z,mulfixed8_8_lbl2
	xor a
	sub e
	ld e,a
	sbc a,a
	sub d
	ld d,a
mulfixed8_8_lbl2:
;;; Now we need to put DE in BC to use mul16
	ld b,d
	ld c,e
	call mul16

;;; Get the middle two bytes, EH, and put them in HL
	ld l,h
	ld h,e

;;; We should check for overflow. If D>0, we will set HL to 0x7FFF
	ld a,d
	or a
	jr z,mulfixed8_8_lbl3
	ld hl,$7FFF
mulfixed8_8_lbl3:

;;; Now we need to restore the sign
  	pop af
	ret p    		; don't need to do anything, result is already positive
	xor a
	sub l
	ld l,a
	sbc a,a
	sub h
	ld h,a
	ret

;;; Adapted form http://z80-heaven.wikidot.com/advanced-math#toc32
BC_Div_DE_88:
;; ;Inputs:
;;; DE,BC are 8.8 Fixed Point numbers
;;; Outputs:
;;; DE is the 8.8 Fixed Point result (rounded to the least significant bit)

;;; First, find out if the output is positive or negative
	ld a,b
	xor d
	push af  ; sign bit is the result sign bit

;;; Now make sure the inputs are positive
	xor b     ; A now has the value of B, since I XORed it with D twice (cancelling)
	jp p,BC_Div_DE_88_lbl1   ; if Positive, don't negate
	xor a
	sub c
	ld c,a
	sbc a,a
	sub b
	ld b,a
BC_Div_DE_88_lbl1:

;;; now make DE negative to optimize the remainder comparison
	ld a,d
	or d
	jp m,BC_Div_DE_88_lbl2
	xor a
	sub e
	ld e,a
	sbc a,a
	sub d
	ld d,a
BC_Div_DE_88_lbl2:

;;; if DE is 0, we can call it an overflow
;;; A is the current value of D
	or e
	jr z,div_fixed88_overflow

;;; The accumulator gets set to B if no overflow.
;;; We can use H=0 to save a few cc in the meantime
	ld h,0

;;; if B+DE>=0, then we'll have overflow
	ld a,b
	add a,e
	ld a,d
	adc a,h
	jr c,div_fixed88_overflow

;;; Now we can load the accumulator/remainder with B
;;; H is already 0
	ld l,b

	ld a,c
	call div_fixed88_sub
	ld c,a

	ld a,b      ; A is now 0
	call div_fixed88_sub

	ld d,c
	ld e,a
	pop af
	ret p
	xor a
	sub e
	ld e,a
	sbc a,a
	sub d
	ld d,a
	ret

div_fixed88_overflow:
	ld de,$7FFF
	pop af
	ret p
	inc de
	inc e
	ret

div_fixed88_sub:
	ld b,8
BC_Div_DE_88_lbl3:
	rla
	adc hl,hl
	add hl,de
	jr c,$+4
	sbc hl,de
	djnz BC_Div_DE_88_lbl3
	adc a,a
	ret
