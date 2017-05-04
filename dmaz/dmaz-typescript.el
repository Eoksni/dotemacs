(use-package js2-mode
  :mode ("\\.js\\'" "\\.ts\\'"))

(use-package tide
  :diminish tide-mode
  :bind (("M-<f1>" . tide-documentation-at-point))
  :init
  (add-hook 'typescript-mode-hook #'dmaz-setup-tide-mode)
  (add-hook 'js2-mode-hook #'dmaz-setup-tide-mode)
  :config
  (advice-add 'tide-doc-buffer :filter-return #'dmaz-tide-doc-buffer--remove-ctrl-M))

(defun dmaz-setup-tide-mode ()
  (interactive)
  (tide-setup)
  
  (flycheck-mode 1)
  (eldoc-mode 1)
  (tide-hl-identifier-mode 1)
  (company-mode 1)
  (add-node-modules-path)
  (add-hook 'before-save-hook #'tide-format-before-save)
  
  (push '("function" . ?ƒ) prettify-symbols-alist)
  (prettify-symbols-mode 1))

(defun dmaz-tide-doc-buffer--remove-ctrl-M (buffer)
    (with-current-buffer buffer (dmaz-hide-ctrl-M))
    buffer)

(provide 'dmaz-typescript)
