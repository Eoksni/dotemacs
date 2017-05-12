(use-package ivy 
  :diminish ivy-mode
  :bind (:map dmaz-keys-minor-mode-map
	      ("C-s" . swiper)
	      :map dmaz-mode-specific-map
	      ("r" . ivy-resume)))

(use-package counsel
  :bind (:map dmaz-keys-minor-mode-map
	      ([remap find-file] . counsel-find-file)
	      ;; ([remap yank-pop] . counsel-yank-pop)
	      ([remap execute-extended-command] . counsel-M-x)
	      :map dmaz-ctl-x-map
	      ("l" . counsel-locate)	      
	      :map ivy-minibuffer-map
	      ;; ([remap yank-pop] . ivy-next-line)
	      ([remap execute-extended-command] . ivy-dispatching-done)
	      :map counsel-find-file-map
	      ([remap yank] . dmaz-yank-filepath)
	      ([remap yank-pop] . dmaz-yank-pop-filepath)))

(use-package counsel-projectile
  :bind (:map projectile-command-map
	      ("s r" . counsel-projectile-rg)))

(provide 'dmaz-completions)
