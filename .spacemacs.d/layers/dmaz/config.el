(defun dmaz/config-eoksni-win8 ()
  (with-eval-after-load "ispell"
    (setenv "DICPATH" "E:/eoksni-dir/portable/hunspell_dictionaries")
    (setq ispell-program-name "hunspell")
    (setq ispell-dictionary "een_US,ru_RU")
    ;; ispell-set-spellchecker-params has to be called
    ;; before ispell-hunspell-add-multi-dic will work
    (ispell-set-spellchecker-params)
    (ispell-hunspell-add-multi-dic "een_US,ru_RU")))
(setq-default flyspell-generic-check-word-predicate
              #'flyspell-generic-progmode-verify)
(advice-add 'ispell-comments-and-strings :override #'dmaz/ispell-comments-and-strings)
;; (advice-add 'move-beginning-of-line :around #'dmaz/move-beginning-of-line--smart)
(advice-add 'typescript/format :around #'dmaz/typescript/format--tmp-here)
(setq projectile-test-suffix-function #'dmaz/projectile-test-suffix)
(setq projectile-create-missing-test-files t)
(add-to-list 'process-coding-system-alist '("growlnotify" utf-8 . cp1251))

(defvar dmaz/growlnotify-command "C:\\Program Files (x86)\\Growl for Windows\\growlnotify.exe")
(defvar dmaz/eoksni-dir "E:\\eoksni-dir")
(defvar dmaz/dropbox-dir "H:\\Documents\\Dropbox")

(funcall (intern (concat "dmaz/config-" (downcase (system-name)))))
