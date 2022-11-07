;;; text.asm
;;; Showing text
;;; TODO maybe I should think about creating my own chars

AT:	equ	$16
INK:	equ	$10
PAPER:	equ	$11

;;; Text right before beginning the game
txt_ready:
	push	bc		; save current state
	push	de
	
	ld	de,txt_tready
	ld	bc,txt_tready_e-txt_tready
	call	$203c		; write

	pop	de		; restore state
	pop	bc
	ret

;;; Delete text right before beginning the game
txt_dready:
	push	bc		; save current state
	push	de
	
	ld	de,txt_tdready
	ld	bc,txt_tdready_e-txt_tdready
	call	$203c		; write

	pop	de		; restore state
	pop	bc
	ret

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
twmo:	call	$203c		; write

	pop	de		; restore state
	pop	bc
	ret
	
txt_tdraw:	db	AT,8,15,INK,7,PAPER,0,'DRAW!'
txt_tdraw_e:	equ	$
txt_twins:	db	AT,8,17,INK,7,PAPER,0,'WINS!'
txt_twins_e:	equ	$
txt_tready:	db	AT,8,12,INK,7,PAPER,0,'GET READY!'
txt_tready_e:	equ	$
txt_tdready:	db	AT,8,12,INK,7,PAPER,0,'          '
txt_tdready_e:	equ	$
