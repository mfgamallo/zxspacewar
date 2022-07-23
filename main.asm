org 32768

main:	halt

	;; read keyboard
	call controls_read

	;; delete the rocket
	call	rocket_delete

	;; paint the star
	call	paint_centre_star

	;; move the rocket
	call	rocket_move

	;; paint the rocket
	call 	rocket_paint
	
	jr 	main


	include "controls.asm"
	include "rocket.asm"
	include	"graph.asm"
	include "math.asm"
	include "newton.asm"
	include "star.asm"
	
end 32768
