;;; text.asm
;;; Showing text
;;; TODO maybe I should think about creating my own chars

CHNL:	equ	$1601
PRINT:	equ	$203c
AT:	equ	$16
INK:	equ	$10
PAPER:	equ	$11
FLASH:	equ	$12
CHAR:	equ	$10

txt_select_channel_2:	
	ld	a,2
	call	CHNL			; select screen
	ret
	
;;; Main menu text
txt_main_menu:
	push	bc		; save current state
	push	de

	ld	de,txt_tp1_keys
	ld	bc,txt_tp1_keys_e-txt_tp1_keys
	call	PRINT		; write
	ld	de,txt_tstart_game
	ld	bc,txt_tstart_game_e-txt_tstart_game
	call	PRINT		; write

	pop	de		; restore state
	pop	bc
	ret

;;; Delete the main menu text
txt_dmain_menu:
	push	bc		; save current state
	push	de

	ld	de,txt_tdp1_keys
	ld	bc,txt_tdp1_keys_e-txt_tdp1_keys
	call	PRINT
	ld	de,txt_tdstart_game
	ld	bc,txt_tdstart_game_e-txt_tdstart_game
	call	PRINT

	pop	de		; restore state
	pop	bc
	ret

;;; Redefine player 1's keys
txt_player1_keys:
	push	bc		; save current state
	push	de

	ld	de,txt_tp1_left
	ld	bc,txt_tp1_left_e-txt_tp1_left
	call	PRINT
	ld	de,txt_tp1_right
	ld	bc,txt_tp1_right_e-txt_tp1_right
	call	PRINT
	ld	de,txt_tp1_thrust
	ld	bc,txt_tp1_thrust_e-txt_tp1_thrust
	call	PRINT
	ld	de,txt_tp1_fire
	ld	bc,txt_tp1_fire_e-txt_tp1_fire
	call	PRINT

	pop	de		; restore state
	pop	bc
	ret

;;; Highlight placeholder for the 'LEFT' key
txt_flash_left:
	push	bc		; save current state
	push	de
	
	ld	de,txt_tp1_left_flash
	ld	bc,txt_tp1_left_flash_e-txt_tp1_left_flash
	call	PRINT

	pop	de		; restore state
	pop	bc
	ret

;;; Highlight placeholder for the 'RIGHT' key
txt_flash_right:
	push	bc		; save current state
	push	de
	
	ld	de,txt_tp1_right_flash
	ld	bc,txt_tp1_right_flash_e-txt_tp1_right_flash
	call	PRINT

	pop	de		; restore state
	pop	bc
	ret

;;; Highlight placeholder for the 'THRUST' key
txt_flash_thrust:
	push	bc		; save current state
	push	de
	
	ld	de,txt_tp1_thrust_flash
	ld	bc,txt_tp1_thrust_flash_e-txt_tp1_thrust_flash
	call	PRINT

	pop	de		; restore state
	pop	bc
	ret

;;; Highlight placeholder for the 'FIRE' key
txt_flash_fire:
	push	bc		; save current state
	push	de
	
	ld	de,txt_tp1_fire_flash
	ld	bc,txt_tp1_fire_flash_e-txt_tp1_fire_flash
	call	PRINT

	pop	de		; restore state
	pop	bc
	ret

;;; Leaves the cursor at the spot for printing the 'LEFT' key
txt_left_key:
	push	bc		; save current state
	push	de
	
	ld	de,txt_tp1_left_loc
	ld	bc,txt_tp1_left_loc_e-txt_tp1_left_loc
	call	PRINT

	pop	de		; restore state
	pop	bc
	ret
	
;;; Leaves the cursor at the spot for printing the 'RIGHT' key
txt_right_key:
	push	bc		; save current state
	push	de
	
	ld	de,txt_tp1_right_loc
	ld	bc,txt_tp1_right_loc_e-txt_tp1_right_loc
	call	PRINT

	pop	de		; restore state
	pop	bc
	ret

;;; Leaves the cursor at the spot for printing the 'THRUST' key
txt_thrust_key:
	push	bc		; save current state
	push	de
	
	ld	de,txt_tp1_thrust_loc
	ld	bc,txt_tp1_thrust_loc_e-txt_tp1_thrust_loc
	call	PRINT

	pop	de		; restore state
	pop	bc
	ret

;;; Leaves the cursor at the spot for printing the 'FIRE' key
txt_fire_key:
	push	bc		; save current state
	push	de
	
	ld	de,txt_tp1_fire_loc
	ld	bc,txt_tp1_fire_loc_e-txt_tp1_fire_loc
	call	PRINT

	pop	de		; restore state
	pop	bc
	ret

;;; Text right before beginning the game
txt_ready:
	push	bc		; save current state
	push	de
	
	ld	de,txt_tready
	ld	bc,txt_tready_e-txt_tready
	call	PRINT

	pop	de		; restore state
	pop	bc
	ret

;;; Delete text right before beginning the game
txt_dready:
	push	bc		; save current state
	push	de
	
	ld	de,txt_tdready
	ld	bc,txt_tdready_e-txt_tdready
	call	PRINT

	pop	de		; restore state
	pop	bc
	ret

;;; Checks which of the rockets were hit and prints the relevant message
txt_winner:
	push	bc			; store current state
	push	de

	ld	a,(rocket1_rktsts)
	and	1		  	; select bit0
	jp	z,twnh		  	; rocket1 not hit
	ld	a,(rocket2_rktsts) 	; rocket1 hit, check if rocket2 is also hit
	and	1		  	; select bit0
	jp	z,twhn		  	; rocket2 not hit
	ld	de,txt_tdraw		; draw!
	ld	bc,txt_tdraw_e-txt_tdraw
	jp	twmo
