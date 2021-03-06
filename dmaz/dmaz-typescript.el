(use-package js2-mode
  :defer t
  :mode ("\\.js\\'"))

(use-package prettify-symbols-mode
  :defer t
  :init
  (add-hook 'js2-mode-hook #'dmaz-enable-prettify-for-js2-mode))

(use-package js-comint
  :defer t
  :bind (:map js2-mode-map
	      ("C-x C-e" . js-send-last-sexp)
	      ("C-M-x" . js-send-last-sexp-and-go)
	      ("C-c b" . dmaz-js-send-buffer-or-region)
	      ("C-c C-b" . dmaz-js-send-buffer-or-region-or-go)
	      ("C-c l" . js-load-file-and-go))
  :init
  (add-hook 'inferior-js-mode-hook #'dmaz-inferior-js-mode-hook-setup t))

(use-package js2-refactor
  :defer t
  :bind (:map js2-refactor-mode-map
	      ([remap move-text-up] . js2r-move-line-up)
	      ([remap move-text-down] . js2r-move-line-down)
	      )
  :init
  (add-hook 'js2-mode-hook #'js2-refactor-mode)
  :config
  (js2r-add-keybindings-with-prefix "C-c C-m"))

(use-package tide
  :defer t
  :diminish tide-mode
  :bind (:map tide-mode-map 
	      ("M-<f1>" . tide-documentation-at-point))
  :init
  (add-hook 'typescript-mode-hook #'dmaz-setup-tide-mode)
  (add-hook 'js2-mode-hook #'dmaz-setup-tide-mode)
  :config
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
  (advice-add 'tide-doc-buffer :filter-return #'dmaz-tide-doc-buffer--remove-ctrl-M))

(defun dmaz-setup-tide-mode ()
  (interactive)
  ;; must go before tide-setup
  (dmaz-apply-formatting-options)
  (tide-setup)
  
  (flycheck-mode 1)
  (eldoc-mode 1)
  (tide-hl-identifier-mode 1)
  (company-mode 1)
  (add-node-modules-path) ;; to make flycheck use local versions of eslint etc
  (add-hook 'before-save-hook #'tide-format-before-save))

(defun dmaz-apply-formatting-options () 
  (let* ((settings-file (dmaz-locate-file-uptree ".vscode/settings.json"))
	 (local-format-options (dmaz-parse-vscode-formatting settings-file)))
    (make-local-variable 'tide-format-options)
    (setq tide-format-options (dmaz-plist-merge tide-format-options local-format-options))))

(defun dmaz-tide-doc-buffer--remove-ctrl-M (buffer)
  (with-current-buffer buffer 
    (dmaz-hide-ctrl-M))
  buffer)

(defun dmaz-js-send-buffer-or-region ()
  (interactive)
  (if (region-active-p)
      (js-send-region (region-beginning) (region-end))
    (js-send-buffer)))

(defun dmaz-js-send-buffer-or-region-or-go ()
  (interactive)
  (if (region-active-p)
      (js-send-region-or-go (region-beginning) (region-end))
    (js-send-buffer-or-go)))

(defun dmaz-enable-prettify-for-js2-mode ()
  (setq prettify-symbols-alist '(("function" . 402)
				 ;; ("=>" . 8658) ;; waaaaaaaaaay too slow for some reason, must be a bug
				 (">=" . 8805)
				 ("<=" . 8804)))
  (prettify-symbols-mode 1))

(defun dmaz-inferior-js-mode-hook-setup ()
  (add-hook 'comint-output-filter-functions 'js-comint-process-output))

(provide 'dmaz-typescript)
