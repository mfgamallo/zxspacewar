org 32768

main:	halt

	;; read keyboard
	call 	controls_read

	;; delete the rocket
	call	rocket_delete

	;; paint the star
	call	paint_centre_star

	;; move the rocket
	call	rocket_move

	;; move the torpedoes
	call	trps_move

	;; paint the rocket
	call 	rocket_paint

	;; paint the torpedoes
	call	trps_paint
	
	jr 	main


	include "controls.asm"
	include "rocket.asm"
	include "torpedoes.asm"
	include "star.asm"
	include "math.asm"
	include "newton.asm"
	include	"graph.asm"
	
end 32768
