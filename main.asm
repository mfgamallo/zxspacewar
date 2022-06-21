org 32768

main:	halt

	;; experiments
	;; xor	a
	;; ld	hl,$ff00
	;; ld	de,$8000
	;; sbc	hl,de
	;; ld	hl,$0400
	;; ld	de,$0200
	;; call distance_term
	;; ld	ix,accel_args
	;; ld	(ix),$01	; x1
	;; ld	(ix+1),$01
	;; ld	(ix+2),$01	; y1
	;; ld	(ix+3),$01
	;; ld	(ix+4),$88	; x2
	;; ld	(ix+5),$00
	;; ld	(ix+6),$88	; y2
	;; ld	(ix+7),$02
	;; call	accel
	
	;; delete the sprite
	ld	hl,(posx)
	ld	de,(posy)
	call	delete_dw_sprite

	;; move the sprite
	call	move

	;; paint the sprite
	ld	hl,(posx)
	ld	de,(posy)
	call 	paint_dw_sprite
	
	jr 	main

move:
	push	bc		; store current state

	;; update accy
	;; simplified accx:	K * ( m0 * (x0-x1) )  /  ( (x0-x1)^2 + (y0-y1)^2 )
	;; simplified accy:	K * ( m0 * (y0-y1) )  /  ( (x0-x1)^2 + (y0-y1)^2 )
	ld	ix,accel_args
	ld	hl,(sunx)	; x0
	ld	(ix),h
	ld	(ix+1),l
	ld	hl,(suny)	; y0
	ld	(ix+2),h
	ld	(ix+3),l
	ld	hl,(posx)	; x1
	ld	(ix+4),h
	ld	(ix+5),l
	ld	hl,(posy)	; y1
	ld	(ix+6),h
	ld	(ix+7),l
	call	accel

	push	de		; keep de because it contains d_acc_y
	ld	de,(posx)
	srl	d
	rr	e
	ld	hl,(sunx)
	srl	h
	rr	l
	sbc	hl,de
	jp	m,acc_x_neg
	ld	hl,(velx)
	add	hl,bc
	jp	acc_x_end
acc_x_neg:
	ld	hl,(velx)
	sbc	hl,bc
acc_x_end:	
	ld	(velx),hl	; new velx

	pop	de		; restore de because it contains the d_acc_y
	ld	bc,(posy)
	srl	b
	rr	c
	ld	hl,(suny)
	srl	h
	rr	l
	sbc	hl,bc
	jp	m,acc_y_neg
	ld	hl,(vely)
	add	hl,de
	jp	acc_y_end
acc_y_neg:
	ld	hl,(vely)
	sbc	hl,de
acc_y_end:	
	ld	(vely),hl	; new vely

	ld	hl,(posx)	; update posx
	ld	de,(velx)
	add	hl,de
	ld	(posx),hl

	ld	hl,(posy)	; update posy
	ld	de,(vely)
	add	hl,de
	ld	(posy),hl

	pop	bc		; restore state
	ret

	
	include	"graph.asm"
	include "math.asm"
	include "newton.asm"

	
posx:	dw	$4000		; range is 0 - $C000
posy:	dw	$3000		; range is 0 - $FF00

velx:	dw	$0100		; range is 0 - $FF00 (signed)
vely:	dw	$0000		; range is 0 - $FF00 (signed)

sunx:	dw	$8000
suny:	dw	$6000

end 32768
