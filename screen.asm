;;; screen.asm
;;; Screen routines: border, clear screen, switch buffer...

BLACK_BORDER	equ	0
WHITE_ON_BLACK	equ	$7	
	
setupscr:
	push	bc		; store current state
	push	hl

	ld	a,BLACK_BORDER	; black border
	out	(254),a
	
	ld	a,WHITE_ON_BLACK	; attributes for the whole screen
	ld	b,256
	ld	c,3
	ld	hl,$d800	; attributes address
suscp:	ld	(hl),a
	inc	hl
	dec	b
	jp	nz,suscp
	dec	c
	jp	nz,suscp

	pop	hl		; restore state
	pop	bc
	ret

;;; Clean the screen
;;; We don't really need a highly efficient algorithm, since we very rarely need to clean the whole screen.
cleanscr:
	push 	bc		; store current state
	push	de
	push	hl

	ld 	hl, $c000
	ld 	de, $c001
	ld 	bc, 6143
	ld 	(hl),0
	ldir
	
	pop	hl		; restore state
	pop	de
	pop	bc
	ret


;;; Switch screen buffers
switch:
	push	de		; store current state
	ld	a,(screen)
	inc	a
	ld	(screen),a
	and	$1
	jr	nz,sw1
	ld	de,$f007	; switch to screen 0, point 0xc000 to bank 7
	call	swchto
	pop	de		; restore state
	ret
sw1:
	ld	de,$f00d	; switch to screen 1, point 0xc000 to bank 5
	call	swchto
	pop	de		; restore state
	ret

;;; D contains the value that will be ANDed to $7ffd
;;; E contains the value that will be ORed to $7ffd
swchto:
	push	bc		; store current state
	
	ld	a,($5b5c)
	and	d
	or	e
	ld	bc,$7ffd
	di
	ld	($5b5c),a
	out	(c),a
	ei

	pop	bc		; restore state
	ret

;;; Switch to screen 0
swchto0:
	push	bc		; store current state
	push	de

	ld	de,$f005	; switch to screen 0, point 0xc000 to bank 5
	ld	a,($5b5c)
	and	d
	or	e
	ld	bc,$7ffd
	di
	ld	($5b5c),a
	out	(c),a
	ei

	pop	de		; restore state
	pop	bc
	ret

screen:	db	$00
