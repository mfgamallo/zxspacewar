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
	ld	(ix+trps),3  	  ; set both bit0 and bit1
	ld	(ix+trpx),b	  ; store the X position of the new torpedo
	ld	(ix+trpx+1),c
	ld	(ix+trpox),b	  ; update the old X position too to avoid artifacts
	ld	(ix+trpox+1),c
	ld	(ix+trpy),d	  ; store the Y position of the new torpedo
	ld	(ix+trpy+1),e
	ld	(ix+trpoy),d	  ; update the old Y position too to avoid artifacts
	ld	(ix+trpoy+1),e

	ld	a,l		  ; load back the rotation into A
	call	thrust		  ; get initial push for the torpedo
	sla	c
	rl	b
	sla	c
	rl	b
	sla	c
	rl	b
	sla	c
	rl	b
	sla	c
	rl	b
	sla	c
	rl	b
	ld	(ix+trpvx),b	  ; store the speed in the X axis
	ld	(ix+trpvx+1),c
	sla	e
	rl	d
	sla	e
	rl	d
	sla	e
	rl	d
	sla	e
	rl	d
	sla	e
	rl	d
	sla	e
	rl	d
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
	and	1		; select the "alive" bit
	cp	0
	jp	z,tmnext	  ; if this torpedo is inactive don't mind it - move to the next
	;; Update X ensuring its current value is preserved in old X
	ld	h,(ix+trpx)
	ld	l,(ix+trpx+1)
	ld	(ix+trpox),h
	ld	(ix+trpox+1),l
	ld	d,(ix+trpvx)
	ld	e,(ix+trpvx+1)
	;; The torpedo is out of the screen with regards to the X axis if either
	;; D is negative and there's no carry when calculating the new positon in the X axis
	;; D is positive and there's carry
	xor	a		; reset A
	add	hl,de		; calculate the new position in the X axis
	rra			; C (carry) moved to bit 7 (sign) of the accumulator
	xor	d		; now the accumulator's 7th bit will be 1 only if the torpedo is out of the screen
	jp	m,tmdie		; if out of the screen, free the torpedo slot
	ld	(ix+trpx),h
	ld	(ix+trpx+1),l
	;; Update Y ensuring its current value is preserved in old Y
	ld	h,(ix+trpy)
	ld	l,(ix+trpy+1)
	ld	(ix+trpoy),h
	ld	(ix+trpoy+1),l
	ld	d,(ix+trpvy)
	ld	e,(ix+trpvy+1)
	add	hl,de
	;; The torpedo is out of the screen with regards to the Y axis if both HL's bits 15 and 14 are set.
	ld	a,h
	and	$c0
	xor	$c0
	jp	z,tmdie
	ld	(ix+trpy),h
	ld	(ix+trpy+1),l
	jp	tmnext		; move to the next slot
tmdie:	ld	(ix+trps),2	; leave bit1 set
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
	and	1		; select the "alive" bit
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

;;; Deletes all the active torpedoes
trps_delete:
	push	de                ; store current state
	push	hl
	push	ix

	ld	ix,trp_list	  ; point to the beginning of the torpedo list
tdloop:	ld	a,(ix+trps)
	cp	0
	jp	z,tdnext	  ; if this torpedo is inactive don't delete it - move to the next
	ld	h,(ix+trpx)	  ; load X
	ld	l,(ix+trpx+1)
	ld	d,(ix+trpy)	  ; load Y
	ld	e,(ix+trpy+1)
	call	delete_dw_dot
	ld	h,(ix+trpox)	  ; load old X
	ld	l,(ix+trpox+1)
	ld	d,(ix+trpoy)	  ; load old Y
	ld	e,(ix+trpoy+1)
	call	delete_dw_dot
	ld	a,(ix+trps)
	and	1		; select "alive" bit
	jp	nz,tdnext	; if the torpedo is alive move on
	ld	(ix+trps),0	; if not reset every bit
tdnext:	ld	e,bptrp		; point to the next slot
	ld	d,0
	add	ix,de
	ld	hl,trp_end_list	; check that we're not past the end of the list
	dec	hl
	push	ix
	pop	de
	sbc	hl,de
	jp	c,tdend		; if we are, end
	jp	tdloop		; loop

tdend:	pop	ix		  ; restore state
	pop	hl
	pop	de
	ret

;;; Each torpedo needs
;;; status: 1 byte
;;; 	bit0: alive
;;; 	bit1: still needs to be deleted from the screen
;;; X position: 2 bytes
;;; Y position: 2 bytes
;;; old X position: 2 bytes
;;; old Y position: 2 bytes
;;; X velocity: 2 bytes
;;; Y velocity: 2 bytes
bptrp:	equ	13
trps:	equ	0		; shift to the status byte
trpx:	equ	1		; shift to X position
trpy:	equ	3		; shift to Y position
trpox:	equ	5		; shift to old X position
trpoy:	equ	7		; shift to old Y position
trpvx:	equ	9		; shift to X velocity
trpvy:	equ	11		; shift to Y velocity

trp_list:
	ds	MAXTRP * bptrp
trp_end_list:			; End of the list of torpedoes
