;;; rockets.asm
;;; Distinction between the two rockets in the game

ROCKET1_INITIAL_ROT:	equ	$80
ROCKET1_INITIAL_POSX:	equ	$8000
ROCKET1_INITIAL_POSY:	equ	$2000
ROCKET1_INITIAL_VELX:	equ	$0180
ROCKET1_INITIAL_VELY:	equ	$0000
ROCKET1_INITIAL_RKTSTS:	equ	$00

ROCKET2_INITIAL_ROT:	equ	$00
ROCKET2_INITIAL_POSX:	equ	$8000
ROCKET2_INITIAL_POSY:	equ	$a000
ROCKET2_INITIAL_VELX:	equ	$fe70
ROCKET2_INITIAL_VELY:	equ	$0000
ROCKET2_INITIAL_RKTSTS:	equ	$02

ROCKET_RECORD_SIZE	equ	$000a

rocket1_rot:	db	$00
rocket1_posx:	dw	$0000
rocket1_posy:	dw	$0000
rocket1_velx:	dw	$0000
rocket1_vely:	dw	$0000
rocket1_rktsts:	db	$00

rocket2_rot:	db	$00
rocket2_posx:	dw	$0000
rocket2_posy:	dw	$0000
rocket2_velx:	dw	$0000
rocket2_vely:	dw	$0000
rocket2_rktsts:	db	$00

;;; We keep these so we can delete them even after switching the
;;; screen buffer - we don't want to have to delete the whole
;;; screen!
old_rocket1_rot:	db	$00
old_rocket1_posx:	dw	$0000
old_rocket1_posy:	dw	$0000
old_rocket1_velx:	dw	$0000
old_rocket1_vely:	dw	$0000
old_rocket1_rktsts:	db	$00
	
old_rocket2_rot:	db	$00
old_rocket2_posx:	dw	$0000
old_rocket2_posy:	dw	$0000
old_rocket2_velx:	dw	$0000
old_rocket2_vely:	dw	$0000
old_rocket2_rktsts:	db	$00

reset_rocket1:
	ld	a,ROCKET1_INITIAL_ROT
	ld	(rocket1_rot),a
	ld	(old_rocket1_rot),a
	ld	hl,ROCKET1_INITIAL_POSX
	ld	(rocket1_posx),hl
	ld	(old_rocket1_posx),hl
	ld	hl,ROCKET1_INITIAL_POSY
	ld	(rocket1_posy),hl
	ld	(old_rocket1_posy),hl
	ld	hl,ROCKET1_INITIAL_VELX
	ld	(rocket1_velx),hl
	ld	(old_rocket1_velx),hl
	ld	hl,ROCKET1_INITIAL_VELY
	ld	(rocket1_vely),hl
	ld	(old_rocket1_vely),hl
	ld	a,ROCKET1_INITIAL_RKTSTS
	ld	(rocket1_rktsts),a
	ld	(old_rocket1_rktsts),a
	ret

reset_rocket2:
	ld	a,ROCKET2_INITIAL_ROT
	ld	(rocket2_rot),a
	ld	(old_rocket2_rot),a
	ld	hl,ROCKET2_INITIAL_POSX
	ld	(rocket2_posx),hl
	ld	(old_rocket2_posx),hl
	ld	hl,ROCKET2_INITIAL_POSY
	ld	(rocket2_posy),hl
	ld	(old_rocket2_posy),hl
	ld	hl,ROCKET2_INITIAL_VELX
	ld	(rocket2_velx),hl
	ld	(old_rocket2_velx),hl
	ld	hl,ROCKET2_INITIAL_VELY
	ld	(rocket2_vely),hl
	ld	(old_rocket2_vely),hl
	ld	a,ROCKET2_INITIAL_RKTSTS
	ld	(rocket2_rktsts),a
	ld	(old_rocket2_rktsts),a
	ret

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

load_old_rocket1:
	push	bc		; store current state
	push	de
	push	hl

	ld	bc,ROCKET_RECORD_SIZE
	ld	de,rot+ROCKET_RECORD_SIZE-1
	ld	hl,old_rocket1_rot+ROCKET_RECORD_SIZE-1
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

load_old_rocket2:
	push	bc		; store current state
	push	de
	push	hl

	ld	bc,ROCKET_RECORD_SIZE
	ld	de,rot+ROCKET_RECORD_SIZE-1
	ld	hl,old_rocket2_rot+ROCKET_RECORD_SIZE-1
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

save_old_rocket1:
	push	bc		; store current state
	push	de
	push	hl

	ld	bc,ROCKET_RECORD_SIZE
	ld	de,old_rocket1_rot+ROCKET_RECORD_SIZE-1
	ld	hl,rocket1_rot+ROCKET_RECORD_SIZE-1
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

save_old_rocket2:
	push	bc		; store current state
	push	de
	push	hl

	ld	bc,ROCKET_RECORD_SIZE
	ld	de,old_rocket2_rot+ROCKET_RECORD_SIZE-1
	ld	hl,rocket2_rot+ROCKET_RECORD_SIZE-1
	lddr

	pop	hl		; restore state
	pop	de
	pop	bc
	ret

	
;;; Current rocket
rot:	db	$00		; rotation
	
posx:	dw	$0000		; range is 0 - $C000
posy:	dw	$0000		; range is 0 - $FF00

velx:	dw	$0000		; range is 0 - $FF00 (signed)
vely:	dw	$0000		; range is 0 - $FF00 (signed)

;;; status:
;;;   bit0: 0=alive, 1=hit
;;;   bit1: 0=rocket1, 1=rocket2
rktsts:	db	$00
