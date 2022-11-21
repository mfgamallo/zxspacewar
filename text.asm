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

txt_set_white_on_black:
	ld	a,INK
	rst	$10
	ld	a,7
	rst	$10
	ld	a,PAPER
	rst	$10
	ld	a,0
	rst	$10
	ret
	
;;; Prints a text at a given position.
;;; de contains the x,y coordinates
;;; hl points to the string to be written
txt_print_at:
	ld	a,AT
	rst	$10
	ld	a,e
	rst	$10
	ld	a,d
	rst	$10
tpal:	ld	a,(hl)
	and	a
	ret	z
	rst	$10
	inc	hl
	jp	tpal

;;; Enables flash
txt_flash_on:
	ld	a,FLASH
	rst	$10
	ld	a,1
	rst	$10
	ret

;;; Disables flash
txt_flash_off:
	ld	a,FLASH
	rst	$10
	ld	a,0
	rst	$10
	ret
	
;;; Main menu text
txt_main_menu:
	push	de		; save current state

	ld	d,10
	ld	e,10
	ld	hl,txt_p1_keys
	call	txt_print_at
	ld	e,12
	ld	hl,txt_p2_keys
	call	txt_print_at
	ld	e,14
	ld	hl,txt_start_game
	call	txt_print_at

	pop	de		; restore state
	ret
	
;;; Delete the main menu text
txt_delete_main_menu:
	push	de		; save current state
	push	hl

	ld	d,10
	ld	e,10
	ld	hl,txt_white20
	call	txt_print_at
	ld	e,12
	ld	hl,txt_white20
	call	txt_print_at
	ld	e,14
	ld	hl,txt_white20
	call	txt_print_at

	pop	hl		; restore state
	pop	de
	ret

;;; Redefine player 1's keys
txt_player1_keys:
	push	de		; save current state

	ld	d,6
	ld	e,8
	ld	hl,txt_p1_left
	call	txt_print_at
	ld	d,6
	ld	e,10
	ld	hl,txt_p1_right
	call	txt_print_at
	ld	d,6
	ld	e,12
	ld	hl,txt_p1_thrust
	call	txt_print_at
	ld	d,6
	ld	e,14
	ld	hl,txt_p1_fire
	call	txt_print_at

	pop	de		; restore state
	ret

;;; Redefine player 2's keys
txt_player2_keys:
	push	de		; save current state

	ld	d,6
	ld	e,8
	ld	hl,txt_p2_left
	call	txt_print_at
	ld	d,6
	ld	e,10
	ld	hl,txt_p2_right
	call	txt_print_at
	ld	d,6
	ld	e,12
	ld	hl,txt_p2_thrust
	call	txt_print_at
	ld	d,6
	ld	e,14
	ld	hl,txt_p2_fire
	call	txt_print_at

	pop	de		; restore state
	ret

;;; Delete menu with the player keys
txt_delete_player_keys:
	push	de		; save current state

	ld	d,6
	ld	e,8
	ld	hl,txt_white25
	call	txt_print_at
	ld	d,6
	ld	e,10
	ld	hl,txt_white25
	call	txt_print_at
	ld	d,6
	ld	e,12
	ld	hl,txt_white25
	call	txt_print_at
	ld	d,6
	ld	e,14
	ld	hl,txt_white25
	call	txt_print_at

	pop	de		; restore state
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

	ld	d,15
	ld	e,8
	ld	hl,txt_draw
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
	ld	d,17
	ld	e,8
	ld	hl,txt_wins
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
	ld	d,17
	ld	e,8
	ld	hl,txt_wins
twmo:	call	txt_print_at

	pop	de		; restore state
	pop	bc
	ret

txt_white1:		db	' ',0
txt_white10:		db	'          ',0
txt_white20:		db	'                    ',0
txt_white25:		db	'                         ',0
txt_p1_keys:		db	'1: PLAYER 1 KEYS',0
txt_p2_keys:		db	'2: PLAYER 2 KEYS',0
txt_start_game:		db	'0: START GAME',0
txt_draw:		db	'DRAW!',0
txt_wins:		db	'WINS!',0
txt_ready:		db	'GET READY!',0
txt_p1_left:		db	'PLAYER 1 LEFT.....',0
txt_p1_right:		db	'PLAYER 1 RIGHT....',0
txt_p1_thrust:		db	'PLAYER 1 THRUST...',0
txt_p1_fire:		db	'PLAYER 1 FIRE.....',0
txt_p2_left:		db	'PLAYER 2 LEFT.....',0
txt_p2_right:		db	'PLAYER 2 RIGHT....',0
txt_p2_thrust:		db	'PLAYER 2 THRUST...',0
txt_p2_fire:		db	'PLAYER 2 FIRE.....',0
	
txt_key_shift:		db	'SHIFT',0
txt_key_z:		db	'Z',0
txt_key_x:		db	'X',0
txt_key_c:		db	'C',0
txt_key_v:		db	'V',0
txt_key_a:		db	'A',0
txt_key_s:		db	'S',0
txt_key_d:		db	'D',0
txt_key_f:		db	'F',0
txt_key_g:		db	'G',0
txt_key_q:		db	'Q',0
txt_key_w:		db	'W',0
txt_key_e:		db	'E',0
txt_key_r:		db	'R',0
txt_key_t:		db	'T',0
txt_key_1:		db	'1',0
txt_key_2:		db	'2',0
txt_key_3:		db	'3',0
txt_key_4:		db	'4',0
txt_key_5:		db	'5',0
txt_key_0:		db	'0',0
txt_key_9:		db	'9',0
txt_key_8:		db	'8',0
txt_key_7:		db	'7',0
txt_key_6:		db	'6',0
txt_key_p:		db	'P',0
txt_key_o:		db	'O',0
txt_key_i:		db	'I',0
txt_key_u:		db	'U',0
txt_key_y:		db	'Y',0
txt_key_enter:		db	'ENTER',0
txt_key_l:		db	'L',0
txt_key_k:		db	'K',0
txt_key_j:		db	'J',0
txt_key_h:		db	'H',0
txt_key_space:		db	'SPACE',0
txt_key_symb:		db	'SYMB',0
txt_key_m:		db	'M',0
txt_key_n:		db	'N',0
txt_key_b:		db	'B',0
