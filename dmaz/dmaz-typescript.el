
(use-package tide
  :init
  ;; formats the buffer before saving
  ;; (add-hook 'before-save-hook 'tide-format-before-save)
  (add-hook 'typescript-mode-hook 'dmaz-setup-tide-mode))

(defun dmaz-setup-tide-mode () 
  (interactive)
  (tide-setup)
  (flycheck-mode 1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode 1)
  (tide-hl-identifier-mode 1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode 1)
  )

(provide 'dmaz-typescript)
