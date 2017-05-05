;;; package --- Summary
;;; Commentary:
;;; Code:

(message "init.el: starting")
;; ;; starting server (deprecated, server is now started from _run script)
;; (require 'server)
;; (when (and (eq system-type 'windows-nt) (file-exists-p (getenv "APPDATA")))
;;   (setq server-auth-dir (concat (getenv "APPDATA") "/.emacs.d/server"))
;;   (make-directory server-auth-dir t))
;; (ignore-errors (server-start))

;; Turn off mouse interface early in startup to avoid momentary display
(dolist (mode '(menu-bar-mode tool-bar-mode scroll-bar-mode))
  (when (fboundp mode) (funcall mode -1)))

(let ((new-user-emacs-dir (getenv "DMAZCFG_DOT_EMACS_DIR")))
  (when new-user-emacs-dir
    (setq user-emacs-directory new-user-emacs-dir)))
(add-to-list 'load-path (concat user-emacs-directory "dmaz/"))

(require 'dmaz-macros)

(when (getenv "DMAZ_EMACSBENCHMARK")
  (add-to-list 'load-path (concat user-emacs-directory "benchmark-init-git/"))
  (require 'benchmark-init-loaddefs)
  (benchmark-init/activate))

(require 'dmaz-init)

(message "init.el finished")
(when (getenv "DMAZ_EMACSBENCHMARK")
  (benchmark-init/show-durations-tree))

