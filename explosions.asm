;;; explosions.asm
;;; Regarding what happens when a rocket is hit

NUM_SPRITES:	equ	8
	
;;; Reset the explosion counters
exps_reset:
	xor	a
	ld	(exp_sprite_count),a
	ret
	
;;; Check if any of the rockets is hit and paint explosions if they are.
;;; Sets the carry flag if it already cycled through all the explosion sprites
exps_paint:
	ld	a,(exp_sprite_count) 	; check if there's no more explosion sprites
	srl	a
	srl	a
	srl	a
	srl	a
	sub	NUM_SPRITES
	jp	c,esptc
	scf
	ret
esptc:	ld	a,(rocket1_rktsts) 	; check if rocket1 is hit
	and	1			; select bit0
	jp	z,espr1n		; if hit, paint explosion
	ld	a,(rocket1_posx+1)
	ld	h,a
	ld	a,(rocket1_posy+1)
	ld	l,a
	ld	a,(exp_sprite_count)
	call	exp_paint
espr1n:	ld	a,(rocket2_rktsts) 	; check if rocket2 is hit
	and	1			; select bit0
	jp	z,espend		; if hit, paint explosion
	ld	a,(rocket2_posx+1)
	ld	h,a
	ld	a,(rocket2_posy+1)
	ld	l,a
	ld	a,(exp_sprite_count)
	call	exp_paint
espend:	ld	a,(exp_sprite_count)
	inc	a
	ld	(exp_sprite_count),a
	xor	a
	ret
exp_sprite_count:	db	$00

;;; Paint an explosion sprite
;;; HL contains the X and Y coordinates of the explosion
;;; A contains which of the explosion sprites to paint
exp_paint:
	push	bc		; save current state
	push	de
	
	ld	d,h
	ld	e,l
	ld	hl,exp_sprites
	and	$70		; get bit4, bit5 and bit6
	sra	a		; shift to the right
	sra	a
	sra	a
	ld	c,a
	xor	a
	ld	b,a
	add	hl,bc
	ld	c,(hl)		; load the address of the sprite
	inc	hl
	ld	b,(hl)
	ld	h,b
	ld	l,c
	call	paint_xy_sprite

	pop	de		; restore state
	pop	bc
	ret

exp_sprites:
	dw	exp_sprite1
	dw	exp_sprite2
	dw	exp_sprite3
	dw	exp_sprite4
	dw	exp_sprite5
	dw	exp_sprite6
	dw	exp_sprite7
	dw	exp_sprite8
	
exp_sprite1:
	db	%10000001, %00000000, %00000000
	db	%01000001, %10000000, %00000000
	db	%01110011, %10000100, %00000000
	db	%01111111, %11011000, %00000000
	db	%01111111, %11111000, %00000000
	db	%00111111, %11110000, %00000000
	db	%00111111, %11111000, %00000000
	db	%00011111, %11111100, %00000000
	db	%00111111, %11111000, %00000000
	db	%00011111, %11110000, %00000000
	db	%00011111, %11111000, %00000000
	db	%00001111, %11111000, %00000000
	db	%00001111, %11111100, %00000000
	db	%00010011, %11100110, %00000000
	db	%00000001, %11000001, %00000000
	db	%00000000, %10000000, %00000000

	db	%01000000, %10000000, %00000000
	db	%00100000, %11000000, %00000000
	db	%00111001, %11000010, %00000000
	db	%00111111, %11101100, %00000000
	db	%00111111, %11111100, %00000000
	db	%00011111, %11111000, %00000000
	db	%00011111, %11111100, %00000000
	db	%00001111, %11111110, %00000000
	db	%00011111, %11111100, %00000000
	db	%00001111, %11111000, %00000000
	db	%00001111, %11111100, %00000000
	db	%00000111, %11111100, %00000000
	db	%00000111, %11111110, %00000000
	db	%00001001, %11110011, %00000000
	db	%00000000, %11100000, %10000000
	db	%00000000, %01000000, %00000000

	db	%00100000, %01000000, %00000000
	db	%00010000, %01100000, %00000000
	db	%00011100, %11100001, %00000000
	db	%00011111, %11110110, %00000000
	db	%00011111, %11111110, %00000000
	db	%00001111, %11111100, %00000000
	db	%00001111, %11111110, %00000000
	db	%00000111, %11111111, %00000000
	db	%00001111, %11111110, %00000000
	db	%00000111, %11111100, %00000000
	db	%00000111, %11111110, %00000000
	db	%00000011, %11111110, %00000000
	db	%00000011, %11111111, %00000000
	db	%00000100, %11111001, %10000000
	db	%00000000, %01110000, %01000000
	db	%00000000, %00100000, %00000000

	db	%00010000, %00100000, %00000000
	db	%00001000, %00110000, %00000000
	db	%00001110, %01110000, %10000000
	db	%00001111, %11111011, %00000000
	db	%00001111, %11111111, %00000000
	db	%00000111, %11111110, %00000000
	db	%00000111, %11111111, %00000000
	db	%00000011, %11111111, %10000000
	db	%00000111, %11111111, %00000000
	db	%00000011, %11111110, %00000000
	db	%00000011, %11111111, %00000000
	db	%00000001, %11111111, %00000000
	db	%00000001, %11111111, %10000000
	db	%00000010, %01111100, %11000000
	db	%00000000, %00111000, %00100000
	db	%00000000, %00010000, %00000000

	db	%00001000, %00010000, %00000000
	db	%00000100, %00011000, %00000000
	db	%00000111, %00111000, %01000000
	db	%00000111, %11111101, %10000000
	db	%00000111, %11111111, %10000000
	db	%00000011, %11111111, %00000000
	db	%00000011, %11111111, %10000000
	db	%00000001, %11111111, %11000000
	db	%00000011, %11111111, %10000000
	db	%00000001, %11111111, %00000000
	db	%00000001, %11111111, %10000000
	db	%00000000, %11111111, %10000000
	db	%00000000, %11111111, %11000000
	db	%00000001, %00111110, %01100000
	db	%00000000, %00011100, %00010000
	db	%00000000, %00001000, %00000000

	db	%00000100, %00001000, %00000000
	db	%00000010, %00001100, %00000000
	db	%00000011, %10011100, %00100000
	db	%00000011, %11111110, %11000000
	db	%00000011, %11111111, %11000000
	db	%00000001, %11111111, %10000000
	db	%00000001, %11111111, %11000000
	db	%00000000, %11111111, %11100000
	db	%00000001, %11111111, %11000000
	db	%00000000, %11111111, %10000000
	db	%00000000, %11111111, %11000000
	db	%00000000, %01111111, %11000000
	db	%00000000, %01111111, %11100000
	db	%00000000, %10011111, %00110000
	db	%00000000, %00001110, %00001000
	db	%00000000, %00000100, %00000000

	db	%00000010, %00000100, %00000000
	db	%00000001, %00000110, %00000000
	db	%00000001, %11001110, %00010000
	db	%00000001, %11111111, %01100000
	db	%00000001, %11111111, %11100000
	db	%00000000, %11111111, %11000000
	db	%00000000, %11111111, %11100000
	db	%00000000, %01111111, %11110000
	db	%00000000, %11111111, %11100000
	db	%00000000, %01111111, %11000000
	db	%00000000, %01111111, %11100000
	db	%00000000, %00111111, %11100000
	db	%00000000, %00111111, %11110000
	db	%00000000, %01001111, %10011000
	db	%00000000, %00000111, %00000100
	db	%00000000, %00000010, %00000000

	db	%00000001, %00000010, %00000000
	db	%00000000, %10000011, %00000000
	db	%00000000, %11100111, %00001000
	db	%00000000, %11111111, %10110000
	db	%00000000, %11111111, %11110000
	db	%00000000, %01111111, %11100000
	db	%00000000, %01111111, %11110000
	db	%00000000, %00111111, %11111000
	db	%00000000, %01111111, %11110000
	db	%00000000, %00111111, %11100000
	db	%00000000, %00111111, %11110000
	db	%00000000, %00011111, %11110000
	db	%00000000, %00011111, %11111000
	db	%00000000, %00100111, %11001100
	db	%00000000, %00000011, %10000010
	db	%00000000, %00000001, %00000000

