(defun dmaz/config-eoksni-win8 ()
  (with-eval-after-load "ispell"
    (setenv "DICPATH" "E:/eoksni-dir/portable/hunspell_dictionaries")
    (setq-default flyspell-generic-check-word-predicate
          #'flyspell-generic-progmode-verify)
    (setq ispell-program-name "hunspell")
    (setq ispell-dictionary "en_US,ru_RU")
    ;; ispell-set-spellchecker-params has to be called
    ;; before ispell-hunspell-add-multi-dic will work
    (ispell-set-spellchecker-params)
    (ispell-hunspell-add-multi-dic "en_US,ru_RU")))

;; (advice-add 'move-beginning-of-line :around #'dmaz/move-beginning-of-line--smart)
(advice-add 'typescript/format :around #'dmaz/typescript/format--tmp-here)
(setq projectile-test-suffix-function #'dmaz/projectile-test-suffix)
(setq projectile-create-missing-test-files t)
(add-to-list 'process-coding-system-alist '("growlnotify" utf-8 . cp1251))

(defvar dmaz/growlnotify-command "C:\\Program Files (x86)\\Growl for Windows\\growlnotify.exe")
(defvar dmaz/eoksni-dir "E:\\eoksni-dir")
(defvar dmaz/dropbox-dir "H:\\Documents\\Dropbox")

(funcall (intern (concat "dmaz/config-" (downcase (system-name)))))
