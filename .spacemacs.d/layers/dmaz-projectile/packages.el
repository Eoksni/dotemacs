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
    :init
    (spacemacs/set-leader-keys
      "ps" 'counsel-projectile-rg)))