exp_sprite2:
	db	%10000001, %00000000, %00000000
	db	%01000001, %11000010, %00000000
	db	%01110011, %11000110, %00000000
	db	%11111111, %11111100, %00000000
	db	%01111111, %11111100, %00000000
	db	%00111111, %11111000, %00000000
	db	%00111111, %11111100, %00000000
	db	%00111110, %01111110, %00000000
	db	%11111110, %01111100, %00000000
	db	%00111111, %11111000, %00000000
	db	%00011111, %11111100, %00000000
	db	%00001111, %11111100, %00000000
	db	%00011111, %11111110, %00000000
	db	%00111011, %11110111, %00000000
	db	%00100001, %11100001, %00000000
	db	%00000000, %11000000, %00000000

	db	%01000000, %10000000, %00000000
	db	%00100000, %11100001, %00000000
	db	%00111001, %11100011, %00000000
	db	%01111111, %11111110, %00000000
	db	%00111111, %11111110, %00000000
	db	%00011111, %11111100, %00000000
	db	%00011111, %11111110, %00000000
	db	%00011111, %00111111, %00000000
	db	%01111111, %00111110, %00000000
	db	%00011111, %11111100, %00000000
	db	%00001111, %11111110, %00000000
	db	%00000111, %11111110, %00000000
	db	%00001111, %11111111, %00000000
	db	%00011101, %11111011, %10000000
	db	%00010000, %11110000, %10000000
	db	%00000000, %01100000, %00000000

	db	%00100000, %01000000, %00000000
	db	%00010000, %01110000, %10000000
	db	%00011100, %11110001, %10000000
	db	%00111111, %11111111, %00000000
	db	%00011111, %11111111, %00000000
	db	%00001111, %11111110, %00000000
	db	%00001111, %11111111, %00000000
	db	%00001111, %10011111, %10000000
	db	%00111111, %10011111, %00000000
	db	%00001111, %11111110, %00000000
	db	%00000111, %11111111, %00000000
	db	%00000011, %11111111, %00000000
	db	%00000111, %11111111, %10000000
	db	%00001110, %11111101, %11000000
	db	%00001000, %01111000, %01000000
	db	%00000000, %00110000, %00000000

	db	%00010000, %00100000, %00000000
	db	%00001000, %00111000, %01000000
	db	%00001110, %01111000, %11000000
	db	%00011111, %11111111, %10000000
	db	%00001111, %11111111, %10000000
	db	%00000111, %11111111, %00000000
	db	%00000111, %11111111, %10000000
	db	%00000111, %11001111, %11000000
	db	%00011111, %11001111, %10000000
	db	%00000111, %11111111, %00000000
	db	%00000011, %11111111, %10000000
	db	%00000001, %11111111, %10000000
	db	%00000011, %11111111, %11000000
	db	%00000111, %01111110, %11100000
	db	%00000100, %00111100, %00100000
	db	%00000000, %00011000, %00000000

	db	%00001000, %00010000, %00000000
	db	%00000100, %00011100, %00100000
	db	%00000111, %00111100, %01100000
	db	%00001111, %11111111, %11000000
	db	%00000111, %11111111, %11000000
	db	%00000011, %11111111, %10000000
	db	%00000011, %11111111, %11000000
	db	%00000011, %11100111, %11100000
	db	%00001111, %11100111, %11000000
	db	%00000011, %11111111, %10000000
	db	%00000001, %11111111, %11000000
	db	%00000000, %11111111, %11000000
	db	%00000001, %11111111, %11100000
	db	%00000011, %10111111, %01110000
	db	%00000010, %00011110, %00010000
	db	%00000000, %00001100, %00000000

	db	%00000100, %00001000, %00000000
	db	%00000010, %00001110, %00010000
	db	%00000011, %10011110, %00110000
	db	%00000111, %11111111, %11100000
	db	%00000011, %11111111, %11100000
	db	%00000001, %11111111, %11000000
	db	%00000001, %11111111, %11100000
	db	%00000001, %11110011, %11110000
	db	%00000111, %11110011, %11100000
	db	%00000001, %11111111, %11000000
	db	%00000000, %11111111, %11100000
	db	%00000000, %01111111, %11100000
	db	%00000000, %11111111, %11110000
	db	%00000001, %11011111, %10111000
	db	%00000001, %00001111, %00001000
	db	%00000000, %00000110, %00000000

	db	%00000010, %00000100, %00000000
	db	%00000001, %00000111, %00001000
	db	%00000001, %11001111, %00011000
	db	%00000011, %11111111, %11110000
	db	%00000001, %11111111, %11110000
	db	%00000000, %11111111, %11100000
	db	%00000000, %11111111, %11110000
	db	%00000000, %11111001, %11111000
	db	%00000011, %11111001, %11110000
	db	%00000000, %11111111, %11100000
	db	%00000000, %01111111, %11110000
	db	%00000000, %00111111, %11110000
	db	%00000000, %01111111, %11111000
	db	%00000000, %11101111, %11011100
	db	%00000000, %10000111, %10000100
	db	%00000000, %00000011, %00000000

	db	%00000001, %00000010, %00000000
	db	%00000000, %10000011, %10000100
	db	%00000000, %11100111, %10001100
	db	%00000001, %11111111, %11111000
	db	%00000000, %11111111, %11111000
	db	%00000000, %01111111, %11110000
	db	%00000000, %01111111, %11111000
	db	%00000000, %01111100, %11111100
	db	%00000001, %11111100, %11111000
	db	%00000000, %01111111, %11110000
	db	%00000000, %00111111, %11111000
	db	%00000000, %00011111, %11111000
	db	%00000000, %00111111, %11111100
	db	%00000000, %01110111, %11101110
	db	%00000000, %01000011, %11000010
	db	%00000000, %00000001, %10000000

