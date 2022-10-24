org 32768

	;; startup
	call	boot

main:	halt

	;; switch screen buffer
	call	switch

	;; read keyboard
	call 	controls_read

	;; delete the rocket 1
	call	load_rocket1
	call	rocket_delete

	;; delete the old rocket 1
	call	load_old_rocket1
	call	rocket_delete

	;; delete the rocket 2
	call	load_rocket2
	call	rocket_delete

	;; delete the old rocket 2
	call	load_old_rocket2
	call	rocket_delete

	;; delete the torpedoes
	call	trps_delete

	;; move the rocket 1
	call	load_rocket1
	call	rocket_move
	call	save_old_rocket1
	call	save_rocket1

	;; move the rocket 2
	call	load_rocket2
	call	rocket_move
	call	save_old_rocket2
	call	save_rocket2
	
	;; move the torpedoes
	call	trps_move

	;; paint the star
	call	paint_centre_star
	
	;; paint the rocket 1
	call	load_rocket1
	call 	rocket_paint

	;; paint the rocket 2
	call	load_rocket2
	call 	rocket_paint

	;; paint the torpedoes
	call	trps_paint

	jr 	main

	
	include "boot.asm"
	include "screen.asm"
	include "rockets.asm"
	include "controls.asm"
	include "rocket.asm"
	include "torpedoes.asm"
	include "star.asm"
	include "math.asm"
	include "newton.asm"
	include	"graph.asm"
	
end 32768
