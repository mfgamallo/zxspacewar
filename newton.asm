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
	