exp_sprite3:	
	db	%10000001, %10000000, %00000000
	db	%11000001, %11000011, %00000000
	db	%11110011, %11000110, %00000000
	db	%11111111, %11111110, %00000000
	db	%01111111, %11111100, %00000000
	db	%00111111, %11111100, %00000000
	db	%00111111, %01111110, %00000000
	db	%01111100, %01111111, %00000000
	db	%11111110, %00111100, %00000000
	db	%11111110, %11111100, %00000000
	db	%00111111, %11111100, %00000000
	db	%00011111, %11111110, %00000000
	db	%00011111, %11111110, %00000000
	db	%00111111, %11110111, %00000000
	db	%00110001, %11110011, %00000000
	db	%01100000, %11100001, %00000000

	db	%01000000, %11000000, %00000000
	db	%01100000, %11100001, %10000000
	db	%01111001, %11100011, %00000000
	db	%01111111, %11111111, %00000000
	db	%00111111, %11111110, %00000000
	db	%00011111, %11111110, %00000000
	db	%00011111, %10111111, %00000000
	db	%00111110, %00111111, %10000000
	db	%01111111, %00011110, %00000000
	db	%01111111, %01111110, %00000000
	db	%00011111, %11111110, %00000000
	db	%00001111, %11111111, %00000000
	db	%00001111, %11111111, %00000000
	db	%00011111, %11111011, %10000000
	db	%00011000, %11111001, %10000000
	db	%00110000, %01110000, %10000000

	db	%00100000, %01100000, %00000000
	db	%00110000, %01110000, %11000000
	db	%00111100, %11110001, %10000000
	db	%00111111, %11111111, %10000000
	db	%00011111, %11111111, %00000000
	db	%00001111, %11111111, %00000000
	db	%00001111, %11011111, %10000000
	db	%00011111, %00011111, %11000000
	db	%00111111, %10001111, %00000000
	db	%00111111, %10111111, %00000000
	db	%00001111, %11111111, %00000000
	db	%00000111, %11111111, %10000000
	db	%00000111, %11111111, %10000000
	db	%00001111, %11111101, %11000000
	db	%00001100, %01111100, %11000000
	db	%00011000, %00111000, %01000000

	db	%00010000, %00110000, %00000000
	db	%00011000, %00111000, %01100000
	db	%00011110, %01111000, %11000000
	db	%00011111, %11111111, %11000000
	db	%00001111, %11111111, %10000000
	db	%00000111, %11111111, %10000000
	db	%00000111, %11101111, %11000000
	db	%00001111, %10001111, %11100000
	db	%00011111, %11000111, %10000000
	db	%00011111, %11011111, %10000000
	db	%00000111, %11111111, %10000000
	db	%00000011, %11111111, %11000000
	db	%00000011, %11111111, %11000000
	db	%00000111, %11111110, %11100000
	db	%00000110, %00111110, %01100000
	db	%00001100, %00011100, %00100000

	db	%00001000, %00011000, %00000000
	db	%00001100, %00011100, %00110000
	db	%00001111, %00111100, %01100000
	db	%00001111, %11111111, %11100000
	db	%00000111, %11111111, %11000000
	db	%00000011, %11111111, %11000000
	db	%00000011, %11110111, %11100000
	db	%00000111, %11000111, %11110000
	db	%00001111, %11100011, %11000000
	db	%00001111, %11101111, %11000000
	db	%00000011, %11111111, %11000000
	db	%00000001, %11111111, %11100000
	db	%00000001, %11111111, %11100000
	db	%00000011, %11111111, %01110000
	db	%00000011, %00011111, %00110000
	db	%00000110, %00001110, %00010000

	db	%00000100, %00001100, %00000000
	db	%00000110, %00001110, %00011000
	db	%00000111, %10011110, %00110000
	db	%00000111, %11111111, %11110000
	db	%00000011, %11111111, %11100000
	db	%00000001, %11111111, %11100000
	db	%00000001, %11111011, %11110000
	db	%00000011, %11100011, %11111000
	db	%00000111, %11110001, %11100000
	db	%00000111, %11110111, %11100000
	db	%00000001, %11111111, %11100000
	db	%00000000, %11111111, %11110000
	db	%00000000, %11111111, %11110000
	db	%00000001, %11111111, %10111000
	db	%00000001, %10001111, %10011000
	db	%00000011, %00000111, %00001000

	db	%00000010, %00000110, %00000000
	db	%00000011, %00000111, %00001100
	db	%00000011, %11001111, %00011000
	db	%00000011, %11111111, %11111000
	db	%00000001, %11111111, %11110000
	db	%00000000, %11111111, %11110000
	db	%00000000, %11111101, %11111000
	db	%00000001, %11110001, %11111100
	db	%00000011, %11111000, %11110000
	db	%00000011, %11111011, %11110000
	db	%00000000, %11111111, %11110000
	db	%00000000, %01111111, %11111000
	db	%00000000, %01111111, %11111000
	db	%00000000, %11111111, %11011100
	db	%00000000, %11000111, %11001100
	db	%00000001, %10000011, %10000100

	db	%00000001, %00000011, %00000000
	db	%00000001, %10000011, %10000110
	db	%00000001, %11100111, %10001100
	db	%00000001, %11111111, %11111100
	db	%00000000, %11111111, %11111000
	db	%00000000, %01111111, %11111000
	db	%00000000, %01111110, %11111100
	db	%00000000, %11111000, %11111110
	db	%00000001, %11111100, %01111000
	db	%00000001, %11111101, %11111000
	db	%00000000, %01111111, %11111000
	db	%00000000, %00111111, %11111100
	db	%00000000, %00111111, %11111100
	db	%00000000, %01111111, %11101110
	db	%00000000, %01100011, %11100110
	db	%00000000, %11000001, %11000010

