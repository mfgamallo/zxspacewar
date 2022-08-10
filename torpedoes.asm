MAXTRP:	equ	10		; maximum number of torpedoes

;;; Expects
;;; A containing rotation
;;; BC containing X position
;;; DE containing Y position
trp_new:
	push	hl		  ; save current state
	push	ix

	ld	l,a		  ; we'll need the rotation if we really create a new torpedo
	
	call	trp_allow	  ; can a new torpedo be fired?
	cp	0
	jp	nz,trp_na

	call	trp_find_slot	  ; make IX point to the next free torpedo slot
	jp	c,trp_na	  ; if there's no free torpedo slot return

	call	trp_reset_interval
	ld	(ix+trps),1  	  ; sets status to "in use"
	ld	(ix+trpx),b	  ; store the X position of the new torpedo
	ld	(ix+trpx+1),c
	ld	(ix+trpy),d	  ; store the Y position of the new torpedo
	ld	(ix+trpy+1),e

	ld	a,l		  ; load back the rotation into A
	call	thrust		  ; get initial push for the torpedo
	ld	(ix+trpvx),b	  ; store the speed in the X axis
	ld	(ix+trpvx+1),c
	ld	(ix+trpvy),d	  ; store the speed in the Y axis
	ld	(ix+trpvy+1),e

trp_na:	pop	ix		  ; restore state
	pop	hl
	ret

;;; Check if the creation of a new torpedo is allowed, that is, if enough time passed since the last shot
;;; sets A to 0 if allowed, something else otherwise
;;; TODO
;;; Use C (carry) instead of A to return
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

;;; Finds a free torpedo slot. Points IX to it. If there's none sets the Carry flag
trp_find_slot:
	push	bc		; store current state
	push	hl
	
	ld	ix,trp_list	; point at the status record for the first torpedo slot
trplp:	ld	a,(ix+trps)
	cp	0
	jp	z,trpfse	; found a free slot! Return
	ld	c,bptrp		; point to the next slot
	ld	b,0
	add	ix,bc
	ld	hl,trp_end_list	; check that we're not past the end of the list
	dec	hl
	push	ix
	pop	bc
	sbc	hl,bc
	jp	c,trpfse	; if we are, carry flag is already set. Return.
	jp	trplp		; loop
trpfse:	pop	hl		; restore state
	pop	bc
	ret

;;; Move all the active torpedoes according to their respective speeds
trps_move:
	push	de		  ; store current state
	push	hl
	push	ix

	ld	ix,trp_list	  ; point to the beginning of the torpedo list
tmloop:	ld	a,(ix+trps)
	cp	0
	jp	z,tmnext	  ; if this torpedo is inactive don't mind it - move to the next
	ld	h,(ix+trpx)	  ; update X
	ld	l,(ix+trpx+1)
	ld	d,(ix+trpvx)
	ld	e,(ix+trpvx+1)
	add	hl,de
	ld	(ix+trpx),h
	ld	(ix+trpx+1),l
	ld	h,(ix+trpy)	  ; update Y
	ld	l,(ix+trpy+1)
	ld	d,(ix+trpvy)
	ld	e,(ix+trpvy+1)
	add	hl,de
	ld	(ix+trpy),h
	ld	(ix+trpy+1),l
tmnext:	ld	e,bptrp		; point to the next slot
	ld	d,0
	add	ix,de
	ld	hl,trp_end_list	; check that we're not past the end of the list
	dec	hl
	push	ix
	pop	de
	sbc	hl,de
	jp	c,tmend		; if we are, end
	jp	tmloop		; loop

tmend:	pop	ix		; restore state
	pop	hl
	pop	de
	ret

;;; Paints all the active torpedoes
trps_paint:
	push	de                ; store current state
	push	hl
	push	ix

	call	trp_inc		  ; increment counter to limit concurrent torpedoes
	ld	ix,trp_list	  ; point to the beginning of the torpedo list
tploop:	ld	a,(ix+trps)
	cp	0
	jp	z,tpnext	  ; if this torpedo is inactive don't paint it - move to the next
	ld	h,(ix+trpx)	  ; load X
	ld	l,(ix+trpx+1)
	ld	d,(ix+trpy)	  ; load Y
	ld	e,(ix+trpy+1)
	call	paint_dw_dot
tpnext:	ld	e,bptrp		; point to the next slot
	ld	d,0
	add	ix,de
	ld	hl,trp_end_list	; check that we're not past the end of the list
	dec	hl
	push	ix
	pop	de
	sbc	hl,de
	jp	c,tpend		; if we are, end
	jp	tploop		; loop

tpend:	pop	ix		  ; restore state
	pop	hl
	pop	de
	ret
	
;;; Each torpedo needs
;;; status: 1 byte
;;; X position: 2 bytes
;;; Y position: 2 bytes
;;; X velocity: 2 bytes
;;; Y velocity: 2 bytes
bptrp:	equ	9
trps:	equ	0		; shift to the status byte
trpx:	equ	1		; shift to X position
trpy:	equ	3		; shift to Y position
trpvx:	equ	5		; shift to X velocity
trpvy:	equ	7		; shift to Y velocity

trp_list:
	ds	MAXTRP * bptrp
trp_end_list:			; End of the list of torpedoes
