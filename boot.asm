;;; boot.asm
;;; Readies the computer for the game. Currently it just clears both screen buffers.

boot:
	call	switch		; switch screen
	call 	setupscr
	call	cleanscr
	call	switch		; switch screen
	call 	setupscr
	call	cleanscr
	ret
