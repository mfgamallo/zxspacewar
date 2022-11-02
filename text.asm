;;; text.asm
;;; Showing text

AT:	equ	$16
INK:	equ	$10
PAPER:	equ	$11
	
;;; Checks which of the rockets were hit and prints the relevant message
txt_winner:
	push	bc			; store current state
	push	de

	ld	a,2
	call	$1601			; select screen
	ld	a,(rocket1_rktsts)
	and	1		  	; select bit0
	jp	z,twnh		  	; rocket1 not hit
	ld	a,(rocket2_rktsts) 	; rocket1 hit, check if rocket2 is also hit
	and	1		  	; select bit0
	jp	z,twhn		  	; rocket2 not hit
	ld	de,txt_draw		; draw!
	ld	bc,txt_draw_e-txt_draw
	jp	twmo
twnh:	ld	a,$70			; rocket1 wins!
	ld	(posx+1),a
	ld	a,$3a
	ld	(posy+1),a
	ld	a,$01
	ld	(rktsts),a
	call	rocket_delete
	call	rocket_paint
	ld	de,txt_wins
	ld	bc,txt_wins_e-txt_wins
	jp	twmo
twhn:	ld	a,$70			; rocket2 wins!
	ld	(posx+1),a
	ld	a,$3a
	ld	(posy+1),a
	ld	a,$03
	ld	(rktsts),a
	call	rocket_delete
	call	rocket_paint
	ld	de,txt_wins
	ld	bc,txt_wins_e-txt_wins
twmo:	call	$203c		; write

	pop	de		; restore state
	pop	bc
	ret
	
txt_draw:	db	AT,8,15,INK,7,PAPER,0,'DRAW!'
txt_draw_e:	equ	$
txt_wins:	db	AT,8,17,INK,7,PAPER,0,'WINS!'
txt_wins_e:	equ	$
