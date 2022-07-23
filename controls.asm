controls_read:
	ld	bc,$dffe
	in	a,(c)
	ld	b,a
	and	$01		; test por 'P'
	call	z,p_key_pressed
	ld	a,b
	and	$02		; test for 'O'
	call	z,o_key_pressed
	
	ld	bc,$fbfe
	in	a,(c)
	and	$01		; test for 'Q'
	call	z,q_key_pressed

	ret

p_key_pressed:
	call	rocket_rotate_right
	ret

o_key_pressed:
	call	rocket_rotate_left
	ret

q_key_pressed:
	call	rocket_thrust
	ret
