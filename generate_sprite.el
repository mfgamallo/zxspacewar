(setq models
      '(
	("VERTICAL"
	 ("0000000110000000"
	  "0000001111000000"
	  "0000011111100000"
	  "0000111111110000"
	  "0001111111111000"
	  "0000000110000000"
	  "0000000110000000"
	  "0000000110000000"
	  "0000000110000000"
	  "0000000110000000"
	  "0000000110000000"
	  "0000000110000000"
	  "0000000110000000"
	  "0000000110000000"
	  "0000000110000000"
	  "0000000110000000"))
	("HORIZONTAL"
	 ("0000000000000000"
	  "0000000000000000"
	  "0000000000000000"
	  "0000000000010000"
	  "0000000000011000"
	  "0000000000011100"
	  "0000000000011110"
	  "1111111111111111"
	  "1111111111111111"
	  "0000000000011110"
	  "0000000000011100"
	  "0000000000011000"
	  "0000000000010000"
	  "0000000000000000"
	  "0000000000000000"
	  "0000000000000000"))
	)
      )

(defun generate-all (models)
  (let ((result ""))
    (dolist (elem models result)
      (setq result (concat result (generate-with-mirrors elem))))))

(defun generate-with-mirrors (elem)
  (print elem)
  (let ((mode (car elem))
	(model (car (cdr elem)))
	(result ""))
    (setq result (concat result (generate-sprites model)))
    (when (equal mode "VERTICAL")
      (setq result (concat result (generate-sprites (flip-v model)))))
    (when (equal mode "HORIZONTAL")
      (setq result (concat result (generate-sprites (flip-h model)))))
    result
    ))

(defun flip-v (model)
  (let (result)
    (dolist (row model result)
      (setq result (cons row result)))))

(defun flip-h (model)
  (let (result)
    (dolist (row model result)
      (let ((rev ""))
	(dotimes (i (length row) rev)
	  (setq rev (concat (char-to-string (aref row i)) rev)))
	(setq result (append result (list rev)))))
    result))
      

(defun generate-sprites (model)
  "Generate a list of lists the ASM strings from MODEL."
  (let (result)
    (dotimes (i 8 result)
      (setq result
	    (cons (expand model (- 7 i) (+ i 1))
		  result)))
    (sprites-to-string result)))

(defun expand (model n-begin n-end)
  (let ((result)
	(begin (make-string n-begin ?0))
	(end (make-string n-end ?0)))
    (dolist (row model result)
      (setq result
	    (append result
		    (list (concat begin row end)))))))

(defun sprites-to-string (sprites)
  (let ((result ""))
    (dolist (sprite sprites result)
      (dolist (row sprite)
	(setq result (concat result "\n" (row-to-string row))))
      (setq result (concat result "\n")))))

(defun row-to-string (row)
  (concat "\tdb\t%"
	  (substring row 0 8) ", %"
	  (substring row 8 16) ", %"
	  (substring row 16 24)))

(defun send-to-scratch (text)
  (set-buffer "*scratch*")
  (insert text))

(let ((text (generate-all models)))
  (send-to-scratch text))
