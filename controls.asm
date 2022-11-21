;;; controls.asm
;;; Input control

ctrl_player1_left:	dw	ctrl_key_o
ctrl_player1_right:	dw	ctrl_key_p
ctrl_player1_thrust:	dw	ctrl_key_q
ctrl_player1_fire:	dw	ctrl_key_space

ctrl_player2_left:	dw	ctrl_key_f
ctrl_player2_right:	dw	ctrl_key_h
ctrl_player2_thrust:	dw	ctrl_key_t
ctrl_player2_fire:	dw	ctrl_key_g
	
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

cwno1:	ld	bc,$f7fe
	in	a,(c)
	ld	b,a
	and	$02		; test for '2'
	jp	nz,cwno2	; if not pressed, check the rest of the keys
	ld	hl,main_player2_keys	; otherwise, get ready for redefining the keys for player 2
	scf
	jp	cwend

cwno2:	
	
	xor	a		; resets the carry flag
cwend:	pop	bc		; restore state
	ret

;;; Read the controls during the game
ctrl_game:
	ld	c,$fe

	ld	ix,(ctrl_player1_left)
	ld	b,(ix+ckp)
	in	a,(c)
	and	(ix+ckb)
	call	z,ctrl_p1_left_key_pressed

	ld	ix,(ctrl_player1_right)
	ld	b,(ix+ckp)
	in	a,(c)
	and	(ix+ckb)
	call	z,ctrl_p1_right_key_pressed

	ld	ix,(ctrl_player1_thrust)
	ld	b,(ix+ckp)
	in	a,(c)
	and	(ix+ckb)
	call	z,ctrl_p1_thrust_key_pressed

	ld	ix,(ctrl_player1_fire)
	ld	b,(ix+ckp)
	in	a,(c)
	and	(ix+ckb)
	call	z,ctrl_p1_fire_key_pressed

	ld	ix,(ctrl_player2_left)
	ld	b,(ix+ckp)
	in	a,(c)
	and	(ix+ckb)
	call	z,ctrl_p2_left_key_pressed

	ld	ix,(ctrl_player2_right)
	ld	b,(ix+ckp)
	in	a,(c)
	and	(ix+ckb)
	call	z,ctrl_p2_right_key_pressed

	ld	ix,(ctrl_player2_thrust)
	ld	b,(ix+ckp)
	in	a,(c)
	and	(ix+ckb)
	call	z,ctrl_p2_thrust_key_pressed

	ld	ix,(ctrl_player2_fire)
	ld	b,(ix+ckp)
	in	a,(c)
	and	(ix+ckb)
	call	z,ctrl_p2_fire_key_pressed

	ret

ctrl_p1_left_key_pressed:
	call	load_rocket1
	call	rocket_rotate_left
	call	save_rocket1
	ret

ctrl_p1_right_key_pressed:
	call	load_rocket1
	call	rocket_rotate_right
	call	save_rocket1
	ret

ctrl_p1_thrust_key_pressed:
	call	load_rocket1
	call	rocket_thrust
	call	save_rocket1
	ret

ctrl_p1_fire_key_pressed:
	call	load_rocket1
	call	rocket_fire
	call	save_rocket1
	ret
	
ctrl_p2_left_key_pressed:
	call	load_rocket2
	call	rocket_rotate_left
	call	save_rocket2
	ret

ctrl_p2_right_key_pressed:
	call	load_rocket2
	call	rocket_rotate_right
	call	save_rocket2
	ret

ctrl_p2_thrust_key_pressed:
	call	load_rocket2
	call	rocket_thrust
	call	save_rocket2
	ret

ctrl_p2_fire_key_pressed:
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
	dw	ctrl_key_shift,ctrl_key_z,ctrl_key_x,ctrl_key_c,ctrl_key_v
	db	$fd
	dw	ctrl_key_a,ctrl_key_s,ctrl_key_d,ctrl_key_f,ctrl_key_g
        db	$fb
	dw	ctrl_key_q,ctrl_key_w,ctrl_key_e,ctrl_key_r,ctrl_key_t
        db	$f7
	dw	ctrl_key_1,ctrl_key_2,ctrl_key_3,ctrl_key_4,ctrl_key_5
        db	$ef
	dw	ctrl_key_0,ctrl_key_9,ctrl_key_8,ctrl_key_7,ctrl_key_6
        db	$df
	dw	ctrl_key_p,ctrl_key_o,ctrl_key_i,ctrl_key_u,ctrl_key_y
        db	$bf
	dw	ctrl_key_enter,ctrl_key_l,ctrl_key_k,ctrl_key_j,ctrl_key_h
        db	$7f
	dw	ctrl_key_space,ctrl_key_symb,ctrl_key_m,ctrl_key_n,ctrl_key_b

