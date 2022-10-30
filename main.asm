;;; main.asm
;;; Game's main loop
;;; Includes every other asm file

org 32768

	;; startup
	call	boot

main_loop:
	halt

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

	;; move the torpedoes
	call	trps_move

	;; move the rocket 1
	call	load_rocket1
	call	rocket_move
	call	col_rocket
	call	save_old_rocket1
	call	save_rocket1

	;; move the rocket 2
	call	load_rocket2
	call	rocket_move
	call	col_rocket
	call	save_old_rocket2
	call	save_rocket2

	;; check for collisions between the two rockets
	call	col_rockets
	
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

	;; Finish if any of the rockets is hit
	call	col_check_rockets
	jp	c,main_collision
	
	jp 	main_loop

main_collision:
	call	exps_reset
main_collision_loop:	
	halt

	;; switch screen buffer
	call	switch

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

	;; paint and animate the explosion(s)
	call	exps_paint

	jp	main_collision_loop

;;; includes
	include "boot.asm"
	include "screen.asm"
	include "controls.asm"
	include "rocket.asm"
	include "rockets.asm"
	include "torpedoes.asm"
	include "star.asm"
	include "explosions.asm"
	include "collisions.asm"
	include "math.asm"
	include "newton.asm"
	include	"graph.asm"
	
end 32768
