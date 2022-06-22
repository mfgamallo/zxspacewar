(setq model
      '(
	"0000000110000000"
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
	"0000000110000000"
	)
      )


(defun generate (model)
  "Generate a list of lists the ASM strings from MODEL."
  (let (result)
    (dotimes (i 8 result)
      (setq result
	    (cons (expand model (- 8 i) i)
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
      (dolist (row sprite result)
	(setq result (concat result "\n" (row-to-string row)))))))

(defun row-to-string (row)
  (concat "\tdb\t%"
	  (substring row 0 8) ", %"
	  (substring row 8 16) ", %"
	  (substring row 16 24)))

(defun send-to-scratch (text)
  (set-buffer "*scratch*")
  (insert text))

(let ((text (generate model)))
  (send-to-scratch text))
