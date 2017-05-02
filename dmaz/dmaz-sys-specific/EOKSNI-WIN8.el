(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(Info-mode-hook (quote (dmaz-Info-mode-remap)))
 '(blink-cursor-mode nil)
 '(current-language-environment (quote utf-8))
 '(delete-selection-mode t)
 '(electric-pair-mode t)
 '(emacs-lisp-mode-hook (quote (eldoc-mode)))
 '(global-auto-revert-mode t)
 '(global-dmaz-keys-minor-mode t nil (dmaz-keybindings))
 '(global-subword-mode t)
 '(help-mode-hook (quote (dmaz-help-mode-remap)))
 '(iflipb-wrap-around nil)
 '(inhibit-startup-screen t)
 '(ivy-count-format "(%d/%d) ")
 '(ivy-mode t)
 '(ivy-use-virtual-buffers t)
 '(make-backup-files nil)
 '(mark-even-if-inactive t)
 '(markdown-command "pandoc")
 '(mouse-wheel-progressive-speed nil)
 '(org-M-RET-may-split-line (quote ((default))))
 '(org-agenda-cmp-user-defined (quote dmaz-agenda-sort))
 '(org-agenda-scheduled-leaders (quote ("" "Sched.%2dx: ")))
 '(org-agenda-sorting-strategy
   (quote
    ((agenda time-up priority-down habit-up user-defined-up effort-up category-up tag-up)
     (todo priority-down category-up)
     (tags priority-down category-up)
     (search category-keep))))
 '(org-blank-before-new-entry (quote ((heading) (plain-list-item))))
 '(org-catch-invisible-edits (quote show-and-error))
 '(org-clock-in-switch-to-state (quote dmaz-clock-in-to-started))
 '(org-enforce-todo-dependencies t)
 '(org-habit-graph-column 70)
 '(org-modules (quote (org-habit)))
 '(org-src-fontify-natively t)
 '(org-todo-keywords
   (quote
    ((sequence "TODO(t)" "WAITING(w)" "STARTED(s)" "|" "DONE(d!/!)" "CANCELLED(c@/!)")
     (sequence "INBOX"))))
 '(package-archives
   (quote
    (("melpa" . "https://melpa.org/packages/")
     ("gnu" . "http://elpa.gnu.org/packages/"))))
 '(package-selected-packages
   (quote
    (magit markdown-mode popwin multiple-cursors pt move-text ace-jump-mode expand-region iflipb ivy-hydra flx counsel swiper ivy use-package restclient visual-regexp-steroids visual-regexp)))
 '(save-place-file (dmaz-joindirs user-emacs-directory "tmp" "places"))
 '(save-place-mode t)
 '(scroll-error-top-bottom t)
 '(scroll-preserve-screen-position t)
 '(select-enable-clipboard t)
 '(set-mark-command-repeat-pop t)
 '(show-paren-mode t)
 '(split-height-threshold nil)
 '(tab-always-indent (quote complete))
 '(tooltip-mode nil)
 '(uniquify-buffer-name-style (quote forward) nil (uniquify))
 '(vc-handled-backends nil)
 '(visible-bell t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
