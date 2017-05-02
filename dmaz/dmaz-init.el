(require 'dmaz-functions)
(require 'dmaz-general-config)
(require 'dmaz-customize)

(require 'dmaz-keybindings)

(require 'dmaz-package)

;; (use-package saveplace
;;   :init
;;   (setq ))

(require 'dmaz-completions)

(require 'dmaz-window)

(require 'dmaz-customize-after)

(require 'dmaz-orgmode-init)

(use-package dmaz-keybindings
  :config
  (dmaz-activate-keymaps))

(provide 'dmaz-init)
