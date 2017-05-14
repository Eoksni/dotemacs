(defun dmaz/move-beginning-of-line--smart (orig-fun &rest args)
  "Move point to begin of indentation or beginning of line.

Move point to the begin of indentation on this line.
If point was already at that position, move point to beginning of line.
If point was already at the beginning of line, move to begin of indentation instead."

  (let* ((old-pos (point))
         (indent-pos (save-excursion (back-to-indentation) (point)))
         (beginning-pos (save-excursion (apply orig-fun args) (point))))
    (if (and (<= old-pos indent-pos) (> old-pos beginning-pos)) 
        (apply orig-fun args)
      (back-to-indentation))))
