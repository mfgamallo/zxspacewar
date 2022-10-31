(setq models
      '(
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
	 "0000000110000000")
	("0000000000111000"
	 "0000011111111100"
	 "0000000111111110"
	 "0000000001111111"
	 "0000000001100011"
	 "0000000001100000"
	 "0000000011000000"
	 "0000000110000000"
	 "0000000110000000"
	 "0000001100000000"
	 "0000011000000000"
	 "0000011000000000"
	 "0000110000000000"
	 "0000110000000000"
	 "0001100000000000"
	 "0001100000000000")
	("0000000001111111"
	 "0000000000111111"
	 "0000000000011111"
	 "0000000000011111"
	 "0000000000111111"
	 "0000000001110011"
	 "0000000011100001"
	 "0000000111000000"
	 "0000001110000000"
	 "0000011100000000"
	 "0000111000000000"
	 "0001110000000000"
	 "0011100000000000"
	 "0111000000000000"
	 "1110000000000000"
	 "1100000000000000")
	("0000000000000000"
	 "0000000000000000"
	 "0000000000000000"
	 "0000000001111111"
	 "0000000000111111"
	 "0000000000111111"
	 "0000000001110011"
	 "0000000111000000"
	 "0000001110000000"
	 "0000111000000000"
	 "0011110000000000"
	 "1111000000000000"
	 "1100000000000000"
	 "0000000000000000"
	 "0000000000000000"
	 "0000000000000000")
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
	 "0000000000000000")
	)
      )

(setq explosion-models
      '(
	("1000000100000000"
	 "0100000110000000"
	 "0111001110000100"
	 "0111111111011000"
	 "0111111111111000"
	 "0011111111110000"
	 "0011111111111000"
	 "0001111111111100"
	 "0011111111111000"
	 "0001111111110000"
	 "0001111111111000"
	 "0000111111111000"
	 "0000111111111100"
	 "0001001111100110"
	 "0000000111000001"
	 "0000000010000000")
	("1000000100000000"
	 "0100000111000010"
	 "0111001111000110"
	 "1111111111111100"
	 "0111111111111100"
	 "0011111111111000"
	 "0011111111111100"
	 "0011111001111110"
	 "1111111001111100"
	 "0011111111111000"
	 "0001111111111100"
	 "0000111111111100"
	 "0001111111111110"
	 "0011101111110111"
	 "0010000111100001"
	 "0000000011000000")
	("1000000110000000"
	 "1100000111000011"
	 "1111001111000110"
	 "1111111111111110"
	 "0111111111111100"
	 "0011111111111100"
	 "0011111101111110"
	 "0111110001111111"
	 "1111111000111100"
	 "1111111011111100"
	 "0011111111111100"
	 "0001111111111110"
	 "0001111111111110"
	 "0011111111110111"
	 "0011000111110011"
	 "0110000011100001")
	("1100000110000001"
	 "1100000111100011"
	 "1111111111101110"
	 "1111111111111110"
	 "0111111111111100"
	 "0011111011111110"
	 "0011111001111111"
	 "0111110000011111"
	 "1111100000111110"
	 "1111111001111110"
	 "0111111101111100"
	 "0011111111111110"
	 "0011111111111110"
	 "0011111111111111"
	 "0111101111110111"
	 "1110000011100011")
	("0000000111000000"
	 "0100001111100010"
	 "1111111111101110"
	 "1111111111111110"
	 "0111111101111100"
	 "0011111001111110"
	 "0011110000111111"
	 "1111000000011111"
	 "1111100000001111"
	 "1111110000111110"
	 "0111111001111100"
	 "0011111011111110"
	 "0011111111111110"
	 "0011111111111111"
	 "0111101111110110"
	 "0010000111100000")
	("0000000111000000"
	 "0000001111100000"
	 "0011111111101100"
	 "0111111011111110"
	 "0111111001111100"
	 "0011110000111110"
	 "0011100000011111"
	 "1111000000000111"
	 "1110000000001111"
	 "1111100000011110"
	 "0111110000111100"
	 "0011111001111110"
	 "0011111111111110"
	 "0001111111111100"
	 "0000101111110000"
	 "0000000111100000")
	("0000000000000000"
	 "0000001111000000"
	 "0000111111001000"
	 "0000011000110100"
	 "0000000000111100"
	 "0001100000011110"
	 "0011100000001110"
	 "0111000000000110"
	 "0110000000001110"
	 "0000000000000000"
	 "0001000000001000"
	 "0011110000011100"
	 "0001111000111100"
	 "0001111100111000"
	 "0000100110000000"
	 "0000000000000000")
	("0000000000000000"
	 "0000000000000000"
	 "0000000000000000"
	 "0000000000000000"
	 "0000000000000000"
	 "0000000000000000"
	 "0000000000000000"
	 "0000000000000000"
	 "0000000000000000"
	 "0000000000000000"
	 "0000000000000000"
	 "0000000000000000"
	 "0000000000000000"
	 "0000000000000000"
	 "0000000000000000"
	 "0000000000000000")
	)
      )

(defun generate-all (models)
  (let ((result ""))
    ;; first quadrant (go through the list, generate all)
    (dolist (model models)
      (setq result (concat result (generate-sprites model))))
    ;; second quadrant (go through the list except the last element, flip vertically
    (dolist (model (cdr (reverse models)))
      (setq result (concat result (generate-sprites (flip-v model)))))
    ;; third quadrant (go thrugh the list except the first and the last, flip both vertically and horizontally)
    (dolist (model (butlast (cdr models)))
      (setq result (concat result (generate-sprites (flip-h (flip-v model))))))
    ;; fourth quadrant (go through the list except the first, flip horizontally
    (dolist (model (reverse (cdr models)) result)
      (setq result (concat result (generate-sprites (flip-h model)))))
    ))

(defun generate-noflips (models)
  (let ((result ""))
    (dolist (model models result)
      (setq result (concat result (generate-sprites model))))
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

;; (let ((text (generate-all models)))
;;   (send-to-scratch text))

;; (let ((text (generate-noflips explosion-models)))
;;   (send-to-scratch text))