exp_sprite4:	
	db	%11000001, %10000001, %00000000
	db	%11000001, %11100011, %00000000
	db	%11111111, %11101110, %00000000
	db	%11111111, %11111110, %00000000
	db	%01111111, %11111100, %00000000
	db	%00111110, %11111110, %00000000
	db	%00111110, %01111111, %00000000
	db	%01111100, %00011111, %00000000
	db	%11111000, %00111110, %00000000
	db	%11111110, %01111110, %00000000
	db	%01111111, %01111100, %00000000
	db	%00111111, %11111110, %00000000
	db	%00111111, %11111110, %00000000
	db	%00111111, %11111111, %00000000
	db	%01111011, %11110111, %00000000
	db	%11100000, %11100011, %00000000

	db	%01100000, %11000000, %10000000
	db	%01100000, %11110001, %10000000
	db	%01111111, %11110111, %00000000
	db	%01111111, %11111111, %00000000
	db	%00111111, %11111110, %00000000
	db	%00011111, %01111111, %00000000
	db	%00011111, %00111111, %10000000
	db	%00111110, %00001111, %10000000
	db	%01111100, %00011111, %00000000
	db	%01111111, %00111111, %00000000
	db	%00111111, %10111110, %00000000
	db	%00011111, %11111111, %00000000
	db	%00011111, %11111111, %00000000
	db	%00011111, %11111111, %10000000
	db	%00111101, %11111011, %10000000
	db	%01110000, %01110001, %10000000

	db	%00110000, %01100000, %01000000
	db	%00110000, %01111000, %11000000
	db	%00111111, %11111011, %10000000
	db	%00111111, %11111111, %10000000
	db	%00011111, %11111111, %00000000
	db	%00001111, %10111111, %10000000
	db	%00001111, %10011111, %11000000
	db	%00011111, %00000111, %11000000
	db	%00111110, %00001111, %10000000
	db	%00111111, %10011111, %10000000
	db	%00011111, %11011111, %00000000
	db	%00001111, %11111111, %10000000
	db	%00001111, %11111111, %10000000
	db	%00001111, %11111111, %11000000
	db	%00011110, %11111101, %11000000
	db	%00111000, %00111000, %11000000

	db	%00011000, %00110000, %00100000
	db	%00011000, %00111100, %01100000
	db	%00011111, %11111101, %11000000
	db	%00011111, %11111111, %11000000
	db	%00001111, %11111111, %10000000
	db	%00000111, %11011111, %11000000
	db	%00000111, %11001111, %11100000
	db	%00001111, %10000011, %11100000
	db	%00011111, %00000111, %11000000
	db	%00011111, %11001111, %11000000
	db	%00001111, %11101111, %10000000
	db	%00000111, %11111111, %11000000
	db	%00000111, %11111111, %11000000
	db	%00000111, %11111111, %11100000
	db	%00001111, %01111110, %11100000
	db	%00011100, %00011100, %01100000

	db	%00001100, %00011000, %00010000
	db	%00001100, %00011110, %00110000
	db	%00001111, %11111110, %11100000
	db	%00001111, %11111111, %11100000
	db	%00000111, %11111111, %11000000
	db	%00000011, %11101111, %11100000
	db	%00000011, %11100111, %11110000
	db	%00000111, %11000001, %11110000
	db	%00001111, %10000011, %11100000
	db	%00001111, %11100111, %11100000
	db	%00000111, %11110111, %11000000
	db	%00000011, %11111111, %11100000
	db	%00000011, %11111111, %11100000
	db	%00000011, %11111111, %11110000
	db	%00000111, %10111111, %01110000
	db	%00001110, %00001110, %00110000

	db	%00000110, %00001100, %00001000
	db	%00000110, %00001111, %00011000
	db	%00000111, %11111111, %01110000
	db	%00000111, %11111111, %11110000
	db	%00000011, %11111111, %11100000
	db	%00000001, %11110111, %11110000
	db	%00000001, %11110011, %11111000
	db	%00000011, %11100000, %11111000
	db	%00000111, %11000001, %11110000
	db	%00000111, %11110011, %11110000
	db	%00000011, %11111011, %11100000
	db	%00000001, %11111111, %11110000
	db	%00000001, %11111111, %11110000
	db	%00000001, %11111111, %11111000
	db	%00000011, %11011111, %10111000
	db	%00000111, %00000111, %00011000

	db	%00000011, %00000110, %00000100
	db	%00000011, %00000111, %10001100
	db	%00000011, %11111111, %10111000
	db	%00000011, %11111111, %11111000
	db	%00000001, %11111111, %11110000
	db	%00000000, %11111011, %11111000
	db	%00000000, %11111001, %11111100
	db	%00000001, %11110000, %01111100
	db	%00000011, %11100000, %11111000
	db	%00000011, %11111001, %11111000
	db	%00000001, %11111101, %11110000
	db	%00000000, %11111111, %11111000
	db	%00000000, %11111111, %11111000
	db	%00000000, %11111111, %11111100
	db	%00000001, %11101111, %11011100
	db	%00000011, %10000011, %10001100

	db	%00000001, %10000011, %00000010
	db	%00000001, %10000011, %11000110
	db	%00000001, %11111111, %11011100
	db	%00000001, %11111111, %11111100
	db	%00000000, %11111111, %11111000
	db	%00000000, %01111101, %11111100
	db	%00000000, %01111100, %11111110
	db	%00000000, %11111000, %00111110
	db	%00000001, %11110000, %01111100
	db	%00000001, %11111100, %11111100
	db	%00000000, %11111110, %11111000
	db	%00000000, %01111111, %11111100
	db	%00000000, %01111111, %11111100
	db	%00000000, %01111111, %11111110
	db	%00000000, %11110111, %11101110
	db	%00000001, %11000001, %11000110

