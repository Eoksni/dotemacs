(use-package ivy 
  :diminish ivy-mode
  :bind (:map dmaz-keys-minor-mode-map
	      ("C-s" . swiper)
	      :map dmaz-mode-specific-map
	      ("r" . ivy-resume)))

(use-package counsel
  :bind (:map dmaz-keys-minor-mode-map
	      ([remap yank-pop] . counsel-yank-pop)
	      ([remap execute-extended-command] . counsel-M-x)
	      :map dmaz-ctl-x-map
	      ("l" . counsel-locate)
	      :map ivy-minibuffer-map
	      ([remap yank-pop] . ivy-next-line)
	      ([remap execute-extended-command] . ivy-dispatching-done)))

;; (use-package projectile
;;   :defer t
;;   :config
;;   (counsel-projectile-on))

(provide 'dmaz-completions)