ckp:	equ	0		; shift to the 'b' part of the i/o port
ckb:	equ	1		; shift to the bit to isolate to test for
ckk:	equ	2		; shift to the address to the key representation
	
ctrl_key_shift:
	db	$fe
	db	$01
	dw	txt_key_shift
ctrl_key_z:
	db	$fe
	db	$02
	dw	txt_key_z
ctrl_key_x:
	db	$fe
	db	$04
	dw	txt_key_x
ctrl_key_c:
	db	$fe
	db	$08
	dw	txt_key_c
ctrl_key_v:
	db	$fe
	db	$10
	dw	txt_key_v
ctrl_key_a:
	db	$fd
	db	$01
	dw	txt_key_a
ctrl_key_s:
	db	$fd
	db	$02
	dw	txt_key_s
ctrl_key_d:
	db	$fd
	db	$04
	dw	txt_key_d
ctrl_key_f:
	db	$fd
	db	$08
	dw	txt_key_f
ctrl_key_g:
	db	$fd
	db	$10
	dw	txt_key_g
ctrl_key_q:	
	db	$fb
	db	$01
	dw	txt_key_q
ctrl_key_w:
	db	$fb
	db	$02
	dw	txt_key_w
ctrl_key_e:
	db	$fb
	db	$04
	dw	txt_key_e
ctrl_key_r:
	db	$fb
	db	$08
	dw	txt_key_r
ctrl_key_t:
	db	$fb
	db	$10
	dw	txt_key_t
ctrl_key_1:	
	db	$f7
	db	$01
	dw	txt_key_1
ctrl_key_2:
	db	$f7
	db	$02
	dw	txt_key_2
ctrl_key_3:
	db	$f7
	db	$04
	dw	txt_key_3
ctrl_key_4:
	db	$f7
	db	$08
	dw	txt_key_4
ctrl_key_5:
	db	$f7
	db	$10
	dw	txt_key_5
ctrl_key_0:	
        db	$ef
	db	$01
	dw	txt_key_0
ctrl_key_9:
	db	$ef
	db	$02
	dw	txt_key_9
ctrl_key_8:
	db	$ef
	db	$04
	dw	txt_key_8
ctrl_key_7:
	db	$ef
	db	$08
	dw	txt_key_7
ctrl_key_6:
	db	$ef
	db	$10
	dw	txt_key_6
ctrl_key_p:	
	db	$df
	db	$01
	dw	txt_key_p
ctrl_key_o:
	db	$df
	db	$02
	dw	txt_key_o
ctrl_key_i:
	db	$df
	db	$04
	dw	txt_key_i
ctrl_key_u:
	db	$df
	db	$08
	dw	txt_key_u
ctrl_key_y:
	db	$df
	db	$10
	dw	txt_key_y
ctrl_key_enter:	
	db	$bf
	db	$01
	dw	txt_key_enter
ctrl_key_l:
	db	$bf
	db	$02
	dw	txt_key_l
ctrl_key_k:
	db	$bf
	db	$04
	dw	txt_key_k
ctrl_key_j:
	db	$bf
	db	$08
	dw	txt_key_j
ctrl_key_h:
	db	$bf
	db	$10
	dw	txt_key_h
ctrl_key_space:	
	db	$7f
	db	$01
	dw	txt_key_space
ctrl_key_symb:
	db	$7f
	db	$02
	dw	txt_key_symb
ctrl_key_m:
	db	$7f
	db	$04
	dw	txt_key_m
ctrl_key_n:
	db	$7f
	db	$08
	dw	txt_key_n
ctrl_key_b:
	db	$7f
	db	$10
	dw	txt_key_b
