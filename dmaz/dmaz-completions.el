(use-package ivy 
  :diminish ivy-mode
  :bind (:map dmaz-keys-minor-mode-map
	      ([remap isearch-forward] . swiper)
	      :map dmaz-mode-specific-map
	      ("r" . ivy-resume)))

(use-package swiper
  :bind (:map swiper-map
	      ([remap ivy-reverse-i-search] . ivy-previous-line-or-history)))

(use-package counsel
  :bind (:map dmaz-keys-minor-mode-map
	      ([remap find-file] . counsel-find-file)
	      ;; ([remap yank-pop] . counsel-yank-pop)
	      ([remap execute-extended-command] . counsel-M-x)
	      ([remap describe-function] . counsel-describe-function)
	      ([remap describe-variable] . counsel-describe-variable)
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
