;;; main.asm
;;; Game's main loop
;;; Includes every other asm file

org $7000

READY_SECS:	equ	2
WINNER_SECS:	equ	2
	
	;; startup
	call	boot

main_welcome:
	;; call	swchto0

	;; paint the main menu
	call	txt_main_menu
main_welcome_loop:
	halt

	;; Read keyboard
	call	ctrl_welcome

	;; loop if none of the expected keys was pressed
	jp	nc,main_welcome_loop

	;; otherwise, delete the menu and go to the corresponding screen
	call	txt_delete_main_menu
	jp	(hl)

main_player1_keys:
	;; Print current player 1 keys
	call	txt_player1_keys

	;; Ask key for 'LEFT'
	ld	d,24
	ld	e,8
	call	txt_flash_on
	ld	hl,txt_white1
	call	txt_print_at
	call	ctrl_wait_release
	call	ctrl_identify
	ld	(ctrl_player1_left),hl
	ld	ix,(ctrl_player1_left)
	ld	l,(ix+ckk)
	ld	h,(ix+ckk+1)
	call	txt_flash_off
	call	txt_print_at
	
	;; Ask key for 'RIGHT'
	ld	d,24
	ld	e,10
	call	txt_flash_on
	ld	hl,txt_white1
	call	txt_print_at
	call	ctrl_wait_release
	call	ctrl_identify
	ld	(ctrl_player1_right),hl
	ld	ix,(ctrl_player1_right)
	ld	l,(ix+ckk)
	ld	h,(ix+ckk+1)
	call	txt_flash_off
	call	txt_print_at

	;; Ask key for 'THRUST'
	ld	d,24
	ld	e,12
	call	txt_flash_on
	ld	hl,txt_white1
	call	txt_print_at
	call	ctrl_wait_release
	call	ctrl_identify
	ld	(ctrl_player1_thrust),hl
	ld	ix,(ctrl_player1_thrust)
	ld	l,(ix+ckk)
	ld	h,(ix+ckk+1)
	call	txt_flash_off
	call	txt_print_at

	;; Ask key for 'FIRE'
	ld	d,24
	ld	e,14
	call	txt_flash_on
	ld	hl,txt_white1
	call	txt_print_at
	call	ctrl_wait_release
	call	ctrl_identify
	ld	(ctrl_player1_fire),hl
	ld	ix,(ctrl_player1_fire)
	ld	l,(ix+ckk)
	ld	h,(ix+ckk+1)
	call	txt_flash_off
	call	txt_print_at

	call	txt_delete_player_keys
	jp	main_welcome

main_ready:
	call 	swchto0

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
	ld	d,12
	ld	e,8
	ld	hl,txt_ready
	call	txt_print_at

	ld	b,50*READY_SECS		; Wait READY_SECS.
main_ready_loop:
	halt
	
	djnz	main_ready_loop

	;; Clear the screen
	ld	d,12
	ld	e,8
	ld	hl,txt_white20
	call	txt_print_at

main_game:
	call	trps_reset	; delete all the previous torpedoes
main_game_loop:
	halt

	;; switch screen buffer
	call	switch

	;; read keyboard
	call 	ctrl_game

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
