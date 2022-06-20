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
	sbc	hl,bc
	srl	h
	rr	l
	ld	(accel_dx),hl	; x axis distance
	call	distance_term
	ex	de,hl
	ld	h,(ix+2)
	ld	l,(ix+3)
	ld	b,(ix+6)
	ld	c,(ix+7)
	sbc	hl,bc
	srl	h
	rr	l
	ld	(accel_dy),hl	; y axis distance
	call	distance_term
	add	hl,de
	ld	(accel_d),hl	; distance

	ex	de,hl
	ld	bc,(accel_dx)
	call	BC_Div_DE_88
	srl	d
	rr	e
	srl	d
	rr	e
	srl	d
	rr	e
	srl	d
	rr	e
	srl	d
	rr	e
	srl	d
	rr	e
	srl	d
	rr	e
	srl	d
	rr	e
	push	de		; accel x

	ld	de,(accel_d)
	ld	bc,(accel_dy)
	call	BC_Div_DE_88	; accel_y in DE
	srl	d
	rr	e
	srl	d
	rr	e
	srl	d
	rr	e
	srl	d
	rr	e
	srl	d
	rr	e
	srl	d
	rr	e
	srl	d
	rr	e
	srl	d
	rr	e
	pop	bc		; accel_x in BC

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
	
