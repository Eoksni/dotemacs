;; You can keep system- or user-specific customizations here (use `dmaz-visit-system-after-config`)
(setq dmaz-system-after-config (concat user-emacs-directory "dmaz/dmaz-sys-specific/" system-name "_after.el")
      dmaz-user-after-config (concat user-emacs-directory "dmaz/dmaz-sys-specific/dmaz-login-specific/" user-login-name "_after.el")
      dmaz-user-after-dir (concat user-emacs-directory "dmaz/dmaz-sys-specific/dmaz-login-specific/" user-login-name "_after"))
(when (file-exists-p dmaz-system-after-config) (load dmaz-system-after-config))
(when (file-exists-p dmaz-user-after-config) (load dmaz-user-after-config))

(provide 'dmaz-customize-after)
