;;; graph.asm
;;; Painting routines.

;;; Paint a dot with the position in 16bit words
;;; HL containing X
;;; DE containing Y
paint_dw_dot:
	ld	l,d
	call	paint_xy_dot
	ret

;;; Delete a dot with the position in 16bit words
;;; HL containing X
;;; DE containing Y
delete_dw_dot:
	ld	l,d
	call	delete_xy_dot
	ret

	
;;; -------------------------------------------------------------------------------------------
;;; past this point only single bytes are considered - fixed point arithmetic no longer applies
;;; -------------------------------------------------------------------------------------------

;;; Paint a sprite
;;; DE containing X and Y
;;; HL containing the pre-shifted sprite group
paint_xy_sprite:
	push	bc		; store current state

	ld	b,d		; remember the x coordinate so we can get the shifted sprite
	ex	de,hl		; HL containing the X,Y coordinates now
	call	pos_to_address	; get the screen memory address that corresponds to the x,y coordinates
	ex	de,hl		; now DE = screen memory and HL = sprite group
	ld	a,b		; load the x coordinate into a
	and	7		; use as index for shifting the sprite
	call	get_sprite	; get the definitive (shifted) sprite
	call	paint_sprite

	pop	bc		; restore state
	ret

;;; Paint a sprite horizontally mirrored
;;; DE containing X and Y
;;; HL containing the pre-shifted sprite group
paint_xy_sprite_hm:
	push	bc		; store current state

	ld	b,d		; remember the x coordinate so we can get the shifted sprite
	ex	de,hl		; HL containing the X,Y coordinates now
	call	pos_to_address	; get the screen memory address that corresponds to the x,y coordinates
	ex	de,hl		; now DE = screen memory and HL = sprite group
	ld	a,b		; load the x coordinate into a
	and	7		; use as index for shifting the sprite
	neg			; because we want to print the sprite horizontally mirrored, we get the sprite
	add	a,7		; shifted in the inverse order (right to left)
	call	get_sprite	; get the definitive (shifted) sprite
	call	paint_sprite_hm

	pop	bc		; restore state
	ret

;;; Paint a sprite vertically mirrored
;;; DE containing X and Y
;;; HL containing the pre-shifted sprite group
paint_xy_sprite_vm:
	push	bc		; store current state

	ld	b,d		; remember the x coordinate so we can get the shifted sprite
	ex	de,hl		; HL containing the X,Y coordinates now
	call	pos_to_address	; get the screen memory address that corresponds to the x,y coordinates
	ex	de,hl		; now DE = screen memory and HL = sprite group
	ld	a,b		; load the x coordinate into a
	and	7		; use as index for shifting the sprite
	call	get_sprite	; get the definitive (shifted) sprite
	call	paint_sprite_vm

	pop	bc		; restore state
	ret

;;; Paint a sprite horizontally AND vertically mirrored
;;; DE containing X and Y
;;; HL containing the pre-shifted sprite group
paint_xy_sprite_vhm:
	push	bc		; store current state

	ld	b,d		; remember the x coordinate so we can get the shifted sprite
	ex	de,hl		; HL containing the X,Y coordinates now
	call	pos_to_address	; get the screen memory address that corresponds to the x,y coordinates
	ex	de,hl		; now DE = screen memory and HL = sprite group
	ld	a,b		; load the x coordinate into a
	and	7		; use as index for shifting the sprite
	neg			; because we want to print the sprite horizontally mirrored, we get the sprite
	add	a,7		; shifted in the inverse order (right to left)
	call	get_sprite	; get the definitive (shifted) sprite
	call	paint_sprite_vhm

	pop	bc		; restore state
	ret

;;; Paint a sprite 24 pixels wide and 16 pixels tall
;;; HL pointing to sprite
;;; DE pointing to screen
paint_sprite:
	push	bc		; store current state
	ld	b,16		; the sprite is 16 lines high
	
pslp:	ld	a,(de)		; get one byte from the screen
	or 	(hl)		; or it with a byte from the sprite
	ld	(de),a		; put in on the screen
	inc	hl		; next byte
	inc	e		; next column
	ld	a,(de)
	or	(hl)
	ld	(de),a
	inc	hl
	inc	e
	ld	a,(de)
	or	(hl)
	ld	(de),a
	inc	hl
	
	dec	e		; point to the beginning of the sprite
	dec	e
	ex	de,hl
	call	line_down	; next line of the sprite
	ex	de,hl
	djnz	pslp

	pop	bc		; restore state
	ret

