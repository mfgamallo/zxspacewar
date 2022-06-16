org 32768

main:	halt
	
	;; delete the sprite
	ld	hl,(posy)	; load both posx and posy since they are next to each other
	call	delete_xy_sprite

	;; move the sprite
	call	move

	;; paint the sprite
	ld	hl,(posy)	; load both posx and posy since they are next to each other
	call 	paint_xy_sprite
	
	jr 	main

move:
	push	bc		; store current state

	;; update accy
	;; simplified acc:	K * ( m0 * m1 * (y0-y1) )  /  ( (x0-x1)^2 + (y0-y1)^2 )
	

	ld	a,(accx)	; update velx
	ld	b,a
	ld	a,(velx)
	add	a,b
	ld	(velx),a

	ld	a,(accx)	; update vely
	ld	b,a
	ld	a,(velx)
	add	a,b
	ld	(velx),a

	ld	a,(velx)	; update posx
	ld	b,a
	ld	a,(posx)
	add	a,b
	ld	(posx),a

	ld	a,(vely)	; update posy
	ld	b,a
	ld	a,(posy)
	add	a,b
	ld	(posy),a

	pop	bc		; restore state
	ret

include	"graph.asm"
	
posy:	db	0		; range is 0 - 255
posx:	db	0		; range is 0 - 192

velx:	db	1		; range is -128 - 127
vely:	db	0		; range is -128 - 127

accx:	db	0		; range is -128 - 127
accy:	db	0		; range is -128 - 127

end 32768
