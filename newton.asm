;;; Simplified acceleration
;;; Currently both masses are 1 :-P
;;; IX pointing to accel_args
;;; IX = x0
;;; IX + 2 = y0
;;; IX + 4 = x1
;;; IX + 6 = y1
;;; value returned in
;;; BC - accel x
;;; DE - accel y
accel_args:	dw	0, 0, 0, 0
accel_dx:	dw	0
accel_dy:	dw	0
accel_d:	dw	0
accel:
	push	hl		; store current status
	
	ld	h,(ix)
	ld	l,(ix+1)	
	ld	b,(ix+4)
	ld	c,(ix+5)
	srl	h
	rr	l
	srl	b
	rr	c
	call	order_asc
	sbc	hl,bc
	ld	(accel_dx),hl	; x axis distance
	call	distance_term
	ex	de,hl
	ld	h,(ix+2)
	ld	l,(ix+3)
	ld	b,(ix+6)
	ld	c,(ix+7)
	srl	h
	rr	l
	srl	b
	rr	c
	call	order_asc
	sbc	hl,bc
	ld	(accel_dy),hl	; y axis distance
	call	distance_term
	srl	h
	rr	l
	srl	d
	rr	e
	add	hl,de		; can't be negative
	ld	(accel_d),hl	; distance

	ex	de,hl
	ld	bc,(accel_dx)
	call	BC_Div_DE_88
	push	de		; accel x

	ld	de,(accel_d)
	ld	bc,(accel_dy)
	call	BC_Div_DE_88	; accel_y in DE
	pop	bc		; accel_x in BC

	srl	b
	rr	c
	srl	d
	rr	e
	srl	b
	rr	c
	srl	d
	rr	e
	srl	b
	rr	c
	srl	d
	rr	e
	srl	b
	rr	c
	srl	d
	rr	e
	srl	b
	rr	c
	srl	d
	rr	e
	srl	b
	rr	c
	srl	d
	rr	e
	srl	b
	rr	c
	srl	d
	rr	e
	srl	b
	rr	c
	srl	d
	rr	e

	pop	hl		; restore status
	ret
	
;;; Calculates one of the terms of the distance
;;; (x2 - x1) ^ 2
;;; actually, it only calculates the power of 2 of the first half of
;;; the 8.8 fixed point number received as a parameter
;;; HL -(x2 - x1)
;;; result returned in HL
distance_term:
	push	bc		; store current state
	push	de
	
	ld	e,h		; keep the most significant byte from BC
	call	mul8

	pop	de		; restore state
	pop	bc
	ret
	;; push	de		; store current state
	
	;; ld	d,h
	;; ld	e,l
	;; call	mulfixed8_8

	;; pop	de		; restore state
	;; ret

;;; Gets a number in HL and another in BC.
;;; Ensures that the lowest is in BC and the highest in HL
order_asc:
	push	hl
	push	bc
	sbc	hl,bc
	jp	m,order_asc_neg
	pop	bc
	pop	hl
	ret
order_asc_neg:
	pop	hl
	pop	bc
	ret

;;; A containing rotation (0-255)
;;; returning
;;; x thrust in BC
;;; y thrust in DE
thrust:
	push	af
	call	cosine_pond

	ld	b,a
	sra	b
	rr	c
	sra	b
	rr	c
	sra	b
	rr	c
	sra	b
	rr	c
	sra	b
	rr	c
	sra	b
	rr	c
	sra	b
	rr	c
	sra	b
	rr	c
	
	pop	af
	call	sine_pond

	ld	d,a
	sra	d
	rr	e
	sra	d
	rr	e
	sra	d
	rr	e
	sra	d
	rr	e
	sra	d
	rr	e
	sra	d
	rr	e
	sra	d
	rr	e
	sra	d
	rr	e

	ret
	

;;; Ponderated sine
;;; Check sine_table
;;; A containing degrees 0-255 (mapped to 0-360)
;;; Returns sine * 100 in A
sine_pond:
	push	bc		; store current state
	push	hl

	ld	hl,sine_table
	ld	c,a
	xor	a
	ld	b,a
	add	hl,bc
	ld	a,(hl)

	pop	hl		; restore state
	pop	bc
	ret

;;; Ponderated cosine
;;; Check cosine_table
;;; A containing degrees 0-255 (mapped to 0-360)
;;; Returns cosine * 100 in A
cosine_pond:
	push	bc		; store current state
	push	hl

	ld	hl,cosine_table
	ld	c,a
	xor	a
	ld	b,a
	add	hl,bc
	ld	a,(hl)

	pop	hl		; restore state
	pop	bc
	ret
	
