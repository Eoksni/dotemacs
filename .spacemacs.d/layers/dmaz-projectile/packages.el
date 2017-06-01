(defconst dmaz-projectile-packages
  '(
    projectile-ripgrep
    projectile
    ))

(defun dmaz-projectile/init-projectile-ripgrep ()
  (use-package projectile-ripgrep
    :defer t))

(defun dmaz-projectile/post-init-projectile ()
  (use-package projectile
    :defer t
    :config
    (setq projectile-sort-order 'default)
    (setq projectile-switch-project-action (quote projectile-dired))
    :init
    (spacemacs/set-leader-keys
      "ps" 'counsel-projectile-rg)))
