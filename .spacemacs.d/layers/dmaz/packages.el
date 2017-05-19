(defconst dmaz-packages
  '(
    ranger
    typescript-mode
    ))

(defun dmaz/post-init-ranger ()
  ;; https://github.com/ralesi/ranger.el/issues/156
  ;; Fix the masks for the elisp internal implementation of ls
  (setq ranger-dired-display-mask '(t t t t t t t)
        ranger-dired-hide-mask '(nil nil nil nil nil nil t))
  )

(defun dmaz/pre-init-typescript-mode ()
  (use-package typescript-mode
    :mode "\\.js\\'"))
