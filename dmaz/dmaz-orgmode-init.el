(add-to-list 'process-coding-system-alist '("growlnotify" utf-8 . cp1251))

(define-key dmaz-mode-specific-map (kbd "C-x C-r") 'dmaz-show-clockreport)

(use-package org-clock
  :defer 5
  :commands (org-clock-save org-clock-load)
  :bind (:map dmaz-mode-specific-map
	      ("C-x C-j" . org-clock-goto))
  :config
  (add-hook 'kill-emacs-hook 'org-clock-save)
  (org-clock-load))

(use-package org
  :defer t
  :bind (:map dmaz-goto-map
	      ("r" . org-refile-goto-last-stored))
  :init
  (add-hook 'org-mode-hook #'dmaz-org-mode-hook)
  :config  
  (require 'org-notify)
  (advice-add 'org-clock-get-clocktable :around #'org-clock-get-clocktable--respect-org-extend-today-until)

  (dmaz-disable-keys-for-function-in-keymap 'org-remove-file org-mode-map))

(use-package org-habit
  :defer t
  :config
  (advice-add 'org-habit-parse-todo :around #'org-habit-parse-todo--respect-org-extend-today-until))

(use-package org-agenda
  :defer t
  :bind (:map dmaz-mode-specific-map
	      ("a" . org-agenda))
  :config  
  (dmaz-special-beginning-of-buffer org-agenda
    (org-agenda-next-item 1))
  (dmaz-special-end-of-buffer org-agenda
    (org-agenda-previous-item 1))
  
  (add-hook 'org-agenda-finalize-hook #'dmaz-org-finalize-agenda-hook)
  (add-to-list 'org-agenda-custom-commands 
	       '("d" "daily start"
		((agenda ""
			 (
			  (org-agenda-skip-function #'org-agenda-skip-scheduled-if-hour)
			  (org-habit-show-habits t)
			  (org-agenda-max-entries 5)
			  (org-agenda-cmp-user-defined #'(lambda (a b) (if (> (random) (random)) 1 -1)))
			  (org-agenda-sorting-strategy '(user-defined-up))
			  )
			 )))
	       ;; '("d" "daily start"
	       ;; 	 (
	       ;; 	  ;; ;; started tasks
	       ;; 	  ;; (tags-todo "+TODO=\"STARTED\"-#habits"
	       ;; 	  ;; 	     ((org-agenda-overriding-header "STARTED Actions")
	       ;; 	  ;; 	      (org-agenda-tags-todo-honor-ignore-options t)
	       ;; 	  ;; 	      (org-agenda-todo-ignore-scheduled nil)
	       ;; 	  ;; 	      (org-agenda-todo-ignore-deadlines nil)))

	       ;; 	  ;; ;; deadlines
	       ;; 	  ;; (tags-todo "+DEADLINE<=\"<today>\"-TODO=\"STARTED\""
	       ;; 	  ;; 	     ((org-agenda-overriding-header "Late Deadlines")
	       ;; 	  ;; 	      (org-agenda-tags-todo-honor-ignore-options t)
	       ;; 	  ;; 	      (org-agenda-todo-ignore-scheduled t)
	       ;; 	  ;; 	      (org-agenda-todo-ignore-deadlines nil)))
	       
	       ;; 	  ;; ;; schedules
	       ;; 	  ;; (tags-todo "+SCHEDULED<\"<today>\"-TODO=\"STARTED\"-#habits"
	       ;; 	  ;; 	     ((org-agenda-overriding-header "Late Schedule")
	       ;; 	  ;; 	      (org-agenda-tags-todo-honor-ignore-options t)
	       ;; 	  ;; 	      (org-agenda-todo-ignore-scheduled nil)
	       ;; 	  ;; 	      (org-agenda-todo-ignore-deadlines t)))

	       ;; 	  ;; ;; habits scheduled
	       ;; 	  ;; (tags-todo "+SCHEDULED<=\"<today>\"-TODO=\"STARTED\"+#habits"
	       ;; 	  ;; 	     ((org-agenda-overriding-header "Scheduled Habits")
	       ;; 	  ;; 	      (org-agenda-tags-todo-honor-ignore-options t)
	       ;; 	  ;; 	      (org-agenda-todo-ignore-scheduled nil)
	       ;; 	  ;; 	      (org-agenda-todo-ignore-deadlines t)))

	       ;; 	  ;; ;; waiting
	       ;; 	  ;; (tags-todo "+TODO=\"WAIT\""
	       ;; 	  ;; 	     ((org-agenda-overriding-header "Waiting")
	       ;; 	  ;; 	      (org-agenda-tags-todo-honor-ignore-options t)
	       ;; 	  ;; 	      (org-agenda-todo-ignore-scheduled t)
	       ;; 	  ;; 	      (org-agenda-todo-ignore-deadlines t)))

	       ;; 	  ;; today's schedule
	       ;; 	  (agenda ""
	       ;; 		  (
	       ;; 		   (org-agenda-skip-function #'org-agenda-skip-scheduled-if-hour)
	       ;; 		   (org-habit-show-habits t)
	       ;; 		   (org-agenda-max-entries 5)
	       ;; 		   (org-agenda-cmp-user-defined #'(lambda (a b) (if (> (random) (random)) 1 -1)))
	       ;; 		   (org-agenda-sorting-strategy '(user-defined-up))
	       ;; 		   )
	       ;; 		  )

	       ;; 	  ;; ;; next tasks
	       ;; 	  ;; (tags-todo "+TODO=\"NEXT\"-#hold"
	       ;; 	  ;; 	     ((org-agenda-overriding-header "NEXT Actions")
	       ;; 	  ;; 	      (org-agenda-tags-todo-honor-ignore-options t)
	       ;; 	  ;; 	      (org-agenda-todo-ignore-scheduled t)
	       ;; 	  ;; 	      (org-agenda-todo-ignore-deadlines t)))

	       ;; 	  ;; ;; projects
	       ;; 	  ;; (tags-todo "-TODO=\"WAIT\"-TODO=\"INBOX\""
	       ;; 	  ;; 	     (
	       ;; 	  ;; 	      (org-agenda-skip-function 'bh/skip-non-projects)
	       ;; 	  ;; 	      (org-agenda-overriding-header
	       ;; 	  ;; 	       "Projects (< to restrict by project)")))

	       ;; 	  ;; ;; inbox
	       ;; 	  ;; (tags-todo "-TODO=\"INBOX\"+#inbox"
	       ;; 	  ;; 	     ((org-agenda-overriding-header "Inbox")
	       ;; 	  ;; 	      (org-agenda-tags-todo-honor-ignore-options t)
	       ;; 	  ;; 	      (org-agenda-todo-ignore-scheduled nil)
	       ;; 	  ;; 	      (org-agenda-todo-ignore-deadlines nil)))

	       ;; 	  ;; ;; backlog
	       ;; 	  ;; (tags-todo "+TODO=\"TODO\"-#hold-#inbox"
	       ;; 	  ;; 	     ((org-agenda-overriding-header "Action Backlog")
	       ;; 	  ;; 	      (org-agenda-tags-todo-honor-ignore-options t)
	       ;; 	  ;; 	      (org-agenda-todo-ignore-scheduled t)
	       ;; 	  ;; 	      (org-agenda-todo-ignore-deadlines t)))
	       ;; 	  )
	       ;; 	 ;; ((org-agenda-max-entries      5)
	       ;; 	 ;;  (org-agenda-cmp-user-defined #'(lambda (a b) (if (> (random) (random)) 1 -1)))
	       ;; 	 ;;  (org-agenda-sorting-strategy '(user-defined-up)))
	       ;; 	 )
	       ))

(use-package org-capture
  :bind (:map dmaz-mode-specific-map
	      ("c" . org-capture)))

(use-package org-notify
  :defer 5
  :config
  (require 'org)
  (defalias 'org-notify-make-todo 'dmaz-org-notify-make-todo)
  (org-notify-add 'default
		  '(:time "5m" :actions dmaz-org-notify-action-notify))
  (org-notify-start 10))

;; (setq org-agenda-clockreport-parameter-plist (list :link t :maxlevel 6))
;; (setq org-clocktable-defaults (list :maxlevel 10 :lang "en" :scope 'file :block nil :tstart nil :tend nil :step nil :stepskip0 nil :fileskip0 nil :tags nil :emphasize t :link nil :narrow '60! :indent t :formula nil :timestamp nil :level nil :tcolumns nil :formatter nil))

;; ;; Disable C-c [ and C-c ] in org-mode
;; (defadvice org-refile-goto-last-stored (before dmaz-set-mark-for-refile-goto activate)
;;   "Pushes mark before going to last stored refile"
;;   (push-mark)
;;   )
;; (add-hook 'org-mode-hook
;;           (lambda ()
;;             (auto-fill-mode t)
;;             (local-set-key (kbd "C-c C-g") 'org-refile-goto-last-stored)
;;             (abbrev-mode 1)
;;             ) 'append)



;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ;; Allow refile to create parent tasks with confirmation
;; (setq org-refile-allow-creating-parent-nodes (quote confirm))

;; (setq org-special-ctrl-a/e t)
;; (setq org-hierarchical-todo-statistics nil)
;;                                         ;(setq org-use-property-inheritance ('))

(defun dmaz-show-notification (notification &optional title)
  (interactive "sNotification text: ")
  (let ((title (or title "Emacs")))
    (start-process "emacs-timer-notification" nil
                   dmaz-growlnotify-command (format "/t:%s" title) (concat "/i:" (dmaz-joindirs user-emacs-directory "emacs.png")) notification)))

(defun dmaz-org-notify-action-notify (plist)
  "Pop up a notification window."
  (dmaz-show-notification (org-notify-body-text plist) (plist-get plist :heading)))

(defun dmaz-org-notify-make-todo (heading &rest ignored)
  "Replacement for org-notify-make-todo Create one todo item."
  (macrolet ((get (k) `(plist-get list ,k))
             (pr (k v) `(setq result (plist-put result ,k ,v))))
    (let* ((list (nth 1 heading))      (notify (or (get :NOTIFY) "default"))
           (deadline (or (org-notify-convert-deadline (get :deadline)) (dmaz-org-notify-convert-scheduled (get :scheduled))))
           (heading (get :raw-value))
           result)
      (when (and (eq (get :todo-type) 'todo) heading deadline)
        (pr :heading heading)     (pr :notify (intern notify))
        (pr :begin (get :begin))
        (pr :file (nth org-notify-parse-file (org-agenda-files 'unrestricted)))
        (pr :timestamp deadline)  (pr :uid (md5 (concat heading deadline)))
        (pr :deadline (- (org-time-string-to-seconds deadline)
                         (float-time))))
      result)))

(defun dmaz-org-notify-convert-scheduled (orig)
  "Convert original scheduled from `org-element-parse-buffer' to
simple timestamp string."
  (if (and orig (plist-get (plist-get orig 'timestamp)
                           :hour-start))
      (replace-regexp-in-string "^<\\|>$" ""
                                (plist-get (plist-get orig 'timestamp)
                                           :raw-value))))

(defun dmaz-org-setup-eoksni-dir ()
  (interactive)
  (with-eval-after-load "org"
    (add-to-list 'org-agenda-files (dmaz-joindirs dmaz-path-to-eoksni-dir "notes"))
    (add-to-list 'org-agenda-files (dmaz-joindirs dmaz-path-to-eoksni-dir "work/jslearning/jslearning.org"))))

(defun dmaz-org-setup-onedrive-dir ()
  (interactive))

(defun dmaz-org-setup-dropbox-dir ()
  (interactive)
  (with-eval-after-load "org"
    (setq org-directory (dmaz-joindirs (file-name-as-directory dmaz-path-to-dropbox-dir) "notes"))
    (add-to-list 'org-agenda-files (dmaz-joindirs org-directory "life"))
    (add-to-list 'org-agenda-files (dmaz-joindirs org-directory "main.org"))
    (setq org-default-notes-file (dmaz-joindirs org-directory "main.org"))))

(defun dmaz-clock-in-to-started (kw)
  "Switch task from TODO or NEXT to STARTED when clocking in.
Skips capture tasks."
  (if (and (member (org-get-todo-state) (list "TODO" "NEXT"))
           (not (and (boundp 'org-capture-mode) org-capture-mode)))
      "STARTED"))

(defun dmaz-agenda-sort (a b)
  "Sorting strategy for agenda items.
;; Late deadlines first, then scheduled, then non-late deadlines"
  (let (result num-a num-b)
    (cond
                                        ; time specific items are already sorted first by org-agenda-sorting-strategy

                                        ; late deadlines
     ((dmaz-agenda-sort-test-num 'dmaz-is-late-deadline '< a b))

                                        ; deadlines for today
     ((dmaz-agenda-sort-test 'dmaz-is-due-deadline a b))

                                        ; pending deadlines
     ((dmaz-agenda-sort-test-num 'dmaz-is-pending-deadline '< a b))

                                        ; late scheduled items
     ((dmaz-agenda-sort-test-num 'dmaz-is-scheduled-late '> a b))

                                        ; scheduled items for today
     ((dmaz-agenda-sort-test 'dmaz-is-scheduled-today a b))

                                        ; non-deadline and non-scheduled items
     ((dmaz-agenda-sort-test 'dmaz-is-not-scheduled-or-deadline a b))

                                        ; finally default to unsorted
     (t (setq result nil))
     )
    result))

(defmacro dmaz-agenda-sort-test (fn a b)
  "Test for agenda sort"
  `(cond
                                        ; if both match leave them unsorted
    ((and (apply ,fn (list ,a))
          (apply ,fn (list ,b)))
     (setq result nil))
                                        ; if a matches put a first
    ((apply ,fn (list ,a))
                                        ; if b also matches leave unsorted
     (if (apply ,fn (list ,b))
         (setq result nil)
       (setq result -1)))
                                        ; otherwise if b matches put b first
    ((apply ,fn (list ,b))
     (setq result 1))
                                        ; if none match leave them unsorted
    (t nil)))

(defmacro dmaz-agenda-sort-test-num (fn compfn a b)
  `(cond
    ((apply ,fn (list ,a))
     (setq num-a (string-to-number (match-string 1 ,a)))
     (if (apply ,fn (list ,b))
         (progn
           (setq num-b (string-to-number (match-string 1 ,b)))
           (setq result (if (apply ,compfn (list num-a num-b))
                            -1
                          1)))
       (setq result -1)))
    ((apply ,fn (list ,b))
     (setq result 1))
    (t nil)))

(defun dmaz-is-not-scheduled-or-deadline (date-str)
  (and (not (dmaz-is-deadline date-str))
       (not (dmaz-is-scheduled date-str))))

(defun dmaz-is-due-deadline (date-str)
  (string-match "Deadline:" date-str))

(defun dmaz-is-late-deadline (date-str)
  (string-match "In *\\(-.*\\)d\.:" date-str))

(defun dmaz-is-pending-deadline (date-str)
  (string-match "In \\([^-]*\\)d\.:" date-str))

(defun dmaz-is-deadline (date-str)
  (or (dmaz-is-due-deadline date-str)
      (dmaz-is-late-deadline date-str)
      (dmaz-is-pending-deadline date-str)))

(defun dmaz-is-scheduled (date-str)
  (or (dmaz-is-scheduled-today date-str)
      (dmaz-is-scheduled-late date-str)))

(defun dmaz-is-scheduled-today (date-str)
  t)

(defun dmaz-is-scheduled-late (date-str)
  (string-match "Sched\.\\(.*\\)x:" date-str))

(defun org-agenda-skip-scheduled-if-not-today ()
  "If this function returns nil, the current match should not be skipped.
Otherwise, the function must return a position from where the search
should be continued."
  (ignore-errors
    (let ((subtree-end (save-excursion (org-end-of-subtree t)))
          (scheduled-day
	   (time-to-days
	    (org-time-string-to-time
	     (org-entry-get nil "SCHEDULED"))))
          (now (time-to-days (current-time))))
      (and scheduled-day
	   (not (= scheduled-day now))
	   subtree-end))))

(defun org-agenda-skip-scheduled-if-hour ()
  "If this function returns nil, the current match should not be skipped.
Otherwise, the function must return a position from where the search
should be continued."
  (let (beg 
	end 
	(regexp (concat "\\<" org-scheduled-string
			" *<\\([^>]+[0-9]\\{1,2\\}:[0-9]\\{2\\}[0-9-+:/hdwmy \t.]*\\)>")))
    (org-back-to-heading t)
    (setq beg (point)
	  end (progn (outline-next-heading) (1- (point))))
    (goto-char beg)
    (and
     (re-search-forward regexp end t)
     end)))

(defun dmaz-eq-time-and-time (time1 time2)
  (and (not (time-less-p time1 time2))
       (not (time-less-p time2 time1))))

(defun dmaz-org-mode-hook () 
  (auto-fill-mode))

(defun dmaz-org-finalize-agenda-hook () 
  ;; remove mouse highlight - performance
  (remove-text-properties
   (point-min) (point-max) '(mouse-face t))
  (dmaz-apply-auto-exclude))

(defun time-to-days--respect-org-extend-today-until (orig-fun time &rest args)
  (let* ((decoded (decode-time time))
	 (sec (nth 0 decoded))
	 (min (nth 1 decoded))
	 (hour (nth 2 decoded))
	 (res (apply orig-fun time args)))
    (if (or (>= hour org-extend-today-until) (and (= sec min hour 0)))
	res
      (- res 1))))

(defun org-habit-parse-todo--respect-org-extend-today-until (orig-fun &rest args)
  (advice-add 'time-to-days :around #'time-to-days--respect-org-extend-today-until)
  (let ((res (apply orig-fun args)))
    (advice-remove 'time-to-days #'time-to-days--respect-org-extend-today-until)
    res))

(defun dmaz-org-auto-exclude-function (tag)
  ;; t if want to exclude
  (and (cond
	((string= tag "drill") t)
	((string= tag "loud")
	 (let ((hour (nth 2 (decode-time))))
	   (or (< hour 9) (> hour 22))))
	((string= tag "daytime")
	 (let ((hour (nth 2 (decode-time))))
	   (or (< hour 9) (> hour 17)))))
       (concat "-" tag)))

(defvar-local dmaz-apply-auto-exclude--applied nil)

(defun dmaz-apply-auto-exclude ()
  (interactive)
  (when (and (not dmaz-apply-auto-exclude--applied) org-agenda-auto-exclude-function)
    (setq dmaz-apply-auto-exclude--applied t)
    (org-agenda-filter-show-all-tag)
    (setq org-agenda-tag-filter nil)
    (dolist (tag (org-agenda-get-represented-tags))
      (let ((modifier (funcall org-agenda-auto-exclude-function tag)))
	(if modifier
	    (push modifier org-agenda-tag-filter))))
    (if (not (null org-agenda-tag-filter))
	(org-agenda-filter-apply org-agenda-tag-filter 'tag nil))))

(defun org-matcher-time--respect-org-extend-today-until (time)
  (let* ((decoded (decode-time time))
	 (sec (nth 0 decoded))
	 (min (nth 1 decoded))
	 (hour (nth 2 decoded)))
    (if (= 0 sec min hour)
	(float-time (encode-time sec min (+ org-extend-today-until hour) (nth 3 decoded) (nth 4 decoded) (nth 5 decoded)))
      time)))

(defun org-clock-get-clocktable--respect-org-extend-today-until (orig-fun &rest args)
  (advice-add 'org-matcher-time :filter-return #'org-matcher-time--respect-org-extend-today-until)
  (let ((res (apply orig-fun args)))
    (advice-remove 'org-matcher-time #'org-matcher-time--respect-org-extend-today-until)
    res))

(defun org-matcher-time--from-scram-to-scram (time)
  (let* ((decoded (decode-time time))
	 (sec (nth 0 decoded))
	 (min (nth 1 decoded))
	 (hour (nth 2 decoded)))
    (if (= 0 sec min hour)
	(float-time (encode-time sec min (+ 17 hour) (nth 3 decoded) (nth 4 decoded) (nth 5 decoded)))
      time)))

(defun dmaz-show-clockreport (clocktable-start clocktable-end)
  (interactive "sFrom time (default <-1d>): \nsTo time (default <today>): ")
  (when (equal clocktable-start "") (setq clocktable-start "<-1d>"))
  (when (equal clocktable-end "") (setq clocktable-end "<today>"))  
  (let ((org-agenda-files (org-agenda-files nil 'ifmode))
	(p (copy-sequence org-agenda-clockreport-parameter-plist))
	tbl)
    (setq p (org-plist-delete p :block))
    (setq p (plist-put p :tstart clocktable-start))
    (setq p (plist-put p :tend clocktable-end))
    (setq p (plist-put p :scope 'agenda))
    
    (advice-add 'org-matcher-time :filter-return #'org-matcher-time--from-scram-to-scram)
    (setq tbl (apply 'org-clock-get-clocktable p))
    (advice-remove 'org-matcher-time #'org-matcher-time--from-scram-to-scram)
    
    (switch-to-buffer-other-window  (generate-new-buffer "*dmaz-clockreport*"))
    (insert tbl)))

(provide 'dmaz-orgmode-init)
;; (message "dmaz-orgmode-init.el stage 9.5 completed")
