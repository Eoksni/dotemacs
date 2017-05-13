(defconst dmaz-syntax-checking-packages
  '(
    add-node-modules-path
    flycheck
    ))

;; I have no idea why, but it is always nil at the initialization
;; (when (configuration-layer/package-usedp 'flycheck)
(defun dmaz-syntax-checking/init-add-node-modules-path ()
  (use-package add-node-modules-path
    :defer t))

(defun dmaz-syntax-checking/post-init-flycheck ()
  (add-hook 'flycheck-mode-hook #'add-node-modules-path))
