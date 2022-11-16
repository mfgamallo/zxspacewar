;;; boot.asm
;;; Readies the computer for the game. Currently it just clears both screen buffers.

boot:
	call	switch		; switch screen
	call 	setupscr
	call	cleanscr
	call	switch		; switch screen
	call 	setupscr
	call	cleanscr
	call	txt_select_channel_2 ; ready to print text
	call	txt_set_white_on_black ; ensure text is white and background is black
	ret
