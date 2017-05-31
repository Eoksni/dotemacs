(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(Info-mode-hook (quote (dmaz-Info-mode-remap)))
 '(auto-dim-other-buffers-mode t)
 '(auto-revert-verbose nil)
 '(blink-cursor-mode nil)
 '(company-tooltip-align-annotations t)
 '(current-language-environment (quote utf-8))
 '(custom-enabled-themes (quote (zenburn)))
 '(custom-safe-themes
   (quote
    ("ad18964df4cb93b04db80cad9dbe0fd4429eb4b66ed1dc4f6695656d382051b2" "a0dc0c1805398db495ecda1994c744ad1a91a9455f2a17b59b716f72d3585dde" default)))
 '(delete-selection-mode t)
 '(dmaz-font-string "Consolas-11")
 '(dmaz-path-to-dictionary-dir "E:\\eoksni-dir\\portable\\hunspell_dictionaries")
 '(editorconfig-mode nil)
 '(electric-pair-mode t)
 '(emacs-lisp-mode-hook (quote (eldoc-mode prettify-symbols-mode)))
 '(eshell-history-file-name
   (dmaz-joindirs user-emacs-directory "tmp" "eshell" "history"))
 '(flycheck-check-syntax-automatically (quote (save idle-change mode-enabled)))
 '(flycheck-idle-change-delay 2.0)
 '(global-auto-revert-mode t)
 '(global-discover-mode nil)
 '(global-dmaz-keys-minor-mode t nil (dmaz-keybindings))
 '(global-subword-mode t)
 '(help-mode-hook (quote (dmaz-help-mode-remap)))
 '(iflipb-wrap-around nil)
 '(inhibit-startup-screen t)
 '(ispell-program-name
   "C:/ProgramData/chocolatey/lib/hunspell.portable/tools/bin/hunspell.exe")
 '(ivy-count-format "(%d/%d) ")
 '(ivy-extra-directories (quote ("./")))
 '(ivy-mode t)
 '(ivy-use-virtual-buffers t)
 '(js2-strict-trailing-comma-warning nil)
 '(magit-completing-read-function (quote ivy-completing-read))
 '(make-backup-files nil)
 '(mark-even-if-inactive t)
 '(markdown-command "C:\\Users\\Dmitriy\\AppData\\Local\\Pandoc\\pandoc.exe")
 '(mc/list-file (dmaz-joindirs user-emacs-directory "tmp" ".mc-lists.el"))
 '(mode-icons-mode t)
 '(mouse-wheel-progressive-speed nil)
 '(package-archives
   (quote
    (("melpa" . "https://melpa.org/packages/")
     ("gnu" . "http://elpa.gnu.org/packages/")
     ("org" . "http://orgmode.org/elpa/"))))
 '(package-selected-packages
   (quote
    (avy discover js2-refactor auto-dim-other-buffers git-commit-insert-issue counsel-projectile projectile-ripgrep counsel mode-icons which-key js-comint org-plus-contrib vue-mode dired-single projectile add-node-modules-path tide js2-mode company magit markdown-mode popwin multiple-cursors move-text expand-region iflipb ivy-hydra flx swiper ivy use-package restclient visual-regexp-steroids visual-regexp)))
 '(popwin:special-display-config
   (quote
    ((help-mode)
     ("*tide-documentation*" :noselect t)
     (ag-mode))))
 '(projectile-completion-system (quote ivy))
 '(projectile-indexing-method (quote alien))
 '(projectile-known-projects-file
   (dmaz-joindirs user-emacs-directory "tmp" "projectile-bookmarks.eld"))
 '(projectile-mode t nil (projectile))
 '(projectile-switch-project-action (quote projectile-dired))
 '(save-place-file (dmaz-joindirs user-emacs-directory "tmp" "places"))
 '(save-place-mode t)
 '(scroll-error-top-bottom t)
 '(scroll-preserve-screen-position t)
 '(select-enable-clipboard t)
 '(set-language-environment-hook (quote (dmaz-set-language-environment-hook)))
 '(set-mark-command-repeat-pop t)
 '(show-paren-mode t)
 '(split-height-threshold nil)
 '(tab-always-indent (quote complete))
 '(tooltip-mode nil)
 '(uniquify-buffer-name-style (quote forward) nil (uniquify))
 '(vc-handled-backends nil)
 '(visible-bell t)
 '(which-key-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-dim-other-buffers-face ((t (:background "gray20")))))
