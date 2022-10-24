boot:
	call	switch		; switch screen
	call 	setupscr
	call	cleanscr
	call	switch		; switch screen
	call 	setupscr
	call	cleanscr
	ret
