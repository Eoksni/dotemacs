(defun dmaz-is-substring (STRING SUBSTRING)
  (if (< (length STRING) (length SUBSTRING))
      nil
    (if (equal (substring STRING 0 (length SUBSTRING)) SUBSTRING)
        t
      nil)))

(defun dmaz-del-substring (STRING SUBSTRING)
  (substring STRING (length SUBSTRING)))

(defun dmaz-eval-and-replace (value)
  "Evaluate the sexp at point and replace it with its value"
  (interactive (list (eval-last-sexp nil)))
  (kill-sexp -1)
  (insert (format "%S" value)))

(defun dmaz-smart-home()
  "Move point to first non-whitespace character or beginning-of-line.

Move point to the first non-whitespace character on this line.
If point was already at that position, move point to beginning of line."
  (interactive)
  (let ((oldpos (point)))
    (back-to-indentation)
    (and (<= oldpos (point))
         (beginning-of-line))))

(defun dmaz-semnav-up (arg)
  (interactive "p")
  (when (nth 3 (syntax-ppss))
    (if (> arg 0)
        (progn
          (skip-syntax-forward "^\"")
          (goto-char (1+ (point)))
          (decf arg))
      (skip-syntax-backward "^\"")
      (goto-char (1- (point)))
      (incf arg)))
  (up-list arg))

