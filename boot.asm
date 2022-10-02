BLACK_BORDER	equ	0
WHITE_ON_BLACK	equ	$7	
	
boot:
	push	bc		; store current state
	push	hl

	ld	a,BLACK_BORDER	; black border
	out	(254),a
	
	ld	a,WHITE_ON_BLACK	; attributes for the whole screen
	ld	b,256
	ld	c,3
	ld	hl,$5800	; attributes address
bootlp:	ld	(hl),a
	inc	hl
	dec	b
	jp	nz,bootlp
	dec	c
	jp	nz,bootlp

	pop	hl		; restore state
	pop	bc
	ret
