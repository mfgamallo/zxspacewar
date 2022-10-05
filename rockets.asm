ROCKET_RECORD_SIZE	equ	$0009

rocket1_rot:	db	$00
rocket1_posx:	dw	$8000
rocket1_posy:	dw	$2000
rocket1_velx:	dw	$0180
rocket1_vely:	dw	$0000

rocket2_rot:	db	$00
rocket2_posx:	dw	$8000
rocket2_posy:	dw	$a000
rocket2_velx:	dw	$fe70
rocket2_vely:	dw	$0000

load_rocket1:
	push	bc		; store current state
	push	de
	push	hl

	ld	bc,ROCKET_RECORD_SIZE
	ld	de,rot+ROCKET_RECORD_SIZE-1
	ld	hl,rocket1_rot+ROCKET_RECORD_SIZE-1
	lddr

	pop	hl		; restore state
	pop	de
	pop	bc
	ret

load_rocket2:
	push	bc		; store current state
	push	de
	push	hl

	ld	bc,ROCKET_RECORD_SIZE
	ld	de,rot+ROCKET_RECORD_SIZE-1
	ld	hl,rocket2_rot+ROCKET_RECORD_SIZE-1
	lddr

	pop	hl		; restore state
	pop	de
	pop	bc
	ret

save_rocket1:
	push	bc		; store current state
	push	de
	push	hl

	ld	bc,ROCKET_RECORD_SIZE
	ld	de,rocket1_rot+ROCKET_RECORD_SIZE-1
	ld	hl,rot+ROCKET_RECORD_SIZE-1
	lddr

	pop	hl		; restore state
	pop	de
	pop	bc
	ret

save_rocket2:
	push	bc		; store current state
	push	de
	push	hl

	ld	bc,ROCKET_RECORD_SIZE
	ld	de,rocket2_rot+ROCKET_RECORD_SIZE-1
	ld	hl,rot+ROCKET_RECORD_SIZE-1
	lddr

	pop	hl		; restore state
	pop	de
	pop	bc
	ret

	
;;; Current rocket
rot:	db	$00		; rotation
	
posx:	dw	$8000		; range is 0 - $C000
posy:	dw	$2000		; range is 0 - $FF00

velx:	dw	$0180		; range is 0 - $FF00 (signed)
vely:	dw	$0000		; range is 0 - $FF00 (signed)

