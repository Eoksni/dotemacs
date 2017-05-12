(use-package magit
  :defer 10
  :bind (:map dmaz-ctl-x-map
	      ("g" . magit-status))
  :init
  (add-hook 'git-commit-mode-hook #'git-commit-insert-issue-mode)
  (add-hook 'git-rebase-mode #'turn-off-dmaz-keys-minor-mode))

(provide 'dmaz-magit)
