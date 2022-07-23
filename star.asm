star_x:	defl	$80		; middle of the screen
star_y:	defl	$60		; middle of the screen

paint_center_star:
	ld	h,star_x
	ld	l,star_y
	call	paint_xy_star
	ret
	
;;; Paint a sprite
;;; HL containing X and Y
paint_xy_star:
	push	de		; store current state

	call	pos_to_address	; get the screen memory address that corresponds to the x,y coordinates
	ex	de,hl		; now DE = screen memory
	call	get_star
	call	paint_star

	pop	de		; restore state
	ret

;;; Paint a sprite 24 pixels wide and 16 pixels tall
;;; HL pointing to sprite
;;; DE pointing to screen
paint_star:
	push	bc		; store current state
	ld	b,16		; the sprite is 16 lines high
	
paint_star_loop:
	ld 	a,(hl)		; get one byte
	ld	(de),a		; put in on the screen
	inc	hl		; next byte
	inc	e		; next column
	ld	a,(hl)
	ld	(de),a
	inc	hl
	
	dec	e		; point to the beginning of the sprite
	ex	de,hl
	call	line_down	; next line of the sprite
	ex	de,hl
	djnz	paint_star_loop

	pop	bc		; restore state
	ret

;;; Returns the right star sprite address in HL
get_star:
	push	de		; save current state
	
	ld	hl,star
	ld	a,(star_cycle)
	inc	a
	ld	(star_cycle),a
	and	%00110000
	sra	a
	sra	a
	sra	a
	ld	e,a
	xor	a
	ld	d,a
	add	hl,de
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	ex	de,hl

	pop	de		; restore state
	ret

star_cycle:
	db	$00
	
star:
	dw	star_01
	dw	star_03
	dw	star_02
	dw	star_03
	
star_01:
	db	%00000001, %00000000
	db	%00000001, %00000000
	db	%00000001, %00000000
	db	%00000001, %10000000
	db	%00000011, %11000000
	db	%00000011, %11000000
	db	%00001110, %11110000
	db	%00011110, %00111111
	db	%11111100, %01111000
	db	%00001111, %01110000
	db	%00000011, %11000000
	db	%00000011, %11000000
	db	%00000001, %10000000
	db	%00000000, %10000000
	db	%00000000, %10000000
	db	%00000000, %10000000
star_02:
	db	%00000000, %10000000
	db	%00000000, %10000000
	db	%00000000, %10000000
	db	%00000001, %10000000
	db	%00000011, %11000000
	db	%00000011, %11000000
	db	%00001111, %01110000
	db	%11111100, %01111000
	db	%00011100, %00111111
	db	%00001110, %11110000
	db	%00000011, %11000000
	db	%00000011, %11000000
	db	%00000001, %10000000
	db	%00000001, %00000000
	db	%00000001, %00000000
	db	%00000001, %00000000
star_03:
	db	%10000000, %00000001
	db	%01000000, %00000010
	db	%00100000, %00000100
	db	%00010000, %00001000
	db	%00001100, %00110000
	db	%00001110, %01110000
	db	%00000111, %11100000
	db	%00000011, %11000000
	db	%00000011, %11000000
	db	%00000111, %11100000
	db	%00001110, %01110000
	db	%00001100, %00110000
	db	%00010000, %00001000
	db	%00100000, %00000100
	db	%01000000, %00000010
	db	%10000000, %00000001
