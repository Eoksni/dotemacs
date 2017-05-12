(require 'cl)

(require 'dmaz-functions)
(require 'dmaz-general-config)
(require 'dmaz-customize)

(use-package dmaz-keybindings
  :config

  (if (not (daemonp))
      (dmaz-reverse-input-method 'russian-computer)
    (defun rev-inp-m-init (f)
      (lexical-let ((frame f))
	(run-at-time nil nil
		     #'(lambda () (unless (and (daemonp) (eq frame terminal-frame))
			       (dmaz-reverse-input-method 'russian-computer)
			       (remove-hook 'after-make-frame-functions #'rev-inp-m-init))))
	)
      )
    (add-hook 'after-make-frame-functions #'rev-inp-m-init)))

(require 'dmaz-package)

(require 'dmaz-completions)

(require 'dmaz-window)

(use-package projectile
  :defer t
  :config
  (counsel-projectile-on))

(require 'dmaz-orgmode-init)

(require 'dmaz-magit)

(use-package dired
  :bind (:map dired-mode-map
	      ([return] . dired-single-buffer)
	      ("^" . dmaz-dired-single-up))
  :config
  ;; replace dired mouse interaction with dired-single one
  (defalias 'dired-mouse-find-file-other-window 'dired-single-buffer-mouse)

  (dmaz-special-beginning-of-buffer dired
    (while (not (ignore-errors (dired-get-filename)))
      (dired-next-line 1)))
  (dmaz-special-end-of-buffer dired
    (dired-previous-line 1))
  
  (add-hook 'dired #'discover-mode-turn-on))

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

(use-package vue-mode
  :mode "\\.vue\\'")

(use-package restclient-mode
  :mode "\\.rest\\'")

(use-package dmaz-keybindings
  :config
  (dmaz-activate-keymaps))

(require 'dmaz-customize-after)
(provide 'dmaz-init)
