(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(Info-mode-hook (quote (dmaz-Info-mode-remap)))
 '(auto-revert-verbose nil)
 '(blink-cursor-mode nil)
 '(company-tooltip-align-annotations t)
 '(current-language-environment (quote utf-8))
 '(custom-enabled-themes (quote (zenburn)))
 '(custom-safe-themes
   (quote
    ("ad18964df4cb93b04db80cad9dbe0fd4429eb4b66ed1dc4f6695656d382051b2" "a0dc0c1805398db495ecda1994c744ad1a91a9455f2a17b59b716f72d3585dde" default)))
 '(delete-selection-mode t)
 '(dmaz-font-string "Consolas-11")
 '(editorconfig-mode t)
 '(electric-pair-mode t)
 '(emacs-lisp-mode-hook (quote (eldoc-mode prettify-symbols-mode)))
 '(eshell-history-file-name
   (dmaz-joindirs user-emacs-directory "tmp" "eshell" "history"))
 '(flycheck-check-syntax-automatically (quote (save idle-change mode-enabled)))
 '(flycheck-idle-change-delay 2.0)
 '(global-auto-revert-mode t)
 '(global-dmaz-keys-minor-mode t nil (dmaz-keybindings))
 '(global-subword-mode t)
 '(help-mode-hook (quote (dmaz-help-mode-remap)))
 '(iflipb-wrap-around nil)
 '(inhibit-startup-screen t)
 '(ivy-count-format "(%d/%d) ")
 '(ivy-mode t)
 '(ivy-use-virtual-buffers t)
 '(ls-lisp-dirs-first t)
 '(ls-lisp-ignore-case t)
 '(ls-lisp-use-string-collate nil)
 '(ls-lisp-verbosity (quote (links)))
 '(make-backup-files nil)
 '(mark-even-if-inactive t)
 '(markdown-command "C:\\Users\\Dmitriy\\AppData\\Local\\Pandoc\\pandoc.exe")
 '(mc/list-file (dmaz-joindirs user-emacs-directory "tmp" ".mc-lists.el"))
 '(mode-icons-mode t)
 '(mouse-wheel-progressive-speed nil)
 '(org-M-RET-may-split-line (quote ((default))))
 '(org-agenda-auto-exclude-function (quote dmaz-org-auto-exclude-function))
 '(org-agenda-cmp-user-defined (quote dmaz-agenda-sort))
 '(org-agenda-scheduled-leaders (quote ("" "Sched.%2dx: ")))
 '(org-agenda-sorting-strategy
   (quote
    ((agenda time-up priority-down habit-up user-defined-up effort-up category-up tag-up)
     (todo priority-down category-up)
     (tags priority-down category-up)
     (search category-keep))))
 '(org-agenda-span (quote day))
 '(org-agenda-window-setup (quote only-window))
 '(org-blank-before-new-entry (quote ((heading) (plain-list-item))))
 '(org-capture-templates
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
     ("T" "today" entry
      (file+headline org-default-notes-file "today")
      "* TODO %?
SCHEDULED: %t")
     ("h" "habit" entry
      (file+headline
       (dmaz-joindirs org-directory "life" "habits.org")
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
       (dmaz-joindirs org-directory "mindmap.org")
       "drill")
      "* %?                         :drill:
:PROPERTIES:
:DATE_ADDED: %u
:END:
"))))
 '(org-catch-invisible-edits (quote show-and-error))
 '(org-clock-in-switch-to-state (quote dmaz-clock-in-to-started))
 '(org-clock-persist t)
 '(org-clock-persist-query-resume nil)
 '(org-clock-report-include-clocking-task t)
 '(org-drill-add-random-noise-to-intervals-p t)
 '(org-enforce-todo-dependencies t)
 '(org-extend-today-until 6)
 '(org-habit-graph-column 70)
 '(org-log-into-drawer t)
 '(org-modules (quote (org-habit org-drill)))
 '(org-show-notification-handler (quote dmaz-show-notification))
 '(org-src-fontify-natively t)
 '(org-startup-indented t)
 '(org-todo-keyword-faces
   (quote
    (("TODO" :foreground "red" :weight bold)
     ("PENDING" :foreground "green" :weight bold)
     ("NEXT" :foreground "blue" :weight bold)
     ("TEST" :foreground "blue" :weight bold)
     ("STARTED" :foreground "magenta" :weight bold)
     ("DONE" :foreground "forest green" :weight bold)
     ("WAITING" :foreground "gray" :weight bold)
     ("CANCELLED" :foreground "forest green" :weight bold))))
 '(org-todo-keywords
   (quote
    ((sequence "TODO(t)" "WAITING(w)" "STARTED(s)" "|" "DONE(d!/!)" "CANCELLED(c@/!)")
     (sequence "INBOX"))))
 '(package-archives
   (quote
    (("melpa" . "https://melpa.org/packages/")
     ("gnu" . "http://elpa.gnu.org/packages/")
     ("org" . "http://orgmode.org/elpa/"))))
 '(package-selected-packages
   (quote
    (git-commit-insert-issue counsel-projectile projectile-ripgrep counsel mode-icons which-key js-comint org-plus-contrib vue-mode dired-single projectile add-node-modules-path tide js2-mode company magit markdown-mode popwin multiple-cursors move-text ace-jump-mode expand-region iflipb ivy-hydra flx swiper ivy use-package restclient visual-regexp-steroids visual-regexp)))
 '(popwin:special-display-config
   (quote
    ((help-mode)
     ("*tide-documentation*" :noselect t)
     (ag-mode))))
 '(projectile-completion-system (quote ivy))
 '(projectile-indexing-method (quote alien))
 '(projectile-known-projects-file
   (dmaz-joindirs user-emacs-directory "tmp" "projectile-bookmarks.eld"))
 '(projectile-mode t nil (projectile))
 '(projectile-switch-project-action (quote projectile-dired))
 '(save-place-file (dmaz-joindirs user-emacs-directory "tmp" "places"))
 '(save-place-mode t)
 '(scroll-error-top-bottom t)
 '(scroll-preserve-screen-position t)
 '(select-enable-clipboard t)
 '(set-language-environment-hook (quote (dmaz-set-language-environment-hook)))
 '(set-mark-command-repeat-pop t)
 '(show-paren-mode t)
 '(split-height-threshold nil)
 '(tab-always-indent (quote complete))
 '(tooltip-mode nil)
 '(uniquify-buffer-name-style (quote forward) nil (uniquify))
 '(vc-handled-backends nil)
 '(visible-bell t)
 '(which-key-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
