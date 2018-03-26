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
    ;; (compile :location built-in)
    quickrun
    indium
    ;; spaceline-all-the-icons
    mocha
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

    (quickrun-add-command "javascript/node/print"
      '((:command . "node")
        (:exec . "%c -e \"const fs = require('fs'); const content = fs.readFileSync('%s', {encoding: 'utf8'}); console.log(eval(content))\"")
        (:description "Automatic print of evaluated expression")
        )
      :default "javascript")
    )
  )

(defun dmaz/init-indium ()
  (use-package indium
    :commands (indium-run-node)
    :defer t
    :config
    )
  )

;; (defun dmaz/init-spaceline-all-the-icons ()
;;   (use-package spaceline-all-the-icons
;;     :after (spaceline)
;;     :config
;;     (spaceline-all-the-icons-theme))
;;   )

(defun dmaz/init-mocha ()
  (use-package mocha
    :defer t
    :init
    (spacemacs/set-leader-keys "oma" #'mocha-test-at-point)
    (spacemacs/set-leader-keys "omp" #'mocha-test-project)
    (spacemacs/set-leader-keys "omf" #'mocha-test-file)
    :config
    (setq mocha-command ".\\node_modules\\.bin\\mocha.cmd")
    ;; (setq mocha-command "yarn test ")
    (setq mocha-which-node "")
    (push '("*mocha tests*" :dedicated t :position bottom :stick t :noselect t :height 0.4) popwin:special-display-config)

    ;; HACK: waiting for https://github.com/scottaj/mocha.el/issues/61
    (defun mocha-generate-command (debug &optional mocha-file test)
      "The test command to run.

If DEBUG is true, then make this a debug command.

If MOCHA-FILE is specified run just that file otherwise run
MOCHA-PROJECT-TEST-DIRECTORY.

IF TEST is specified run mocha with a grep for just that test."
      (let* ((path (or mocha-file mocha-project-test-directory))
             (target (if test (concat "--fgrep \"" test "\" ") ""))
             (node-command (concat mocha-which-node (if debug (concat " --debug=" mocha-debug-port) "")))
             (options (concat mocha-options (if debug " -t 21600000")))
             (options (concat options (concat " --reporter " mocha-reporter)))
             (opts-file (mocha-opts-file path)))
        (when opts-file
          (setq options (concat options (if opts-file (concat " --opts " opts-file)))))
        (concat mocha-environment-variables " "
                node-command " "
                mocha-command " "
                options " "
                target
                path)))
    )
  )
