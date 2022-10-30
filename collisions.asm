;;; Checks if a point is contained within a rectangle (borders included)
;;; DE contains the coordinates of the point
;;; HL contains the coordinates of the top-left corner of a 16x16 rectangle
;;; The carry flag is set if the point is indeed contained within the rectangle
col_contains:
	ld	a,h	; check if D > H
	sub	d
	jp	nc,ccno
	ld	a,h	; check if D < H+16
	add	a,16
	sub	d
	jp	c,ccno
	ld	a,l	; check if E > L
	sub	e
	jp	nc,ccno
	ld	a,l	; check if E < L+16
	add	a,16
	sub	e
	jp	c,ccno
	scf			; carry flag set
	ret
ccno:	xor	a		; carry flag reset
	ret

;;; Explodes the current rocket if there's collision
col_rocket:
	push	hl		; store current state

	;; check for collisions with torpedoes
	ld	a,(posx+1)
	ld	h,a
	ld	a,(posy+1)
	ld	l,a
	ld	a,(rktsts)
	call	trps_collision
	jp	c,crco
	;; check for collisions with the central star
	ld	a,(posx+1)	; upper left corner
	ld	h,a
	ld	a,(posy+1)
	ld	l,a
	ld	a,star_x
	ld	d,a
	ld	a,star_y
	ld	e,a
	call	col_contains
	jp	c,crco
	ld	a,star_x+16	; upper right corner
	ld	d,a
	ld	a,star_y
	ld	e,a
	call	col_contains
	jp	c,crco
	ld	a,star_x	; lower left corner
	ld	d,a
	ld	a,star_y=16
	ld	e,a
	call	col_contains
	jp	c,crco
	ld	a,star_x+16	; lower right corner
	ld	d,a
	ld	a,star_y+16
	ld	e,a
	call	col_contains
	jp	c,crco
	
	jp	crnoco		; no collisions
crco:	ld	a,(rktsts)
	or	1
	ld	(rktsts),a

crnoco:	pop	hl		; restore state
	ret
