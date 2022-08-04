MAXTRP:	equ	10		; maximum amount of torpedoes

;;; Expects
;;; A containing rotation
;;; BC containing X position
;;; DE containing Y position
trp_new:
	push	hl		  ; save current state
	push	ix

	;; make IX point to the next free torpedo slot
	ld	ix,trp_list 	  ; point to the beginning of the list of torpedoes
	push	de		  ; save Y position for later
	ld	a,(trp_next)	  ; position of the first free slot in the list of torpedoes
	ld	e,a
	xor	a
	ld	d,a
	add	ix,de		  ; point to the first free torpedo slot
	pop	de		  ; restore Y position to DE

	ld	(ix+trpx),b	  ; store the X position of the new torpedo
	ld	(ix+trpx+1),c
	ld	(ix+trpy),d	  ; store the Y position of the new torpedo
	ld	(ix+trpy+1),e

	;; TODO
	;; calculate the velocity in the X and Y axis from the rotation (A) and store it

	;; TODO
	;; ensure the pointer is correctly moved to the next free slot
	;; push up trp_next to account for the new torpedo
	;; ld	hl,(trp_next)
	;; push	de
	;; xor	d
	;; ld	e,bptrp
	;; add	hl,de
	;; ld	(trp_next),hl
	;; pop	de
	
	pop	ix		  ; restore state
	pop	hl
	ret

trps_paint:
	push	de                ; store current state
	push	hl
	push	ix
	
	;; TODO
	;; Paint all the dots, and not just the first one
	ld	ix,trp_list 	  ; point to the beginning of the list of torpedoes
	ld	h,(ix+trpx)	  ; load X
	ld	l,(ix+trpx+1)
	ld	d,(ix+trpy)	  ; load Y
	ld	e,(ix+trpy+1)
	call	paint_dw_dot

	pop	ix		  ; restore state
	pop	hl
	pop	de
	ret
	
;;; Each torpedo needs
;;; X position: 2 bytes
;;; Y position: 2 bytes
;;; X velocity: 2 bytes
;;; Y velocity: 2 bytes
bptrp:	equ	8
trpx:	equ	0		; shift to X position
trpy:	equ	2		; shift to Y position
trpvx:	equ	4		; shift to X velocity
trpvy:	equ	6		; shift to Y velocity

trp_next:
	db	$00		; shift to the next free torpedo slot

trp_list:
	ds	MAXTRP * bptrp
