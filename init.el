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

(let ((new-user-emacs-dir (file-name-directory (file-truename load-file-name))))
  (when new-user-emacs-dir
    (setq user-emacs-directory new-user-emacs-dir)))

(when (getenv "DMAZ_EMACSBENCHMARK")
  (add-to-list 'load-path (concat user-emacs-directory "benchmark-init-git/"))
  (require 'benchmark-init-loaddefs)
  (benchmark-init/activate))

;; ++spacemacs initialization
(if (getenv "SPACEMACSDIR")
    (if (file-name-absolute-p (getenv "SPACEMACSDIR"))
        nil
      (setenv "SPACEMACSDIR" (concat user-emacs-directory (getenv "SPACEMACSDIR")))
      )
  (setenv "SPACEMACSDIR" (concat user-emacs-directory ".spacemacs.d/"))
  )
(let* (
       (spacemacsdir (directory-file-name (getenv "SPACEMACSDIR")))
       (parentdir (file-name-directory spacemacsdir))
       (spacemacsdirname (file-name-nondirectory spacemacsdir))
       (elpadirname (concat spacemacsdirname "-elpa/"))
       )
  (setq package-user-dir (concat parentdir elpadirname))
  )
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
 ("org" . "http://orgmode.org/elpa/")
 ("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)
(setq spacemacs-start-directory (concat user-emacs-directory "spacemacs/"))
(load-file (concat spacemacs-start-directory "init.el"))
;; --spacemacs initialization

(message "init.el finished")
(when (getenv "DMAZ_EMACSBENCHMARK")
  (benchmark-init/show-durations-tree))
