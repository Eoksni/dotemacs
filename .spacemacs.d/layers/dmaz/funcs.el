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

(defun dmaz/play-sound-file-async (file)
  "Plys with some overhead, but at least doesn't freeze Emacs.
Took from https://github.com/lolownia/org-pomodoro/issues/41#issuecomment-113898387"
  (let ((command (car command-line-args)))
    (start-process "play-sound-file-async" nil command "-Q" "--batch" "--eval"
                   (format "(play-sound-file \"%s\")" file))))

(defun dmaz/apply-formatting-options ()
  (let* ((settings-file (dmaz/locate-file-uptree ".vscode/settings.json"))
         (local-format-options (dmaz/parse-vscode-formatting settings-file)))
    (make-local-variable 'tide-format-options)
    (setq tide-format-options (dmaz/plist-merge tide-format-options local-format-options))))

(defun dmaz/locate-file-uptree (f)
  (dmaz/joindirs (locate-dominating-file "." f) f))

(defun dmaz/parse-vscode-formatting (f)
  "Parses `f' as .vscode/settings.json to get formatting options suitable for `tide-format-options',
  (setq tide-format-options (dmaz-parse-vscode-formatting \".vscode/settings.json\"))"

  (let* ((regexp "^[^/]*\"javascript\\.format\\.\\(.*\\)\": \\([a-z]*\\)")
         (file-contents (with-temp-buffer
                          (insert-file-contents f)
                          (buffer-substring-no-properties
                           (point-min)
                           (point-max))))
         (string-list (split-string file-contents "\n" t))
         (filtered-list (remove-if-not #'(lambda (s)
                                           (string-match regexp s))
                                       string-list))
         (values-list (mapcan #'(lambda (s)
                                  (string-match regexp s)
                                  (let ((name (match-string 1 s))
                                        (value (if (equal (match-string 2 s) "true") t nil)))
                                    `(,(intern (concat ":" name)) ,value))
                                  ) filtered-list)))
    values-list))

(defun dmaz/plist-merge (&rest plists)
  (if plists
      (let ((result (copy-sequence (car plists))))
        (while (setq plists (cdr plists))
          (let ((plist (car plists)))
            (while plist
              (setq result (plist-put result (car plist) (car (cdr plist)))
                    plist (cdr (cdr plist))))))
        result)
    nil))

(defun dmaz/projectile-format-all-typescript-files ()
  (interactive)
  (let (project-root-path (projectile-project-root))
    (dolist (file (projectile-current-project-files))
      (setq file (expand-file-name (dmaz/joindirs (projectile-project-root) file)))
      (message "processing file %s" file)
      (when (and (file-exists-p file) (not (file-directory-p file)))
        (message "opening file")
        (find-file file)
        (message "opened file")
        (when (eq major-mode 'typescript-mode)
          (message "formatting file")
          (tide-format)
          (save-buffer)
          (kill-buffer nil))))
    )
  )
