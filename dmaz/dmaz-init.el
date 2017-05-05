(require 'cl)

(require 'dmaz-functions)
(require 'dmaz-general-config)
(require 'dmaz-customize)

;; (use-package dmaz-keybindings
;;   :config
;;   (dmaz-reverse-input-method 'russian-computer))
(require 'dmaz-keybindings)

(require 'dmaz-package)

(require 'dmaz-completions)

(require 'dmaz-window)

(require 'dmaz-customize-after)

(require 'dmaz-orgmode-init)

(require 'dmaz-magit)

;;        (define-key dired-mode-map [return] 'dired-single-buffer)
;;        (define-key dired-mode-map [mouse-1] 'dired-single-buffer-mouse)
;;        (define-key dired-mode-map "^"
;;      	(function
;;      	 (lambda nil (interactive) (dired-single-buffer "..")))))


(use-package dired
  :bind (:map dired-mode-map
	      ([return] . dired-single-buffer)
	      ("^" . dmaz-dired-single-up))
  :config
  ;; replace dired mouse interaction with dired-single one
  (defalias 'dired-mouse-find-file-other-window 'dired-single-buffer-mouse))

(use-package markdown-mode
  :defer t
  :config
  (add-hook 'markdown-mode-hook #'flycheck-mode))

(use-package editorconfig
  :diminish editorconfig-mode)

(use-package autorevert
  :diminish auto-revert-mode)

(use-package eldoc
  :diminish eldoc-mode)

(require 'dmaz-typescript)

(use-package restclient-mode
  :mode "\\.rest\\'")

(use-package dmaz-keybindings
  :config
  (dmaz-activate-keymaps))

(provide 'dmaz-init)
