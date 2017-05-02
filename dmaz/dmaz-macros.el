;; ++macros ;;
(defmacro with-libraries (&rest body)
  (if (> (length body) 1)
      (let ((symbol (pop body)))
        `(if (require ,symbol nil t)
             (with-libraries ,@body)
           (warn (format "Could not load library '%s" ,symbol))))
    (pop body)))
(defmacro with-library (symbol &rest body)
  `(with-libraries ,symbol (progn ,@body)))
(defmacro after-libraries (&rest body)
  (if (> (length body) 1)
      `(eval-after-load ,(pop body) (after-libraries ,@body))
    (pop body)))
(defmacro after-library (symbol &rest body)
  `(eval-after-load ,symbol '(progn ,@body)))
;; --macros ;;

(provide 'dmaz-macros)
