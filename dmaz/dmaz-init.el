(require 'dmaz-functions)
(require 'dmaz-general-config)
(require 'dmaz-customize)

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


(use-package dired-single
  :bind (:map dired-mode-map
	      ([return] . dired-single-buffer)
	      ([mouse-1] . dired-single-buffer-mouse)
	      ("^" . dmaz-dired-single-up)))

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
