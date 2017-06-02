(defconst dmaz-org-packages
  '(
    org
    ))

(defun dmaz-org/post-init-org ()
  (use-package org-notify
    :defer 5
    :config
    (require 'org) ; needed to have org-agenda-files properly set up
    (advice-add 'org-notify-make-todo :override 'dmaz-org/notify-make-todo)
    (org-notify-add 'default
                    '(:time "5m" :actions dmaz-org/notify-action-notify))
    (org-notify-start 10))

  (use-package org-clock
    :defer 5
    :commands (org-clock-save org-clock-load)
    ;; :bind (:map dmaz-mode-specific-map
    ;;             ("C-x C-j" . org-clock-goto))
    :config
    (add-hook 'kill-emacs-hook 'org-clock-save)
    (org-clock-load))

  (use-package org-pomodoro
    :defer t
    :init
    (setq org-pomodoro-short-break-length 17)
    (setq org-pomodoro-long-break-length 30)
    (setq org-pomodoro-length 52)
    (setq org-pomodoro-audio-player "E:\\eoksni-dir\\portable\\mplayer-svn-37931\\mplayer.exe"))

  ;; org configuration
  (use-package org
    :defer t
    :config
    (spacemacs/toggle-mode-line-org-clock-on)
    (dmaz-org/setup-eoksni-dir)
    (dmaz-org/setup-dropbox-dir)
    )

  (setq org-modules '(org-drill org-habit))
  (setq org-columns-default-format "%40ITEM(Task) %17Effort(Estimated Effort){:} %CLOCKSUM_T")
  (defvar-local dmaz-org/apply-auto-exclude--applied nil)
  (advice-add 'org-clock-get-clocktable :around #'dmaz-org/clock-get-clocktable--respect-org-extend-today-until)
  (setq
   org-M-RET-may-split-line (quote ((default)))
   org-agenda-auto-exclude-function (quote dmaz-org/auto-exclude-function)
   org-agenda-cmp-user-defined (quote dmaz-org/agenda-sort)
   org-agenda-scheduled-leaders (quote ("" "Sched.%2dx: "))
   org-agenda-sorting-strategy
   (quote
    ((agenda time-up priority-down habit-up user-defined-up effort-up category-up tag-up)
     (todo priority-down category-up)
     (tags priority-down category-up)
     (search category-keep)))
   org-agenda-span (quote day)
   org-agenda-window-setup (quote only-window)
   org-blank-before-new-entry (quote ((heading) (plain-list-item)))
   org-capture-templates
   (quote
    (("f" "food" item
      (file+headline org-default-notes-file "food")
      "- %U %?" :prepend t)
     ("l" "clocked todo" entry
      (file+headline org-default-notes-file "today")
      "* STARTED %^{prompt}%?" :clock-in t :clock-keep t)
     ("t" "todo" entry
      (file+headline org-default-notes-file "INBOX inbox")
      "* TODO %?
")
     ("a" "work-agenda" entry
      (file+datetree+prompt dmaz-org/work-agenda-file)
      "* TODO %?
")
     ("T" "today" entry
      (file+headline org-default-notes-file "today")
      "* TODO %?
SCHEDULED: %t")
     ("h" "habit" entry
      (file+headline
       (dmaz/joindirs org-directory "life" "habits.org")
       "habits")
      "* TODO %?
SCHEDULED: <%<%Y-%m-%d %a> .+1d>
:PROPERTIES:
:STYLE:    habit
:CLOCK_MODELINE_TOTAL: today
:END:")
     ("w" "words" checkitem
      (file+headline org-default-notes-file "words")
      "")
     ("b" "books" checkitem
      (file+headline org-default-notes-file "books")
      "")
     ("d" "drill" entry
      (file+headline org-default-notes-file "drill")
      "* Fact                         :drill:
:PROPERTIES:
:DATE_ADDED: %u
:END:

%?")
     ("m" "drill for mindmap" entry
      (file+headline
       (dmaz/joindirs org-directory "mindmap.org")
       "drill")
      "* %?                         :drill:
:PROPERTIES:
:DATE_ADDED: %u
:END:
")))
   org-catch-invisible-edits (quote show-and-error)
   org-clock-in-switch-to-state (quote dmaz-org/clock-in-to-started)
   org-clock-persist t
   org-clock-persist-query-resume nil
   org-clock-report-include-clocking-task t
   org-drill-add-random-noise-to-intervals-p t
   org-drill-learn-fraction 0.4
   org-enforce-todo-dependencies t
   org-extend-today-until 6
   org-log-into-drawer t
   org-outline-path-complete-in-steps nil
   org-refile-targets (quote ((org-agenda-files :maxlevel . 5)))
   org-refile-use-outline-path (quote file)
   org-show-notification-handler (quote dmaz/show-notification)
   org-src-fontify-natively t
   org-startup-indented t
   org-todo-keyword-faces
   (quote
    (("TODO" :foreground "red" :weight bold)
     ("PENDING" :foreground "green" :weight bold)
     ("NEXT" :foreground "blue" :weight bold)
     ("TEST" :foreground "blue" :weight bold)
     ("STARTED" :foreground "magenta" :weight bold)
     ("DONE" :foreground "forest green" :weight bold)
     ("WAITING" :foreground "gray" :weight bold)
     ("CANCELLED" :foreground "forest green" :weight bold)))
   org-todo-keywords
   (quote
    ((sequence "TODO(t)" "WAITING(w)" "STARTED(s)" "|" "DONE(d!/!)" "CANCELLED(c@/!)")
     (sequence "INBOX")))
   )
  ;; org-agenda configuration
  (add-hook 'org-agenda-finalize-hook #'dmaz-org/finalize-agenda-hook)
  (use-package org-agenda
    :defer t
    :config
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
                 )
    )

  ;; org-drill configuration
  (setq
   org-drill-add-random-noise-to-intervals-p t
   org-drill-learn-fraction 0.4
   )

  ;; org-habit configuration
  (setq org-habit-graph-column 70)
  (advice-add 'org-habit-parse-todo :around #'dmaz-org/habit-parse-todo--respect-org-extend-today-until)

  (spacemacs/set-leader-keys
    "jc" 'org-clock-goto)
  )
