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

(defun dmaz/typescript/format--tmp-here (orig-fun &rest args)
  (let ((temporary-file-directory default-directory))
    (apply orig-fun args)))

(defun dmaz/projectile-test-suffix (project-type)
  (or (projectile-test-suffix project-type) ".test"))

(defun dmaz/joindirs (root &rest dirs)
  "Joins a series of directories together, like Python's os.path.join,
  (dmaz/joindirs \"/tmp\" \"a\" \"b\" \"c\") => /tmp/a/b/c"

  (if (not dirs)
      root
    (apply 'dmaz/joindirs
           (expand-file-name (car dirs) root)
           (cdr dirs))))

(defun dmaz/show-notification (notification &optional title)
  (interactive "sNotification text: ")
  (let ((title (or title "Emacs")))
    (start-process "emacs-timer-notification" nil
                   dmaz/growlnotify-command (format "/t:%s" title) (concat "/i:" (dmaz/joindirs user-emacs-directory "emacs.png")) notification)))

(defun dmaz/eq-time-and-time (time1 time2)
  (and (not (time-less-p time1 time2))
       (not (time-less-p time2 time1))))
