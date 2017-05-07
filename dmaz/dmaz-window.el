(use-package iflipb
  :bind (:map dmaz-keys-minor-mode-map
	      ("C-<tab>" . iflipb-next-buffer)))

(define-key dmaz-keys-minor-mode-map (kbd "M-]") 'next-multiframe-window)
(define-key dmaz-keys-minor-mode-map (kbd "M-[") 'previous-multiframe-window)

(use-package popwin
  :config
  ;; cant use it with customize because it is not autoloaded
  (setq popwin:popup-window-height 25)
  (setq popwin:special-display-config (quote ((help-mode) ("*tide-documentation*" :noselect t) (messages-buffer-mode :noselect t) (ag-mode))))
  (popwin-mode 1))

;; (require 'buffer-move)

;; (define-key dmaz-keys-minor-mode-map (kbd "<C-S-up>")     'buf-move-up)
;; (define-key dmaz-keys-minor-mode-map (kbd "<C-S-down>")   'buf-move-down)
;; (define-key dmaz-keys-minor-mode-map (kbd "<C-S-left>")   'buf-move-left)
;; (define-key dmaz-keys-minor-mode-map (kbd "<C-S-right>")  'buf-move-right)

;; (define-key dmaz-keys-minor-mode-map (read-kbd-macro (format "C-%s" dmaz-mouse-button-prev-buffer)) 'previous-buffer)
;; (define-key dmaz-keys-minor-mode-map (read-kbd-macro (format "C-%s" dmaz-mouse-button-next-buffer)) 'next-buffer)
;; (define-key dmaz-keys-minor-mode-map (read-kbd-macro dmaz-mouse-button-prev-buffer) 'winner-undo)
;; (define-key dmaz-keys-minor-mode-map (read-kbd-macro dmaz-mouse-button-next-buffer) 'winner-redo)

;; (winner-mode 1)
;; ;; ++popwin ;;
;; (add-to-list 'load-path (concat user-emacs-directory "popwin-el-git"))
;; (require 'popwin)
;; (setq display-buffer-function 'popwin:display-buffer)

;; ;; (add-to-list 'popwin:special-display-config '("^\\*helm.*\\*$" :regexp t))
;; ;; (add-to-list 'popwin:special-display-config '())

;; ;; --popwin ;;

;; ;; ++alert
;; ;; (add-to-list 'load-path (concat user-emacs-directory "gntp.el-git"))
;; ;; (require 'gntp)

;; ;; (add-to-list 'load-path (concat user-emacs-directory "alert-git"))
;; ;; (require 'alert)

;; ;; (setq alert-default-style 'gntp)
;; ;; (alert "qwer")
;; ;; --alert

;; ;; (require 'dmaz-workgroups)
;; (message "init.el: window-related configured")
;; ;; --window-config related ;;

(provide 'dmaz-window)
