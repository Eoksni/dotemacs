(defconst dmaz-packages
  '(
    ranger
    typescript-mode
    tide
    git-commit-insert-issue
    vue-mode
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


