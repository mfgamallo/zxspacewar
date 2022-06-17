;;; Simplified distance between two points
;;; arguments (words) in stack (in push order)
;;; x1
;;; x2
;;; y1
;;; y2
distance:

;;; Calculates one of the terms of the distance
;;; (x2 - x1) ^ 2
;;; DE - x1
;;; HL - x2
;;; Assumes x1 and x2 are fixed point 8.8
;;; When doing the power of two discards the decimal parts of x1 and x2
;;; result returned in HL
distance_term:
	sbc	hl,de
	ld	e,h		; keep the most significative byte from BC
	call	mul8
	ret
	
