(require 'dmaz-functions)
(require 'dmaz-general-config)
(require 'dmaz-customize)

(require 'dmaz-keybindings)

(require 'dmaz-package)

(require 'dmaz-completions)

(require 'dmaz-window)

(require 'dmaz-customize-after)

(require 'dmaz-orgmode-init)

(require 'dmaz-magit)

(use-package editorconfig
  :diminish editorconfig-mode)

(use-package autorevert
  :diminish auto-revert-mode)

(use-package eldoc
  :diminish eldoc-mode)

(require 'dmaz-typescript)

(use-package restclient-mode
  :mode "\\.rest\\'")

(use-package dmaz-keybindings
  :config
  (dmaz-activate-keymaps))

(provide 'dmaz-init)
