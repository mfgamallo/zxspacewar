;;; controls.asm
;;; Input control

;;; If one of the expected keys is pressed, sets the carry flag and
;;; returns the address for the next jump in HL. Otherwise it resets
;;; the carry flag.
ctrl_welcome:
	push	bc		; save current state

	ld	bc,$effe
	in	a,(c)
	ld	b,a
	and	$01		; test for '0'
	jp	nz,cwno0	; if not pressed, check the rest of the keys
	ld	hl,main_ready	; otherwise, get ready for starting the game
	scf
	jp	cwend

cwno0:	ld	bc,$f7fe
	in	a,(c)
	ld	b,a
	and	$01		; test for '1'
	jp	nz,cwno1	; if not pressed, check the rest of the keys
	ld	hl,main_player1_keys	; otherwise, get ready for redefining the keys for player 1
	scf
	jp	cwend

cwno1:
	
	xor	a		; resets the carry flag
cwend:	pop	bc		; restore state
	ret

;;; Read the controls during the game
ctrl_game:
	ld	bc,$fbfe
	in	a,(c)
	ld	b,a
	and	$01		; test for 'Q'
	call	z,q_key_pressed
	ld	a,b
	and	$10		; test for 'T'
	call	z,t_key_pressed

	ld	bc,$fdfe
	in	a,(c)
	ld	b,a
	and	$08		; test for 'F'
	call	z,f_key_pressed
	ld	a,b
	and	$10		; test for 'G'
	call	z,g_key_pressed

	ld	bc,$dffe
	in	a,(c)
	ld	b,a
	and	$01		; test por 'P'
	call	z,p_key_pressed
	ld	a,b
	and	$02		; test for 'O'
	call	z,o_key_pressed
	
	ld	bc,$bffe
	in	a,(c)
	and	$10		; test for 'H'
	call	z,h_key_pressed

	ld	bc,$7ffe
	in	a,(c)
	and	$01		; test for 'SPACE'
	call	z,space_key_pressed

	ret

p_key_pressed:
	call	load_rocket1
	call	rocket_rotate_right
	call	save_rocket1
	ret

o_key_pressed:
	call	load_rocket1
	call	rocket_rotate_left
	call	save_rocket1
	ret

q_key_pressed:
	call	load_rocket1
	call	rocket_thrust
	call	save_rocket1
	ret

space_key_pressed:
	call	load_rocket1
	call	rocket_fire
	call	save_rocket1
	ret
	
h_key_pressed:
	call	load_rocket2
	call	rocket_rotate_right
	call	save_rocket2
	ret

f_key_pressed:
	call	load_rocket2
	call	rocket_rotate_left
	call	save_rocket2
	ret

t_key_pressed:
	call	load_rocket2
	call	rocket_thrust
	call	save_rocket2
	ret

g_key_pressed:
	call	load_rocket2
	call	rocket_fire
	call	save_rocket2
	ret

;;; Wait for a key and identify it
;;; Returns HL pointing to the key structure
ctrl_identify:
	push	bc			 ; save current state
	push	de
	
cirst:	ld	hl,ctrl_key_data 	 ; point to the key representations
	ld	d,8			 ; 8 rows in the keyboard
	ld	c,$fe			 ; C doesn't change between keyboard rows
ciol:	ld	b,(hl)			 ; get address for keyboard row
	inc	hl			 ; point to the next char
	in	a,(c)
	and	$1f			 ; just consider the first five bits
	ld	e,5			 ; keys in a row
ciil:	srl	a			 ; move key bit to carry
	jp	nc,cikf			 ; key found - leave
	inc	hl			 ; key not found - try with the next one
	inc	hl
	dec	e			 ; check if we reached the end of the row
	jp	nz,ciil			 ; we didn't, check next key in the row
	dec	d			 ; we did, move to the next row
	jp	nz,ciol			 ; check if we run out of rows
	jp	cirst			 ; if we did start over
cikf:	ld	e,(hl)		         ; found our key - retrieve key structure and leave
	inc	hl
	ld	d,(hl)
	ex	de,hl

	pop	de			 ; restore state
	pop	bc
	ret

;;; Wait until every key has been releases
ctrl_wait_release:
	push	bc			; save current state
	push	de

	ld	c,$fe			; C doesn't change between keyboard rows
cwrkp:	ld	d,8			; there's eight rows of keys
	ld	hl,ctrl_key_data	; point to the key representations
cwrnr	ld	b,(hl)			; point to the key row
	in	a,(c)			; read the keyboard
	and	$1f
	sub	$1f
	jp	nz,cwrkp		; there's a key pressed. Start from the beginning
	inc	hl			; point to the next row
	inc	hl
	inc	hl
	inc	hl
	inc	hl
	inc	hl
	dec	d
	jp	nz,cwrnr		; iterate to check the next row
	;; There's no keys being pressed. We can return

	pop	de			; restore state
	pop	bc
	ret

;;; Key rows. The first element of each row is the "B" part of the keyboard row input address
ctrl_key_data:
	db 	$fe
	dw	txt_key_shift,txt_key_z,txt_key_x,txt_key_c,txt_key_v
	db	$fd
	dw	txt_key_a,txt_key_s,txt_key_d,txt_key_f,txt_key_g
        db	$fb
	dw	txt_key_q,txt_key_w,txt_key_e,txt_key_r,txt_key_t
        db	$f7
	dw	txt_key_1,txt_key_2,txt_key_3,txt_key_4,txt_key_5
        db	$ef
	dw	txt_key_0,txt_key_9,txt_key_8,txt_key_7,txt_key_6
        db	$df
	dw	txt_key_p,txt_key_o,txt_key_i,txt_key_u,txt_key_y
        db	$bf
	dw	txt_key_enter,txt_key_l,txt_key_k,txt_key_j,txt_key_h
        db	$7f
	dw	txt_key_space,txt_key_symb,txt_key_m,txt_key_n,txt_key_b
