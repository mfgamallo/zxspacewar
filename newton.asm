;;; Simplified acceleration
;;; Currently both masses are 1 :-P
;;; IX pointing to accel_args
;;; IX = x1
;;; IX + 2 = y1
;;; IX + 4 = x2
;;; IX + 6 = y2
;;; value returned in HL
accel_args:	dw	0, 0, 0, 0
	
;;; Simplified distance between two points
;;; value returned in HL
distance:
	push	bc		; store current status
	push	de
	
	ld	h,(ix+4)
	ld	l,(ix+5)
	ld	b,(ix)
	ld	c,(ix+1)
	call	distance_term
	ex	de,hl
	ld	h,(ix+6)
	ld	l,(ix+7)
	ld	b,(ix+2)
	ld	c,(ix+3)
	call	distance_term
	add	hl,de

	pop	de		; restore status
	pop	bc
	ret

;;; Calculates one of the terms of the distance
;;; (x2 - x1) ^ 2
;;; BC - x1
;;; HL - x2
;;; Assumes x1 and x2 are fixed point 8.8
;;; When doing the power of two discards the decimal parts of x1 and x2
;;; result returned in HL
distance_term:
	push	de		; store current state
	
	sbc	hl,bc
	ld	e,h		; keep the most significative byte from BC
	call	mul8

	pop	de		; restore state
	ret
	