;;; Paint a horizontally mirrored sprite 24 pixels wide and 16 pixels tall
;;; HL pointing to sprite
;;; DE pointing to screen
paint_sprite_hm:
	push	bc		; store current state
	ld	b,16		; the sprite is 16 lines high
	
pslph:	inc	hl		; point to the last byte in the line
	inc	hl		; (because we're mirroring horizontally)
	ld	a,(de)		; get one byte from the screen
	ld	c,a
	ld 	a,(hl)		; get a byte from the sprite
	call	mirror_byte	; mirror the byte
	or	c		; or it with the byte from the screen
	ld	(de),a		; put in on the screen
	dec	hl		; previous byte
	inc	e		; next column
	ld	a,(de)
	ld	c,a
	ld	a,(hl)
	call	mirror_byte
	or	c
	ld	(de),a
	dec	hl
	inc	e
	ld	a,(de)
	ld	c,a
	ld	a,(hl)
	call	mirror_byte
	or	c
	ld	(de),a
	inc	hl
	inc	hl
	inc	hl
	
	dec	e		; point to the beginning of the sprite
	dec	e
	ex	de,hl
	call	line_down	; next line of the sprite
	ex	de,hl
	djnz	pslph

	pop	bc		; restore state
	ret

;;; Paint a sprite vertically mirrored 24 pixels wide and 16 pixels tall
;;; HL pointing to sprite
;;; DE pointing to screen
paint_sprite_vm:
	push	bc		; store current state

	ld	b,0
	ld	c,45
	add	hl,bc
	ld	b,16		; the sprite is 16 lines high
pslpv:	ld	a,(de)		; get one byte from the screen
	or 	(hl)		; or it with a byte from the sprite
	ld	(de),a		; put in on the screen
	inc	hl		; next byte
	inc	e		; next column
	ld	a,(de)
	or	(hl)
	ld	(de),a
	inc	hl
	inc	e
	ld	a,(de)
	or	(hl)
	ld	(de),a
	dec	hl		; point to the previous line
	dec	hl		; (because we're painting the sprite vertically mirrored)
	dec	hl
	dec	hl
	dec	hl
	
	dec	e		; point to the beginning of the sprite
	dec	e
	ex	de,hl
	call	line_down	; next line of the sprite
	ex	de,hl
	djnz	pslpv

	pop	bc		; restore state
	ret

;;; Paint a sprite vertically AND horizontally mirrored 24 pixels wide and 16 pixels tall
;;; HL pointing to sprite
;;; DE pointing to screen
paint_sprite_vhm:
	push	bc		; store current state

	ld	b,0
	ld	c,47
	add	hl,bc
	ld	b,16		; the sprite is 16 lines high
pslpvh:	ld	a,(de)		; get one byte from the screen
	ld	c,a
	ld 	a,(hl)		; get a byte from the sprite
	call	mirror_byte	; mirror the byte
	or	c		; or it with the byte from the screen
	ld	(de),a		; put in on the screen
	dec	hl		; next byte
	inc	e		; next column
	ld	a,(de)
	ld	c,a
	ld 	a,(hl)
	call	mirror_byte
	or	c
	ld	(de),a
	dec	hl
	inc	e
	ld	a,(de)
	ld	c,a
	ld 	a,(hl)
	call	mirror_byte
	or	c
	ld	(de),a
	dec	hl		; point to the previous line
				; (because we're painting the sprite vertically mirrored)
	dec	e		; point to the beginning of the sprite
	dec	e
	ex	de,hl
	call	line_down	; next line of the sprite
	ex	de,hl
	djnz	pslpvh

	pop	bc		; restore state
	ret

;;; Delete a sprite
;;; HL containing X and Y
delete_xy_sprite:
	push	de		; store current state

	call	pos_to_address
	ex	de,hl
	call	delete_sprite

	pop	de		; restore state
	ret

;;; Delete a sprite 24 pixels wide and 16 pixels tall
;;; DE pointing to screen
delete_sprite:
	push	bc		; store current state
	ld	b,16		; the sprite is 16 lines high
	
dslp:	ld 	a,0		; deleting
	ld	(de),a		; put in on the screen
	inc	e		; next column
	ld	(de),a
	inc	e
	ld	(de),a
	
	dec	e		; point to the beginning of the sprite
	dec	e
	ex	de,hl
	call	line_down	; next line of the sprite
	ex	de,hl
	djnz	dslp

	pop	bc		; restore state
	ret

;;; Paint a dot
;;; HL containing X and Y
paint_xy_dot:
	push	bc		; store current state
	
	push	hl	        ; we need the X to calculate the pixel (bit) that needs to be set
	call	pos_to_address	; hl now points to the right byte in the screen
	pop	af		; calculate shift from X
	and	7
	call	get_dot		; a now contains a byte with the single dot set to 1
	ld	b,a
	ld	a,(hl)
	or	b
	ld	(hl),a

	pop	bc		; restore state
	ret

;;; Delete a dot
;;; HL containing X and Y
delete_xy_dot:
	call	pos_to_address	; hl now points to the right byte in the screen
	ld	(hl),0
	ret
	
;;; Calculate the next line down
;;; HL pointing to a point in the screen
;;; Return HL pointing to the point immediately down
line_down:
        inc	h
        ld	a,h
        and	7
        ret	nz
        ld	a,l
        add	a,32
        ld	l,a
        ret	c
        ld	a,h
        sub	8
        ld	h,a
        ret

;;; Convert X, Y to a screen address
;;; HL contains X and Y
;;; Returns screen address in HL
pos_to_address:
	push	bc		; store current state

	ld	b,h
	ld	c,l
	ld	a,c
	rra
	rra
	rra
	and	24
	or	192
	ld	h,a
	ld	a,c
	and	7
	or	h
	ld	h,a
	ld	a,c
	rla
	rla
	and	224
	ld	l,a
	ld	a,b
	rra
	rra
	rra
	and	31
	or	l
	ld	l,a

	pop	bc		; restore state
	ret

;;; Paint a sprite properly rotated.
;;; A containing rotation
;;; HL pointing to the pack of sprite groups
rotate_and_paint_sprite:
	push	bc		; store current state
	push	de

	push	af
	and	%01111000	; reset bits 0, 1, 2, 7
	cp	72
	jp	nc,rspe		; check wether to invert the number or not
	sra	a		; shift 2 (because each address is two bytes) to the right filling with 0
	sra	a
	jp	rspn
rspe:	
	sla	a	; shift 1 to the left
	sra	a	; shift 4 to the right filling with previous
	sra	a
	sra	a
	sra	a
	neg 		; 2s complement, return
	sla	a
rspn:	
	ld	c,a		; load a into bc
	xor	a
	ld	b,a
	add	hl,bc		; use bc as index with hl as base
	ld	e,(hl)		; load location of sprite (before pre-shifting) in de
	inc	hl
	ld	d,(hl)
	ex	de,hl		; move de to hl, ready to return

	pop	af		; decide which mirroring we're going to apply
	pop	de		; restore state
	pop	bc
	and	%11000000	; check the first two bits
	jp	z,rsnvnh		; if it's 00, there's no need to mirror
	cp	64
	jp	z,rsvnh			; if it's 01, mirror vertically
	cp	128
	jp	z,rsvh			; if it's 10, mirror both vertically and horizontally
	call	paint_xy_sprite_hm	; else (11), mirror horizontally
	ret
rsnvnh:	call	paint_xy_sprite
	ret
rsvnh:	call	paint_xy_sprite_vm
	ret
rsvh:	call	paint_xy_sprite_vhm
	ret
	
;;; Get the rightly shifted sprite depending on the pixel
;;; A holds the pixel
;;; HL points the the pre-shifted sprite group
;;; Return HL pointing to the right sprite
get_sprite:
	push 	bc		; store current status
	push	de

	ld	b,h
	ld	c,l
	ld	h,0
	ld	l,a
	add	hl,hl		; multiply by 48
	add 	hl,hl
	add 	hl,hl
	add 	hl,hl
	ld 	d,h
	ld 	e,l
	add 	hl,hl
	add 	hl,de		; HL is now x48
	add 	hl,bc

	pop	de		; restore status
	pop	bc
	ret

;;; Mirrors one byte
;;; A holds the byte to mirror
;;; The mirrored byte is returned in A itself
mirror_byte:
	push	bc		; store current status

	ld	b,a
	rlc	b
	rra
	rlc	b
	rra
	rlc	b
	rra
	rlc	b
	rra
	rlc	b
	rra
	rlc	b
	rra
	rlc	b
	rra
	rlc	b
	rra
	
	pop	bc		; restore status
	ret
	
;;; Get the right byte to paint a single dot at a specific point
;;; A holds the pixel inside the byte
;;; returns A with the right byte
get_dot:
	push	de		; store current state
	push	hl

	ld	hl,dots
	ld	e,a
	xor	a
	ld	d,a
	add	hl,de
	ld	a,(hl)

	pop	hl		; restore state
	pop	de
	ret

dots:
	db	$80
	db	$40
	db	$20
	db	$10
	db	$08
	db	$04
	db	$02
	db	$01