exp_sprite5:
	db	%00000001, %11000000, %00000000
	db	%01000011, %11100010, %00000000
	db	%11111111, %11101110, %00000000
	db	%11111111, %11111110, %00000000
	db	%01111111, %01111100, %00000000
	db	%00111110, %01111110, %00000000
	db	%00111100, %00111111, %00000000
	db	%11110000, %00011111, %00000000
	db	%11111000, %00001111, %00000000
	db	%11111100, %00111110, %00000000
	db	%01111110, %01111100, %00000000
	db	%00111110, %11111110, %00000000
	db	%00111111, %11111110, %00000000
	db	%00111111, %11111111, %00000000
	db	%01111011, %11110110, %00000000
	db	%00100001, %11100000, %00000000

	db	%00000000, %11100000, %00000000
	db	%00100001, %11110001, %00000000
	db	%01111111, %11110111, %00000000
	db	%01111111, %11111111, %00000000
	db	%00111111, %10111110, %00000000
	db	%00011111, %00111111, %00000000
	db	%00011110, %00011111, %10000000
	db	%01111000, %00001111, %10000000
	db	%01111100, %00000111, %10000000
	db	%01111110, %00011111, %00000000
	db	%00111111, %00111110, %00000000
	db	%00011111, %01111111, %00000000
	db	%00011111, %11111111, %00000000
	db	%00011111, %11111111, %10000000
	db	%00111101, %11111011, %00000000
	db	%00010000, %11110000, %00000000

	db	%00000000, %01110000, %00000000
	db	%00010000, %11111000, %10000000
	db	%00111111, %11111011, %10000000
	db	%00111111, %11111111, %10000000
	db	%00011111, %11011111, %00000000
	db	%00001111, %10011111, %10000000
	db	%00001111, %00001111, %11000000
	db	%00111100, %00000111, %11000000
	db	%00111110, %00000011, %11000000
	db	%00111111, %00001111, %10000000
	db	%00011111, %10011111, %00000000
	db	%00001111, %10111111, %10000000
	db	%00001111, %11111111, %10000000
	db	%00001111, %11111111, %11000000
	db	%00011110, %11111101, %10000000
	db	%00001000, %01111000, %00000000

	db	%00000000, %00111000, %00000000
	db	%00001000, %01111100, %01000000
	db	%00011111, %11111101, %11000000
	db	%00011111, %11111111, %11000000
	db	%00001111, %11101111, %10000000
	db	%00000111, %11001111, %11000000
	db	%00000111, %10000111, %11100000
	db	%00011110, %00000011, %11100000
	db	%00011111, %00000001, %11100000
	db	%00011111, %10000111, %11000000
	db	%00001111, %11001111, %10000000
	db	%00000111, %11011111, %11000000
	db	%00000111, %11111111, %11000000
	db	%00000111, %11111111, %11100000
	db	%00001111, %01111110, %11000000
	db	%00000100, %00111100, %00000000

	db	%00000000, %00011100, %00000000
	db	%00000100, %00111110, %00100000
	db	%00001111, %11111110, %11100000
	db	%00001111, %11111111, %11100000
	db	%00000111, %11110111, %11000000
	db	%00000011, %11100111, %11100000
	db	%00000011, %11000011, %11110000
	db	%00001111, %00000001, %11110000
	db	%00001111, %10000000, %11110000
	db	%00001111, %11000011, %11100000
	db	%00000111, %11100111, %11000000
	db	%00000011, %11101111, %11100000
	db	%00000011, %11111111, %11100000
	db	%00000011, %11111111, %11110000
	db	%00000111, %10111111, %01100000
	db	%00000010, %00011110, %00000000

	db	%00000000, %00001110, %00000000
	db	%00000010, %00011111, %00010000
	db	%00000111, %11111111, %01110000
	db	%00000111, %11111111, %11110000
	db	%00000011, %11111011, %11100000
	db	%00000001, %11110011, %11110000
	db	%00000001, %11100001, %11111000
	db	%00000111, %10000000, %11111000
	db	%00000111, %11000000, %01111000
	db	%00000111, %11100001, %11110000
	db	%00000011, %11110011, %11100000
	db	%00000001, %11110111, %11110000
	db	%00000001, %11111111, %11110000
	db	%00000001, %11111111, %11111000
	db	%00000011, %11011111, %10110000
	db	%00000001, %00001111, %00000000

	db	%00000000, %00000111, %00000000
	db	%00000001, %00001111, %10001000
	db	%00000011, %11111111, %10111000
	db	%00000011, %11111111, %11111000
	db	%00000001, %11111101, %11110000
	db	%00000000, %11111001, %11111000
	db	%00000000, %11110000, %11111100
	db	%00000011, %11000000, %01111100
	db	%00000011, %11100000, %00111100
	db	%00000011, %11110000, %11111000
	db	%00000001, %11111001, %11110000
	db	%00000000, %11111011, %11111000
	db	%00000000, %11111111, %11111000
	db	%00000000, %11111111, %11111100
	db	%00000001, %11101111, %11011000
	db	%00000000, %10000111, %10000000

	db	%00000000, %00000011, %10000000
	db	%00000000, %10000111, %11000100
	db	%00000001, %11111111, %11011100
	db	%00000001, %11111111, %11111100
	db	%00000000, %11111110, %11111000
	db	%00000000, %01111100, %11111100
	db	%00000000, %01111000, %01111110
	db	%00000001, %11100000, %00111110
	db	%00000001, %11110000, %00011110
	db	%00000001, %11111000, %01111100
	db	%00000000, %11111100, %11111000
	db	%00000000, %01111101, %11111100
	db	%00000000, %01111111, %11111100
	db	%00000000, %01111111, %11111110
	db	%00000000, %11110111, %11101100
	db	%00000000, %01000011, %11000000

