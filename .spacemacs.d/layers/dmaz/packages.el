(defconst dmaz-packages
  '(
    ;; ranger
    ;; typescript-mode
    ;; ts-comint
    ;; tide
    ;; git-commit-insert-issue
    ;; vue-mode
    dired-single
    ;; evil
    string-inflection
    evil-goggles
    ;; indium
    ;; (compile :location built-in)
    quickrun
    ))

;; (defun dmaz/post-init-ranger ()
;;   ;; https://github.com/ralesi/ranger.el/issues/156
;;   ;; Fix the masks for the elisp internal implementation of ls
;;   ;; (setq ranger-dired-display-mask '(t t t t t t t)
;;   ;;       ranger-dired-hide-mask '(nil nil nil nil nil nil t))
;;   )

;; (defun dmaz/init-compile ()
;;   (use-package compile
;;     :config
;;     ;; karma webpack compilation errors parsing
;;     (pushnew '(karma-webpack "^.*webpack:///\\(.*\\):\\([[:digit:]]+\\):[[:digit:]]+ <- [./_[:alnum:]]+:[[:digit:]]+.*$" 1 2) compilation-error-regexp-alist-alist)
;;     (pushnew 'karma-webpack compilation-error-regexp-alist)
;;     ;; mocha compilation errors parsing
;;     (pushnew '(mocha "^.*at .*(\\(.*\\):\\([[:digit:]]+\\):[[:digit:]]+).*$" 1 2) compilation-error-regexp-alist-alist)
;;     (pushnew 'mocha compilation-error-regexp-alist)
;;     )
;;   )

;; (defun dmaz/init-vue-mode ()
;;   (use-package vue-mode))

;; (defun dmaz/init-ts-comint ()
;;   (use-package ts-comint :defer t)
;;   (add-hook 'typescript-mode-hook
;;             (lambda ()
;;               (local-set-key (kbd "C-x C-e") 'ts-send-last-sexp)
;;               (local-set-key (kbd "C-c r") 'ts-send-region)
;;               (local-set-key (kbd "C-c C-r") 'ts-send-region-and-go)
;;               (local-set-key (kbd "C-M-x") 'ts-send-last-sexp-and-go)
;;               (local-set-key (kbd "C-c b") 'ts-send-buffer)
;;               (local-set-key (kbd "C-c C-b") 'ts-send-buffer-and-go)
;;               (local-set-key (kbd "C-c l") 'ts-load-file-and-go)))
;;   )

;; (defun dmaz/pre-init-typescript-mode ()
;;   (use-package typescript-mode
;;     :mode "\\.js\\'"))

;; (defun dmaz/post-init-tide ()
;;   ;; default formatting options correspond to vscode formatting
;;   (setq tide-format-options '(
;;                               :insertSpaceAfterCommaDelimiter t
;;                                                               :insertSpaceAfterSemicolonInForStatements t
;;                                                               :insertSpaceBeforeAndAfterBinaryOperators t
;;                                                               :insertSpaceAfterKeywordsInControlFlowStatements t
;;                                                               :insertSpaceAfterFunctionKeywordForAnonymousFunctions t
;;                                                               :insertSpaceBeforeFunctionParenthesis nil
;;                                                               :insertSpaceAfterOpeningAndBeforeClosingNonemptyParenthesis nil
;;                                                               :insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets nil
;;                                                               :insertSpaceAfterOpeningAndBeforeClosingTemplateStringBraces nil
;;                                                               :insertSpaceAfterOpeningAndBeforeClosingJsxExpressionBraces nil
;;                                                               :placeOpenBraceOnNewLineForFunctions nil
;;                                                               :placeOpenBraceOnNewLineForControlBlocks nil))

;;   (advice-add 'tide-setup :before #'dmaz/apply-formatting-options))

;; (defun dmaz/init-git-commit-insert-issue ()
;;   (use-package git-commit-insert-issue
;;     :defer t)
;;   (add-hook 'git-commit-mode-hook 'git-commit-insert-issue-mode)
;;   (advice-add 'insert-issue--get-remote-url :around #'dmaz/insert-issue--get-remote-url)
;;   (advice-add 'git-commit-insert-issue-github-issues-format :around #'dmaz/git-commit-insert-issue-github-issues-format))


(defun dmaz/init-dired-single ()
  (use-package dired-single :defer t)
  (use-package dired
    :bind (:map dired-mode-map
                ([return] . dired-single-buffer)
                ("^" . dmaz/dired-single-up))
    :config
    (advice-add 'dired-mouse-find-file-other-window :override #'dired-single-buffer-mouse)

    (dmaz/special-beginning-of-buffer dired
      (while (not (ignore-errors (dired-get-filename)))
        (dired-next-line 1)))
    (dmaz/special-end-of-buffer dired
      (dired-previous-line 1))
    )
  )

;; (defun dmaz/post-init-evil ()
;;   (spacemacs/set-leader-keys
;;     "os" #'dmaz/tag-word-or-region))

(defun dmaz/init-string-inflection ()
  (use-package string-inflection
    :commands (string-inflection-kebab-case-function string-inflection-camelcase-function)
    :defer t))

(defun dmaz/init-evil-goggles ()
  (use-package evil-goggles
    :config
    (evil-goggles-mode)
    (setq evil-goggles-pulse nil) ; the visual effect is nice, but causes some flickering of the cursor (at least on windows), so I disable it
    ))

;; (defun dmaz/init-indium ()
;;   (use-package indium
;;     :commands (indium-run-node)
;;     :defer t
;;     )
;;   (setq indium-exec-path-setup t) ;; some issues with manipulation exec-path due to spaces in the Program Files
;;   )

(defun dmaz/init-quickrun ()
  (use-package quickrun
    :commands (quickrun quickrun-region quickrun-replace-region)
    :defer t
    :init
    (spacemacs/set-leader-keys "oqq" #'quickrun)
    (spacemacs/set-leader-keys "oqr" #'quickrun-region)
    (spacemacs/set-leader-keys "oqR" #'quickrun-replace-region)
    :config
    (push '("*quickrun*" :dedicated t :position bottom :stick t :noselect nil) popwin:special-display-config)
    )
  )
