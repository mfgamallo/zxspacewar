org 32768

main:	halt
	
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
	;; simplified acc:	K * ( m0 * m1 * (y0-y1) )  /  ( (x0-x1)^2 + (y0-y1)^2 )
	

	ld	hl,(velx)	; update velx
	ld	de,(accx)
	add	hl,de	 
	ld	(velx),hl

	ld	hl,(vely)	; update vely
	ld	de,(accy)
	add	hl,de	 
	ld	(vely),hl

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
	
posx:	dw	0		; range is 0 - $C000
posy:	dw	0		; range is 0 - $FF00

velx:	dw	$0100		; range is 0 - $FF00 (signed)
vely:	dw	$0000		; range is 0 - $FF00 (signed)

accx:	dw	$0000		; range is 0 - $FF00 (signed)
accy:	dw	$0000		; range is 0 - $FF00 (signed)

end 32768
