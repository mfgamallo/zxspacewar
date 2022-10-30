controls_read:
	ld	bc,$fbfe
	in	a,(c)
	and	$01		; test for 'Q'
	call	z,q_key_pressed
	ld	bc,$fbfe
	in	a,(c)
	and	$10		; test for 'T'
	call	z,t_key_pressed

	ld	bc,$fdfe
	in	a,(c)
	and	$08		; test for 'F'
	call	z,f_key_pressed
	ld	bc,$fdfe
	in	a,(c)
	and	$10		; test for 'G'
	call	z,g_key_pressed

	ld	bc,$dffe
	in	a,(c)
	and	$01		; test por 'P'
	call	z,p_key_pressed
	ld	bc,$dffe
	in	a,(c)
	and	$02		; test for 'O'
	call	z,o_key_pressed
	
	ld	bc,$bffe
	in	a,(c)
	and	$10		; test for 'H'
	call	z,h_key_pressed

	ld	bc,$7ffe
	in	a,(c)
	and	$01		; test for 'SPACE'
	call	z,space_key_pressed

	ret

p_key_pressed:
	call	load_rocket1
	call	rocket_rotate_right
	call	save_rocket1
	ret

o_key_pressed:
	call	load_rocket1
	call	rocket_rotate_left
	call	save_rocket1
	ret

q_key_pressed:
	call	load_rocket1
	call	rocket_thrust
	call	save_rocket1
	ret

space_key_pressed:
	call	load_rocket1
	call	rocket_fire
	call	save_rocket1
	ret
	
h_key_pressed:
	call	load_rocket2
	call	rocket_rotate_right
	call	save_rocket2
	ret

f_key_pressed:
	call	load_rocket2
	call	rocket_rotate_left
	call	save_rocket2
	ret

t_key_pressed:
	call	load_rocket2
	call	rocket_thrust
	call	save_rocket2
	ret

g_key_pressed:
	call	load_rocket2
	call	rocket_fire
	call	save_rocket2
	ret
