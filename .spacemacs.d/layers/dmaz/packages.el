(defconst dmaz-packages
  '(
    ranger
    typescript-mode
    tide
    git-commit-insert-issue
    vue-mode
    dired
    dired-single
    ))

(defun dmaz/post-init-ranger ()
  ;; https://github.com/ralesi/ranger.el/issues/156
  ;; Fix the masks for the elisp internal implementation of ls
  ;; (setq ranger-dired-display-mask '(t t t t t t t)
  ;;       ranger-dired-hide-mask '(nil nil nil nil nil nil t))
  )

(defun dmaz/init-vue-mode ()
  (use-package vue-mode))

(defun dmaz/pre-init-typescript-mode ()
  (use-package typescript-mode
    :mode "\\.js\\'"))

(defun dmaz/post-init-tide ()
  ;; default formatting options correspond to vscode formatting
  (setq tide-format-options '(
                              :insertSpaceAfterCommaDelimiter t
                                                              :insertSpaceAfterSemicolonInForStatements t
                                                              :insertSpaceBeforeAndAfterBinaryOperators t
                                                              :insertSpaceAfterKeywordsInControlFlowStatements t
                                                              :insertSpaceAfterFunctionKeywordForAnonymousFunctions t
                                                              :insertSpaceBeforeFunctionParenthesis nil
                                                              :insertSpaceAfterOpeningAndBeforeClosingNonemptyParenthesis nil
                                                              :insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets nil
                                                              :insertSpaceAfterOpeningAndBeforeClosingTemplateStringBraces nil
                                                              :insertSpaceAfterOpeningAndBeforeClosingJsxExpressionBraces nil
                                                              :placeOpenBraceOnNewLineForFunctions nil
                                                              :placeOpenBraceOnNewLineForControlBlocks nil))

  (advice-add 'tide-setup :before #'dmaz/apply-formatting-options))

(defun dmaz/init-git-commit-insert-issue ()
  (use-package git-commit-insert-issue
    :defer t))


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
