(use-package org-agenda
  :config
  (add-hook 'org-finalize-agenda-hook
	    ;; remove mouse highlight - performance
	    (lambda () (remove-text-properties
			(point-min) (point-max) '(mouse-face t))))
  :bind (:map dmaz-mode-specific-map
	      ("a" . org-agenda)))

(use-package org-capture
  :bind (:map dmaz-mode-specific-map
	      ("c" . org-capture)))

;; (setq org-capture-templates-contexts
;;       '(("T" ((in-mode . "org-agenda-mode")))))
;; (setq org-clock-sound t)
;; (message "dmaz-orgmode-init.el stage 5 completed")
;; (define-key dmaz-keys-minor-mode-map (kbd "C-c c") 'org-capture)
;; (define-key dmaz-keys-minor-mode-map (kbd "C-c t") (lambda () (interactive) (org-capture nil "t")))
;; (define-key dmaz-keys-minor-mode-map (kbd "C-c m") (lambda () (interactive) (org-capture nil "m")))


;; (setq org-startup-indented t)

;; (setq org-agenda-clockreport-parameter-plist (list :link t :maxlevel 6))
;; (setq org-clocktable-defaults (list :maxlevel 10 :lang "en" :scope 'file :block nil :tstart nil :tend nil :step nil :stepskip0 nil :fileskip0 nil :tags nil :emphasize t :link nil :narrow '60! :indent t :formula nil :timestamp nil :level nil :tcolumns nil :formatter nil))
;; (setq org-todo-keyword-faces
;;       (quote (("TODO" :foreground "red" :weight bold)
;;               ("PENDING" :foreground "green" :weight bold)
;;               ("NEXT" :foreground "blue" :weight bold)
;;               ("TEST" :foreground "blue" :weight bold)
;;               ("STARTED" :foreground "magenta" :weight bold)
;;               ("DONE" :foreground "forest green" :weight bold)
;;               ("WAITING" :foreground "gray" :weight bold)
;;               ;;("HOLD" :foreground "magenta" :weight bold)
;;               ("CANCELLED" :foreground "forest green" :weight bold)
;;               ;;("PHONE" :foreground "forest green" :weight bold)
;;               )))
;; ;; Disable C-c [ and C-c ] in org-mode
;; (defadvice org-refile-goto-last-stored (before dmaz-set-mark-for-refile-goto activate)
;;   "Pushes mark before going to last stored refile"
;;   (push-mark)
;;   )
;; (add-hook 'org-mode-hook
;;           (lambda ()
;;             (auto-fill-mode t)
;;             ;; (local-set-key (kbd "M-q") 'fill-individual-paragraphs)
;;             (local-set-key (kbd "C-c C-g") 'org-refile-goto-last-stored)
;;             ;; Undefine C-c [ and C-c ] since this breaks my
;;             ;; org-agenda files when directories are include It
;;             ;; expands the files in the directories individually
;;             (org-defkey org-mode-map "\C-c["    'undefined)
;;             (org-defkey org-mode-map "\C-c]"    'undefined)
;;             (abbrev-mode 1)
;;             ) 'append)



;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ;; refiling ;;
;; ;; allow refiling into up to 5 levels of the headline trees in all org files
;; (setq org-refile-targets
;;       (quote ((org-agenda-files :maxlevel . 5) (nil :maxlevel . 5))))
;; ;; Stop using paths for refile targets - we file directly with IDO
;; (setq org-refile-use-outline-path nil)

;; ;; Targets complete directly with IDO
;; (setq org-outline-path-complete-in-steps nil)

;; ;; Allow refile to create parent tasks with confirmation
;; (setq org-refile-allow-creating-parent-nodes (quote confirm))

;; ;; Use IDO for both buffer and file completion and ido-everywhere to t
;; (setq org-completion-use-ido t)

;; ;; Targets start with the file name - allows creating level 1 tasks
;; ;;(setq org-refile-use-outline-path (quote file))

;; (message "dmaz-orgmode-init.el stage 7 completed")
;; ;; Targets complete in steps so we start with filename
;; ;; TAB shows the next level of targets etc
;; ;;(setq org-outline-path-complete-in-steps t)
;; ;;;;;;;;;;;;;;
;; (require 'org-install)
;; (message "dmaz-orgmode-init.el stage 7.1 completed")
;; ;; (add-to-list 'org-modules 'org-habits)
;;                                         ;(add-to-list 'org-modules 'org-odt)
;; (add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
;; (message "dmaz-orgmode-init.el stage 7.11 completed")

;; (setq org-log-done 'time)
;; (message "dmaz-orgmode-init.el stage 7.12 completed")

;; ;;(setq org-log-done 'note)

;;                                         ;To save the clock history across Emacs sessions, use
;; (setq org-clock-persist 'history)
;; (message "dmaz-orgmode-init.el stage 7.13 completed")

;; ;;(org-clock-persistence-insinuate)
;;                                         ;To resume the clock under the assumption that you have worked on this task while outside Emacs
;; (message "dmaz-orgmode-init.el stage 7.14 completed")
;; (setq org-clock-persist t)
;; (message "dmaz-orgmode-init.el stage 7.15 completed")
;; ;; (setq org-clock-modeline-total 'current)
;; (setq org-show-notification-handler 'dmaz-org-show-notification)
;; (message "dmaz-orgmode-init.el stage 7.16 completed")
;; (setq org-special-ctrl-a/e t)
;; (message "dmaz-orgmode-init.el stage 7.17 completed")
;; (setq org-log-into-drawer t)
;; (message "dmaz-orgmode-init.el stage 7.18 completed")
;; (setq org-clock-into-drawer t)
;; (message "dmaz-orgmode-init.el stage 7.2 completed")
;; (setq org-hierarchical-todo-statistics nil)
;;                                         ;(setq org-use-property-inheritance ('))

;;                                         ;(add-to-list 'org-modules 'org-timer)

;; ;;
;;                                         ;Modify the org-clock-in so that a timer is started with the default
;;                                         ;value except if a timer is already started :
;; ;; (add-hook 'org-clock-in-hook '(lambda ()
;;                                 ;; (org-timer-set-timer '(16))))
;; ;; (add-hook 'org-clock-out-hook '(lambda ()  (org-timer-stop)))
;; ;;

;; ;; The following is needed because habits "following days" are screwd up otherwise ;;
;; (add-hook 'org-agenda-mode-hook '(lambda () (setq show-trailing-whitespace nil)))
;; (message "dmaz-orgmode-init.el stage 7.3 completed")
;; ;; (defun org-summary-todo (n-done n-not-done)
;; ;;   "Switch entry to DONE when all subentries are done, to TODO otherwise."
;; ;;   (if (= n-not-done 0) (org-todo "DONE"))
;; ;;   )

;; ;; (add-hook 'org-after-todo-statistics-hook 'org-summary-todo)

;; ;;                                                                                 ;;
;; (defun org-my ()
;;   "Visits file with main org-mode notes"
;;   (interactive)
;;   (find-file org-default-notes-file)
;;   )
;; (defun dmaz-org-agenda ()
;;   (interactive)
;;   (org-agenda)
;;   )

;; (defun dmaz-org-init ()
;;   (interactive)
;;   )
;; (message "dmaz-orgmode-init.el stage 8 completed")


;; (defun dmaz-org-show-notification (notification &optional title)
;;   (let ((title (or title "Emacs")))
;;     (start-process "emacs-timer-notification" nil
;;                    "growlnotify" (format "/t:%s" title) "/i:E:\\eoksni-dir\\portable\\emacs\\dotemacs\\emacs.png" notification)
;;     ))
;; (defun dmaz-org-notify-action-notify (plist)
;;   "Pop up a notification window."
;;   (dmaz-org-show-notification (org-notify-body-text plist) (plist-get plist :heading))
;;   )
;; (defun dmaz-org-notify-make-todo (orig-fun heading &rest ignored)
;;   "Create one todo item."
;;   (macrolet ((get (k) `(plist-get list ,k))
;;              (pr (k v) `(setq result (plist-put result ,k ,v))))
;;     (let* ((list (nth 1 heading))      (notify (or (get :NOTIFY) "default"))
;;            (deadline (or (org-notify-convert-deadline (get :deadline)) (dmaz-org-notify-convert-scheduled (get :scheduled))))
;;            (heading (get :raw-value))
;;            result)
;;       (when (and (eq (get :todo-type) 'todo) heading deadline)
;;         (pr :heading heading)     (pr :notify (intern notify))
;;         (pr :begin (get :begin))
;;         (pr :file (nth org-notify-parse-file (org-agenda-files 'unrestricted)))
;;         (pr :timestamp deadline)  (pr :uid (md5 (concat heading deadline)))
;;         (pr :deadline (- (org-time-string-to-seconds deadline)
;;                          (float-time))))
;;       result)))
;; (defun dmaz-org-notify-convert-scheduled (orig)
;;   "Convert original scheduled from `org-element-parse-buffer' to
;; simple timestamp string."
;;   (if (and orig (plist-get (plist-get orig 'timestamp)
;;                            :hour-start))
;;       (replace-regexp-in-string "^<\\|>$" ""
;;                                 (plist-get (plist-get orig 'timestamp)
;;                                            :raw-value))))
;; (message "dmaz-orgmode-init.el stage 9 completed")
;; ;;(require 'org-notify)
;; (message "dmaz-orgmode-init.el stage 9.1 completed")
;; (advice-add 'org-notify-make-todo :around #'dmaz-org-notify-make-todo)
;; (message "dmaz-orgmode-init.el stage 9.2 completed")
;; ;;(org-notify-add 'default
;; ;;                '(:time "5m" :actions dmaz-org-notify-action-notify))
;; (message "dmaz-orgmode-init.el stage 9.3 completed")
;; ;; (org-notify-add 'urgent-second '(:time "3m" :actions (-notify/window -ding)
;; ;;                                        :period "15s" :duration 10))
;; ;; (org-notify-add 'minute '(:time "5m" :actions -notify/window
;; ;;                                 :period "100s" :duration 70))
;; ;; (org-notify-add '12hours
;; ;;                 '(:time "3m" :actions (-notify/window -ding)
;; ;;                         :period "15s" :duration 10)
;; ;;                 '(:time "100m" :actions -notify/window
;; ;;                         :period "2m" :duration 60)
;; ;;                 '(:time "12h" :actions -notify/window :audible nil
;; ;;                         :period "10m" :duration 200))
;; ;; (org-notify-add '5days
;; ;;                 '(:time "100m" :actions -notify/window
;; ;;                         :period "2m" :duration 60)
;; ;;                 '(:time "2d" :actions -notify/window
;; ;;                         :period "15m" :duration 100)
;; ;;                 '(:time "5d" :actions -notify/window
;; ;;                         :period "2h" :duration 200))
;; ;; (org-notify-add 'long-20days
;; ;;                 '(:time "2d" :actions -notify/window
;; ;;                         :period "15m" :duration 60)
;; ;;                 '(:time "5d" :actions -notify/window
;; ;;                         :period "2h" :duration 60)
;; ;;                 '(:time "20d" :actions -email :period "2d" :audible nil))
;; ;; (org-notify-add 'long-50days
;; ;;                 '(:time "4d" :actions -notify/window
;; ;;                         :period "30m" :duration 100)
;; ;;                 '(:time "10d" :actions -notify/window
;; ;;                         :period "4h" :duration 200)
;; ;;                 '(:time "50d" :actions -email :period "3d" :audible nil))
;; ;; (org-notify-add 'long-100days
;; ;;                 '(:time "2d" :actions -notify/window
;; ;;                         :period "1h" :duration 200)
;; ;;                 '(:time "10d" :actions -notify/window
;; ;;                         :period "10h" :duration 300)
;; ;;                 '(:time "50d" :actions -email :period "3d" :audible nil)
;; ;;                 '(:time "100d" :actions -email :period "5d" :audible nil))
;; ;;(org-notify-start 10)
;; (message "dmaz-orgmode-init.el stage 9.3 completed")
;; (setq org-agenda-log-mode-items '(state))
;; (message "dmaz-orgmode-init.el stage 9.4 completed")


(defun dmaz-org-setup-eoksni-dir ()
  (interactive)
  (message "Setting eoksni-dir %s" dmaz-path-to-eoksni-dir)
  (with-eval-after-load "org-agenda"
    (add-to-list 'org-agenda-files (dmaz-joindirs dmaz-path-to-eoksni-dir "notes"))
    (add-to-list 'org-agenda-files (dmaz-joindirs dmaz-path-to-eoksni-dir "work/jslearning/jslearning.org"))))

(defun dmaz-org-setup-onedrive-dir ()
  (interactive)
  (message "Setting onedrive-dir %s" dmaz-path-to-onedrive-dir)
  (with-eval-after-load "org-agenda"
    (setq org-directory (dmaz-joindirs (file-name-as-directory dmaz-path-to-onedrive-dir) "notes"))
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

(provide 'dmaz-orgmode-init)
;; (message "dmaz-orgmode-init.el stage 9.5 completed")
