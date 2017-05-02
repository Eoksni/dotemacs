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

(require 'dmaz-typescript)

(use-package dmaz-keybindings
  :config
  (dmaz-activate-keymaps))

(provide 'dmaz-init)