exp_sprite6:
	db	%00000001, %11000000, %00000000
	db	%00000011, %11100000, %00000000
	db	%00111111, %11101100, %00000000
	db	%01111110, %11111110, %00000000
	db	%01111110, %01111100, %00000000
	db	%00111100, %00111110, %00000000
	db	%00111000, %00011111, %00000000
	db	%11110000, %00000111, %00000000
	db	%11100000, %00001111, %00000000
	db	%11111000, %00011110, %00000000
	db	%01111100, %00111100, %00000000
	db	%00111110, %01111110, %00000000
	db	%00111111, %11111110, %00000000
	db	%00011111, %11111100, %00000000
	db	%00001011, %11110000, %00000000
	db	%00000001, %11100000, %00000000

	db	%00000000, %11100000, %00000000
	db	%00000001, %11110000, %00000000
	db	%00011111, %11110110, %00000000
	db	%00111111, %01111111, %00000000
	db	%00111111, %00111110, %00000000
	db	%00011110, %00011111, %00000000
	db	%00011100, %00001111, %10000000
	db	%01111000, %00000011, %10000000
	db	%01110000, %00000111, %10000000
	db	%01111100, %00001111, %00000000
	db	%00111110, %00011110, %00000000
	db	%00011111, %00111111, %00000000
	db	%00011111, %11111111, %00000000
	db	%00001111, %11111110, %00000000
	db	%00000101, %11111000, %00000000
	db	%00000000, %11110000, %00000000

	db	%00000000, %01110000, %00000000
	db	%00000000, %11111000, %00000000
	db	%00001111, %11111011, %00000000
	db	%00011111, %10111111, %10000000
	db	%00011111, %10011111, %00000000
	db	%00001111, %00001111, %10000000
	db	%00001110, %00000111, %11000000
	db	%00111100, %00000001, %11000000
	db	%00111000, %00000011, %11000000
	db	%00111110, %00000111, %10000000
	db	%00011111, %00001111, %00000000
	db	%00001111, %10011111, %10000000
	db	%00001111, %11111111, %10000000
	db	%00000111, %11111111, %00000000
	db	%00000010, %11111100, %00000000
	db	%00000000, %01111000, %00000000

	db	%00000000, %00111000, %00000000
	db	%00000000, %01111100, %00000000
	db	%00000111, %11111101, %10000000
	db	%00001111, %11011111, %11000000
	db	%00001111, %11001111, %10000000
	db	%00000111, %10000111, %11000000
	db	%00000111, %00000011, %11100000
	db	%00011110, %00000000, %11100000
	db	%00011100, %00000001, %11100000
	db	%00011111, %00000011, %11000000
	db	%00001111, %10000111, %10000000
	db	%00000111, %11001111, %11000000
	db	%00000111, %11111111, %11000000
	db	%00000011, %11111111, %10000000
	db	%00000001, %01111110, %00000000
	db	%00000000, %00111100, %00000000

	db	%00000000, %00011100, %00000000
	db	%00000000, %00111110, %00000000
	db	%00000011, %11111110, %11000000
	db	%00000111, %11101111, %11100000
	db	%00000111, %11100111, %11000000
	db	%00000011, %11000011, %11100000
	db	%00000011, %10000001, %11110000
	db	%00001111, %00000000, %01110000
	db	%00001110, %00000000, %11110000
	db	%00001111, %10000001, %11100000
	db	%00000111, %11000011, %11000000
	db	%00000011, %11100111, %11100000
	db	%00000011, %11111111, %11100000
	db	%00000001, %11111111, %11000000
	db	%00000000, %10111111, %00000000
	db	%00000000, %00011110, %00000000

	db	%00000000, %00001110, %00000000
	db	%00000000, %00011111, %00000000
	db	%00000001, %11111111, %01100000
	db	%00000011, %11110111, %11110000
	db	%00000011, %11110011, %11100000
	db	%00000001, %11100001, %11110000
	db	%00000001, %11000000, %11111000
	db	%00000111, %10000000, %00111000
	db	%00000111, %00000000, %01111000
	db	%00000111, %11000000, %11110000
	db	%00000011, %11100001, %11100000
	db	%00000001, %11110011, %11110000
	db	%00000001, %11111111, %11110000
	db	%00000000, %11111111, %11100000
	db	%00000000, %01011111, %10000000
	db	%00000000, %00001111, %00000000

	db	%00000000, %00000111, %00000000
	db	%00000000, %00001111, %10000000
	db	%00000000, %11111111, %10110000
	db	%00000001, %11111011, %11111000
	db	%00000001, %11111001, %11110000
	db	%00000000, %11110000, %11111000
	db	%00000000, %11100000, %01111100
	db	%00000011, %11000000, %00011100
	db	%00000011, %10000000, %00111100
	db	%00000011, %11100000, %01111000
	db	%00000001, %11110000, %11110000
	db	%00000000, %11111001, %11111000
	db	%00000000, %11111111, %11111000
	db	%00000000, %01111111, %11110000
	db	%00000000, %00101111, %11000000
	db	%00000000, %00000111, %10000000

	db	%00000000, %00000011, %10000000
	db	%00000000, %00000111, %11000000
	db	%00000000, %01111111, %11011000
	db	%00000000, %11111101, %11111100
	db	%00000000, %11111100, %11111000
	db	%00000000, %01111000, %01111100
	db	%00000000, %01110000, %00111110
	db	%00000001, %11100000, %00001110
	db	%00000001, %11000000, %00011110
	db	%00000001, %11110000, %00111100
	db	%00000000, %11111000, %01111000
	db	%00000000, %01111100, %11111100
	db	%00000000, %01111111, %11111100
	db	%00000000, %00111111, %11111000
	db	%00000000, %00010111, %11100000
	db	%00000000, %00000011, %11000000

