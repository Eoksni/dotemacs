;; ;; To exclude some major modes from activating `dmaz-keys-minor-mode`
;; ;; you can use hooks for that major mode to
;; ;; turn-off-dmaz-keys-minor-mode or to add SYMBOL of that major mode
;; ;; to list `dmaz-keys-exclude-modes`

;; ;; To override or disable some keybindings of dmaz-keys-minor-mode
;; ;; in some major modes use it like so:
;; (defun dmaz-Info-mode-hook ()
;;   (let ((map (make-keymap)))
;;     (set-keymap-parent map dmaz-keys-minor-mode-map)
;;     (define-key map (read-kbd-macro dmaz-mouse-button-prev-buffer) 'Info-history-back)
;;     (define-key map (read-kbd-macro dmaz-mouse-button-next-buffer) 'Info-history-forward)
;;     (define-key map (read-kbd-macro dmaz-mouse-button-wheel-forward) 'mwheel-scroll)
;;     (define-key map (read-kbd-macro dmaz-mouse-button-wheel-backward) 'mwheel-scroll)
;;
;;     ;; To restore previous meaning to keybinding (but better to use
;;     ;; `dmaz-disable-keys-for-function-in-keymap'):
;;     (define-key map (kbd "M-p") nil)
;;     (define-key map (kbd "M-n") nil)
;;
;;     (add-to-list 'minor-mode-overriding-map-alist `(dmaz-keys-minor-mode . ,map))
;;     )
;;   )
;; (defun dmaz-eshell-mode-remap ()
;;   (let ((map (make-sparse-keymap)))
;;     (set-keymap-parent map dmaz-keys-minor-mode-map)
;;
;;     (dmaz-disable-keys-for-function-in-keymap 'eshell-previous-matching-input-from-input map eshell-mode-map)
;;     (dmaz-disable-keys-for-function-in-keymap 'eshell-next-matching-input-from-input map eshell-mode-map)
;;     (dmaz-disable-keys-for-function-in-keymap 'eshell-bol map eshell-mode-map)
;;
;;     (add-to-list 'minor-mode-overriding-map-alist `(dmaz-keys-minor-mode . ,map))
;;     )
;;   )
;; (add-hook 'Info-mode-hook 'dmaz-Info-mode-hook)
;; ;; Remember, only use above for OVERRIDING keybindings, new keys
;; ;; can be introduced much simpler using `local-set-key`
;;

(defvar dmaz-keys-minor-mode-map (make-sparse-keymap) "dmaz-keys-minor-mode keymap.")

(defvar dmaz-goto-map (make-sparse-keymap)
  "Keymap as an extension of `goto-map' as part of `dmaz-keys-minor-mode-map'")
(defvar dmaz-dmaz-map (make-sparse-keymap)
  "My personal keyspace - C-z")
(defvar dmaz-mode-specific-map (make-sparse-keymap)
  "Keymap as an extension of `mode-specific-map' as part of `dmaz-keys-minor-mode-map'")
(defvar dmaz-ctl-x-map (make-sparse-keymap)
  "Keymap as an extension of `ctl-x-map' as part of `dmaz-keys-minor-mode-map'")

(defvar dmaz-keys-minor-mode-hook nil
  "Hook run when `dmaz-keys-minor-mode' is turned on.")

(define-minor-mode dmaz-keys-minor-mode
  "A minor mode so that my key settings override annoying major
  modes."
  :init-value nil
  :lighter " dk" ;; whitespace before `dk` is important!
  :keymap 'dmaz-keys-minor-mode-map
  :group 'dmaz
  :require 'dmaz-keybindings
  :global nil)

(defun turn-off-dmaz-keys-minor-mode ()
  (dmaz-keys-minor-mode 0))

(defun turn-on-dmaz-keys-minor-mode ()
  (dmaz-keys-minor-mode 1))

(defun dmaz-activate-keymaps ()
  (use-global-map (make-composed-keymap dmaz-keys-minor-mode-map global-map))
  (setcdr goto-map (cons (car goto-map) (cons dmaz-goto-map (cdr goto-map))))
  (setcdr mode-specific-map (cons (car mode-specific-map) (cons dmaz-mode-specific-map (cdr mode-specific-map))))
  (setcdr ctl-x-map (cons (car ctl-x-map) (cons dmaz-ctl-x-map (cdr ctl-x-map)))))

(define-globalized-minor-mode 
  global-dmaz-keys-minor-mode 
  dmaz-keys-minor-mode 
  (lambda ()
    (when (and 
	   (not (memq major-mode dmaz-keys-exclude-modes))
	   (not (minibufferp (current-buffer))))
      (turn-on-dmaz-keys-minor-mode)))
  :group 'dmaz
  :require 'dmaz-keybindings)

(defun dmaz-Info-mode-remap ()
  (let ((map (make-sparse-keymap)))
    (set-keymap-parent map dmaz-keys-minor-mode-map)
    (define-key map (read-kbd-macro dmaz-mouse-button-prev-buffer) 'Info-history-back)
    (define-key map (read-kbd-macro dmaz-mouse-button-next-buffer) 'Info-history-forward)
    (define-key map (read-kbd-macro dmaz-mouse-button-wheel-forward) 'mwheel-scroll)
    (define-key map (read-kbd-macro dmaz-mouse-button-wheel-backward) 'mwheel-scroll)

    (add-to-list 'minor-mode-overriding-map-alist `(dmaz-keys-minor-mode . ,map))))

(defun dmaz-help-mode-remap ()
  (let ((map (make-sparse-keymap)))
    (set-keymap-parent map dmaz-keys-minor-mode-map)
    (define-key map (read-kbd-macro dmaz-mouse-button-prev-buffer) 'help-go-back)
    (define-key map (read-kbd-macro dmaz-mouse-button-next-buffer) 'help-go-forward)

    (add-to-list 'minor-mode-overriding-map-alist `(dmaz-keys-minor-mode . ,map))))

(define-key dmaz-keys-minor-mode-map (kbd "M-g") dmaz-goto-map)
(define-key dmaz-keys-minor-mode-map (kbd "C-x") dmaz-ctl-x-map)
(define-key dmaz-keys-minor-mode-map (kbd "C-c") dmaz-mode-specific-map)
(define-key dmaz-keys-minor-mode-map (kbd "C-z") dmaz-dmaz-map)

(define-key dmaz-ctl-x-map (kbd "C-M-e") 'eval-and-replace)
(define-key dmaz-keys-minor-mode-map (kbd "C-.") 'dmaz-indent)
(define-key dmaz-keys-minor-mode-map (kbd "C-,") 'dmaz-unindent)
(define-key dmaz-keys-minor-mode-map (kbd "M-;") 'dmaz-comment-or-uncomment-region-or-line)

(dmaz-disable-keys-for-function-in-keymap 'indent-region dmaz-keys-minor-mode-map) ;; use <tab> instead
(dmaz-disable-keys-for-function-in-keymap 'mark-sexp dmaz-keys-minor-mode-map) ;; use "M-8" instead

(define-key dmaz-keys-minor-mode-map [remap list-directory] (dmaz-get-resulting-fun 'dired))
(define-key dmaz-ctl-x-map (kbd "f") (lookup-key dmaz-ctl-x-map (kbd "C-f")))
(define-key dmaz-ctl-x-map (kbd "C-r") 'dmaz-rename-current-buffer-file)

(define-key dmaz-keys-minor-mode-map (kbd "C-<f1>") 'dmaz-show-file-name)
(define-key dmaz-keys-minor-mode-map (kbd "C-<f2>") 'dmaz-show-dir-name)

(define-key dmaz-keys-minor-mode-map (kbd "C-k") 'dmaz-kill-line)

(use-package visual-regexp-steroids
  :commands vr/query-replace
  :init
  (define-key dmaz-keys-minor-mode-map [remap query-replace-regexp] 'vr/query-replace))

(define-key dmaz-keys-minor-mode-map [remap move-beginning-of-line] 'dmaz-smart-home)
(define-key dmaz-keys-minor-mode-map (kbd "M-7") 'dmaz-mark-whole-word)

(define-key dmaz-keys-minor-mode-map (kbd "M-8") 'er/expand-region)

(use-package expand-region
  :bind (:map dmaz-keys-minor-mode-map
	      ("M-8" . er/expand-region)))

(define-key dmaz-keys-minor-mode-map (kbd "M-^") (lambda () (interactive)
                                                   (let ((current-prefix-arg '(4)))
                                                     (call-interactively 'join-line))))
(define-key dmaz-keys-minor-mode-map (kbd "C-M-^") 'join-line)

(define-key dmaz-keys-minor-mode-map [remap goto-line] 'dmaz-goto-line-with-feedback)

(define-key dmaz-ctl-x-map (kbd "k") 'kill-this-buffer)
(define-key dmaz-dmaz-map (where-is-internal 'save-buffers-kill-terminal (current-global-map) t t) 'save-buffers-kill-emacs)

(define-key dmaz-keys-minor-mode-map (kbd "<C-return>") 'dmaz-open-line-below)
(define-key dmaz-keys-minor-mode-map (kbd "<C-S-return>") 'dmaz-open-line-above)

(use-package ace-jump-mode
  :bind (:map dmaz-dmaz-map
	      ("SPC" . ace-jump-mode)
	      :map dmaz-keys-minor-mode-map
	      ([remap goto-char] . ace-jump-mode)))

(use-package move-text
  :bind (:map dmaz-keys-minor-mode-map
	      ("M-p" . move-text-up)
	      ("M-n" . move-text-down)))

(use-package multiple-cursors
  :bind (:map dmaz-keys-minor-mode-map
	      ("C-S-<mouse-1>" . mc/add-cursor-on-click)
	      ("C-S-c C-S-c" . mc/edit-lines)
	      ("C->" . mc/mark-next-like-this)
	      ("C-<" . mc/mark-previous-like-this)))

;; (defadvice read-passwd (around my-read-passwd act)
;;   (let ((local-function-key-map nil))
;;     ad-do-it))

;; (setq read-passwd-map
;;        (let ((map read-passwd-map))
;;          (set-keymap-parent map minibuffer-local-map)
;;          (define-key map [return] #'exit-minibuffer)
;;          (define-key map [backspace] #'delete-backward-char)
;;          map))

;; (if (not (daemonp))
;;     (reverse-input-method 'russian-computer)
;;   (require 'cl)
;;   (defun rev-inp-m-init (f)
;;     (lexical-let ((frame f))
;; 		 (message "hello")
;;     		 (run-at-time nil nil
;;     		 	      #'(lambda () (unless (and (daemonp) (eq frame terminal-frame))
;;     		 			;; (reverse-input-method 'russian-computer)
;; 					(message "doublehello")
;;     		 			(remove-hook 'after-make-frame-functions #'rev-inp-m-init))))
;; 		 )
;;     )
;;   (add-hook 'after-make-frame-functions #'rev-inp-m-init))

(provide 'dmaz-keybindings)
