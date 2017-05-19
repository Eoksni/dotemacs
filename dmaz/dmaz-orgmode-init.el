(define-key dmaz-mode-specific-map (kbd "C-x C-r") 'dmaz-show-clockreport)

(use-package org
  :defer t
  :bind (:map dmaz-goto-map
	      ("r" . org-refile-goto-last-stored))
  :init
  
  :config  
  (require 'org-notify)
  )

(use-package org-agenda
  :defer t
  :bind (:map dmaz-mode-specific-map
	      ("a" . org-agenda))
  :config  
  (dmaz-special-beginning-of-buffer org-agenda
    (org-agenda-next-item 1))
  (dmaz-special-end-of-buffer org-agenda
    (org-agenda-previous-item 1))
  
  )

(use-package org-capture
  :bind (:map dmaz-mode-specific-map
	      ("c" . org-capture)))

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

(provide 'dmaz-orgmode-init)
;; (message "dmaz-orgmode-init.el stage 9.5 completed")