exp_sprite7:
	db	%00000000, %00000000, %00000000
	db	%00000011, %11000000, %00000000
	db	%00001111, %11001000, %00000000
	db	%00000110, %00110100, %00000000
	db	%00000000, %00111100, %00000000
	db	%00011000, %00011110, %00000000
	db	%00111000, %00001110, %00000000
	db	%01110000, %00000110, %00000000
	db	%01100000, %00001110, %00000000
	db	%00000000, %00000000, %00000000
	db	%00010000, %00001000, %00000000
	db	%00111100, %00011100, %00000000
	db	%00011110, %00111100, %00000000
	db	%00011111, %00111000, %00000000
	db	%00001001, %10000000, %00000000
	db	%00000000, %00000000, %00000000

	db	%00000000, %00000000, %00000000
	db	%00000001, %11100000, %00000000
	db	%00000111, %11100100, %00000000
	db	%00000011, %00011010, %00000000
	db	%00000000, %00011110, %00000000
	db	%00001100, %00001111, %00000000
	db	%00011100, %00000111, %00000000
	db	%00111000, %00000011, %00000000
	db	%00110000, %00000111, %00000000
	db	%00000000, %00000000, %00000000
	db	%00001000, %00000100, %00000000
	db	%00011110, %00001110, %00000000
	db	%00001111, %00011110, %00000000
	db	%00001111, %10011100, %00000000
	db	%00000100, %11000000, %00000000
	db	%00000000, %00000000, %00000000

	db	%00000000, %00000000, %00000000
	db	%00000000, %11110000, %00000000
	db	%00000011, %11110010, %00000000
	db	%00000001, %10001101, %00000000
	db	%00000000, %00001111, %00000000
	db	%00000110, %00000111, %10000000
	db	%00001110, %00000011, %10000000
	db	%00011100, %00000001, %10000000
	db	%00011000, %00000011, %10000000
	db	%00000000, %00000000, %00000000
	db	%00000100, %00000010, %00000000
	db	%00001111, %00000111, %00000000
	db	%00000111, %10001111, %00000000
	db	%00000111, %11001110, %00000000
	db	%00000010, %01100000, %00000000
	db	%00000000, %00000000, %00000000

	db	%00000000, %00000000, %00000000
	db	%00000000, %01111000, %00000000
	db	%00000001, %11111001, %00000000
	db	%00000000, %11000110, %10000000
	db	%00000000, %00000111, %10000000
	db	%00000011, %00000011, %11000000
	db	%00000111, %00000001, %11000000
	db	%00001110, %00000000, %11000000
	db	%00001100, %00000001, %11000000
	db	%00000000, %00000000, %00000000
	db	%00000010, %00000001, %00000000
	db	%00000111, %10000011, %10000000
	db	%00000011, %11000111, %10000000
	db	%00000011, %11100111, %00000000
	db	%00000001, %00110000, %00000000
	db	%00000000, %00000000, %00000000

	db	%00000000, %00000000, %00000000
	db	%00000000, %00111100, %00000000
	db	%00000000, %11111100, %10000000
	db	%00000000, %01100011, %01000000
	db	%00000000, %00000011, %11000000
	db	%00000001, %10000001, %11100000
	db	%00000011, %10000000, %11100000
	db	%00000111, %00000000, %01100000
	db	%00000110, %00000000, %11100000
	db	%00000000, %00000000, %00000000
	db	%00000001, %00000000, %10000000
	db	%00000011, %11000001, %11000000
	db	%00000001, %11100011, %11000000
	db	%00000001, %11110011, %10000000
	db	%00000000, %10011000, %00000000
	db	%00000000, %00000000, %00000000

	db	%00000000, %00000000, %00000000
	db	%00000000, %00011110, %00000000
	db	%00000000, %01111110, %01000000
	db	%00000000, %00110001, %10100000
	db	%00000000, %00000001, %11100000
	db	%00000000, %11000000, %11110000
	db	%00000001, %11000000, %01110000
	db	%00000011, %10000000, %00110000
	db	%00000011, %00000000, %01110000
	db	%00000000, %00000000, %00000000
	db	%00000000, %10000000, %01000000
	db	%00000001, %11100000, %11100000
	db	%00000000, %11110001, %11100000
	db	%00000000, %11111001, %11000000
	db	%00000000, %01001100, %00000000
	db	%00000000, %00000000, %00000000

	db	%00000000, %00000000, %00000000
	db	%00000000, %00001111, %00000000
	db	%00000000, %00111111, %00100000
	db	%00000000, %00011000, %11010000
	db	%00000000, %00000000, %11110000
	db	%00000000, %01100000, %01111000
	db	%00000000, %11100000, %00111000
	db	%00000001, %11000000, %00011000
	db	%00000001, %10000000, %00111000
	db	%00000000, %00000000, %00000000
	db	%00000000, %01000000, %00100000
	db	%00000000, %11110000, %01110000
	db	%00000000, %01111000, %11110000
	db	%00000000, %01111100, %11100000
	db	%00000000, %00100110, %00000000
	db	%00000000, %00000000, %00000000

	db	%00000000, %00000000, %00000000
	db	%00000000, %00000111, %10000000
	db	%00000000, %00011111, %10010000
	db	%00000000, %00001100, %01101000
	db	%00000000, %00000000, %01111000
	db	%00000000, %00110000, %00111100
	db	%00000000, %01110000, %00011100
	db	%00000000, %11100000, %00001100
	db	%00000000, %11000000, %00011100
	db	%00000000, %00000000, %00000000
	db	%00000000, %00100000, %00010000
	db	%00000000, %01111000, %00111000
	db	%00000000, %00111100, %01111000
	db	%00000000, %00111110, %01110000
	db	%00000000, %00010011, %00000000
	db	%00000000, %00000000, %00000000

exp_sprite8:
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000

	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000

	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000

	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000

	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000

	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000

	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000

	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
	db	%00000000, %00000000, %00000000
