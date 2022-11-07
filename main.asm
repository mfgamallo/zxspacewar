;;; main.asm
;;; Game's main loop
;;; Includes every other asm file

org $7000

READY_SECS:	equ	2
WINNER_SECS:	equ	2
	
	;; startup
	call	boot

main_ready:
	call swchto0

	;; paint the rocket 1
	call	reset_rocket1
	call	load_rocket1
	call 	rocket_paint

	;; paint the rocket 2
	call	reset_rocket2
	call	load_rocket2
	call 	rocket_paint

	;; paint the star
	call	paint_centre_star

	;; Print message to get ready
	call	txt_ready

	ld	b,50*READY_SECS		; Wait READY_SECS.
main_ready_loop:
	halt
	
	djnz	main_ready_loop

	;; Clear the screen
	call	txt_dready

main_game:
	call	trps_reset	; delete all the previous torpedoes
main_game_loop:
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
	
	jp 	main_game_loop

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

	;; paint the star
	call	paint_centre_star

	;; paint and animate the explosion(s)
	call	exps_paint
	jp	c,main_outcome

	jp	main_collision_loop

main_outcome:
	;; Switch to screen 0
	call swchto0

	;; print the winner
	call	txt_winner

	ld	b,50*WINNER_SECS	; Wait WINNER_SECS
main_outcome_loop:
	halt

	djnz	main_outcome_loop

	;; Delete the rocket from the outcome
	call	rocket_delete

	jp	main_ready

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
	include "text.asm"
	
end $7000