;;; Sine
;;; Divide the 360 degres space in 256 positions (fits in a byte)
;;; Shifted 270 degrees, since I prefer to think that "0 degrees" means looking up, not right, and Y grows from the top of the screen towards the bottom.
;;; Results are multiplied by 100
sine_table:
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f6
	db	$f6
	db	$f6
	db	$f6
	db	$f6
	db	$f6
	db	$f6
	db	$f6
	db	$f7
	db	$f7
	db	$f7
	db	$f7
	db	$f7
	db	$f7
	db	$f8
	db	$f8
	db	$f8
	db	$f8
	db	$f8
	db	$f9
	db	$f9
	db	$f9
	db	$f9
	db	$f9
	db	$fa
	db	$fa
	db	$fa
	db	$fa
	db	$fa
	db	$fb
	db	$fb
	db	$fb
	db	$fb
	db	$fc
	db	$fc
	db	$fc
	db	$fc
	db	$fd
	db	$fd
	db	$fd
	db	$fd
	db	$fe
	db	$fe
	db	$fe
	db	$fe
	db	$0
	db	$0
	db	$0
	db	$0
	db	$1
	db	$1
	db	$1
	db	$1
	db	$2
	db	$2
	db	$2
	db	$2
	db	$2
	db	$3
	db	$3
	db	$3
	db	$3
	db	$4
	db	$4
	db	$4
	db	$4
	db	$5
	db	$5
	db	$5
	db	$5
	db	$5
	db	$6
	db	$6
	db	$6
	db	$6
	db	$6
	db	$6
	db	$7
	db	$7
	db	$7
	db	$7
	db	$7
	db	$7
	db	$8
	db	$8
	db	$8
	db	$8
	db	$8
	db	$8
	db	$8
	db	$8
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$8
	db	$8
	db	$8
	db	$8
	db	$8
	db	$8
	db	$8
	db	$8
	db	$7
	db	$7
	db	$7
	db	$7
	db	$7
	db	$7
	db	$6
	db	$6
	db	$6
	db	$6
	db	$6
	db	$6
	db	$5
	db	$5
	db	$5
	db	$5
	db	$4
	db	$4
	db	$4
	db	$4
	db	$4
	db	$3
	db	$3
	db	$3
	db	$3
	db	$2
	db	$2
	db	$2
	db	$2
	db	$2
	db	$1
	db	$1
	db	$1
	db	$1
	db	$0
	db	$0
	db	$0
	db	$0
	db	$fe
	db	$fe
	db	$fe
	db	$fe
	db	$fd
	db	$fd
	db	$fd
	db	$fd
	db	$fc
	db	$fc
	db	$fc
	db	$fc
	db	$fb
	db	$fb
	db	$fb
	db	$fb
	db	$fa
	db	$fa
	db	$fa
	db	$fa
	db	$fa
	db	$f9
	db	$f9
	db	$f9
	db	$f9
	db	$f9
	db	$f8
	db	$f8
	db	$f8
	db	$f8
	db	$f8
	db	$f7
	db	$f7
	db	$f7
	db	$f7
	db	$f7
	db	$f7
	db	$f6
	db	$f6
	db	$f6
	db	$f6
	db	$f6
	db	$f6
	db	$f6
	db	$f6
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5

;;; Cosine
;;; Divide the 360 degres space in 256 positions (fits in a byte)
;;; Shifted 90 degrees, since I prefer to think that "0 degrees" means looking up, not right.
;;; Reversed, as I prefer to think sprits turn clockwise
;;; Results are multiplied by 100
cosine_table:
	db	$0
	db	$0
	db	$0
	db	$0
	db	$0
	db	$1
	db	$1
	db	$1
	db	$1
	db	$2
	db	$2
	db	$2
	db	$2
	db	$3
	db	$3
	db	$3
	db	$3
	db	$4
	db	$4
	db	$4
	db	$4
	db	$4
	db	$5
	db	$5
	db	$5
	db	$5
	db	$5
	db	$6
	db	$6
	db	$6
	db	$6
	db	$6
	db	$7
	db	$7
	db	$7
	db	$7
	db	$7
	db	$7
	db	$8
	db	$8
	db	$8
	db	$8
	db	$8
	db	$8
	db	$8
	db	$8
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$9
	db	$8
	db	$8
	db	$8
	db	$8
	db	$8
	db	$8
	db	$8
	db	$7
	db	$7
	db	$7
	db	$7
	db	$7
	db	$7
	db	$7
	db	$6
	db	$6
	db	$6
	db	$6
	db	$6
	db	$5
	db	$5
	db	$5
	db	$5
	db	$5
	db	$4
	db	$4
	db	$4
	db	$4
	db	$3
	db	$3
	db	$3
	db	$3
	db	$3
	db	$2
	db	$2
	db	$2
	db	$2
	db	$1
	db	$1
	db	$1
	db	$1
	db	$0
	db	$0
	db	$0
	db	$0
	db	$fe
	db	$fe
	db	$fe
	db	$fe
	db	$fd
	db	$fd
	db	$fd
	db	$fd
	db	$fc
	db	$fc
	db	$fc
	db	$fc
	db	$fb
	db	$fb
	db	$fb
	db	$fb
	db	$fb
	db	$fa
	db	$fa
	db	$fa
	db	$fa
	db	$f9
	db	$f9
	db	$f9
	db	$f9
	db	$f9
	db	$f8
	db	$f8
	db	$f8
	db	$f8
	db	$f8
	db	$f7
	db	$f7
	db	$f7
	db	$f7
	db	$f7
	db	$f7
	db	$f7
	db	$f6
	db	$f6
	db	$f6
	db	$f6
	db	$f6
	db	$f6
	db	$f6
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f5
	db	$f6
	db	$f6
	db	$f6
	db	$f6
	db	$f6
	db	$f6
	db	$f6
	db	$f6
	db	$f7
	db	$f7
	db	$f7
	db	$f7
	db	$f7
	db	$f7
	db	$f8
	db	$f8
	db	$f8
	db	$f8
	db	$f8
	db	$f9
	db	$f9
	db	$f9
	db	$f9
	db	$f9
	db	$fa
	db	$fa
	db	$fa
	db	$fa
	db	$fa
	db	$fb
	db	$fb
	db	$fb
	db	$fb
	db	$fc
	db	$fc
	db	$fc
	db	$fc
	db	$fd
	db	$fd
	db	$fd
	db	$fd
	db	$fe
	db	$fe
	db	$fe
	db	$fe
	db	$0
