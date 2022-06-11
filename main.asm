org 32768

main:	halt
	
	;; delete the sprite
	ld	hl,(posy)	; load both posx and posy since they are next to each other
	call	delete_xy_sprite

	;; call mvsprt
	ld	a,(posx)
	inc	a
	ld	(posx),a
	ld	a,(posy)
	inc	a
	ld	(posy),a

	;; paint the sprite
	ld	hl,(posy)	; load both posx and posy since they are next to each other
	call 	paint_xy_sprite
	
	jr 	main

include	"graph.asm"
	
posy:	db	0
posx:	db	0

end 32768
