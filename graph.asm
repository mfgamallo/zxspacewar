;;; Paint a sprite
;;; HL containing X and Y
paint_xy_sprite:
	push	bc		; store current state
	push	de

	ld	b,h		; remember posx for later
	call	pos_to_address
	ld	a,b		; we need posx to get the rightly shifted sprite
	and	7
	ex	de,hl
	ld	hl,sprite
	call	get_sprite
	call	paint_sprite

	pop	de		; restore state
	pop	bc
	ret

;;; Paint a sprite 24 pixels wide and 16 pixels tall
;;; HL pointing to sprite
;;; DE pointing to screen
paint_sprite:
	push	bc		; store current state
	ld	b,16		; the sprite is 16 lines high
	
pslp:	ld 	a,(hl)		; get one byte
	ld	(de),a		; put in on the screen
	inc	hl		; next byte
	inc	e		; next column
	ld	a,(hl)
	ld	(de),a
	inc	hl
	inc	e
	ld	a,(hl)
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
	or	64
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

;;; Get the rightly shifted sprite depending of the pixel
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

sprite:
	db 	%00000001, %10000000, %00000000
	db	%00000011, %11000000, %00000000
	db  	%00000111, %11100000, %00000000
	db 	%00001111, %11110000, %00000000
	db 	%00000001, %10000000, %00000000
	db 	%00000001, %10000000, %00000000
	db 	%00000001, %10000000, %00000000
	db 	%00000001, %10000000, %00000000
	db 	%00000001, %10000000, %00000000
	db 	%00000001, %10000000, %00000000
	db 	%00000001, %10000000, %00000000
	db 	%00000001, %10000000, %00000000
	db 	%00000001, %10000000, %00000000
	db 	%00000001, %10000000, %00000000
	db 	%00000001, %10000000, %00000000
	db 	%00000001, %10000000, %00000000

	db	%00000000, %11000000, %00000000
	db	%00000001, %11100000, %00000000
	db	%00000011, %11110000, %00000000
	db	%00000111, %11111000, %00000000
	db	%00000000, %11000000, %00000000
	db	%00000000, %11000000, %00000000
	db	%00000000, %11000000, %00000000
	db	%00000000, %11000000, %00000000
	db	%00000000, %11000000, %00000000
	db	%00000000, %11000000, %00000000
	db	%00000000, %11000000, %00000000
	db	%00000000, %11000000, %00000000
	db	%00000000, %11000000, %00000000
	db	%00000000, %11000000, %00000000
	db	%00000000, %11000000, %00000000	
	db	%00000000, %11000000, %00000000

	db	%00000000, %01100000, %00000000    
	db	%00000000, %11110000, %00000000    
    	db	%00000001, %11111000, %00000000    
    	db	%00000011, %11111100, %00000000    
    	db	%00000000, %01100000, %00000000    
    	db	%00000000, %01100000, %00000000    
    	db	%00000000, %01100000, %00000000    
    	db	%00000000, %01100000, %00000000    
    	db	%00000000, %01100000, %00000000    
    	db	%00000000, %01100000, %00000000    
    	db	%00000000, %01100000, %00000000    
    	db	%00000000, %01100000, %00000000    	
    	db	%00000000, %01100000, %00000000    
    	db	%00000000, %01100000, %00000000    
    	db	%00000000, %01100000, %00000000    
    	db	%00000000, %01100000, %00000000    

	db	%00000000, %00110000, %00000000
	db	%00000000, %01111000, %00000000
	db	%00000000, %11111100, %00000000
	db	%00000001, %11111110, %00000000
	db	%00000000, %00110000, %00000000
	db	%00000000, %00110000, %00000000
	db	%00000000, %00110000, %00000000
	db	%00000000, %00110000, %00000000
	db	%00000000, %00110000, %00000000
	db	%00000000, %00110000, %00000000
	db	%00000000, %00110000, %00000000
	db	%00000000, %00110000, %00000000
	db	%00000000, %00110000, %00000000
	db	%00000000, %00110000, %00000000
	db	%00000000, %00110000, %00000000
	db	%00000000, %00110000, %00000000

    	db	%00000000, %00011000, %00000000
    	db	%00000000, %00111100, %00000000
    	db	%00000000, %01111110, %00000000
    	db	%00000000, %11111111, %00000000
    	db	%00000000, %00011000, %00000000
    	db	%00000000, %00011000, %00000000
    	db	%00000000, %00011000, %00000000
    	db	%00000000, %00011000, %00000000
    	db	%00000000, %00011000, %00000000
    	db	%00000000, %00011000, %00000000
    	db	%00000000, %00011000, %00000000
    	db	%00000000, %00011000, %00000000
    	db	%00000000, %00011000, %00000000
    	db	%00000000, %00011000, %00000000
    	db	%00000000, %00011000, %00000000
    	db	%00000000, %00011000, %00000000

    	db	%00000000, %00001100, %00000000	
    	db	%00000000, %00011110, %00000000
    	db	%00000000, %00111111, %00000000
    	db	%00000000, %01111111, %10000000
    	db	%00000000, %00001100, %00000000
    	db	%00000000, %00001100, %00000000
    	db	%00000000, %00001100, %00000000
    	db	%00000000, %00001100, %00000000
    	db	%00000000, %00001100, %00000000
    	db	%00000000, %00001100, %00000000
    	db	%00000000, %00001100, %00000000
    	db	%00000000, %00001100, %00000000
    	db	%00000000, %00001100, %00000000
    	db	%00000000, %00001100, %00000000
    	db	%00000000, %00001100, %00000000
    	db	%00000000, %00001100, %00000000

    	db	%00000000, %00000110, %00000000
    	db	%00000000, %00001111, %00000000
    	db	%00000000, %00011111, %10000000
    	db	%00000000, %00111111, %11000000
    	db	%00000000, %00000110, %00000000
    	db	%00000000, %00000110, %00000000
    	db	%00000000, %00000110, %00000000
    	db	%00000000, %00000110, %00000000
    	db	%00000000, %00000110, %00000000
    	db	%00000000, %00000110, %00000000
    	db	%00000000, %00000110, %00000000
    	db	%00000000, %00000110, %00000000
    	db	%00000000, %00000110, %00000000
    	db	%00000000, %00000110, %00000000
    	db	%00000000, %00000110, %00000000
    	db	%00000000, %00000110, %00000000

    	db	%00000000, %00000011, %00000000    		
    	db	%00000000, %00000111, %10000000		
    	db	%00000000, %00001111, %11000000		
    	db	%00000000, %00011111, %11100000		
    	db	%00000000, %00000011, %00000000		
    	db	%00000000, %00000011, %00000000		
    	db	%00000000, %00000011, %00000000		
    	db	%00000000, %00000011, %00000000		
    	db	%00000000, %00000011, %00000000		
    	db	%00000000, %00000011, %00000000		
    	db	%00000000, %00000011, %00000000		
    	db	%00000000, %00000011, %00000000		
    	db	%00000000, %00000011, %00000000		
    	db	%00000000, %00000011, %00000000		
    	db	%00000000, %00000011, %00000000		
    	db	%00000000, %00000011, %00000000		
