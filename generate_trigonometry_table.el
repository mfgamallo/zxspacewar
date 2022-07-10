;;
;; generate_trigonometry_table.el
;; Generates tables both for sine and cosine
;; It needs to have 256 entries, corresponding to every value the Accumulator can take
;; A value of 0 corresponds to 0 degrees, whereas a value of 255 corresponds to 360 degrees
;;
(let ((res "\n"))
  (dotimes (i 256)
    (let* ((degrees (+ (* i (/ 360.0 255.0)) 270))
	   (rads (* degrees (/ (* pi 2) 360)))
	   (sine (floor (* (sin rads) 5))))
      (when (< sine 0)
	(setq sine (+ 255 sine)))
      (setq res (concat res (format "\tdb\t$%x\n" sine)))))
  (print res))

(let ((res "\n"))
  (dotimes (j 256)
    (let* ((i (- 255 j))
	   (degrees (+ (* i (/ 360.0 255.0)) 90))
	   (rads (* degrees (/ (* pi 2) 360)))
	   (cosine (floor (* (cos rads) 5))))
      (when (< cosine 0)
	(setq cosine (+ 255 cosine)))
      (setq res (concat res (format "\tdb\t$%x\n" cosine)))))
  (print res))
