org 32768

main:	halt

	;; read keyboard
	ld	bc,$dffe
	in	a,(c)
	ld	b,a
	and	$01		; test por 'P'
	call	z,p_key_pressed
	ld	a,b
	and	$02		; test for 'O'
	call	z,o_key_pressed
	
	ld	bc,$fbfe
	in	a,(c)
	and	$01		; test for 'Q'
	call	z,q_key_pressed

	;; delete the sprite
	ld	hl,(posx)
	ld	de,(posy)
	call	delete_dw_sprite

	;; move the sprite
	call	move

	;; paint the sprite
	ld	a,(rot)
	ld	hl,(posx)
	ld	de,(posy)
	call 	paint_dw_sprite
	
	jr 	main

p_key_pressed:
	ld	a,(rot)
	inc	a
	ld	(rot),a
	ret

o_key_pressed:
	ld	a,(rot)
	dec	a
	ld	(rot),a
	ret

q_key_pressed:
	ld	a,(rot)
	call	thrust
	ld	hl,(velx)
	add	hl,bc
	ld	(velx),hl
	ld	hl,(vely)
	add	hl,de
	ld	(vely),hl
	ret

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
	call	update_posx
	ld	(posx),hl

	ld	hl,(posy)	; update posy
	ld	de,(vely)
	call	update_posy
	ld	(posy),hl

	pop	bc		; restore state
	ret

;;; Takes the current position in HL and the speed in DE
;;; Returns the position in HL taking limits into account
update_posy:
	push	bc
	
	add	hl,de
	push	hl
	ld	bc,$b000
	sbc	hl,bc
	pop	hl
	jp	c,update_posy_end
	ld	a,d
	and	a
	jp	p,update_posy_max
	ld	hl,$0000
	jp	update_posy_end
update_posy_max:
	ld	hl,$b000
update_posy_end:	
	pop	bc
	ret
	
;;; Takes the current position in HL and the speed in DE
;;; Returns the position in HL taking limits into account
;;; if pos is positive (0-127)
;;; 	and vel is negative (128-255)
;;; 	and + is negative
;;; 		then result is 0
;;; if pos is negative (128-255)
;;; 	and vel is positive (0-127)
;;; 	and + is positive
;;; 		then result is 255
update_posx:
	ld	a,h
	and	a
	jp	m,update_posx_next
	ld	a,d
	and	a
	jp	p,update_posx_sum_end
	add	hl,de
	ld	a,h
	and	a
	jp	p,update_posx_end
	ld	hl,$0000
update_posx_end:
	push	hl
	ld	de,$f400
	sbc	hl,de
	pop	hl
	jp	c,update_posx_check_end
	ld	hl,$f400
update_posx_check_end:
	ret
update_posx_sum_end:
	add	hl,de
	ret
update_posx_next:
	ld	a,d
	and	a
	jp	m,update_posx_sum_end
	add	hl,de
	ld	a,h
	and	a
	jp	m,update_posx_end
	ld	hl,$f400
	ret

	include	"graph.asm"
	include "math.asm"
	include "newton.asm"


rot:	db	$00		; rotation
	
posx:	dw	$8000		; range is 0 - $C000
posy:	dw	$2000		; range is 0 - $FF00

velx:	dw	$0180		; range is 0 - $FF00 (signed)
vely:	dw	$0000		; range is 0 - $FF00 (signed)

sunx:	dw	$8000
suny:	dw	$6000

end 32768
