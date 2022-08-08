MAXTRP:	equ	10		; maximum amount of torpedoes

;;; Expects
;;; A containing rotation
;;; BC containing X position
;;; DE containing Y position
trp_new:
	push	hl		  ; save current state
	push	ix

	call	trp_allow	  ; can a new torpedo be fired?
	cp	0
	jp	nz,trp_na
	call	trp_reset_interval

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

trp_na:	pop	ix		  ; restore state
	pop	hl
	ret

;;; Check if the creation of a new torpedo is allowed, that is:
;;; - less than MAXTRP are already created
;;; - trp_interv is zero
;;; sets A to 0 if allowed, something else otherwise
trp_allow:
	ld	a,(trp_ic)
	cp	trp_i
	ret	p
	xor	a
	ret
	
;;; Increments the counter that limits the amount of torpedoes that can be fired in a time interval
trp_inc:
	call	trp_allow
	ret	z
	ld	a,(trp_ic)
	inc	a
	ld	(trp_ic),a
	ret

;;; Resets the firing interval. This happens after a new torpedo being created, and is meant to limit the number of torpedoes that can be fired in a time interval
trp_reset_interval:
	ld	a,$00
	ld	(trp_ic),a
	ret
	
trp_ic:	db	$00		; interval counter to limit the amount of torpedoes that can be fired in a time interval
trp_i:	equ	$90		; interval to limit the amount of torpedoes that can be fired in a time interval

trps_paint:
	push	de                ; store current state
	push	hl
	push	ix

	call	trp_inc		  ; increment counter to limit concurrent torpedoes
	
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