(defun dmaz-extend-selection (arg &optional incremental)
  "Select the current word.
Subsequent calls expands the selection to larger semantic unit."
  (interactive (list (prefix-numeric-value current-prefix-arg)
                     (or (region-active-p)
                         (eq last-command this-command))))
  (if incremental
      (progn
        (dmaz-semnav-up (- arg))
        (forward-sexp)
        (mark-sexp -1))
    (if (> arg 1)
        (dmaz-extend-selection (1- arg) t)
      (if (looking-at "\\=\\(\\s_\\|\\sw\\)*\\_>")
          (goto-char (match-end 0))
        (unless (memq (char-before) '(?\) ?\"))
          (forward-sexp)))
      (mark-sexp -1))))

(defun dmaz-mark-whole-word()
  (interactive)
  (forward-word)
  (mark-word -1))

(defun dmaz-unindent ()
  "Just wrapper for indent-rigidly"
  (interactive)
  (let (beg end (deactivate-mark nil))
    (if (region-active-p)
        (setq beg (region-beginning) end (region-end))
      (setq beg (line-beginning-position) end (line-end-position)))
    (indent-rigidly beg end (* tab-width -1))))

(defun dmaz-indent ()
  "Just wrapper for indent-rigidly"
  (interactive)
  (let (beg end (deactivate-mark nil))
    (if (region-active-p)
        (setq beg (region-beginning) end (region-end))
      (setq beg (line-beginning-position) end (line-end-position)))
    (indent-rigidly beg end (* tab-width 1))))

(defun dmaz-turn-on-autoindent-yanked ()
  "Enables automatic indentation of yanked text"
  (dolist (command '(yank yank-pop))
    (eval `(defadvice ,command (after indent-region activate)
             (and (not current-prefix-arg)
                  (member major-mode dmaz-modes-for-autoindent-yanked)
                  (let ((mark-even-if-inactive transient-mark-mode))
                    (indent-region (region-beginning) (region-end) nil)))))))

(defun dmaz-turn-off-tool-bar ()
  (if (functionp 'tool-bar-mode) (tool-bar-mode -1)))

(defun dmaz-lorem ()
  "Insert a lorem ipsum."
  (interactive)
  (insert "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do "
          "eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim"
          "ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut "
          "aliquip ex ea commodo consequat. Duis aute irure dolor in "
          "reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla "
          "pariatur. Excepteur sint occaecat cupidatat non proident, sunt in "
          "culpa qui officia deserunt mollit anim id est laborum."))

(defun dmaz-untabify-buffer ()
  (interactive)
  (untabify (point-min) (point-max)))

(defun dmaz-indent-buffer ()
  (interactive)
  (indent-region (point-min) (point-max)))

(defun dmaz-cleanup-buffer ()
  "Perform a bunch of operations on the whitespace content of a buffer."
  (interactive)
  (dmaz-indent-buffer)
  (dmaz-untabify-buffer)
  (delete-trailing-whitespace))

(defun dmaz-add-watchwords ()
  (font-lock-add-keywords
   nil '(("\\<\\(FIXME\\|TODO\\|FIX\\|HACK\\|REFACTOR\\|NOCOMMIT\\)"
          1 font-lock-warning-face t))))

(defun dmaz-disable-keys-for-function-in-keymap (FUNSYMBOL KEYMAP &optional SEARCHKEYMAP)
  "Finds all keybindings to invoke function FUNSYMBOL and undefines them in KEYMAP keymap"
  (dolist (element (where-is-internal FUNSYMBOL (if (keymapp SEARCHKEYMAP) SEARCHKEYMAP KEYMAP)))
    (define-key KEYMAP element nil)))

(defun dmaz-buffer-local-set-key (KEYBINDING FUNCTION)
  "Do not use it several times! Look at implementation for
reasoning."
  (let ((map (make-sparse-keymap))
        (local-map (current-local-map)))
    (set-keymap-parent map local-map)
    (define-key map KEYBINDING FUNCTION)
    (use-local-map map)))

(defun dmaz-open-cmd-here ()
  (interactive)
  (let ((process-connection-type nil)) (start-process "" nil "cmd" "/C" "start")))

(defun dmaz-open-explorer-here ()
  (interactive)
  (let ((process-connection-type nil)) (start-process "" nil "explorer" (dmaz-get-dir-name))))

(defun dmaz-open-in-external-app ()
  "Open the current file or dired marked files in external app.
Works in Microsoft Windows, Mac OS X, Linux."
  (interactive)
  (let (doIt
        (myFileList
         (cond
          ((string-equal major-mode "dired-mode") (dired-get-marked-files))
          (t (list (buffer-file-name))))))
    (setq doIt (if (<= (length myFileList) 5)
                   t
                 (y-or-n-p "Open more than 5 files?")))
    (when doIt
      (cond
       ((eq system-type 'windows-nt)
        (mapc (lambda (fPath) (w32-shell-execute "open" (replace-regexp-in-string "/" "\\" fPath t t))) myFileList))
       ((eq system-type 'darwin)
        (mapc (lambda (fPath) (let ((process-connection-type nil)) (start-process "" nil "open" fPath)))  myFileList))
       ((eq system-type 'gnu/linux)
        (mapc (lambda (fPath) (let ((process-connection-type nil)) (start-process "" nil "xdg-open" fPath))) myFileList))))))

(defun dmaz-kill-line ()
  (interactive)
  (if (region-active-p)
      (kill-region (region-beginning) (region-end))
    (call-interactively 'kill-line)))

(defun dmaz-get-file-name ()
  (let (system-specific-file-name
        (path (if (eq major-mode 'dired-mode)
                  (dired-current-directory)
                buffer-file-name)))
    (cond
     ((eq system-type 'windows-nt)
      (setq system-specific-file-name (replace-regexp-in-string "/" "\\" path t t)))
     (t
      (setq system-specific-file-name path)))
    (when system-specific-file-name
      system-specific-file-name)))

(defun dmaz-get-dir-name ()
  "Show the full path to directory of current file in the minibuffer."
  (interactive)
  (let (system-specific-dir-name
        (path (if (eq major-mode 'dired-mode)
                  dired-directory
                (file-name-directory buffer-file-name))))
    (cond
     ((eq system-type 'windows-nt)
      (setq system-specific-dir-name (replace-regexp-in-string "/" "\\" path t t)))
     (t
      (setq system-specific-dir-name path)))
    (when system-specific-dir-name
      system-specific-dir-name)))

(defun dmaz-show-file-name ()
  "Show the full path file name in the minibuffer."
  (interactive)
  (let ((system-specific-file-name (dmaz-get-file-name)))
    (when system-specific-file-name
      (message system-specific-file-name)
      (kill-new system-specific-file-name))))

(defun dmaz-show-dir-name ()
  "Show the full path to directory of current file in the minibuffer."
  (interactive)
  (let ((system-specific-dir-name (dmaz-get-dir-name)))
    (when system-specific-dir-name
      (message system-specific-dir-name)
      (kill-new system-specific-dir-name))))

(defun dmaz-comment-or-uncomment-region-or-line ()
  "Comments or uncomments the region or the current line if there's no active region."
  (interactive)
  (let (beg end)
    (if (region-active-p)
        (setq beg (region-beginning) end (region-end))
      (setq beg (line-beginning-position) end (line-end-position)))
    (comment-or-uncomment-region beg end)
    (next-line)))

(defun dmaz-visit-system-config ()
  "Visits file with system-specific configuration"
  (interactive)
  (find-file dmaz-system-config))

(defun dmaz-visit-init-config ()
  "Visit startup configuration file - ~/.emacs.d/init.el"
  (interactive)
  (find-file (concat user-emacs-directory "init.el")))

(defun dmaz-visit-system-after-config ()
  "Visits file with system-specific configuration which executes in the end of init.el"
  (interactive)
  (find-file dmaz-system-after-config))

(defun dmaz-get-resulting-fun (FUNSYMBOL)
  (let ((funremap (command-remapping FUNSYMBOL)))
    (if funremap
        funremap
      FUNSYMBOL)))

(defun dmaz-delete-current-file ()
  "Delete the file associated with the current buffer. Close the current buffer too.

If no file is associated, just close buffer."
  (interactive)
  (let ((fName (buffer-file-name)))
    (when fName
      (delete-file fName)
      (message "「%s」 deleted." fName))
    (kill-buffer (current-buffer))))

(defun dmaz-uniq-lines (beg end)
  "Unique lines in region.
Called from a program, there are two arguments:
BEG and END (region to sort)."
  (interactive "r")
  (save-excursion
    (save-restriction
      (narrow-to-region beg end)
      (goto-char (point-min))
      (while (not (eobp))
        (kill-line 1)
        (yank)
        (let ((next-line (point)))
          (while
              (re-search-forward
               (format "^%s" (regexp-quote (car kill-ring))) nil t)
            (replace-match "" nil nil))
          (goto-char next-line))))))

(defun dmaz-get-char-by-class (class-string)
  "Gets char from current syntax table."
  (dotimes (char 256)
    (let* ((syntax-entry (aref (syntax-table) char))
           (class (and syntax-entry
                       (syntax-class syntax-entry)))
           (pair (and syntax-entry
                      (cdr syntax-entry))))
      (when (eq class (car (string-to-syntax class-string)))
        (return char)
        ))))

(defun dmaz-get-escape-char ()
  "Gets escape char from current syntax table."
  (dmaz-get-char-by-class "\\"))

(defun dmaz-get-quote-char ()
  "Gets quote char from current syntax table."
  (dmaz-get-char-by-class "\""))

(defun dmaz-escape-region ()
  (declare (obsolete "Use er/expand-region instead" "02.05.2017"))
  (interactive)
  (let
      (pos1
       pos2
       (escape-string (string (dmaz-get-escape-char)))
       (quote-string (string (dmaz-get-quote-char)))
       start-inside-string
       end-inside-string)
    (save-excursion
      (when (not (use-region-p))
        (if (er--point-inside-string-p)
            (progn
              (setq quote-string (string (er--current-quotes-char)))
              (er/mark-outside-quotes))
          (er/expand-region 1)))
      (setq pos1 (region-beginning) pos2 (region-end))

      (setq start-inside-string
            (progn
              (goto-char pos1)
              (er--point-inside-string-p)))
      (setq end-inside-string
            (progn
              (goto-char pos2)
              (er--point-inside-string-p)))
      (save-restriction
        (narrow-to-region pos1 pos2)

        (let (insert-before (er--point-inside-string-p))
          (when start-inside-string (progn
                                      (goto-char (point-min))
                                      (insert quote-string)))
          (when end-inside-string (progn
                                    (goto-char (point-max))
                                    (insert quote-string)))

          (goto-char (point-min))
          (while (search-forward-regexp
                  (concat "\\([" quote-string escape-string "]\\)")
                  nil
                  t)
            (replace-match (concat escape-string escape-string "\\1")))

          (when (not start-inside-string) (progn
                                            (goto-char (point-min))
                                            (insert quote-string)))
          (when (not end-inside-string) (progn
                                          (goto-char (point-max))
                                          (insert quote-string))))))))

(defun dmaz-generate-uid ()
  (format "%04x%04x-%04x-%04x-%04x-%06x%06x"
          (random (expt 16 4))
          (random (expt 16 4))
          (random (expt 16 4))
          (random (expt 16 4))
          (random (expt 16 4))
          (random (expt 16 6))
          (random (expt 16 6))))

(defun dmaz-launch-emacs-with-benchmark ()
  (interactive)
  (start-process-shell-command (dmaz-generate-uid) nil "set DMAZ_EMACSBENCHMARK=true && emacs-run-server-head"))

(defun dmaz-joindirs (root &rest dirs)
  "Joins a series of directories together, like Python's os.path.join,
  (dmaz-joindirs \"/tmp\" \"a\" \"b\" \"c\") => /tmp/a/b/c"

  (if (not dirs)
      root
    (apply 'dmaz-joindirs
           (expand-file-name (car dirs) root)
           (cdr dirs))))

(defun dmaz-remove-dos-eol ()
  "Do not show ^M in files containing mixed UNIX and DOS line endings."
  (interactive)
  (when (eq buffer-display-table nil)
    (setq buffer-display-table (make-display-table))
    )
  (aset buffer-display-table ?\^M []))

(defun dmaz-insert-date ()
  "Insert a time-stamp according to locale's date and time format."
  (interactive)
  (insert (format-time-string "%c" (current-time))))

(defun dmaz-timestamp ()
  (interactive)
  (insert (format-time-string "%d.%m.%Y %H:%M")))

(defun dmaz-set-language-environment-hook ()
  (setq default-process-coding-system '(utf-8 . utf-8)))

(defun dmaz-rename-current-buffer-file ()
  "Renames current buffer and file it is visiting."
  (interactive)
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (error "Buffer '%s' is not visiting a file!" name)
      (let ((new-name (read-file-name "New name: " filename)))
        (if (get-buffer new-name)
            (error "A buffer named '%s' already exists!" new-name)
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil)
          (message "File '%s' successfully renamed to '%s'"
                   name (file-name-nondirectory new-name)))))))

(defun dmaz-goto-line-with-feedback ()
  "Show line numbers temporarily, while prompting for the line number input"
  (interactive)
  (unwind-protect
      (progn
        (linum-mode 1)
        (goto-line (read-number "Goto line: ")))
    (linum-mode -1)))

(defun dmaz-open-line-below ()
  (interactive)
  (if (eolp)
      (newline)
    (end-of-line)
    (newline)))

(defun dmaz-open-line-above ()
  (interactive)
  (beginning-of-line)
  (newline)
  (forward-line -1))

(defun dmaz-hide-ctrl-M ()
  "Hides the disturbing '^M' showing up in files containing mixed UNIX and DOS line endings."
  (interactive)
  (setq buffer-display-table (make-display-table))
  (aset buffer-display-table ?\^M []))

(defun dmaz-dired-single-up ()
  (interactive) 
  (dired-single-buffer ".."))

(defun dmaz-reverse-input-method (input-method)
  "Build the reverse mapping of single letters from INPUT-METHOD."
  (interactive
   (list (read-input-method-name "Use input method (default current): ")))
  (if (and input-method (symbolp input-method))
      (setq input-method (symbol-name input-method)))
  (let ((current current-input-method)
        (modifiers '(nil (control) (meta) (control meta))))
    (when input-method
      (activate-input-method input-method))
    (when (and current-input-method quail-keyboard-layout)
      (dolist (map (cdr (quail-map)))
        (let* ((to (car map))
               (from (quail-get-translation
                      (cadr map) (char-to-string to) 1)))
          (when (and (characterp from) (characterp to))
            (dolist (mod modifiers)
              (define-key local-function-key-map
                (vector (append mod (list from)))
                (vector (append mod (list to)))))))))
    (when input-method
      (activate-input-method current))))

(defun dmaz-revisit-buffer ()
  (interactive)
  (save-buffer)
  (revert-buffer :ignore-auto :noconfirm))

(defmacro dmaz-special-beginning-of-buffer (mode &rest forms)
  "Took it from https://fuco1.github.io/2017-05-06-Enhanced-beginning--and-end-of-buffer-in-special-mode-buffers-(dired-etc.).html

Define a special version of `beginning-of-buffer' in MODE.

The special function is defined such that the point first moves
to `point-min' and then FORMS are evaluated.  If the point did
not change because of the evaluation of FORMS, jump
unconditionally to `point-min'.  This way repeated invocations
toggle between real beginning and logical beginning of the
buffer."
  (declare (indent 1))
  (let ((fname (intern (concat "my-" (symbol-name mode) "-beginning-of-buffer")))
        (mode-map (intern (concat (symbol-name mode) "-mode-map")))
        (mode-hook (intern (concat (symbol-name mode) "-mode-hook"))))
    `(progn
       (defun ,fname ()
         (interactive)
         (let ((p (point)))
           (goto-char (point-min))
           ,@forms
           (when (= p (point))
             (goto-char (point-min)))))
       (add-hook ',mode-hook
                 (lambda ()
                   (define-key ,mode-map
                     [remap beginning-of-buffer] ',fname))))))

(defmacro dmaz-special-end-of-buffer (mode &rest forms)
  "Took it from https://fuco1.github.io/2017-05-06-Enhanced-beginning--and-end-of-buffer-in-special-mode-buffers-(dired-etc.).html

Define a special version of `end-of-buffer' in MODE.

The special function is defined such that the point first moves
to `point-max' and then FORMS are evaluated.  If the point did
not change because of the evaluation of FORMS, jump
unconditionally to `point-max'.  This way repeated invocations
toggle between real end and logical end of the buffer."
  (declare (indent 1))
  (let ((fname (intern (concat "my-" (symbol-name mode) "-end-of-buffer")))
        (mode-map (intern (concat (symbol-name mode) "-mode-map")))
        (mode-hook (intern (concat (symbol-name mode) "-mode-hook"))))
    `(progn
       (defun ,fname ()
         (interactive)
         (let ((p (point)))
           (goto-char (point-max))
           ,@forms
           (when (= p (point))
             (goto-char (point-max)))))
       (add-hook ',mode-hook
                 (lambda ()
                   (define-key ,mode-map
                     [remap end-of-buffer] ',fname))))))

(defun dmaz-show-clock-header ()
  "Show the clock header in the minibuffer."
  (interactive)
  (when org-clock-heading
    (message org-clock-heading)
    (kill-new org-clock-heading)))

(defun dmaz-insert-and-close-clock ()
  "Inserts the clock header in the current buffer and closes current clock todo."
  (interactive)
  (when org-clock-heading
    (insert org-clock-heading)
    (let ((org-clock-out-switch-to-state "DONE"))
      (org-clock-out))))

(defun dmaz-parse-vscode-formatting (f)
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

(defun dmaz-find-dirlocals-dir ()
  "Finds directory where closest .dir-locals file is located"
  (interactive)
  (file-name-directory
   (let ((d (dir-locals-find-file ".")))
     (if (stringp d) d (car d)))))

(defun dmaz-plist-merge (&rest plists)
  (if plists
      (let ((result (copy-sequence (car plists))))
        (while (setq plists (cdr plists))
          (let ((plist (car plists)))
            (while plist
              (setq result (plist-put result (car plist) (car (cdr plist)))
                    plist (cdr (cdr plist))))))
        result)
    nil))

(defun dmaz-locate-file-uptree (f) 
  (dmaz-joindirs (locate-dominating-file "." f) f))

(provide 'dmaz-functions)