twnh:	ld	a,$70			; rocket1 wins!
	ld	(posx+1),a
	ld	a,$3a
	ld	(posy+1),a
	ld	a,$01
	ld	(rktsts),a
	xor	a
	ld	(rot),a
	call	rocket_delete
	call	rocket_paint
	ld	de,txt_twins
	ld	bc,txt_twins_e-txt_twins
	jp	twmo
twhn:	ld	a,$70			; rocket2 wins!
	ld	(posx+1),a
	ld	a,$3a
	ld	(posy+1),a
	ld	a,$03
	ld	(rktsts),a
	xor	a
	ld	(rot),a
	call	rocket_delete
	call	rocket_paint
	ld	de,txt_twins
	ld	bc,txt_twins_e-txt_twins
twmo:	call	PRINT

	pop	de		; restore state
	pop	bc
	ret
	
txt_tdraw:		db	AT,8,15,INK,7,PAPER,0,'DRAW!'
txt_tdraw_e:		equ	$
txt_twins:		db	AT,8,17,INK,7,PAPER,0,'WINS!'
txt_twins_e:		equ	$
txt_tready:		db	AT,8,12,INK,7,PAPER,0,'GET READY!'
txt_tready_e:		equ	$
txt_tdready:		db	AT,8,12,INK,7,PAPER,0,'          '
txt_tdready_e:		equ	$
txt_tstart_game:	db	AT,12,10,INK,7,PAPER,0,'0: START GAME'
txt_tstart_game_e:	equ	$
txt_tdstart_game:	db	AT,12,10,INK,7,PAPER,0,'             '
txt_tdstart_game_e:	equ	$
txt_tp1_keys:		db	AT,10,10,INK,7,PAPER,0,'1: PLAYER 1 KEYS'
txt_tp1_keys_e:		equ	$
txt_tdp1_keys:		db	AT,10,10,INK,7,PAPER,0,'                '
txt_tdp1_keys_e:	equ	$
txt_tp1_left:		db	AT,8,6,INK,7,PAPER,0,'PLAYER 1 LEFT.....'
txt_tp1_left_e:		equ	$
txt_tp1_right:		db	AT,10,6,INK,7,PAPER,0,'PLAYER 1 RIGHT....'
txt_tp1_right_e:	equ	$
txt_tp1_thrust:		db	AT,12,6,INK,7,PAPER,0,'PLAYER 1 THRUST...'
txt_tp1_thrust_e:	equ	$
txt_tp1_fire:		db	AT,14,6,INK,7,PAPER,0,'PLAYER 1 FIRE.....'
txt_tp1_fire_e:		equ	$
txt_tp1_left_flash:	db	AT,8,24,FLASH,1,' '
txt_tp1_left_flash_e:	equ	$
txt_tp1_right_flash:	db	AT,10,24,FLASH,1,' '
txt_tp1_right_flash_e:	equ	$
txt_tp1_thrust_flash:	db	AT,12,24,FLASH,1,' '
txt_tp1_thrust_flash_e:	equ	$
txt_tp1_fire_flash:	db	AT,14,24,FLASH,1,' '
txt_tp1_fire_flash_e:	equ	$
txt_tp1_left_loc:	db	AT,8,24,FLASH,0
txt_tp1_left_loc_e:	equ	$
txt_tp1_right_loc:	db	AT,10,24,FLASH,0
txt_tp1_right_loc_e:	equ	$
txt_tp1_thrust_loc:	db	AT,12,24,FLASH,0
txt_tp1_thrust_loc_e:	equ	$
txt_tp1_fire_loc:	db	AT,14,24,FLASH,0
txt_tp1_fire_loc_e:	equ	$

;;; Prints the representation of a key
;;; HL pointing to the string representing the key preceded by its length
txt_key:
	push	bc		; save current state
	push	de

	xor	a
	ld	b,a
	ld	c,(hl)
	inc	hl
	ld	d,h
	ld	e,l
	call	PRINT

	pop	de		; restore state
	pop	bc
	ret

txt_key_shift:		db	5,'SHIFT'
txt_key_z:		db	1,'Z'
txt_key_x:		db	1,'X'
txt_key_c:		db	1,'C'
txt_key_v:		db	1,'V'
txt_key_a:		db	1,'A'
txt_key_s:		db	1,'S'
txt_key_d:		db	1,'D'
txt_key_f:		db	1,'F'
txt_key_g:		db	1,'G'
txt_key_q:		db	1,'Q'
txt_key_w:		db	1,'W'
txt_key_e:		db	1,'E'
txt_key_r:		db	1,'R'
txt_key_t:		db	1,'T'
txt_key_1:		db	1,'1'
txt_key_2:		db	1,'2'
txt_key_3:		db	1,'3'
txt_key_4:		db	1,'4'
txt_key_5:		db	1,'5'
txt_key_0:		db	1,'0'
txt_key_9:		db	1,'9'
txt_key_8:		db	1,'8'
txt_key_7:		db	1,'7'
txt_key_6:		db	1,'6'
txt_key_p:		db	1,'P'
txt_key_o:		db	1,'O'
txt_key_i:		db	1,'I'
txt_key_u:		db	1,'U'
txt_key_y:		db	1,'Y'
txt_key_enter:		db	5,'ENTER'
txt_key_l:		db	1,'L'
txt_key_k:		db	1,'K'
txt_key_j:		db	1,'J'
txt_key_h:		db	1,'H'
txt_key_space:		db	5,'SPACE'
txt_key_symb:		db	4,'SYMB'
txt_key_m:		db	1,'M'
txt_key_n:		db	1,'N'
txt_key_b:		db	1,'B'
